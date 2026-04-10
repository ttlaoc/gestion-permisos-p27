# Skill: Seguridad de API e integraciones

## Objetivo
Diseñar integraciones seguras con AppSheet, n8n, Google Calendar y futuras cargas externas.

## Reglas
- Validar origen, formato y autenticidad de datos importados.
- Tratar todo archivo externo como no confiable.
- Usar timeouts y listas permitidas cuando haya llamadas salientes.
- Considerar riesgo de SSRF si se aceptan URLs.
- Limitar permisos de las cuentas de servicio.
- Registrar importaciones y conciliaciones.
- Diseñar reintentos idempotentes.

## Riesgos
- SSRF
- abuso de integraciones
- datos corruptos importados
- duplicidades
- escalado de privilegios entre sistemas