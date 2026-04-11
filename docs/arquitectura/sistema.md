# Arquitectura del sistema

## Visión general

El sistema se plantea como una arquitectura de capas simples y robustas:

1. PostgreSQL como fuente de verdad del dominio.
2. AppSheet como interfaz de captura, revisión y consulta.
3. n8n como capa futura de automatización y orquestación.
4. Google Calendar como integración futura de salida.
5. Séneca como sistema oficial externo, fuera del perímetro de escritura automática en esta fase.

## Principios

- Seguridad por defecto.
- Defensa en profundidad.
- Mínimo privilegio.
- Trazabilidad completa de acciones sensibles.
- Reglas de negocio críticas reforzadas en base de datos.
- Separación entre datos operativos, configuración, auditoría e integraciones.

## Componentes

### Base de datos PostgreSQL

Responsabilidades:

- persistir el dominio
- aplicar restricciones e integridad
- mantener históricos
- calcular días hábiles y consecutividad real
- exponer vistas de apoyo para AppSheet cuando aporten valor real

Esquemas:

- `config`: parámetros funcionales editables
- `core`: entidades operativas
- `audit`: auditoría e históricos
- `integration`: importaciones y conciliaciones
- `appsheet`: vistas de exposición

### AppSheet

Uso previsto:

- alta de pre-solicitudes por profesorado
- revisión y decisión por dirección
- mantenimiento básico de calendario y configuración por administración
- consulta de estado y trazabilidad resumida

Estrategia técnica del MVP:

- escribir directamente sobre tablas base en operaciones simples
- reservar vistas para *joins*, paneles y lectura
- editar también la configuración simple sobre su tabla base `config.parametro_sistema`

Límites deliberados:

- no se confía en AppSheet para reglas críticas
- no se guardan secretos funcionales en AppSheet
- no se habilitan adjuntos hasta definir política de seguridad

### n8n

Uso futuro:

- avisos y recordatorios
- sincronización con Google Calendar
- registro de importaciones de exportes
- procesos idempotentes de conciliación

### Integraciones externas

- Google Calendar: salida controlada de eventos autorizados
- Séneca: solo conciliación manual o semimanual, sin automatización robotizada en esta fase

## Flujo principal

1. Un docente crea una pre-solicitud.
2. La solicitud pasa de `borrador` a `enviada`.
3. Automatización o dirección la clasifica como `validada_automatica` o `requiere_revision`.
4. Dirección decide si pide subsanación, autoriza para Séneca o deniega.
5. Administración registra la presentación en Séneca cuando proceda.
6. La solicitud se resuelve en `aceptada` o `denegada`.
7. La solicitud se cierra en `cerrada` o termina anticipadamente en `cancelada`.

## Máquina de estados

Estados base:

- `borrador`
- `enviada`
- `validada_automatica`
- `requiere_revision`
- `pendiente_subsanacion`
- `autorizada_para_seneca`
- `presentada_en_seneca`
- `aceptada`
- `denegada`
- `cerrada`
- `cancelada`

Las transiciones permitidas se guardan en tabla, no embebidas en AppSheet.

Estados terminales:

- `cerrada`
- `cancelada`

## Seguridad de arquitectura

- Roles separados para propietario, AppSheet, automatización y solo lectura.
- Permisos de AppSheet sobre tablas base concretas y vistas de apoyo mínimas.
- Auditoría de cambios de configuración y de estado.
- Registro de importaciones futuras.
- Configuración funcional en tabla propia.
- Secretos fuera de la base de datos operativa.

## Decisiones aplazadas

- TODO: decidir si conviene una API intermedia propia antes de activar acciones sensibles desde AppSheet.
- TODO: decidir si el desempate por letra debe resolverse en SQL, en proceso de revisión o en automatización externa.
