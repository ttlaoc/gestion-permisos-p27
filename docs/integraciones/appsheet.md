# Guia de conexion con AppSheet

## Estrategia recomendada para el MVP

AppSheet no debe apoyarse en una arquitectura fragil basada en editar vistas de forma implicita.

La estrategia elegida es:

- editar tablas base cuando la escritura es simple, directa y segura
- usar vistas principalmente para lectura, joins, paneles y apoyo visual
- admitir solo una vista editable justificada: `appsheet.vw_parametros_editables`

## Objetos a conectar

### Edicion directa sobre tablas base

- `core.docente`
- `core.solicitud`
- `core.calendario_no_lectivo`
- `core.incidencia_solicitud`

### Vistas de AppSheet

- `appsheet.vw_parametros_editables` - editable de forma controlada
- `appsheet.vw_revision_solicitudes` - solo lectura

## Clasificacion de las vistas revisadas

| Vista | Decision | Motivo |
|---|---|---|
| `appsheet.vw_docentes` | eliminada | duplicaba `core.docente` sin aportar control adicional; la edicion es simple sobre tabla base |
| `appsheet.vw_solicitudes` | eliminada | duplicaba `core.solicitud`; la logica critica ya vive en triggers y funciones sobre la tabla base |
| `appsheet.vw_calendario_no_lectivo` | eliminada | mantenimiento simple y seguro directamente sobre `core.calendario_no_lectivo` |
| `appsheet.vw_incidencias` | eliminada | entidad operativa simple; conviene editar `core.incidencia_solicitud` |
| `appsheet.vw_parametros_editables` | editable justificada | filtra `editable = true`, evita exponer parametros no administrables y usa `valor_texto` apto para AppSheet |
| `appsheet.vw_revision_solicitudes` | solo lectura | join de apoyo visual para revision; no debe utilizarse para escritura |

## Recomendacion por rol

- profesorado: acceso a sus solicitudes y lectura de catalogos necesarios
- direccion: acceso a revision, incidencias y decisiones
- administracion: acceso a parametros, calendario y marcaje de Seneca

## Recomendaciones tecnicas

- usar una cuenta de base de datos dedicada a AppSheet
- limitar permisos a tablas y vistas previstas
- aplicar security filters por email y rol
- no confiar solo en la ocultacion de columnas
- usar validaciones de AppSheet como apoyo, no como control principal

## Columnas clave

- `solicitud_id` como key tecnica
- `codigo` como identificador visible
- `version_registro` para refresco y deteccion de cambios
- `requiere_revision_manual` para paneles de direccion
- `valor_texto` y `tipo_valor` para administracion simple de parametros

## Configuracion editable

Para el MVP se ha sustituido el uso directo de `valor_json` por un modelo mas simple en `config.parametro_sistema`:

- `tipo_valor`: `texto`, `entero` o `booleano`
- `valor_texto`: valor editable desde AppSheet

La base de datos convierte internamente ese valor a JSONB cuando hace falta para funciones de lectura tecnica y auditoria. Con esto:

- AppSheet evita editar JSON manualmente
- la configuracion sigue siendo tipada
- la auditoria conserva un formato normalizado

## Advertencias

- `vw_revision_solicitudes` es expresamente de solo lectura
- `vw_parametros_editables` es la unica vista pensada para escritura y queda justificada por su filtro `editable = true`
- si AppSheet necesita escritura compleja, valorar backend intermedio
- no habilitar adjuntos hasta cerrar la politica de seguridad
