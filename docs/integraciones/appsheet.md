# Guía de conexión con AppSheet

## Objetivo del MVP

Montar una app funcional sin backend intermedio:

- AppSheet escribe sobre tablas base.
- PostgreSQL valida estados y reglas críticas.
- Las vistas se usan solo para consulta, paneles y apoyo visual.

## Principio general de modelado

- **Escritura**: siempre que la operación sea simple y segura, sobre tabla base.
- **Lectura**: usar vistas para paneles, uniones y cuadros de revisión.
- **Autoridad funcional**: la base de datos valida transiciones, cálculos y restricciones.
- **AppSheet no sustituye la lógica crítica**: solo guía la captura y la operación diaria.

## Objetos a conectar

### Tablas editables

- `core.solicitud`
- `core.docente`
- `core.calendario_no_lectivo`
- `core.incidencia_solicitud`
- `config.parametro_sistema`

### Vistas de solo lectura

- `appsheet.vw_revision_solicitudes`
- `appsheet.vw_parametros_editables`

## Configuración general recomendada en AppSheet

### Nombres visibles sugeridos

| Objeto | Nombre visible recomendado |
|---|---|
| `core.solicitud` | Solicitudes |
| `core.docente` | Docentes |
| `core.calendario_no_lectivo` | Calendario no lectivo |
| `core.incidencia_solicitud` | Incidencias |
| `config.parametro_sistema` | Parámetros del sistema |
| `appsheet.vw_revision_solicitudes` | Panel de revisión |
| `appsheet.vw_parametros_editables` | Panel de parámetros |

### Claves y etiquetas recomendadas

| Objeto | Clave | Label |
|---|---|---|
| `core.solicitud` | `solicitud_id` | `codigo` |
| `core.docente` | `docente_id` | `codigo_interno` |
| `core.calendario_no_lectivo` | `calendario_no_lectivo_id` | `descripcion` |
| `core.incidencia_solicitud` | `incidencia_id` | `descripcion` |
| `config.parametro_sistema` | `parametro_id` | `clave` |
| `appsheet.vw_revision_solicitudes` | `solicitud_id` | `codigo` |
| `appsheet.vw_parametros_editables` | `parametro_id` | `clave` |

## Configuración práctica por tabla

### `core.solicitud`

- clave primaria: `solicitud_id`
- label recomendado: `codigo`
- usuarios:
  - profesorado
  - dirección
  - administración

#### Campos editables por profesorado

- `docente_id`
- `fecha_inicio`
- `fecha_fin`
- `motivo`
- `observaciones_docente`
- `estado_actual` solo en acciones controladas (`borrador`, `enviada`, `cancelada`)

#### Campos editables por dirección

- `estado_actual`
- `observaciones_direccion`
- `revisada_por_usuario_id`

#### Campos editables por administración

- `estado_actual`
- `presentada_en_seneca`
- `fecha_presentacion_seneca`
- `referencia_seneca`

#### Campos solo lectura

- `codigo`
- `dias_habiles_solicitados`
- `es_consecutiva_real`
- `requiere_revision_manual`
- `version_registro`
- `creada_en`
- `actualizada_en`

#### Nombres visibles recomendados de columnas

| Columna | Nombre visible |
|---|---|
| `codigo` | Código |
| `docente_id` | Docente |
| `fecha_solicitud` | Fecha de solicitud |
| `fecha_inicio` | Inicio |
| `fecha_fin` | Fin |
| `motivo` | Motivo |
| `observaciones_docente` | Observaciones del profesorado |
| `observaciones_direccion` | Observaciones de dirección |
| `estado_actual` | Estado |
| `dias_habiles_solicitados` | Días hábiles solicitados |
| `es_consecutiva_real` | Consecutividad real |
| `requiere_revision_manual` | Requiere revisión manual |
| `presentada_en_seneca` | Presentada en Séneca |
| `fecha_presentacion_seneca` | Fecha de presentación en Séneca |
| `referencia_seneca` | Referencia de Séneca |

### `core.docente`

- clave primaria: `docente_id`
- label recomendado: `codigo_interno`
- usuarios:
  - dirección
  - administración
- campos editables:
  - `codigo_interno`
  - `nombre`
  - `apellido_1`
  - `apellido_2`
  - `email_centro`
  - `departamento`
  - `activo`
  - `inicial_desempate`
  - `observaciones`
- campos solo lectura:
  - `docente_id`
  - `creado_en`
  - `actualizado_en`

### `core.calendario_no_lectivo`

- clave primaria: `calendario_no_lectivo_id`
- label recomendado: `descripcion`
- usuarios:
  - administración
  - dirección
- campos editables:
  - `fecha`
  - `descripcion`
  - `ambito`
  - `es_festivo`
  - `es_no_lectivo`
  - `origen`
- campos solo lectura:
  - `calendario_no_lectivo_id`
  - `creado_en`
  - `actualizado_en`

### `core.incidencia_solicitud`

- clave primaria: `incidencia_id`
- label recomendado: `descripcion`
- usuarios:
  - dirección
  - administración
- campos editables:
  - `solicitud_id`
  - `tipo_incidencia`
  - `severidad`
  - `descripcion`
  - `abierta`
  - `detectada_por_usuario_id`
  - `resuelta_por_usuario_id`
  - `resuelta_en`
- campos solo lectura:
  - `incidencia_id`
  - `creada_en`
  - `actualizada_en`

### `config.parametro_sistema`

- clave primaria: `parametro_id`
- label recomendado: `clave`
- usuarios:
  - administración
  - dirección
