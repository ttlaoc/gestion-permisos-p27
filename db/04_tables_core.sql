BEGIN;

CREATE SEQUENCE IF NOT EXISTS core.seq_codigo_solicitud START WITH 1 INCREMENT BY 1;

CREATE TABLE IF NOT EXISTS config.parametro_sistema (
    parametro_id              BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    clave                     TEXT NOT NULL,
    categoria                 TEXT NOT NULL,
    descripcion               TEXT NOT NULL,
    valor_json                JSONB NOT NULL,
    editable                  BOOLEAN NOT NULL DEFAULT TRUE,
    version                   INTEGER NOT NULL DEFAULT 1,
    actualizado_por           UUID NULL,
    actualizado_en            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    creado_en                 TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.usuario (
    usuario_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email                     TEXT NOT NULL,
    nombre_mostrar            TEXT NOT NULL,
    rol_principal             core.rol_usuario_enum NOT NULL,
    activo                    BOOLEAN NOT NULL DEFAULT TRUE,
    proveedor_identidad       TEXT NOT NULL DEFAULT 'appsheet',
    referencia_externa        TEXT NULL,
    creado_en                 TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.docente (
    docente_id                UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    usuario_id                UUID NULL REFERENCES core.usuario(usuario_id),
    codigo_interno            TEXT NOT NULL,
    nombre                    TEXT NOT NULL,
    apellido_1                TEXT NOT NULL,
    apellido_2                TEXT NULL,
    email_centro              TEXT NOT NULL,
    departamento              TEXT NULL,
    activo                    BOOLEAN NOT NULL DEFAULT TRUE,
    inicial_desempate         CHAR(1) NOT NULL,
    documento_hash            TEXT NULL,
    observaciones             TEXT NULL,
    creado_en                 TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.calendario_no_lectivo (
    calendario_no_lectivo_id  BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    fecha                     DATE NOT NULL,
    descripcion               TEXT NOT NULL,
    ambito                    TEXT NOT NULL DEFAULT 'centro',
    es_festivo                BOOLEAN NOT NULL DEFAULT TRUE,
    es_no_lectivo             BOOLEAN NOT NULL DEFAULT TRUE,
    origen                    TEXT NOT NULL DEFAULT 'manual',
    creado_en                 TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizado_en            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.estado_transicion_permitida (
    transicion_id             BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    estado_origen             core.estado_solicitud_enum NOT NULL,
    estado_destino            core.estado_solicitud_enum NOT NULL,
    rol_requerido             core.rol_usuario_enum NOT NULL,
    requiere_comentario       BOOLEAN NOT NULL DEFAULT FALSE,
    activa                    BOOLEAN NOT NULL DEFAULT TRUE,
    creado_en                 TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.solicitud (
    solicitud_id              UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    codigo                    TEXT NOT NULL DEFAULT ('P27-' || lpad(nextval('core.seq_codigo_solicitud')::TEXT, 6, '0')),
    docente_id                UUID NOT NULL REFERENCES core.docente(docente_id),
    creada_por_usuario_id     UUID NULL REFERENCES core.usuario(usuario_id),
    revisada_por_usuario_id   UUID NULL REFERENCES core.usuario(usuario_id),
    fecha_solicitud           DATE NOT NULL DEFAULT CURRENT_DATE,
    fecha_inicio              DATE NOT NULL,
    fecha_fin                 DATE NOT NULL,
    motivo                    TEXT NOT NULL,
    observaciones_docente     TEXT NULL,
    observaciones_direccion   TEXT NULL,
    estado_actual             core.estado_solicitud_enum NOT NULL DEFAULT 'borrador',
    dias_habiles_solicitados  INTEGER NOT NULL DEFAULT 0,
    es_consecutiva_real       BOOLEAN NOT NULL DEFAULT FALSE,
    requiere_revision_manual  BOOLEAN NOT NULL DEFAULT FALSE,
    presentada_en_seneca      BOOLEAN NOT NULL DEFAULT FALSE,
    fecha_presentacion_seneca DATE NULL,
    referencia_seneca         TEXT NULL,
    version_registro          INTEGER NOT NULL DEFAULT 1,
    creada_en                 TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizada_en            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS core.incidencia_solicitud (
    incidencia_id             UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    solicitud_id              UUID NOT NULL REFERENCES core.solicitud(solicitud_id) ON DELETE CASCADE,
    tipo_incidencia           core.tipo_incidencia_enum NOT NULL,
    severidad                 core.severidad_incidencia_enum NOT NULL DEFAULT 'media',
    descripcion               TEXT NOT NULL,
    abierta                   BOOLEAN NOT NULL DEFAULT TRUE,
    detectada_por_usuario_id  UUID NULL REFERENCES core.usuario(usuario_id),
    resuelta_por_usuario_id   UUID NULL REFERENCES core.usuario(usuario_id),
    resuelta_en               TIMESTAMPTZ NULL,
    creada_en                 TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    actualizada_en            TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit.configuracion_historial (
    configuracion_historial_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    parametro_id               BIGINT NULL REFERENCES config.parametro_sistema(parametro_id),
    clave                      TEXT NOT NULL,
    version_anterior           INTEGER NULL,
    version_nueva              INTEGER NOT NULL,
    valor_anterior             JSONB NULL,
    valor_nuevo                JSONB NOT NULL,
    actor_usuario_id           UUID NULL,
    origen                     core.origen_evento_enum NOT NULL DEFAULT 'sql_directo',
    motivo                     TEXT NULL,
    creado_en                  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit.solicitud_historial_estado (
    solicitud_historial_estado_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    solicitud_id                  UUID NOT NULL REFERENCES core.solicitud(solicitud_id) ON DELETE CASCADE,
    estado_anterior               core.estado_solicitud_enum NULL,
    estado_nuevo                  core.estado_solicitud_enum NOT NULL,
    actor_usuario_id              UUID NULL REFERENCES core.usuario(usuario_id),
    actor_rol                     core.rol_usuario_enum NULL,
    comentario                    TEXT NULL,
    origen                        core.origen_evento_enum NOT NULL DEFAULT 'sql_directo',
    creado_en                     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit.solicitud_historial_cambios (
    solicitud_historial_cambio_id BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    solicitud_id                  UUID NOT NULL REFERENCES core.solicitud(solicitud_id) ON DELETE CASCADE,
    accion                        TEXT NOT NULL,
    actor_usuario_id              UUID NULL REFERENCES core.usuario(usuario_id),
    origen                        core.origen_evento_enum NOT NULL DEFAULT 'sql_directo',
    fila_anterior                 JSONB NULL,
    fila_nueva                    JSONB NULL,
    creado_en                     TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS audit.acceso_administrativo (
    acceso_administrativo_id   BIGINT GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    usuario_id                 UUID NULL REFERENCES core.usuario(usuario_id),
    accion                     TEXT NOT NULL,
    detalle                    TEXT NULL,
    origen                     core.origen_evento_enum NOT NULL DEFAULT 'sql_directo',
    creado_en                  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS integration.carga_externa (
    carga_externa_id           UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    tipo_carga                 TEXT NOT NULL,
    referencia_origen          TEXT NULL,
    hash_contenido             TEXT NULL,
    estado                     TEXT NOT NULL DEFAULT 'pendiente',
    registros_recibidos        INTEGER NOT NULL DEFAULT 0,
    registros_validos          INTEGER NOT NULL DEFAULT 0,
    registros_rechazados       INTEGER NOT NULL DEFAULT 0,
    detalle_error              TEXT NULL,
    iniciada_por_usuario_id    UUID NULL REFERENCES core.usuario(usuario_id),
    creado_en                  TIMESTAMPTZ NOT NULL DEFAULT CURRENT_TIMESTAMP,
    finalizado_en              TIMESTAMPTZ NULL
);

COMMIT;
