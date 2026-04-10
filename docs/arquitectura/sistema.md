# Arquitectura del sistema

## Vision general

El sistema se plantea como una arquitectura de capas simples y robustas:

1. PostgreSQL como fuente de verdad del dominio.
2. AppSheet como interfaz de captura, revision y consulta.
3. n8n como capa futura de automatizacion y orquestacion.
4. Google Calendar como integracion futura de salida.
5. Seneca como sistema oficial externo, fuera del perimetro de escritura automatica en esta fase.

## Principios

- Seguridad por defecto.
- Defensa en profundidad.
- Minimo privilegio.
- Trazabilidad completa de acciones sensibles.
- Reglas de negocio criticas reforzadas en base de datos.
- Separacion entre datos operativos, configuracion, auditoria e integraciones.

## Componentes

### Base de datos PostgreSQL

Responsabilidades:

- persistir el dominio
- aplicar restricciones e integridad
- mantener historicos
- calcular dias habiles y consecutividad real
- exponer vistas de apoyo para AppSheet cuando aporten valor real

Esquemas:

- `config`: parametros funcionales editables
- `core`: entidades operativas
- `audit`: auditoria e historicos
- `integration`: importaciones y conciliaciones
- `appsheet`: vistas de exposicion

### AppSheet

Uso previsto:

- alta de pre-solicitudes por profesorado
- revision y decision por direccion
- mantenimiento basico de calendario y configuracion por administracion
- consulta de estado y trazabilidad resumida

Estrategia tecnica del MVP:

- escribir directamente sobre tablas base en operaciones simples
- reservar vistas para joins, paneles y lectura
- admitir como excepcion controlada la vista `appsheet.vw_parametros_editables`, porque filtra solo configuracion administrable

Limites deliberados:

- no se confia en AppSheet para reglas criticas
- no se guardan secretos funcionales en AppSheet
- no se habilitan adjuntos hasta definir politica de seguridad

### n8n

Uso futuro:

- avisos y recordatorios
- sincronizacion con Google Calendar
- registro de importaciones de exportes
- procesos idempotentes de conciliacion

### Integraciones externas

- Google Calendar: salida controlada de eventos autorizados
- Seneca: solo conciliacion manual o semimanual, sin automatizacion robotizada en esta fase

## Flujo principal

1. Un docente crea una pre-solicitud.
2. La solicitud pasa de `borrador` a `enviada`.
3. Direccion revisa y mueve a `en_revision`.
4. Direccion puede autorizar, denegar o marcar incidencia.
5. Administracion registra la presentacion en Seneca cuando proceda.
6. La solicitud se cierra cuando el ciclo interno queda completado.

## Maquina de estados

Estados base:

- `borrador`
- `enviada`
- `en_revision`
- `pendiente_subsanacion`
- `validada_interna`
- `autorizada_direccion`
- `denegada_direccion`
- `incidencia_detectada`
- `presentada_seneca`
- `cerrada`
- `cancelada`

Las transiciones permitidas se guardan en tabla, no embebidas en AppSheet.

## Seguridad de arquitectura

- Roles separados para propietario, AppSheet, automatizacion y solo lectura.
- Permisos de AppSheet sobre tablas base concretas y vistas de apoyo minimas.
- Auditoria de cambios de configuracion y de estado.
- Registro de importaciones futuras.
- Configuracion funcional en tabla propia.
- Secretos fuera de la base de datos operativa.

## Decisiones aplazadas

- TODO: decidir si conviene una API intermedia propia antes de activar acciones sensibles desde AppSheet.
- TODO: decidir si el desempate por letra debe resolverse en SQL, en proceso de revision o en automatizacion externa.
