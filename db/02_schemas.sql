BEGIN;

CREATE SCHEMA IF NOT EXISTS config;
CREATE SCHEMA IF NOT EXISTS core;
CREATE SCHEMA IF NOT EXISTS audit;
CREATE SCHEMA IF NOT EXISTS integration;
CREATE SCHEMA IF NOT EXISTS appsheet;

COMMENT ON SCHEMA config IS 'Configuracion funcional editable del sistema.';
COMMENT ON SCHEMA core IS 'Datos operativos y de negocio.';
COMMENT ON SCHEMA audit IS 'Trazabilidad, historicos y auditoria.';
COMMENT ON SCHEMA integration IS 'Registro de importaciones e integraciones.';
COMMENT ON SCHEMA appsheet IS 'Vistas de exposicion para AppSheet.';

COMMIT;
