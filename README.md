# Gestion interna de permisos P.27

Sistema interno para la gestion previa de permisos retribuidos por asuntos particulares P.27 en un centro educativo.

Este repositorio arranca el proyecto con un MVP serio centrado en:

- modelo de datos PostgreSQL como fuente de verdad
- seguridad por defecto y trazabilidad
- preparacion para AppSheet como interfaz principal
- preparacion para automatizaciones con n8n
- preparacion para sincronizacion futura con Google Calendar
- conciliacion futura con exportes de Seneca, sin robotizacion fragil

## Alcance del MVP

El MVP cubre la capa de datos, reglas base, auditoria y documentacion. La interfaz de usuario se plantea con AppSheet conectada a PostgreSQL. No se incluye aun un backend HTTP propio porque, para esta fase, la prioridad es cerrar bien el dominio, las restricciones y la seguridad del modelo.

## Estructura del repositorio

```text
.
|-- AGENTS.md
|-- README.md
|-- db/
|-- docs/
|-- examples/
|-- infra/
`-- scripts/
```

## Puesta en marcha local

### Opcion 1: PostgreSQL local existente

1. Crear la base de datos usando [db/00_create_database.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/00_create_database.sql).
2. Ejecutar los scripts `01` a `11` en orden.
3. Revisar y adaptar los parametros de `config.parametro_sistema`.
4. Conectar AppSheet a las vistas de `appsheet`.

### Opcion 2: Docker Compose

1. Copiar valores de entorno desde `.env.example`.
2. Levantar [infra/docker-compose.yml](/c:/Users/rbh/Desktop/gestion-permisos-p27/infra/docker-compose.yml).
3. Ejecutar [scripts/aplicar_esquema.ps1](/c:/Users/rbh/Desktop/gestion-permisos-p27/scripts/aplicar_esquema.ps1) o lanzar los SQL manualmente con `psql`.

## Orden de despliegue SQL

1. [db/00_create_database.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/00_create_database.sql)
2. [db/01_extensions.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/01_extensions.sql)
3. [db/02_schemas.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/02_schemas.sql)
4. [db/03_types.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/03_types.sql)
5. [db/04_tables_core.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/04_tables_core.sql)
6. [db/05_constraints.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/05_constraints.sql)
7. [db/06_indexes.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/06_indexes.sql)
8. [db/07_functions.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/07_functions.sql)
9. [db/08_triggers.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/08_triggers.sql)
10. [db/09_views_appsheet.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/09_views_appsheet.sql)
11. [db/10_roles.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/10_roles.sql)
12. [db/11_seed_minimo.sql](/c:/Users/rbh/Desktop/gestion-permisos-p27/db/11_seed_minimo.sql)

## Documentacion principal

- Arquitectura: [docs/arquitectura/sistema.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/arquitectura/sistema.md)
- Dominio: [docs/dominio/modelo-dominio.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/dominio/modelo-dominio.md)
- Seguridad: [docs/seguridad/modelo-seguridad.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/seguridad/modelo-seguridad.md)
- Diseno funcional: [docs/operacion/diseno-funcional.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/operacion/diseno-funcional.md)
- Diseno tecnico: [docs/operacion/diseno-tecnico.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/operacion/diseno-tecnico.md)
- Guia operativa: [docs/operacion/guia-operativa.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/operacion/guia-operativa.md)
- Roadmap: [docs/operacion/roadmap.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/operacion/roadmap.md)
- Pendientes: [docs/operacion/todo.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/operacion/todo.md)
- AppSheet: [docs/integraciones/appsheet.md](/c:/Users/rbh/Desktop/gestion-permisos-p27/docs/integraciones/appsheet.md)

## TODO iniciales ya identificados

- Confirmar el algoritmo normativo exacto para desempate por letra.
- Confirmar si el cupo diario es global de centro o por etapa/departamento.
- Confirmar si ciertas solicitudes deben bloquearse en vez de marcarse para revision manual.
- Definir politica final de adjuntos antes de habilitar ficheros en AppSheet.
- Definir politica de autenticacion final para AppSheet y futuras automatizaciones.
