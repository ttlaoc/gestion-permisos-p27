BEGIN;

CREATE OR REPLACE VIEW appsheet.vw_docentes AS
SELECT
    docente_id,
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
FROM core.docente;

CREATE OR REPLACE VIEW appsheet.vw_solicitudes AS
SELECT
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
FROM core.solicitud;

CREATE OR REPLACE VIEW appsheet.vw_parametros_editables AS
SELECT
    parametro_id,
    clave,
    categoria,
    descripcion,
    valor_json,
    editable,
    version,
    actualizado_en
FROM config.parametro_sistema
WHERE editable = TRUE;

CREATE OR REPLACE VIEW appsheet.vw_calendario_no_lectivo AS
SELECT
    calendario_no_lectivo_id,
    fecha,
    descripcion,
    ambito,
    es_festivo,
    es_no_lectivo,
    origen,
    creado_en,
    actualizado_en
FROM core.calendario_no_lectivo;

CREATE OR REPLACE VIEW appsheet.vw_incidencias AS
SELECT
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
FROM core.incidencia_solicitud;

CREATE OR REPLACE VIEW appsheet.vw_revision_solicitudes AS
SELECT
    s.solicitud_id,
    s.codigo,
    d.codigo_interno AS docente_codigo,
    d.nombre,
    d.apellido_1,
    d.apellido_2,
    d.departamento,
    d.inicial_desempate,
    s.fecha_inicio,
    s.fecha_fin,
    s.dias_habiles_solicitados,
    s.estado_actual,
    s.es_consecutiva_real,
    s.requiere_revision_manual,
    s.presentada_en_seneca,
    s.referencia_seneca,
    s.actualizada_en
FROM core.solicitud s
JOIN core.docente d ON d.docente_id = s.docente_id;

COMMIT;
