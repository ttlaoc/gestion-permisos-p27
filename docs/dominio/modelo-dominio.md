# Modelo de dominio

## Objetivo del dominio

Gestionar el ciclo interno de una solicitud P.27 antes de su presentacion oficial en Seneca, con validacion, revision, seguimiento y trazabilidad.

## Entidades principales

### Docente

Representa a la persona que solicita el permiso.

Campos clave:

- identificador tecnico `docente_id`
- `codigo_interno`
- nombre y apellidos
- `email_centro`
- `departamento`
- `inicial_desempate`
- `activo`

Notas:

- `inicial_desempate` deja preparado el uso del criterio por letra.
- `documento_hash` permite referencia tecnica sin guardar el documento en claro.

### Usuario

Representa a la identidad operativa en el sistema.

Roles base:

- profesorado
- direccion
- administracion
- automatizacion
- consulta

### Solicitud

Es la agregacion principal del dominio.

Campos clave:

- `codigo`
- `docente_id`
- fechas de inicio y fin
- motivo y observaciones
- `estado_actual`
- `dias_habiles_solicitados`
- `es_consecutiva_real`
- `requiere_revision_manual`
- metadatos de Seneca

Reglas relevantes:

- el rango de fechas no puede invertirse
- el calculo de dias habiles usa calendario no lectivo
- la consecutividad real ignora dias no habiles
- una solicitud puede requerir revision manual sin quedar denegada

### Historial de estados

Registra todas las transiciones de estado, incluido el alta inicial.

Uso:

- trazabilidad
- auditoria
- investigacion de incidencias
- analitica futura

### Incidencia de solicitud

Registra hallazgos o bloqueos de revision.

Casos tipicos:

- cupo diario superado
- maximo anual orientativo superado
- consecutividad real
- datos incompletos
- conflicto con calendario

### Calendario no lectivo

Determina dias que no deben computarse como habiles.

Uso:

- calculo de dias habiles
- deteccion de consecutividad real
- futuras sincronizaciones y comprobaciones

### Parametro de sistema

Configura reglas funcionales sin tocar codigo.

Ejemplos:

- cupo diario
- maximo anual por docente
- activacion de reglas
- metadatos del centro

Modelado MVP:

- `tipo_valor` para tipado funcional simple
- `valor_texto` para edicion administrativa desde AppSheet
- conversion interna a JSONB solo cuando se necesita un formato tecnico uniforme

## Invariantes del dominio

- cada solicitud tiene un estado actual unico
- toda transicion de estado debe ser auditable
- la configuracion editable tiene historial
- los datos de auditoria no se mezclan con tablas operativas
- los secretos tecnicos no se almacenan como parametros funcionales

## Reglas iniciales modeladas

- calculo de dias habiles por `generate_series` y calendario no lectivo
- consecutividad real por dia habil anterior y siguiente
- marcaje de revision manual por:
  - cupo diario
  - maximo anual orientativo
  - consecutividad real

## Reglas que quedan preparadas pero no cerradas

- TODO: criterio exacto de desempate por letra segun normativa interna.
- TODO: definir si el cupo diario aplica por centro, etapa, turno o departamento.
- TODO: definir si algunas incidencias bloquean transicion o solo exigen revision humana.
