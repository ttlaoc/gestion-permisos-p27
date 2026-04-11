# Preparación para n8n y Google Calendar

## n8n

Usos previstos:

- recordatorios y avisos
- conciliaciones futuras
- sincronización de calendario
- procesos programados

Reglas:

- una cuenta de servicio propia
- permisos mínimos
- reintentos idempotentes
- log de cargas e integraciones en `integration.carga_externa`

## Google Calendar

Uso previsto:

- publicar eventos internos solo para solicitudes autorizadas

Requisitos previos:

- definir calendario de destino
- definir si se usa un calendario de centro o varios
- definir idempotencia por `solicitud_id`
- definir política de actualización y cancelación

## No hacer aún

- no automatizar Séneca
- no aceptar URL arbitrarias
- no exponer secretos en tablas operativas
