# Roadmap por fases

## Fase 1: base de datos y modelo

- cerrar el modelo SQL inicial
- completar calendario del curso
- validar reglas reales con direccion
- preparar roles y estrategia de despliegue por entorno

## Fase 2: AppSheet

- conectar AppSheet a PostgreSQL
- crear vistas, slices y formularios por rol
- aplicar security filters
- definir acciones y automatizaciones internas minimas
- validar experiencia de profesorado y direccion

## Fase 3: automatizaciones n8n

- avisos internos
- reintentos idempotentes
- registro de ejecuciones e importaciones
- conciliaciones basicas con cargas manuales

## Fase 4: Google Calendar

- sincronizar solicitudes autorizadas
- definir identificadores externos e idempotencia
- gestionar altas, cambios y cancelaciones

## Fase 5: conciliacion con exportes de Seneca

- disenar formato de carga
- validar integridad de registros importados
- conciliar estado interno vs. estado oficial
- generar alertas por divergencias
