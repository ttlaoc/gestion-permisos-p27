BEGIN;

INSERT INTO config.parametro_sistema (clave, categoria, descripcion, tipo_valor, valor_texto, editable)
VALUES
    ('reglas.cupo_diario_permisos', 'reglas', 'Número máximo orientativo de permisos P.27 por día hábil.', 'numero', '5', TRUE),
    ('reglas.max_dias_habiles_por_docente', 'reglas', 'Máximo anual orientativo de días hábiles P.27 por docente.', 'numero', '2', TRUE),
    ('reglas.revisar_consecutividad_real', 'reglas', 'Marca para revisión manual las solicitudes consecutivas en días hábiles reales.', 'booleano', 'true', TRUE),
    ('reglas.letra_desempate_inicio', 'reglas', 'Letra inicial para desempate de prioridad si la normativa interna lo requiere.', 'texto', 'M', TRUE),
    ('centro.nombre', 'centro', 'Nombre visible del centro.', 'texto', 'IES Demo P27', TRUE),
    ('centro.codigo', 'centro', 'Código interno o administrativo del centro.', 'texto', '11000000', TRUE),
    ('curso.academico', 'centro', 'Curso académico operativo del MVP.', 'texto', '2025-2026', TRUE),
    ('integraciones.google_calendar_habilitado', 'integraciones', 'Activa futuras integraciones con Google Calendar.', 'booleano', 'false', TRUE),
    ('integraciones.n8n_habilitado', 'integraciones', 'Activa futuras automatizaciones de n8n.', 'booleano', 'false', TRUE)
ON CONFLICT (clave) DO NOTHING;

INSERT INTO core.usuario (usuario_id, email, nombre_mostrar, rol_principal, proveedor_identidad, referencia_externa)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'direccion@centro.local', 'Dirección Centro', 'direccion', 'appsheet', 'direccion-demo'),
    ('22222222-2222-2222-2222-222222222222', 'admin@centro.local', 'Administración Centro', 'administracion', 'appsheet', 'admin-demo'),
    ('33333333-3333-3333-3333-333333333333', 'docente1@centro.local', 'Ana Ruiz', 'profesorado', 'appsheet', 'docente-ana'),
    ('44444444-4444-4444-4444-444444444444', 'docente2@centro.local', 'Luis Pérez', 'profesorado', 'appsheet', 'docente-luis'),
    ('55555555-5555-5555-5555-555555555555', 'docente3@centro.local', 'Marta Gómez', 'profesorado', 'appsheet', 'docente-marta'),
    ('66666666-6666-6666-6666-666666666666', 'docente4@centro.local', 'José Martín', 'profesorado', 'appsheet', 'docente-jose'),
    ('77777777-7777-7777-7777-777777777777', 'docente5@centro.local', 'Elena Navarro', 'profesorado', 'appsheet', 'docente-elena'),
    ('88888888-8888-8888-8888-888888888888', 'automatizacion@centro.local', 'Proceso MVP', 'automatizacion', 'sistema', 'automatizacion-demo')
ON CONFLICT (email) DO NOTHING;

