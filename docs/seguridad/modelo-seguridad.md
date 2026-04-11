# Seguridad, amenazas y controles

## Marco de referencia

Este proyecto toma como referencia:

- OWASP ASVS
- OWASP Cheat Sheet Series

La seguridad se aplica de forma pragmática y por capas.

## Objetivos de seguridad

- proteger datos personales y operativos
- evitar alteraciones no trazadas
- reducir superficie de ataque en integraciones
- garantizar control de acceso por rol y recurso
- soportar investigación forense básica ante incidencias

## Amenazas principales

### Inyección SQL

Riesgo:

- consultas construidas con concatenación

Controles:

- consultas parametrizadas siempre
- privilegios mínimos por rol
- restricciones y *checks* en SQL

### IDOR o BOLA

Riesgo:

- un usuario consulta o modifica solicitudes ajenas

Controles:

- filtrado por rol y por recurso en AppSheet o backend futuro
- vistas acotadas
- trazabilidad de cambios
- recomendación de *security filters* en AppSheet

### XSS y salida insegura

Riesgo:

- textos libres mostrados después en AppSheet u otros paneles

Controles:

- tratamiento de toda entrada como no confiable
- escape y saneado en la capa de presentación
- no renderizar HTML arbitrario

### CSRF

Riesgo:

- acciones no deseadas si se expone una API web futura

Controles:

- aplicable a futuro si se incorpora backend HTTP
- autenticación fuerte y tokens anti-CSRF cuando corresponda

### SSRF y abuso de integraciones

Riesgo:

- importaciones por URL o flujos n8n salientes sin control

Controles:

- no aceptar URLs arbitrarias en esta fase
- *allowlist* y *timeouts* para futuras llamadas salientes
- cuentas de servicio con permisos mínimos

### Fuga de secretos

Riesgo:

- credenciales en el repositorio, *logs* o tablas operativas

Controles:

- secretos fuera del SQL versionado
- uso de variables de entorno o gestor seguro
- documentación separada para configuración funcional y credenciales

### *Logging* inseguro

Riesgo:

- volcado de PII, *tokens* o documentos

Controles:

- auditoría separada de logs operativos
- no registrar secretos
- no almacenar documentos completos en históricos

### Manipulación de estados

Riesgo:

- saltarse revisiones o mover estados sin permiso

Controles:

- tabla de transiciones permitidas
- trigger de validación de transiciones
- historial de estados en auditoría

## Controles implementados en el MVP

- separación por esquemas
- *checks* y únicos
- índices para acceso y auditoría
- histórico de configuración
- histórico de cambios y estados de solicitudes
- cálculos de negocio críticos en funciones SQL
- roles de base de datos con mínimo privilegio
- AppSheet con permisos sobre tablas base concretas y vistas mínimas de apoyo
- registro de futuras importaciones externas

## Controles operativos recomendados

- TLS obligatorio hacia PostgreSQL en entornos no locales
- rotación de credenciales de servicio
- copias de seguridad cifradas
- política de retención de auditoría
- revisión periódica de permisos AppSheet y n8n
- cuentas separadas por entorno

## Controles no activados aún

- antivirus o escaneo de adjuntos
- SSO corporativo
- backend HTTP con autenticación propia
- RLS por fila en PostgreSQL

## Decisiones y límites

- Se evita almacenar secretos en `config.parametro_sistema`.
- Se aplaza la subida de ficheros hasta definir controles completos.
- Se aplaza cualquier automatización de escritura sobre Séneca.
- En el MVP no se admite escritura sobre vistas AppSheet; la escritura se hace sobre tablas base con permisos acotados.

## TODO

- Definir si la fase 2 usará RLS además de filtros AppSheet.
- Definir política de retención de datos personales.
- Definir catálogo final de eventos auditables para administración sensible.
