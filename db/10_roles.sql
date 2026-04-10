BEGIN;

DO $$
BEGIN
    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'gp27_owner') THEN
        CREATE ROLE gp27_owner NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'gp27_appsheet') THEN
        CREATE ROLE gp27_appsheet NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'gp27_automation') THEN
        CREATE ROLE gp27_automation NOLOGIN;
    END IF;

    IF NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = 'gp27_readonly') THEN
        CREATE ROLE gp27_readonly NOLOGIN;
    END IF;
END
$$;

-- Limpieza defensiva para evitar arrastrar grants de iteraciones previas del MVP.
REVOKE ALL PRIVILEGES ON ALL TABLES IN SCHEMA core, config, integration, appsheet
FROM gp27_appsheet, gp27_automation, gp27_readonly;
REVOKE ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA config, core
FROM gp27_appsheet, gp27_automation, gp27_readonly;

GRANT USAGE ON SCHEMA config, core, audit, integration, appsheet TO gp27_owner;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA config, core, audit, integration TO gp27_owner;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA config, core TO gp27_owner;

-- AppSheet: escritura directa solo en tablas base operativas y lectura en vistas de apoyo.
GRANT USAGE ON SCHEMA config, core, appsheet TO gp27_appsheet;
GRANT USAGE ON SCHEMA appsheet TO gp27_readonly;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA config, core TO gp27_appsheet;

GRANT SELECT (
    parametro_id,
    clave,
    categoria,
    descripcion,
    tipo_valor,
    valor_texto,
    editable,
    version,
    actualizado_por,
    actualizado_en,
    creado_en
) ON config.parametro_sistema TO gp27_appsheet;
GRANT UPDATE (
    tipo_valor,
    valor_texto
) ON config.parametro_sistema TO gp27_appsheet;

GRANT SELECT (
    docente_id,
    usuario_id,
    codigo_interno,
    nombre,
    apellido_1,
    apellido_2,
    email_centro,
    departamento,
    activo,
    inicial_desempate,
    observaciones,
    creado_en,
    actualizado_en
) ON core.docente TO gp27_appsheet;
GRANT INSERT (
    docente_id,
    usuario_id,
    codigo_interno,
    nombre,
    apellido_1,
    apellido_2,
    email_centro,
    departamento,
    activo,
    inicial_desempate,
    observaciones
) ON core.docente TO gp27_appsheet;
GRANT UPDATE (
    usuario_id,
    codigo_interno,
    nombre,
    apellido_1,
    apellido_2,
    email_centro,
    departamento,
    activo,
    inicial_desempate,
    observaciones
) ON core.docente TO gp27_appsheet;

GRANT SELECT (
    solicitud_id,
    codigo,
    docente_id,
    creada_por_usuario_id,
    revisada_por_usuario_id,
    fecha_solicitud,
    fecha_inicio,
    fecha_fin,
    motivo,
    observaciones_docente,
    observaciones_direccion,
    estado_actual,
    dias_habiles_solicitados,
    es_consecutiva_real,
    requiere_revision_manual,
    presentada_en_seneca,
    fecha_presentacion_seneca,
    referencia_seneca,
    version_registro,
    creada_en,
    actualizada_en
) ON core.solicitud TO gp27_appsheet;
GRANT INSERT (
    solicitud_id,
    docente_id,
    creada_por_usuario_id,
    revisada_por_usuario_id,
    fecha_solicitud,
    fecha_inicio,
    fecha_fin,
    motivo,
    observaciones_docente,
    observaciones_direccion,
    estado_actual,
    presentada_en_seneca,
    fecha_presentacion_seneca,
    referencia_seneca
) ON core.solicitud TO gp27_appsheet;
GRANT UPDATE (
    docente_id,
    creada_por_usuario_id,
    revisada_por_usuario_id,
    fecha_solicitud,
    fecha_inicio,
    fecha_fin,
    motivo,
    observaciones_docente,
    observaciones_direccion,
    estado_actual,
    presentada_en_seneca,
    fecha_presentacion_seneca,
    referencia_seneca
) ON core.solicitud TO gp27_appsheet;

GRANT SELECT (
    calendario_no_lectivo_id,
    fecha,
    descripcion,
    ambito,
    es_festivo,
    es_no_lectivo,
    origen,
    creado_en,
    actualizado_en
) ON core.calendario_no_lectivo TO gp27_appsheet;
GRANT INSERT (
    fecha,
    descripcion,
    ambito,
    es_festivo,
    es_no_lectivo,
    origen
) ON core.calendario_no_lectivo TO gp27_appsheet;
GRANT UPDATE (
    fecha,
    descripcion,
    ambito,
    es_festivo,
    es_no_lectivo,
    origen
) ON core.calendario_no_lectivo TO gp27_appsheet;

GRANT SELECT (
    incidencia_id,
    solicitud_id,
    tipo_incidencia,
    severidad,
    descripcion,
    abierta,
    detectada_por_usuario_id,
    resuelta_por_usuario_id,
    resuelta_en,
    creada_en,
    actualizada_en
) ON core.incidencia_solicitud TO gp27_appsheet;
GRANT INSERT (
    incidencia_id,
    solicitud_id,
    tipo_incidencia,
    severidad,
    descripcion,
    abierta,
    detectada_por_usuario_id,
    resuelta_por_usuario_id,
    resuelta_en
) ON core.incidencia_solicitud TO gp27_appsheet;
GRANT UPDATE (
    solicitud_id,
    tipo_incidencia,
    severidad,
    descripcion,
    abierta,
    detectada_por_usuario_id,
    resuelta_por_usuario_id,
    resuelta_en
) ON core.incidencia_solicitud TO gp27_appsheet;

GRANT SELECT ON appsheet.vw_parametros_editables TO gp27_appsheet;
GRANT SELECT ON appsheet.vw_revision_solicitudes TO gp27_appsheet, gp27_readonly;

-- Automatizacion: sin escritura operativa en entidades de AppSheet.
GRANT USAGE ON SCHEMA integration TO gp27_automation;
GRANT SELECT, INSERT, UPDATE ON integration.carga_externa TO gp27_automation;
GRANT SELECT ON appsheet.vw_revision_solicitudes TO gp27_automation;
GRANT SELECT (
    solicitud_id,
    codigo,
    docente_id,
    fecha_inicio,
    fecha_fin,
    estado_actual,
    presentada_en_seneca,
    fecha_presentacion_seneca,
    referencia_seneca,
    actualizada_en
) ON core.solicitud TO gp27_automation;

-- Solo lectura: vistas de apoyo aptas para consulta y paneles.
GRANT SELECT ON appsheet.vw_parametros_editables TO gp27_readonly;

COMMIT;

-- TODO: crear usuarios login reales por entorno y asignarles estos roles sin guardar secretos en SQL versionado.
