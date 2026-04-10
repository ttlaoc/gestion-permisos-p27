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
- mantener como unica excepcion editable `appsheet.vw_parametros_editables`, porque filtra las filas administrables
- evitar logica compleja en formulas si ya existe en SQL
- usar `version_registro` para ayudar a detectar concurrencia y refresco
- aplicar security filters y slices por rol

## Consideraciones n8n

- flujos idempotentes
- registro de importaciones en `integration.carga_externa`
- cuentas de servicio con rol limitado
- no escribir sobre Seneca

## Decision pendiente

- TODO: decidir si fase 2 exige backend intermedio para acciones sensibles.
