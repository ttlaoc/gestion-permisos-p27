BEGIN;

DROP VIEW IF EXISTS appsheet.vw_revision_solicitudes;
DROP VIEW IF EXISTS appsheet.vw_incidencias;
DROP VIEW IF EXISTS appsheet.vw_calendario_no_lectivo;
DROP VIEW IF EXISTS appsheet.vw_parametros_editables;
DROP VIEW IF EXISTS appsheet.vw_solicitudes;
DROP VIEW IF EXISTS appsheet.vw_docentes;

CREATE OR REPLACE VIEW appsheet.vw_parametros_editables AS
SELECT
    parametro_id,
    clave,
    categoria,
    descripcion,
    tipo_valor,
    valor_texto,
    version,
    actualizado_en
FROM config.parametro_sistema
WHERE editable = TRUE
WITH LOCAL CHECK OPTION;

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

COMMENT ON VIEW appsheet.vw_parametros_editables IS
'Vista editable justificada para AppSheet: filtra solo parametros marcados como editables y expone valores escalares aptos para el MVP.';

COMMENT ON VIEW appsheet.vw_revision_solicitudes IS
'Vista de solo lectura para AppSheet orientada a revision y paneles; no debe usarse para escritura.';

COMMIT;
