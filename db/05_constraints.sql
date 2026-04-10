BEGIN;

ALTER TABLE config.parametro_sistema
    ADD CONSTRAINT uq_parametro_sistema_clave UNIQUE (clave),
    ADD CONSTRAINT chk_parametro_sistema_clave
        CHECK (clave ~ '^[a-z0-9_.-]+$'),
    ADD CONSTRAINT chk_parametro_sistema_categoria
        CHECK (char_length(trim(categoria)) >= 3),
    ADD CONSTRAINT chk_parametro_sistema_valor_texto_no_vacio
        CHECK (char_length(trim(valor_texto)) >= 1),
    ADD CONSTRAINT chk_parametro_sistema_tipo_y_valor
        CHECK (
            tipo_valor = 'texto'
            OR (tipo_valor = 'numero' AND trim(valor_texto) ~ '^-?[0-9]+$')
            OR (tipo_valor = 'booleano' AND lower(trim(valor_texto)) IN ('true', 'false'))
            OR (
                tipo_valor = 'fecha'
                AND to_char(to_date(trim(valor_texto), 'YYYY-MM-DD'), 'YYYY-MM-DD') = trim(valor_texto)
            )
        );

ALTER TABLE core.usuario
    ADD CONSTRAINT uq_usuario_email UNIQUE (email),
    ADD CONSTRAINT chk_usuario_email_formato
        CHECK (email ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$');

ALTER TABLE core.docente
    ADD CONSTRAINT uq_docente_codigo_interno UNIQUE (codigo_interno),
    ADD CONSTRAINT uq_docente_email_centro UNIQUE (email_centro),
    ADD CONSTRAINT uq_docente_usuario UNIQUE (usuario_id),
    ADD CONSTRAINT chk_docente_email_formato
        CHECK (email_centro ~* '^[A-Z0-9._%+-]+@[A-Z0-9.-]+\.[A-Z]{2,}$'),
    ADD CONSTRAINT chk_docente_inicial_desempate
        CHECK (inicial_desempate ~ '^[A-Z]$');

ALTER TABLE core.calendario_no_lectivo
    ADD CONSTRAINT uq_calendario_no_lectivo_fecha UNIQUE (fecha);

ALTER TABLE core.estado_transicion_permitida
    ADD CONSTRAINT uq_estado_transicion UNIQUE (estado_origen, estado_destino, rol_requerido),
    ADD CONSTRAINT chk_estado_transicion_distinta
        CHECK (estado_origen <> estado_destino);

ALTER TABLE core.solicitud
    ADD CONSTRAINT uq_solicitud_codigo UNIQUE (codigo),
    ADD CONSTRAINT chk_solicitud_rango_fechas
        CHECK (fecha_inicio <= fecha_fin),
    ADD CONSTRAINT chk_solicitud_dias_habiles
        CHECK (dias_habiles_solicitados >= 0),
    ADD CONSTRAINT chk_solicitud_version
        CHECK (version_registro >= 1),
    ADD CONSTRAINT chk_solicitud_seneca_coherencia
        CHECK (
            (presentada_en_seneca = FALSE AND fecha_presentacion_seneca IS NULL)
            OR (presentada_en_seneca = TRUE AND fecha_presentacion_seneca IS NOT NULL)
        );

ALTER TABLE core.incidencia_solicitud
    ADD CONSTRAINT chk_incidencia_resolucion
        CHECK (
            (abierta = TRUE AND resuelta_en IS NULL)
            OR (abierta = FALSE AND resuelta_en IS NOT NULL)
        );

ALTER TABLE integration.carga_externa
    ADD CONSTRAINT chk_carga_externa_contadores
        CHECK (
            registros_recibidos >= 0
            AND registros_validos >= 0
            AND registros_rechazados >= 0
            AND registros_validos + registros_rechazados <= registros_recibidos
        );

COMMIT;
