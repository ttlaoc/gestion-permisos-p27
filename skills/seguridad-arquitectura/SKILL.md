# Skill: Seguridad de arquitectura

## Objetivo
Diseñar el sistema con seguridad por defecto y defensa en profundidad.

## Reglas
- Aplicar mínimo privilegio en base de datos, automatizaciones y herramientas conectadas.
- Separar datos operativos, configuración y auditoría.
- Diseñar roles explícitos: profesorado, dirección, administración técnica.
- No confiar en la interfaz para aplicar reglas críticas; reforzarlas en la base de datos o backend.
- Toda acción sensible debe poder auditarse.
- Evitar dependencias innecesarias.
- Documentar amenazas y mitigaciones por componente.

## Amenazas a considerar
- Acceso indebido a solicitudes ajenas
- Manipulación de configuración del sistema
- Exposición de datos personales
- Modificación no trazada de estados
- Integraciones inseguras con herramientas externas
- Errores de diseño que permitan saltarse validaciones

## Controles mínimos
- Restricciones e integridad en SQL
- Historial de cambios
- Separación de privilegios
- Validación fuerte de entradas
- Revisión explícita de permisos por rol