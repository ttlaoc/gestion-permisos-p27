# Skill: Validación de entradas y salida

## Objetivo
Prevenir inyecciones, errores lógicos y datos inconsistentes.

## Reglas
- Validar siempre tipo, formato, rango, obligatoriedad y coherencia.
- Normalizar espacios, mayúsculas/minúsculas y fechas.
- No confiar en valores procedentes de formularios o integraciones.
- Rechazar o marcar revisión manual ante entradas ambiguas.
- Escapar salidas cuando se muestren textos que puedan contener contenido no confiable.
- No interpolar valores en consultas SQL.

## Riesgos a cubrir
- SQL injection
- XSS almacenado o reflejado
- Datos incoherentes
- Bypass de reglas de negocio