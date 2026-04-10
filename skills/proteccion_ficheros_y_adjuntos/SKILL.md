# Skill: Protección de ficheros y adjuntos

## Objetivo
Gestionar adjuntos de solicitudes sin abrir vías de ataque.

## Reglas
- Limitar tipos MIME y extensiones permitidas.
- Renombrar ficheros de forma segura.
- No confiar en el nombre original del archivo.
- No ejecutar ni servir adjuntos desde ubicaciones ejecutables.
- Analizar tamaño máximo permitido.
- Diseñar controles de acceso a adjuntos.
- Evitar path traversal.
- No almacenar rutas construidas con entrada directa del usuario.

## Riesgos
- Malware
- Path traversal
- Exposición de documentos sensibles
- Subida de contenido peligroso