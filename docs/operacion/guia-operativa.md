# Guia operativa

## Arranque local

1. Crear la base con `db/00_create_database.sql`.
2. Ejecutar los SQL en orden.
3. Verificar semillas, tablas y vistas.
4. Conectar AppSheet segun la estrategia del MVP:
   - tablas editables: `core.docente`, `core.solicitud`, `core.calendario_no_lectivo`, `core.incidencia_solicitud`
   - vistas de apoyo: `appsheet.vw_parametros_editables`, `appsheet.vw_revision_solicitudes`

## Verificaciones basicas

- existen esquemas `config`, `core`, `audit`, `integration`, `appsheet`
- existen registros en `config.parametro_sistema`
- una solicitud seed tiene historico de estados
- las vistas de `appsheet` devuelven datos
- el rol de AppSheet puede leer y escribir solo donde corresponde

## Operacion recomendada

- ajustar `config.parametro_sistema` antes de uso real
- cargar calendario no lectivo completo del curso
- revisar permisos del usuario de AppSheet
- revisar que n8n use otra cuenta de servicio distinta

## Politica de cambios

- cualquier cambio de esquema debe entrar como nuevo archivo SQL versionado o como evolucion posterior documentada
- no editar semillas de produccion sin dejar trazabilidad

## Incidencias

- si una solicitud falla en transicion, revisar `core.estado_transicion_permitida`
- si el calculo de dias habiles no cuadra, revisar `core.calendario_no_lectivo`
- si AppSheet no puede escribir, revisar grants sobre tabla base o sobre `appsheet.vw_parametros_editables`
