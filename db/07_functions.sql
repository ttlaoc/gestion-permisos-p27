BEGIN;

CREATE OR REPLACE FUNCTION audit.fn_actor_usuario_id()
RETURNS UUID
LANGUAGE plpgsql
AS $$
DECLARE
    v_actor TEXT;
BEGIN
    v_actor := NULLIF(current_setting('app.actor_usuario_id', TRUE), '');
    IF v_actor IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN v_actor::UUID;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION audit.fn_actor_rol()
RETURNS core.rol_usuario_enum
LANGUAGE plpgsql
AS $$
DECLARE
    v_rol TEXT;
BEGIN
    v_rol := NULLIF(current_setting('app.actor_rol', TRUE), '');
    IF v_rol IS NULL THEN
        RETURN NULL;
    END IF;
    RETURN v_rol::core.rol_usuario_enum;
EXCEPTION
    WHEN OTHERS THEN
        RETURN NULL;
END;
$$;

CREATE OR REPLACE FUNCTION audit.fn_origen_evento()
RETURNS core.origen_evento_enum
LANGUAGE plpgsql
AS $$
DECLARE
    v_origen TEXT;
BEGIN
    v_origen := NULLIF(current_setting('app.origen_evento', TRUE), '');
    IF v_origen IS NULL THEN
        RETURN 'sql_directo';
    END IF;
    RETURN v_origen::core.origen_evento_enum;
EXCEPTION
    WHEN OTHERS THEN
        RETURN 'sql_directo';
END;
$$;

CREATE OR REPLACE FUNCTION audit.fn_set_timestamp()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    NEW.actualizado_en := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_parametro_a_jsonb(
    p_tipo_valor config.parametro_tipo_valor_enum,
    p_valor_texto TEXT
)
RETURNS JSONB
LANGUAGE plpgsql
IMMUTABLE
AS $$
BEGIN
    CASE p_tipo_valor
        WHEN 'entero' THEN
            RETURN to_jsonb(trim(p_valor_texto)::INTEGER);
        WHEN 'booleano' THEN
            RETURN to_jsonb(lower(trim(p_valor_texto))::BOOLEAN);
        ELSE
            RETURN to_jsonb(p_valor_texto);
    END CASE;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_obtener_parametro_json(p_clave TEXT)
RETURNS JSONB
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_tipo config.parametro_tipo_valor_enum;
    v_valor_texto TEXT;
BEGIN
    SELECT tipo_valor, valor_texto
    INTO v_tipo, v_valor_texto
    FROM config.parametro_sistema
    WHERE clave = p_clave
    LIMIT 1;

    IF v_tipo IS NULL THEN
        RETURN NULL;
    END IF;

    RETURN core.fn_parametro_a_jsonb(v_tipo, v_valor_texto);
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_obtener_parametro_entero(p_clave TEXT, p_default INTEGER)
RETURNS INTEGER
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_json JSONB;
    v_texto TEXT;
BEGIN
    v_json := core.fn_obtener_parametro_json(p_clave);
    IF v_json IS NULL THEN
        RETURN p_default;
    END IF;

    IF jsonb_typeof(v_json) = 'number' THEN
        RETURN (v_json::TEXT)::INTEGER;
    END IF;

    v_texto := trim(both '"' FROM v_json::TEXT);
    RETURN COALESCE(NULLIF(v_texto, '')::INTEGER, p_default);
EXCEPTION
    WHEN OTHERS THEN
        RETURN p_default;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_obtener_parametro_booleano(p_clave TEXT, p_default BOOLEAN)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_json JSONB;
    v_texto TEXT;
BEGIN
    v_json := core.fn_obtener_parametro_json(p_clave);
    IF v_json IS NULL THEN
        RETURN p_default;
    END IF;

    IF jsonb_typeof(v_json) = 'boolean' THEN
        RETURN (v_json::TEXT)::BOOLEAN;
    END IF;

    v_texto := lower(trim(both '"' FROM v_json::TEXT));
    RETURN COALESCE(NULLIF(v_texto, '')::BOOLEAN, p_default);
EXCEPTION
    WHEN OTHERS THEN
        RETURN p_default;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_es_dia_habil(p_fecha DATE)
RETURNS BOOLEAN
LANGUAGE sql
STABLE
AS $$
    SELECT
        EXTRACT(ISODOW FROM p_fecha) BETWEEN 1 AND 5
        AND NOT EXISTS (
            SELECT 1
            FROM core.calendario_no_lectivo c
            WHERE c.fecha = p_fecha
              AND c.es_no_lectivo = TRUE
        );
$$;

CREATE OR REPLACE FUNCTION core.fn_fecha_habil_siguiente(p_fecha DATE)
RETURNS DATE
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_fecha DATE := p_fecha + 1;
BEGIN
    WHILE NOT core.fn_es_dia_habil(v_fecha) LOOP
        v_fecha := v_fecha + 1;
    END LOOP;
    RETURN v_fecha;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_fecha_habil_anterior(p_fecha DATE)
