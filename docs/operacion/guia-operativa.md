# Guía operativa

## Arranque local

1. Crear la base con `db/00_create_database.sql`.
2. Ejecutar los SQL en orden.
3. Verificar semillas, tablas y vistas.
4. Conectar AppSheet según la estrategia del MVP:
   - tablas editables: `config.parametro_sistema`, `core.docente`, `core.solicitud`, `core.calendario_no_lectivo`, `core.incidencia_solicitud`
   - vistas de apoyo: `appsheet.vw_parametros_editables`, `appsheet.vw_revision_solicitudes`
   - aplicar los nombres visibles y recomendaciones de uso definidos en `docs/integraciones/appsheet.md` y `examples/appsheet/`

## Verificaciones básicas

- existen esquemas `config`, `core`, `audit`, `integration`, `appsheet`
- existen registros en `config.parametro_sistema`
- una solicitud seed tiene histórico de estados
- las vistas de `appsheet` devuelven datos
- el rol de AppSheet puede leer y escribir solo donde corresponde

## Operación recomendada

- ajustar `config.parametro_sistema` antes del uso real
- cargar calendario no lectivo completo del curso
- revisar permisos del usuario de AppSheet
- revisar que n8n use otra cuenta de servicio distinta

## Política de cambios

- cualquier cambio de esquema debe entrar como nuevo archivo SQL versionado o como evolución posterior documentada
- no editar semillas de producción sin dejar trazabilidad

## Incidencias

- si una solicitud falla en transición, revisar `core.estado_transicion_permitida`
- si el cálculo de días hábiles no cuadra, revisar `core.calendario_no_lectivo`
- si AppSheet no puede escribir, revisar *grants* sobre tabla base