- campos editables:
  - `tipo_valor`
  - `valor_texto`
- campos solo lectura:
  - `clave`
  - `categoria`
  - `descripcion`
  - `editable`
  - `version`
  - `actualizado_en`
  - `creado_en`

#### Nombres visibles recomendados de columnas

| Columna | Nombre visible |
|---|---|
| `clave` | Clave |
| `categoria` | Categoría |
| `descripcion` | Descripción |
| `tipo_valor` | Tipo de valor |
| `valor_texto` | Valor |
| `editable` | Editable |
| `version` | Versión |
| `actualizado_en` | Actualizado el |

## Vista de revisión recomendada

### `appsheet.vw_revision_solicitudes`

- uso: panel de dirección
- clave recomendada: `solicitud_id`
- label recomendado: `codigo`
- solo lectura
- columnas útiles para panel o dashboard:
  - `docente_codigo`
  - `nombre`
  - `apellido_1`
  - `departamento`
  - `fecha_inicio`
  - `fecha_fin`
  - `dias_habiles_solicitados`
  - `estado_actual`
  - `es_consecutiva_real`
  - `requiere_revision_manual`
  - `presentada_en_seneca`

## Enum recomendado para `core.solicitud.estado_actual`

### Valores técnicos estables

- `borrador`
- `enviada`
- `validada_automatica`
- `requiere_revision`
- `pendiente_subsanacion`
- `autorizada_para_seneca`
- `presentada_en_seneca`
- `aceptada`
- `denegada`
- `cerrada`
- `cancelada`

### Etiquetas visibles recomendadas

| Valor técnico | Etiqueta visible |
|---|---|
| `borrador` | Borrador |
| `enviada` | Enviada |
| `validada_automatica` | Validada automáticamente |
| `requiere_revision` | Requiere revisión |
| `pendiente_subsanacion` | Pendiente de subsanación |
| `autorizada_para_seneca` | Autorizada para Séneca |
| `presentada_en_seneca` | Presentada en Séneca |
| `aceptada` | Aceptada |
| `denegada` | Denegada |
| `cerrada` | Cerrada |
| `cancelada` | Cancelada |

## Estados por perfil

### Profesorado

- puede crear en `borrador`
- puede pasar a `enviada`
- puede cancelar en `borrador`, `enviada` o `pendiente_subsanacion`
- puede reenviar desde `pendiente_subsanacion` a `enviada`

### Dirección

- clasifica en `validada_automatica` o `requiere_revision`
- revisa y decide:
  - `pendiente_subsanacion`
  - `autorizada_para_seneca`
  - `denegada`
- puede cerrar expedientes ya `denegada`

### Administración

- registra `presentada_en_seneca`
- resuelve en `aceptada` o `denegada`
- cierra expedientes `aceptada` o `denegada`

## Slices recomendados

### Profesorado

- **Mis solicitudes**: listado general del docente autenticado.
- **Borradores**: registros en `borrador`.
- **Pendientes de subsanación**: registros en `pendiente_subsanacion`.
- **Histórico personal**: solicitudes `aceptada`, `denegada`, `cerrada` o `cancelada`.

### Dirección

- **Pendientes de clasificación**: `estado_actual = enviada`.
- **Pendientes de revisión**: `estado_actual = requiere_revision`.
- **Pendientes de subsanación**: `estado_actual = pendiente_subsanacion`.
- **Autorizadas para Séneca**: `estado_actual = autorizada_para_seneca`.
- **Panel de revisión**: `appsheet.vw_revision_solicitudes`.

### Administración

- **Pendientes de presentación**: `estado_actual = autorizada_para_seneca`.
- **Presentadas**: `estado_actual = presentada_en_seneca`.
- **Pendientes de cierre**: `estado_actual IN (aceptada, denegada)`.
- **Calendario no lectivo**.
- **Parámetros del sistema**.

## Filtros recomendados

### Profesorado

- *security filter* por correo del usuario autenticado.
- mostrar solo solicitudes del `docente_id` asociado a su `email_centro`.

### Dirección y administración

- acceso a todas las solicitudes.
- usar *slices* por estado para simplificar la operación.

## Formularios y vistas recomendadas

### Profesorado

- formulario **Nueva solicitud**
- formulario **Editar borrador**
- detalle **Estado de mi solicitud**

### Dirección

- vista de tabla **Pendientes de clasificación**
- vista de tabla **Pendientes de revisión**
- detalle **Revisión de solicitud**

### Administración

- vista de tabla **Pendientes de presentación**
- detalle **Registro en Séneca**
- vista de tabla **Pendientes de cierre**

## Flujo funcional paso a paso

1. profesorado crea la solicitud en `borrador`
2. profesorado la envía a `enviada`
3. automatización o dirección la clasifica:
   - `validada_automatica`
   - `requiere_revision`
4. dirección revisa:
   - pide cambios con `pendiente_subsanacion`
   - autoriza con `autorizada_para_seneca`
   - o deniega con `denegada`
5. profesorado subsana y reenvía a `enviada`
6. administración registra `presentada_en_seneca`
7. administración resuelve:
   - `aceptada`
   - `denegada`
8. dirección o administración cierra el expediente en `cerrada`

## Recomendaciones técnicas

- usar una cuenta de base de datos dedicada a AppSheet
- usar *slices* por perfil y por fase del flujo
- configurar `Valid_If` del estado según rol y estado actual
- usar nombres visibles claros para tablas y columnas
- ocultar en formularios los campos derivados y de auditoría
- no confiar en AppSheet para validar transiciones; la base de datos es la autoridad
- no habilitar adjuntos en esta fase