INSERT INTO core.docente (
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
    documento_hash
)
VALUES
    ('aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333', 'DOC-0001', 'Ana', 'Ruiz', 'López', 'docente1@centro.local', 'Lengua', TRUE, 'R', encode(digest('00000000A', 'sha256'), 'hex')),
    ('bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '44444444-4444-4444-4444-444444444444', 'DOC-0002', 'Luis', 'Pérez', 'Martín', 'docente2@centro.local', 'Matemáticas', TRUE, 'P', encode(digest('00000000B', 'sha256'), 'hex')),
    ('ccccaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '55555555-5555-5555-5555-555555555555', 'DOC-0003', 'Marta', 'Gómez', 'Santos', 'docente3@centro.local', 'Biología', TRUE, 'G', encode(digest('00000000C', 'sha256'), 'hex')),
    ('ddddaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '66666666-6666-6666-6666-666666666666', 'DOC-0004', 'José', 'Martín', 'Ruano', 'docente4@centro.local', 'Geografía', TRUE, 'M', encode(digest('00000000D', 'sha256'), 'hex')),
    ('eeeeaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '77777777-7777-7777-7777-777777777777', 'DOC-0005', 'Elena', 'Navarro', 'Díaz', 'docente5@centro.local', 'Inglés', TRUE, 'N', encode(digest('00000000E', 'sha256'), 'hex'))
ON CONFLICT (codigo_interno) DO NOTHING;

INSERT INTO core.estado_transicion_permitida (estado_origen, estado_destino, rol_requerido, requiere_comentario)
VALUES
    ('borrador', 'enviada', 'profesorado', FALSE),
    ('borrador', 'cancelada', 'profesorado', FALSE),
    ('enviada', 'validada_automatica', 'automatizacion', FALSE),
    ('enviada', 'validada_automatica', 'direccion', FALSE),
    ('enviada', 'requiere_revision', 'automatizacion', FALSE),
    ('enviada', 'requiere_revision', 'direccion', FALSE),
    ('enviada', 'cancelada', 'profesorado', TRUE),
    ('validada_automatica', 'pendiente_subsanacion', 'direccion', TRUE),
    ('validada_automatica', 'autorizada_para_seneca', 'direccion', FALSE),
    ('validada_automatica', 'denegada', 'direccion', TRUE),
    ('requiere_revision', 'pendiente_subsanacion', 'direccion', TRUE),
    ('requiere_revision', 'autorizada_para_seneca', 'direccion', FALSE),
    ('requiere_revision', 'denegada', 'direccion', TRUE),
    ('pendiente_subsanacion', 'enviada', 'profesorado', FALSE),
    ('pendiente_subsanacion', 'cancelada', 'profesorado', TRUE),
    ('autorizada_para_seneca', 'presentada_en_seneca', 'administracion', FALSE),
    ('presentada_en_seneca', 'aceptada', 'administracion', FALSE),
    ('presentada_en_seneca', 'denegada', 'administracion', TRUE),
    ('aceptada', 'cerrada', 'administracion', FALSE),
    ('denegada', 'cerrada', 'administracion', FALSE),
    ('denegada', 'cerrada', 'direccion', FALSE)
ON CONFLICT (estado_origen, estado_destino, rol_requerido) DO NOTHING;

INSERT INTO core.calendario_no_lectivo (fecha, descripcion, ambito, es_festivo, es_no_lectivo, origen)
VALUES
    ('2026-01-06', 'Epifanía del Señor', 'centro', TRUE, TRUE, 'seed'),
    ('2026-02-27', 'Día no lectivo de centro', 'centro', FALSE, TRUE, 'seed'),
    ('2026-03-02', 'Festividad local de ejemplo', 'centro', TRUE, TRUE, 'seed'),
    ('2026-04-02', 'Jueves Santo', 'centro', TRUE, TRUE, 'seed'),
    ('2026-04-03', 'Viernes Santo', 'centro', TRUE, TRUE, 'seed'),
    ('2026-05-01', 'Fiesta del Trabajo', 'centro', TRUE, TRUE, 'seed'),
    ('2026-10-12', 'Fiesta Nacional de España', 'centro', TRUE, TRUE, 'seed'),
    ('2026-11-02', 'Libre disposición de centro', 'centro', FALSE, TRUE, 'seed'),
    ('2026-12-08', 'Inmaculada Concepción', 'centro', TRUE, TRUE, 'seed'),
    ('2026-12-25', 'Navidad', 'centro', TRUE, TRUE, 'seed')
ON CONFLICT (fecha) DO NOTHING;

SELECT set_config('app.origen_evento', 'appsheet', TRUE);

SELECT set_config('app.actor_usuario_id', '33333333-3333-3333-3333-333333333333', TRUE);
SELECT set_config('app.actor_rol', 'profesorado', TRUE);
INSERT INTO core.solicitud (
    solicitud_id, docente_id, creada_por_usuario_id, fecha_solicitud, fecha_inicio, fecha_fin,
    motivo, observaciones_docente, estado_actual
)
VALUES
    ('90000000-0000-0000-0000-000000000001', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333',
     '2026-04-11', '2026-05-18', '2026-05-18', 'Gestión personal pendiente de confirmar', 'Borrador guardado por la docente.', 'borrador')
ON CONFLICT (solicitud_id) DO NOTHING;

INSERT INTO core.solicitud (
    solicitud_id, docente_id, creada_por_usuario_id, fecha_solicitud, fecha_inicio, fecha_fin,
    motivo, observaciones_docente, estado_actual
)
VALUES
    ('90000000-0000-0000-0000-000000000002', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '44444444-4444-4444-4444-444444444444',
     '2026-04-09', '2026-06-15', '2026-06-19', 'Trámite familiar puntual', 'Solicitud enviada y pendiente de clasificación.', 'enviada')
ON CONFLICT (solicitud_id) DO NOTHING;

SELECT set_config('app.actor_usuario_id', '55555555-5555-5555-5555-555555555555', TRUE);
SELECT set_config('app.actor_rol', 'profesorado', TRUE);
INSERT INTO core.solicitud (
    solicitud_id, docente_id, creada_por_usuario_id, fecha_solicitud, fecha_inicio, fecha_fin,
    motivo, observaciones_docente, estado_actual
)
VALUES
    ('90000000-0000-0000-0000-000000000003', 'ccccaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '55555555-5555-5555-5555-555555555555',
     '2026-04-08', '2026-05-18', '2026-05-18', 'Consulta médica programada', 'Coincide con otras solicitudes del mismo día.', 'enviada')
ON CONFLICT (solicitud_id) DO NOTHING;

SELECT set_config('app.actor_usuario_id', '66666666-6666-6666-6666-666666666666', TRUE);
SELECT set_config('app.actor_rol', 'profesorado', TRUE);
INSERT INTO core.solicitud (
    solicitud_id, docente_id, creada_por_usuario_id, fecha_solicitud, fecha_inicio, fecha_fin,
    motivo, observaciones_docente, estado_actual
)
VALUES
    ('90000000-0000-0000-0000-000000000004', 'ddddaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '66666666-6666-6666-6666-666666666666',
     '2026-04-07', '2026-05-18', '2026-05-18', 'Asunto personal justificado', 'Solicitud inicialmente completa.', 'enviada')
ON CONFLICT (solicitud_id) DO NOTHING;

SELECT set_config('app.actor_usuario_id', '77777777-7777-7777-7777-777777777777', TRUE);
SELECT set_config('app.actor_rol', 'profesorado', TRUE);
INSERT INTO core.solicitud (
    solicitud_id, docente_id, creada_por_usuario_id, fecha_solicitud, fecha_inicio, fecha_fin,
    motivo, observaciones_docente, estado_actual
)
VALUES
    ('90000000-0000-0000-0000-000000000005', 'eeeeaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '77777777-7777-7777-7777-777777777777',
     '2026-04-06', '2026-05-18', '2026-05-18', 'Gestión administrativa urgente', 'Podría requerir aclaración documental.', 'enviada')
ON CONFLICT (solicitud_id) DO NOTHING;

SELECT set_config('app.actor_usuario_id', '33333333-3333-3333-3333-333333333333', TRUE);
SELECT set_config('app.actor_rol', 'profesorado', TRUE);
INSERT INTO core.solicitud (
    solicitud_id, docente_id, creada_por_usuario_id, fecha_solicitud, fecha_inicio, fecha_fin,
    motivo, observaciones_docente, estado_actual
)
VALUES
    ('90000000-0000-0000-0000-000000000006', 'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '33333333-3333-3333-3333-333333333333',
     '2026-04-05', '2026-05-19', '2026-05-20', 'Asuntos particulares consecutivos', 'Caso preparado para probar consecutividad real.', 'enviada')
ON CONFLICT (solicitud_id) DO NOTHING;

SELECT set_config('app.actor_usuario_id', '44444444-4444-4444-4444-444444444444', TRUE);
SELECT set_config('app.actor_rol', 'profesorado', TRUE);
INSERT INTO core.solicitud (
    solicitud_id, docente_id, creada_por_usuario_id, fecha_solicitud, fecha_inicio, fecha_fin,
    motivo, observaciones_docente, estado_actual
)
VALUES
    ('90000000-0000-0000-0000-000000000007', 'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb', '44444444-4444-4444-4444-444444444444',
     '2026-04-04', '2026-06-22', '2026-06-23', 'Gestión familiar cerrada', 'Caso completo para probar el cierre del expediente.', 'enviada')
ON CONFLICT (solicitud_id) DO NOTHING;

SELECT set_config('app.actor_usuario_id', '88888888-8888-8888-8888-888888888888', TRUE);
SELECT set_config('app.actor_rol', 'automatizacion', TRUE);
UPDATE core.solicitud SET estado_actual = 'validada_automatica'
WHERE solicitud_id IN (
    '90000000-0000-0000-0000-000000000004'
);

UPDATE core.solicitud
SET estado_actual = 'requiere_revision'
WHERE solicitud_id IN (
    '90000000-0000-0000-0000-000000000003',
    '90000000-0000-0000-0000-000000000005',
    '90000000-0000-0000-0000-000000000006',
    '90000000-0000-0000-0000-000000000007'
);

SELECT set_config('app.actor_usuario_id', '11111111-1111-1111-1111-111111111111', TRUE);
SELECT set_config('app.actor_rol', 'direccion', TRUE);

UPDATE core.solicitud
SET estado_actual = 'autorizada_para_seneca',
    revisada_por_usuario_id = '11111111-1111-1111-1111-111111111111',
    observaciones_direccion = 'Validación favorable para continuar el trámite.'
WHERE solicitud_id = '90000000-0000-0000-0000-000000000004';

UPDATE core.solicitud
SET estado_actual = 'pendiente_subsanacion',
    revisada_por_usuario_id = '11111111-1111-1111-1111-111111111111',
    observaciones_direccion = 'Falta adjuntar aclaración sobre la franja solicitada.'
WHERE solicitud_id = '90000000-0000-0000-0000-000000000005';

UPDATE core.solicitud
SET estado_actual = 'autorizada_para_seneca',
    revisada_por_usuario_id = '11111111-1111-1111-1111-111111111111',
    observaciones_direccion = 'Autorizada tras revisión de cupo y consecutividad.'
WHERE solicitud_id = '90000000-0000-0000-0000-000000000006';

UPDATE core.solicitud
SET estado_actual = 'autorizada_para_seneca',
    revisada_por_usuario_id = '11111111-1111-1111-1111-111111111111',
    observaciones_direccion = 'Revisión favorable sin incidencias.'
WHERE solicitud_id = '90000000-0000-0000-0000-000000000007';

SELECT set_config('app.actor_usuario_id', '22222222-2222-2222-2222-222222222222', TRUE);
SELECT set_config('app.actor_rol', 'administracion', TRUE);

UPDATE core.solicitud
SET estado_actual = 'presentada_en_seneca',
    presentada_en_seneca = TRUE,
    fecha_presentacion_seneca = '2026-04-15',
    referencia_seneca = 'SEN-2026-0004'
WHERE solicitud_id = '90000000-0000-0000-0000-000000000004';

UPDATE core.solicitud
SET estado_actual = 'presentada_en_seneca',
    presentada_en_seneca = TRUE,
    fecha_presentacion_seneca = '2026-04-16',
    referencia_seneca = 'SEN-2026-0007'
WHERE solicitud_id = '90000000-0000-0000-0000-000000000007';

UPDATE core.solicitud
SET estado_actual = 'aceptada',
    observaciones_direccion = 'Aceptada tras el registro en Séneca.'
WHERE solicitud_id = '90000000-0000-0000-0000-000000000007';

UPDATE core.solicitud
SET estado_actual = 'cerrada',
    observaciones_direccion = 'Expediente cerrado después de la aceptación.'
WHERE solicitud_id = '90000000-0000-0000-0000-000000000007';

INSERT INTO core.incidencia_solicitud (
    incidencia_id, solicitud_id, tipo_incidencia, severidad, descripcion, abierta,
    detectada_por_usuario_id
)
VALUES
    ('91000000-0000-0000-0000-000000000001', '90000000-0000-0000-0000-000000000003', 'cupo_diario', 'alta',
     'El día 2026-05-18 supera el cupo diario configurado para el MVP.', TRUE, '11111111-1111-1111-1111-111111111111'),
    ('91000000-0000-0000-0000-000000000002', '90000000-0000-0000-0000-000000000005', 'dato_incompleto', 'media',
     'Dirección solicita ampliar la información documental antes de autorizar.', TRUE, '11111111-1111-1111-1111-111111111111'),
    ('91000000-0000-0000-0000-000000000003', '90000000-0000-0000-0000-000000000006', 'consecutividad_real', 'media',
     'La solicitud queda marcada por consecutividad real con otra solicitud del mismo docente.', TRUE, '11111111-1111-1111-1111-111111111111'),
    ('91000000-0000-0000-0000-000000000004', '90000000-0000-0000-0000-000000000007', 'maximo_docente', 'alta',
     'El docente supera el máximo anual orientativo al añadir esta solicitud.', TRUE, '11111111-1111-1111-1111-111111111111')
ON CONFLICT (incidencia_id) DO NOTHING;

COMMIT;
