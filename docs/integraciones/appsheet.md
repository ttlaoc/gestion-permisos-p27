# Guia de conexion con AppSheet

## Tablas o vistas recomendadas

Usar inicialmente las vistas del esquema `appsheet`:

- `vw_docentes`
- `vw_solicitudes`
- `vw_parametros_editables`
- `vw_calendario_no_lectivo`
- `vw_incidencias`
- `vw_revision_solicitudes`

## Recomendacion por rol

- profesorado: acceso a sus solicitudes y lectura de catalogos necesarios
- direccion: acceso a revision, incidencias y decisiones
- administracion: acceso a parametros, calendario y marcaje de Seneca

## Recomendaciones tecnicas

- usar una cuenta de base de datos dedicada a AppSheet
- limitar permisos a vistas previstas
- aplicar security filters por email y rol
- no confiar solo en la ocultacion de columnas
- usar validaciones de AppSheet como apoyo, no como control principal

## Columnas clave

- `solicitud_id` como key tecnica
- `codigo` como identificador visible
- `version_registro` para refresco y deteccion de cambios
- `requiere_revision_manual` para paneles de direccion

## Advertencias

- las vistas con joins, como `vw_revision_solicitudes`, son para consulta
- si AppSheet necesita escritura compleja, valorar backend intermedio
- no habilitar adjuntos hasta cerrar la politica de seguridad
