# Roadmap por fases

## Fase 1: base de datos y modelo

- cerrar el modelo SQL inicial
- completar calendario del curso
- validar reglas reales con dirección
- preparar roles y estrategia de despliegue por entorno

## Fase 2: AppSheet

- conectar AppSheet a PostgreSQL
- conectar tablas base para escritura y vistas de apoyo para lectura
- crear *slices* y formularios por rol
- aplicar *security filters*
- definir acciones y automatizaciones internas mínimas
- validar experiencia de profesorado y dirección

## Fase 3: automatizaciones n8n

- avisos internos
- reintentos idempotentes
- registro de ejecuciones e importaciones
- conciliaciones básicas con cargas manuales

## Fase 4: Google Calendar

- sincronizar solicitudes autorizadas
- definir identificadores externos e idempotencia
- gestionar altas, cambios y cancelaciones

## Fase 5: conciliación con exportes de Séneca

- diseñar formato de carga
- validar integridad de registros importados
- conciliar estado interno frente a estado oficial
- generar alertas por divergencias
