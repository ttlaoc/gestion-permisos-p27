# Skill: Autenticación y autorización

## Objetivo
Evitar accesos indebidos y controlar qué puede ver o modificar cada perfil.

## Reglas
- Diseñar permisos por rol y por recurso.
- Evitar acceso por simple conocimiento de ID.
- Asumir riesgo de IDOR/BOLA y mitigarlo explícitamente.
- El profesorado solo puede ver sus propias solicitudes y estados, salvo vistas públicas agregadas.
- Dirección puede revisar solicitudes y cambiar estados según reglas definidas.
- Administración técnica no debe tener acceso innecesario a datos personales desde la app funcional.
- Toda operación de cambio de estado debe registrar quién la hizo y cuándo.

## Controles
- Filtrado por usuario en vistas de AppSheet
- Restricciones por rol
- Identificadores no triviales cuando convenga
- Auditoría de acciones sensibles