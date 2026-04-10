BEGIN;

CREATE TYPE config.parametro_tipo_valor_enum AS ENUM (
    'texto',
    'entero',
    'booleano'
);

CREATE TYPE core.rol_usuario_enum AS ENUM (
    'profesorado',
    'direccion',
    'administracion',
    'automatizacion',
    'consulta'
);

CREATE TYPE core.estado_solicitud_enum AS ENUM (
    'borrador',
    'enviada',
    'en_revision',
    'pendiente_subsanacion',
    'validada_interna',
    'autorizada_direccion',
    'denegada_direccion',
    'incidencia_detectada',
    'presentada_seneca',
    'cerrada',
    'cancelada'
);

CREATE TYPE core.origen_evento_enum AS ENUM (
    'appsheet',
    'backend',
    'n8n',
    'importacion_manual',
    'sistema',
    'sql_directo'
);

CREATE TYPE core.tipo_incidencia_enum AS ENUM (
    'cupo_diario',
    'maximo_docente',
    'consecutividad_real',
    'dato_incompleto',
    'conflicto_calendario',
    'revision_manual',
    'otro'
);

CREATE TYPE core.severidad_incidencia_enum AS ENUM (
    'informativa',
    'media',
    'alta',
    'critica'
);

COMMIT;
