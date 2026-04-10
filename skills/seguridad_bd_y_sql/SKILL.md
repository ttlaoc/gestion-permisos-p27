# Skill: Seguridad de base de datos y SQL

## Objetivo
Construir un modelo robusto, consistente y resistente a errores y abusos.

## Reglas
- Usar consultas parametrizadas siempre.
- Definir claves primarias, foráneas, índices y restricciones CHECK cuando aporten integridad.
- Usar transacciones en operaciones compuestas.
- No guardar secretos en tablas operativas.
- Diseñar tablas de histórico para cambios sensibles.
- Evitar borrados destructivos salvo decisión explícita y justificada.
- Preferir soft delete o estados de cierre cuando proceda.

## Controles
- CHECKs de dominio
- UNIQUE parciales cuando aplique
- Auditoría
- Roles de BD con permisos mínimos