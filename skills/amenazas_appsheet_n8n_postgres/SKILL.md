# Skill: Logs, auditoría y privacidad

## Objetivo
Tener trazabilidad útil sin exponer datos personales o sensibles.

## Reglas
- Registrar cambios de estado, cambios de configuración y errores relevantes.
- No registrar secretos, tokens, contraseñas ni documentos completos.
- Minimizar datos personales en logs.
- Diferenciar logs operativos de auditoría.
- Diseñar mensajes de error útiles pero no reveladores.
- Preparar capacidad de investigación de incidencias.

## Debe auditarse
- alta de solicitud
- cambio de estado
- cambio de configuración
- acceso administrativo sensible
- conciliaciones/importaciones