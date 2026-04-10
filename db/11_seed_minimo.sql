BEGIN;

INSERT INTO config.parametro_sistema (clave, categoria, descripcion, tipo_valor, valor_texto, editable)
VALUES
    ('reglas.cupo_diario_permisos', 'reglas', 'Numero maximo orientativo de permisos por dia habil.', 'numero', '2', TRUE),
    ('reglas.max_dias_habiles_por_docente', 'reglas', 'Maximo anual orientativo de dias habiles P.27 por docente.', 'numero', '6', TRUE),
    ('reglas.revisar_consecutividad_real', 'reglas', 'Marca para revision manual las solicitudes consecutivas en dias habiles reales.', 'booleano', 'true', TRUE),
    ('reglas.letra_desempate_inicio', 'reglas', 'Letra inicial para desempate de prioridad si la normativa interna lo requiere.', 'texto', 'M', TRUE),
    ('centro.nombre', 'centro', 'Nombre visible del centro.', 'texto', 'IES Demo P27', TRUE),
    ('centro.codigo', 'centro', 'Codigo interno o administrativo del centro.', 'texto', '11000000', TRUE),
    ('integraciones.google_calendar_habilitado', 'integraciones', 'Activa futuras integraciones con Google Calendar.', 'booleano', 'false', TRUE),
    ('integraciones.n8n_habilitado', 'integraciones', 'Activa futuras automatizaciones de n8n.', 'booleano', 'false', TRUE)
ON CONFLICT (clave) DO NOTHING;

INSERT INTO core.usuario (usuario_id, email, nombre_mostrar, rol_principal, proveedor_identidad, referencia_externa)
VALUES
    ('11111111-1111-1111-1111-111111111111', 'direccion@centro.local', 'Direccion Centro', 'direccion', 'appsheet', 'direccion-demo'),
    ('22222222-2222-2222-2222-222222222222', 'admin@centro.local', 'Administracion Centro', 'administracion', 'appsheet', 'admin-demo'),
    ('33333333-3333-3333-3333-333333333333', 'docente1@centro.local', 'Ana Ruiz', 'profesorado', 'appsheet', 'docente-ana'),
    ('44444444-4444-4444-4444-444444444444', 'docente2@centro.local', 'Luis Perez', 'profesorado', 'appsheet', 'docente-luis')
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
    (
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        '33333333-3333-3333-3333-333333333333',
        'DOC-0001',
        'Ana',
        'Ruiz',
        'Lopez',
        'docente1@centro.local',
        'Lengua',
        TRUE,
        'R',
        encode(digest('00000000A', 'sha256'), 'hex')
    ),
    (
        'bbbbbbbb-bbbb-bbbb-bbbb-bbbbbbbbbbbb',
        '44444444-4444-4444-4444-444444444444',
        'DOC-0002',
        'Luis',
        'Perez',
        'Martin',
        'docente2@centro.local',
        'Matematicas',
        TRUE,
        'P',
        encode(digest('00000000B', 'sha256'), 'hex')
    )
ON CONFLICT (codigo_interno) DO NOTHING;

INSERT INTO core.estado_transicion_permitida (estado_origen, estado_destino, rol_requerido, requiere_comentario)
VALUES
    ('borrador', 'enviada', 'profesorado', FALSE),
    ('enviada', 'en_revision', 'direccion', FALSE),
    ('en_revision', 'pendiente_subsanacion', 'direccion', TRUE),
    ('pendiente_subsanacion', 'enviada', 'profesorado', FALSE),
    ('en_revision', 'validada_interna', 'direccion', FALSE),
    ('validada_interna', 'autorizada_direccion', 'direccion', FALSE),
    ('validada_interna', 'denegada_direccion', 'direccion', TRUE),
    ('en_revision', 'incidencia_detectada', 'direccion', TRUE),
    ('incidencia_detectada', 'en_revision', 'direccion', FALSE),
    ('autorizada_direccion', 'presentada_seneca', 'administracion', FALSE),
    ('presentada_seneca', 'cerrada', 'administracion', FALSE),
    ('borrador', 'cancelada', 'profesorado', FALSE),
    ('enviada', 'cancelada', 'profesorado', TRUE),
    ('pendiente_subsanacion', 'cancelada', 'profesorado', TRUE)
ON CONFLICT (estado_origen, estado_destino, rol_requerido) DO NOTHING;

INSERT INTO core.calendario_no_lectivo (fecha, descripcion, ambito, es_festivo, es_no_lectivo, origen)
VALUES
    ('2026-01-06', 'Epifania del Senor', 'centro', TRUE, TRUE, 'seed'),
    ('2026-02-27', 'Dia no lectivo de ejemplo', 'centro', FALSE, TRUE, 'seed'),
    ('2026-04-02', 'Jueves Santo', 'centro', TRUE, TRUE, 'seed'),
    ('2026-04-03', 'Viernes Santo', 'centro', TRUE, TRUE, 'seed')
ON CONFLICT (fecha) DO NOTHING;

SELECT set_config('app.actor_usuario_id', '33333333-3333-3333-3333-333333333333', TRUE);
SELECT set_config('app.actor_rol', 'profesorado', TRUE);
SELECT set_config('app.origen_evento', 'sql_directo', TRUE);

INSERT INTO core.solicitud (
    solicitud_id,
    docente_id,
    creada_por_usuario_id,
    fecha_solicitud,
    fecha_inicio,
    fecha_fin,
    motivo,
    observaciones_docente,
    estado_actual
)
VALUES
    (
        'cccccccc-cccc-cccc-cccc-cccccccccccc',
        'aaaaaaaa-aaaa-aaaa-aaaa-aaaaaaaaaaaa',
        '33333333-3333-3333-3333-333333333333',
        '2026-04-01',
        '2026-04-06',
        '2026-04-07',
        'Asuntos particulares de ejemplo',
        'Solicitud inicial de ejemplo para pruebas de AppSheet.',
        'enviada'
    )
ON CONFLICT (solicitud_id) DO NOTHING;

SELECT set_config('app.actor_usuario_id', '11111111-1111-1111-1111-111111111111', TRUE);
SELECT set_config('app.actor_rol', 'direccion', TRUE);

UPDATE core.solicitud
SET estado_actual = 'en_revision',
    revisada_por_usuario_id = '11111111-1111-1111-1111-111111111111',
    observaciones_direccion = 'Revision inicial realizada.'
WHERE solicitud_id = 'cccccccc-cccc-cccc-cccc-cccccccccccc';

INSERT INTO core.incidencia_solicitud (
    incidencia_id,
    solicitud_id,
    tipo_incidencia,
    severidad,
    descripcion,
    abierta,
    detectada_por_usuario_id
)
VALUES
    (
        'dddddddd-dddd-dddd-dddd-dddddddddddd',
        'cccccccc-cccc-cccc-cccc-cccccccccccc',
        'revision_manual',
        'media',
        'Solicitud marcada para revision manual por configuracion del MVP.',
        TRUE,
        '11111111-1111-1111-1111-111111111111'
    )
ON CONFLICT (incidencia_id) DO NOTHING;

COMMIT;
