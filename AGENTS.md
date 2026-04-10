# AGENTS.md

## Proposito

Sistema interno para gestion de permisos retribuidos P.27 en un centro educativo. El sistema actua antes de Seneca y nunca debe modelarse como sustituto del sistema oficial.

## Prioridades permanentes

1. Seguridad y minimo privilegio
2. Correccion funcional y trazabilidad
3. Mantenibilidad y claridad del dominio
4. Simplicidad operativa
5. Preparacion para AppSheet, n8n y Google Calendar

## Reglas de contribucion

- No introducir integraciones no justificadas con Seneca.
- No hardcodear secretos, tokens, credenciales ni URLs sensibles.
- No mover logica critica de negocio a AppSheet si puede reforzarse en PostgreSQL o en un backend futuro.
- No eliminar auditoria, restricciones, historicos ni validaciones sin documentar el impacto.
- Mantener separados los datos operativos, la configuracion funcional, la auditoria y las integraciones.
- Cualquier decision relevante debe reflejarse en `docs/`.
- Si falta una decision, dejar un `TODO` claro con contexto y una alternativa razonable.
- Usar castellano en la capa funcional y nombres visibles para usuarios.
- Mantener nombres tecnicos consistentes, estables y legibles.

## Seguridad

- Guiarse por OWASP ASVS y OWASP Cheat Sheet Series.
- Usar consultas parametrizadas siempre.
- Validar origen, formato y semantica de entradas.
- Aplicar control de acceso por rol y por recurso.
- Evitar PII innecesaria en logs, exportes y mensajes de error.
- No habilitar adjuntos hasta definir politica de seguridad, tamano, antivirus y retencion.
- Auditar como minimo cambios de estado, configuracion, importaciones y acciones administrativas sensibles.

## Criterios de modelado

- PostgreSQL es la fuente de verdad.
- Preferir soft delete, estados de cierre o desactivacion frente a borrados destructivos.
- Las solicitudes P.27 deben tener maquina de estados y trazabilidad completa.
- El calendario no lectivo debe participar en el calculo de dias habiles y consecutividad real.
- La configuracion editable del sistema vive en tabla propia; los secretos no.
- El disenio debe quedar listo para cupo diario, maximos por docente, desempate por letra y revision manual.

## Entregables minimos al tocar este repo

- SQL organizado y versionable
- Documentacion actualizada
- TODOs explicitos donde falten decisiones
- Ejemplos o semillas cuando ayuden a arrancar
