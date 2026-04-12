# Diseño técnico

## Resumen

El MVP es *database-first*. La prioridad es fijar un modelo estable y seguro antes de ampliar la capa de servicios.

## Artefactos principales

- SQL ordenado por fases
- tablas base y vistas de apoyo para AppSheet
- roles de base de datos
- semillas de ejemplo
- script PowerShell para aplicar el esquema
- Docker Compose para entorno local

## Razón de esta aproximación

- reduce la fragilidad inicial
- fuerza claridad del dominio
- acelera la conexión con AppSheet
- deja un backend propio como decisión evolutiva, no prematura

## Convenciones

- esquemas por responsabilidad
- nombres técnicos en singular para tablas de negocio
- claves primarias técnicas con UUID o identidad según el caso
- claves visibles como `codigo` cuando haya valor operativo
- auditoría en tablas separadas

## Consideraciones sobre AppSheet

- editar tablas base cuando la operación sea simple y segura
- usar vistas solo para lectura, *joins* y paneles
- editar `config.parametro_sistema` directamente para evitar ambigüedad y no depender de vistas escribibles
- evitar lógica compleja en fórmulas si ya existe en SQL
- usar `version_registro` para ayudar a detectar concurrencia y refresco
- aplicar *security filters* y *slices* por rol

## Auditoría de configuración

La tabla `config.parametro_sistema` separa preparación de fila e histórico:

- `audit.fn_preparar_parametro_sistema()` se ejecuta en `BEFORE INSERT OR UPDATE`
- en `INSERT` completa metadatos sin escribir aún en tablas hijas
- en `UPDATE` incrementa `version`, actualiza `actualizado_en` y `actualizado_por`
- `audit.fn_registrar_historial_configuracion()` se ejecuta en `AFTER INSERT OR UPDATE`
- el histórico en `audit.configuracion_historial` se inserta cuando la fila de configuración ya existe materialmente y la FK puede resolverse

Con este diseño el valor inicial queda auditado en altas y cada modificación conserva versión, actor y trazabilidad sin desactivar restricciones.

## Máquina de estados de solicitudes

La lógica crítica del estado vive en PostgreSQL mediante:

- `core.estado_solicitud_enum`
- `core.estado_transicion_permitida`
- `core.fn_validar_transicion_estado()`
- `core.fn_bloquear_edicion_solicitud_final()`
- trigger `trg_solicitud_validar_estado`
- trigger `trg_solicitud_bloquear_edicion_final`
- trigger `trg_solicitud_historial_estado`

Flujo base del MVP:

| Fase | Estados |
|---|---|
| Preparación | `borrador`, `enviada` |
| Clasificación inicial | `validada_automatica`, `requiere_revision` |
| Revisión humana | `pendiente_subsanacion`, `autorizada_para_seneca`, `denegada` |
| Trámite oficial | `presentada_en_seneca` |
| Resolución | `aceptada`, `denegada` |
| Cierre | `cerrada`, `cancelada` |

Controles mínimos implementados:

- no hay cambios a estados no definidos por el *enum*
- no hay transiciones fuera de la tabla de transiciones
- `presentada_en_seneca` solo puede venir de `autorizada_para_seneca`
- `aceptada` y `denegada` solo pueden venir de `presentada_en_seneca`
- `cerrada` y `cancelada` bloquean cualquier edición posterior
- todo cambio de estado se registra automáticamente en auditoría

## Flujo funcional resumido

1. profesorado crea en `borrador`
2. profesorado envía a `enviada`
3. automatización o dirección clasifica en `validada_automatica` o `requiere_revision`
4. dirección revisa y puede mover a `pendiente_subsanacion`, `autorizada_para_seneca` o `denegada`
5. profesorado subsana y vuelve a `enviada` cuando procede
6. administración registra `presentada_en_seneca`
7. administración resuelve en `aceptada` o `denegada`
8. dirección o administración cierra en `cerrada`

## Consideraciones sobre n8n

- flujos idempotentes
- registro de importaciones en `integration.carga_externa`
- cuentas de servicio con rol limitado
- no escribir sobre Séneca

## Decisión pendiente

- TODO: decidir si la fase 2 exige un backend intermedio para acciones sensibles.
