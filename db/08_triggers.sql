BEGIN;

CREATE TRIGGER trg_usuario_set_timestamp
BEFORE UPDATE ON core.usuario
FOR EACH ROW
EXECUTE FUNCTION audit.fn_set_timestamp();

CREATE TRIGGER trg_docente_set_timestamp
BEFORE UPDATE ON core.docente
FOR EACH ROW
EXECUTE FUNCTION audit.fn_set_timestamp();

CREATE TRIGGER trg_calendario_no_lectivo_set_timestamp
BEFORE UPDATE ON core.calendario_no_lectivo
FOR EACH ROW
EXECUTE FUNCTION audit.fn_set_timestamp();

CREATE TRIGGER trg_incidencia_solicitud_set_timestamp
BEFORE UPDATE ON core.incidencia_solicitud
FOR EACH ROW
EXECUTE FUNCTION audit.fn_set_timestamp();

CREATE TRIGGER trg_parametro_sistema_auditar
BEFORE INSERT OR UPDATE ON config.parametro_sistema
FOR EACH ROW
EXECUTE FUNCTION audit.fn_registrar_cambio_configuracion();

CREATE TRIGGER trg_solicitud_derivados
BEFORE INSERT OR UPDATE OF fecha_inicio, fecha_fin, docente_id ON core.solicitud
FOR EACH ROW
EXECUTE FUNCTION core.fn_actualizar_campos_derivados_solicitud();

CREATE TRIGGER trg_solicitud_touch
BEFORE INSERT OR UPDATE ON core.solicitud
FOR EACH ROW
EXECUTE FUNCTION core.fn_touch_solicitud();

CREATE TRIGGER trg_solicitud_validar_estado_inicial
BEFORE INSERT ON core.solicitud
FOR EACH ROW
EXECUTE FUNCTION core.fn_validar_estado_inicial_solicitud();

CREATE TRIGGER trg_solicitud_bloquear_edicion_final
BEFORE UPDATE ON core.solicitud
FOR EACH ROW
EXECUTE FUNCTION core.fn_bloquear_edicion_solicitud_final();

CREATE TRIGGER trg_solicitud_validar_estado
BEFORE UPDATE OF estado_actual ON core.solicitud
FOR EACH ROW
EXECUTE FUNCTION core.fn_validar_transicion_estado();

CREATE TRIGGER trg_solicitud_historial_estado
AFTER INSERT OR UPDATE OF estado_actual ON core.solicitud
FOR EACH ROW
EXECUTE FUNCTION audit.fn_registrar_historial_estado_solicitud();

CREATE TRIGGER trg_solicitud_historial_cambios
AFTER INSERT OR UPDATE ON core.solicitud
FOR EACH ROW
EXECUTE FUNCTION audit.fn_registrar_historial_cambios_solicitud();

COMMIT;
