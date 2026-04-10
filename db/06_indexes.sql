BEGIN;

CREATE INDEX IF NOT EXISTS ix_parametro_sistema_categoria
    ON config.parametro_sistema (categoria);

CREATE INDEX IF NOT EXISTS ix_docente_activo
    ON core.docente (activo);

CREATE INDEX IF NOT EXISTS ix_calendario_no_lectivo_fecha
    ON core.calendario_no_lectivo (fecha);

CREATE INDEX IF NOT EXISTS ix_solicitud_docente_fechas
    ON core.solicitud (docente_id, fecha_inicio, fecha_fin);

CREATE INDEX IF NOT EXISTS ix_solicitud_estado_actual
    ON core.solicitud (estado_actual);

CREATE INDEX IF NOT EXISTS ix_solicitud_revision_manual
    ON core.solicitud (requiere_revision_manual)
    WHERE requiere_revision_manual = TRUE;

CREATE INDEX IF NOT EXISTS ix_solicitud_presentada_seneca
    ON core.solicitud (presentada_en_seneca, fecha_presentacion_seneca);

CREATE INDEX IF NOT EXISTS ix_incidencia_solicitud_abierta
    ON core.incidencia_solicitud (solicitud_id, abierta);

CREATE INDEX IF NOT EXISTS ix_historial_estado_solicitud_fecha
    ON audit.solicitud_historial_estado (solicitud_id, creado_en DESC);

CREATE INDEX IF NOT EXISTS ix_historial_cambios_solicitud_fecha
    ON audit.solicitud_historial_cambios (solicitud_id, creado_en DESC);

CREATE INDEX IF NOT EXISTS ix_configuracion_historial_clave_fecha
    ON audit.configuracion_historial (clave, creado_en DESC);

CREATE INDEX IF NOT EXISTS ix_carga_externa_tipo_estado
    ON integration.carga_externa (tipo_carga, estado, creado_en DESC);

COMMIT;
