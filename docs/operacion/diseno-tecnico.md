# Diseno tecnico

## Resumen

El MVP es database-first. La prioridad es fijar un modelo estable y seguro antes de ampliar la capa de servicios.

## Artefactos principales

- SQL ordenado por fases
- tablas base y vistas de apoyo para AppSheet
- roles de base de datos
- semillas de ejemplo
- script PowerShell para aplicar el esquema
- Docker Compose para entorno local

## Razon de esta aproximacion

- reduce fragilidad inicial
- fuerza claridad del dominio
- acelera conexion con AppSheet
- deja un backend propio como decision evolutiva, no prematura

## Convenciones

- esquemas por responsabilidad
- nombres tecnicos en singular para tablas de negocio
- claves primarias tecnicas con UUID o identidad segun el caso
- claves visibles como `codigo` cuando haya valor operativo
- auditoria en tablas separadas

## Consideraciones AppSheet

- editar tablas base cuando la operacion sea simple y segura
- usar vistas solo para lectura, joins y paneles
- editar `config.parametro_sistema` directamente para evitar ambiguedad y no depender de vistas escribibles
- evitar logica compleja en formulas si ya existe en SQL
- usar `version_registro` para ayudar a detectar concurrencia y refresco
- aplicar security filters y slices por rol

## Maquina de estados de solicitudes

La logica critica del estado vive en PostgreSQL mediante:

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
| Preparacion | `borrador`, `enviada` |
| Clasificacion inicial | `validada_automatica`, `requiere_revision` |
| Revision humana | `pendiente_subsanacion`, `autorizada_para_seneca`, `denegada` |
| Tramite oficial | `presentada_en_seneca` |
| Cierre | `aceptada`, `denegada`, `cerrada`, `cancelada` |

Controles minimos implementados:

- no hay cambios a estados no definidos por enum
- no hay transiciones fuera de la tabla de transiciones
- `presentada_en_seneca` solo puede venir de `autorizada_para_seneca`
- `aceptada` y `denegada` solo pueden venir de `presentada_en_seneca`
- una solicitud en estado terminal no admite mas cambios
- todo cambio de estado se registra automaticamente en auditoria

## Consideraciones n8n

- flujos idempotentes
- registro de importaciones en `integration.carga_externa`
- cuentas de servicio con rol limitado
- no escribir sobre Seneca

## Decision pendiente

- TODO: decidir si fase 2 exige backend intermedio para acciones sensibles.
