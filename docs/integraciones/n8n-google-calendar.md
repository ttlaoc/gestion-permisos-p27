# Preparacion para n8n y Google Calendar

## n8n

Usos previstos:

- recordatorios y avisos
- conciliaciones futuras
- sincronizacion de calendario
- procesos programados

Reglas:

- una cuenta de servicio propia
- permisos minimos
- reintentos idempotentes
- log de cargas e integraciones en `integration.carga_externa`

## Google Calendar

Uso previsto:

- publicar eventos internos solo para solicitudes autorizadas

Requisitos previos:

- definir calendario destino
- definir si se usa un calendario de centro o varios
- definir idempotencia por `solicitud_id`
- definir politica de actualizacion y cancelacion

## No hacer aun

- no automatizar Seneca
- no aceptar URLs arbitrarias
- no exponer secretos en tablas operativas
