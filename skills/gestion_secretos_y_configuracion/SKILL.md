# Skill: Gestión de secretos y configuración

## Objetivo
Evitar fugas de credenciales y configuraciones inseguras.

## Reglas
- Nunca hardcodear secretos.
- Usar variables de entorno o gestor seguro de secretos.
- Separar configuración funcional de credenciales técnicas.
- No mezclar parámetros normativos con secretos.
- Validar la configuración antes de usarla.
- Permitir rotación de secretos sin rediseñar el sistema.
- No mostrar secretos en documentación ni logs.

## Ejemplos de secretos
- contraseñas de base de datos
- claves API
- tokens de n8n
- credenciales de servicios externos