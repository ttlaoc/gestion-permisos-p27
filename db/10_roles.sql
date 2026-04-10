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

GRANT USAGE ON SCHEMA config, core, audit, integration, appsheet TO gp27_owner;
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA config, core, audit, integration TO gp27_owner;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA core TO gp27_owner;

GRANT USAGE ON SCHEMA appsheet TO gp27_appsheet, gp27_readonly;
GRANT SELECT, INSERT, UPDATE ON appsheet.vw_docentes TO gp27_appsheet;
GRANT SELECT, INSERT, UPDATE ON appsheet.vw_solicitudes TO gp27_appsheet;
GRANT SELECT, INSERT, UPDATE ON appsheet.vw_calendario_no_lectivo TO gp27_appsheet;
GRANT SELECT, UPDATE ON appsheet.vw_parametros_editables TO gp27_appsheet;
GRANT SELECT, INSERT, UPDATE ON appsheet.vw_incidencias TO gp27_appsheet;
GRANT SELECT ON appsheet.vw_revision_solicitudes TO gp27_appsheet, gp27_readonly;

GRANT USAGE ON SCHEMA integration TO gp27_automation;
GRANT SELECT, INSERT, UPDATE ON integration.carga_externa TO gp27_automation;
GRANT SELECT ON appsheet.vw_revision_solicitudes TO gp27_automation;
GRANT SELECT ON appsheet.vw_solicitudes TO gp27_automation;

GRANT SELECT ON appsheet.vw_docentes, appsheet.vw_solicitudes, appsheet.vw_revision_solicitudes TO gp27_readonly;

COMMIT;

-- TODO: crear usuarios login reales por entorno y asignarles estos roles sin guardar secretos en SQL versionado.
