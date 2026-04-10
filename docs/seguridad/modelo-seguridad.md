# Seguridad, amenazas y controles

## Marco de referencia

Este proyecto toma como referencia:

- OWASP ASVS
- OWASP Cheat Sheet Series

La seguridad se aplica de forma pragmatica y por capas.

## Objetivos de seguridad

- proteger datos personales y operativos
- evitar alteraciones no trazadas
- reducir superficie de ataque en integraciones
- garantizar control de acceso por rol y recurso
- soportar investigacion forense basica ante incidencias

## Amenazas principales

### Inyeccion SQL

Riesgo:

- consultas construidas con concatenacion

Controles:

- consultas parametrizadas siempre
- privilegios minimos por rol
- restricciones y checks en SQL

### IDOR o BOLA

Riesgo:

- un usuario consulta o modifica solicitudes ajenas

Controles:

- filtrado por rol y por recurso en AppSheet o backend futuro
- vistas acotadas
- trazabilidad de cambios
- recomendacion de security filters en AppSheet

### XSS y salida insegura

Riesgo:

- textos libres mostrados despues en AppSheet u otros paneles

Controles:

- tratamiento de toda entrada como no confiable
- escape y saneado en la capa de presentacion
- no renderizar HTML arbitrario

### CSRF

Riesgo:

- acciones no deseadas si se expone una API web futura

Controles:

- aplicable a futuro si se incorpora backend HTTP
- autenticacion fuerte y tokens anti-CSRF cuando corresponda

### SSRF y abuso de integraciones

Riesgo:

- importaciones por URL o flujos n8n salientes sin control

Controles:

- no aceptar URLs arbitrarias en esta fase
- allowlist y timeouts para futuras llamadas salientes
- cuentas de servicio con permisos minimos

### Fuga de secretos

Riesgo:

- credenciales en repo, logs o tablas operativas

Controles:

- secretos fuera del SQL versionado
- uso de variables de entorno o gestor seguro
- documentacion separada para configuracion funcional y credenciales

### Logging inseguro

Riesgo:

- volcado de PII, tokens o documentos

Controles:

- auditoria separada de logs operativos
- no registrar secretos
- no almacenar documentos completos en historicos

### Manipulacion de estados

Riesgo:

- saltarse revisiones o mover estados sin permiso

Controles:

- tabla de transiciones permitidas
- trigger de validacion de transiciones
- historial de estados en auditoria

## Controles implementados en el MVP

- separacion por esquemas
- checks y unicos
- indices para acceso y auditoria
- historico de configuracion
- historico de cambios y estados de solicitudes
- calculos de negocio criticos en funciones SQL
- roles de base de datos con minimo privilegio
- AppSheet con permisos sobre tablas base concretas y vistas minimas de apoyo
- registro de futuras importaciones externas

## Controles operativos recomendados

- TLS obligatorio hacia PostgreSQL en entornos no locales
- rotacion de credenciales de servicio
- copias de seguridad cifradas
- politica de retencion de auditoria
- revision periodica de permisos AppSheet y n8n
- cuentas separadas por entorno

## Controles no activados aun

- antivirus o escaneo de adjuntos
- SSO corporativo
- backend HTTP con autenticacion propia
- RLS por fila en PostgreSQL

## Decisiones y limites

- Se evita almacenar secretos en `config.parametro_sistema`.
- Se aplaza la subida de ficheros hasta definir controles completos.
- Se aplaza cualquier automatizacion de escritura sobre Seneca.
- En el MVP no se admite escritura sobre vistas AppSheet; la escritura se hace sobre tablas base con permisos acotados.

## TODO

- Definir si la fase 2 usara RLS ademas de filtros AppSheet.
- Definir politica de retencion de datos personales.
- Definir catalogo final de eventos auditables para administracion sensible.