RETURNS DATE
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_fecha DATE := p_fecha - 1;
BEGIN
    WHILE NOT core.fn_es_dia_habil(v_fecha) LOOP
        v_fecha := v_fecha - 1;
    END LOOP;
    RETURN v_fecha;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_calcular_dias_habiles(p_fecha_inicio DATE, p_fecha_fin DATE)
RETURNS INTEGER
LANGUAGE sql
STABLE
AS $$
    SELECT COUNT(*)::INTEGER
    FROM generate_series(p_fecha_inicio, p_fecha_fin, interval '1 day') AS g(fecha)
    WHERE core.fn_es_dia_habil(g.fecha::DATE);
$$;

CREATE OR REPLACE FUNCTION core.fn_es_consecutiva_real(
    p_docente_id UUID,
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_excluir_solicitud_id UUID DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_fecha_previa DATE;
    v_fecha_siguiente DATE;
BEGIN
    v_fecha_previa := core.fn_fecha_habil_anterior(p_fecha_inicio);
    v_fecha_siguiente := core.fn_fecha_habil_siguiente(p_fecha_fin);

    RETURN EXISTS (
        SELECT 1
        FROM core.solicitud s
        WHERE s.docente_id = p_docente_id
          AND s.solicitud_id IS DISTINCT FROM p_excluir_solicitud_id
          AND s.estado_actual NOT IN ('cancelada', 'denegada_direccion')
          AND (
              v_fecha_previa BETWEEN s.fecha_inicio AND s.fecha_fin
              OR v_fecha_siguiente BETWEEN s.fecha_inicio AND s.fecha_fin
          )
    );
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_supera_cupo_diario(
    p_docente_id UUID,
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_excluir_solicitud_id UUID DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_cupo INTEGER;
BEGIN
    v_cupo := core.fn_obtener_parametro_entero('reglas.cupo_diario_permisos', 1);

    RETURN EXISTS (
        SELECT 1
        FROM generate_series(p_fecha_inicio, p_fecha_fin, interval '1 day') AS g(fecha)
        WHERE core.fn_es_dia_habil(g.fecha::DATE)
          AND (
              SELECT COUNT(*)
              FROM core.solicitud s
              WHERE s.solicitud_id IS DISTINCT FROM p_excluir_solicitud_id
                AND s.estado_actual IN (
                    'enviada',
                    'en_revision',
                    'pendiente_subsanacion',
                    'validada_interna',
                    'autorizada_direccion',
                    'presentada_seneca'
                )
                AND g.fecha::DATE BETWEEN s.fecha_inicio AND s.fecha_fin
          ) >= v_cupo
    );
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_supera_maximo_docente(
    p_docente_id UUID,
    p_fecha_inicio DATE,
    p_fecha_fin DATE,
    p_excluir_solicitud_id UUID DEFAULT NULL
)
RETURNS BOOLEAN
LANGUAGE plpgsql
STABLE
AS $$
DECLARE
    v_maximo INTEGER;
    v_total INTEGER;
BEGIN
    v_maximo := core.fn_obtener_parametro_entero('reglas.max_dias_habiles_por_docente', 6);

    SELECT COALESCE(SUM(core.fn_calcular_dias_habiles(s.fecha_inicio, s.fecha_fin)), 0)
    INTO v_total
    FROM core.solicitud s
    WHERE s.docente_id = p_docente_id
      AND s.solicitud_id IS DISTINCT FROM p_excluir_solicitud_id
      AND s.estado_actual IN (
          'enviada',
          'en_revision',
          'pendiente_subsanacion',
          'validada_interna',
          'autorizada_direccion',
          'presentada_seneca',
          'cerrada'
      )
      AND EXTRACT(YEAR FROM s.fecha_inicio) = EXTRACT(YEAR FROM p_fecha_inicio);

    v_total := v_total + core.fn_calcular_dias_habiles(p_fecha_inicio, p_fecha_fin);

    RETURN v_total > v_maximo;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_actualizar_campos_derivados_solicitud()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_revisar_consecutividad BOOLEAN;
BEGIN
    NEW.dias_habiles_solicitados := core.fn_calcular_dias_habiles(NEW.fecha_inicio, NEW.fecha_fin);
    NEW.es_consecutiva_real := core.fn_es_consecutiva_real(
        NEW.docente_id,
        NEW.fecha_inicio,
        NEW.fecha_fin,
        NEW.solicitud_id
    );

    v_revisar_consecutividad := core.fn_obtener_parametro_booleano('reglas.revisar_consecutividad_real', TRUE);

    NEW.requiere_revision_manual :=
        core.fn_supera_cupo_diario(NEW.docente_id, NEW.fecha_inicio, NEW.fecha_fin, NEW.solicitud_id)
        OR core.fn_supera_maximo_docente(NEW.docente_id, NEW.fecha_inicio, NEW.fecha_fin, NEW.solicitud_id)
        OR (v_revisar_consecutividad AND NEW.es_consecutiva_real);

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_touch_solicitud()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.version_registro := COALESCE(NEW.version_registro, 1);
        NEW.actualizada_en := COALESCE(NEW.actualizada_en, CURRENT_TIMESTAMP);
        RETURN NEW;
    END IF;

    NEW.version_registro := OLD.version_registro + 1;
    NEW.actualizada_en := CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION core.fn_validar_transicion_estado()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
DECLARE
    v_actor_rol core.rol_usuario_enum;
BEGIN
    IF TG_OP = 'INSERT' THEN
        RETURN NEW;
    END IF;

    IF NEW.estado_actual = OLD.estado_actual THEN
        RETURN NEW;
    END IF;

    v_actor_rol := audit.fn_actor_rol();

    IF NOT EXISTS (
        SELECT 1
        FROM core.estado_transicion_permitida etp
        WHERE etp.estado_origen = OLD.estado_actual
          AND etp.estado_destino = NEW.estado_actual
          AND etp.activa = TRUE
          AND (v_actor_rol IS NULL OR etp.rol_requerido = v_actor_rol)
    ) THEN
        RAISE EXCEPTION 'Transicion de estado no permitida: % -> %',
            OLD.estado_actual, NEW.estado_actual
            USING ERRCODE = '23514';
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION audit.fn_registrar_cambio_configuracion()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        NEW.actualizado_por := audit.fn_actor_usuario_id();
        INSERT INTO audit.configuracion_historial (
            parametro_id,
            clave,
            version_anterior,
            version_nueva,
            valor_anterior,
            valor_nuevo,
            actor_usuario_id,
            origen
        )
        VALUES (
            NEW.parametro_id,
            NEW.clave,
            NULL,
            NEW.version,
            NULL,
            core.fn_parametro_a_jsonb(NEW.tipo_valor, NEW.valor_texto),
            audit.fn_actor_usuario_id(),
            audit.fn_origen_evento()
        );
        RETURN NEW;
    END IF;

    NEW.version := OLD.version + 1;
    NEW.actualizado_por := audit.fn_actor_usuario_id();
    NEW.actualizado_en := CURRENT_TIMESTAMP;

    INSERT INTO audit.configuracion_historial (
        parametro_id,
        clave,
        version_anterior,
        version_nueva,
        valor_anterior,
        valor_nuevo,
        actor_usuario_id,
        origen
    )
    VALUES (
        NEW.parametro_id,
        NEW.clave,
        OLD.version,
        NEW.version,
        core.fn_parametro_a_jsonb(OLD.tipo_valor, OLD.valor_texto),
        core.fn_parametro_a_jsonb(NEW.tipo_valor, NEW.valor_texto),
        audit.fn_actor_usuario_id(),
        audit.fn_origen_evento()
    );

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION audit.fn_registrar_historial_estado_solicitud()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit.solicitud_historial_estado (
            solicitud_id,
            estado_anterior,
            estado_nuevo,
            actor_usuario_id,
            actor_rol,
            origen
        )
        VALUES (
            NEW.solicitud_id,
            NULL,
            NEW.estado_actual,
            audit.fn_actor_usuario_id(),
            audit.fn_actor_rol(),
            audit.fn_origen_evento()
        );
        RETURN NEW;
    END IF;

    IF NEW.estado_actual IS DISTINCT FROM OLD.estado_actual THEN
        INSERT INTO audit.solicitud_historial_estado (
            solicitud_id,
            estado_anterior,
            estado_nuevo,
            actor_usuario_id,
            actor_rol,
            comentario,
            origen
        )
        VALUES (
            NEW.solicitud_id,
            OLD.estado_actual,
            NEW.estado_actual,
            audit.fn_actor_usuario_id(),
            audit.fn_actor_rol(),
            COALESCE(NEW.observaciones_direccion, NEW.observaciones_docente),
            audit.fn_origen_evento()
        );
    END IF;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE FUNCTION audit.fn_registrar_historial_cambios_solicitud()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF TG_OP = 'INSERT' THEN
        INSERT INTO audit.solicitud_historial_cambios (
            solicitud_id,
            accion,
            actor_usuario_id,
            origen,
            fila_anterior,
            fila_nueva
        )
        VALUES (
            NEW.solicitud_id,
            'INSERT',
            audit.fn_actor_usuario_id(),
            audit.fn_origen_evento(),
            NULL,
            to_jsonb(NEW)
        );
        RETURN NEW;
    END IF;

    INSERT INTO audit.solicitud_historial_cambios (
        solicitud_id,
        accion,
        actor_usuario_id,
        origen,
        fila_anterior,
        fila_nueva
    )
    VALUES (
        NEW.solicitud_id,
        'UPDATE',
        audit.fn_actor_usuario_id(),
        audit.fn_origen_evento(),
        to_jsonb(OLD),
        to_jsonb(NEW)
    );

    RETURN NEW;
END;
$$;

COMMIT;
