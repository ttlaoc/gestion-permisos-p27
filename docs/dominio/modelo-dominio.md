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

### Maquina de estados de solicitud

Estados operativos:

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

Lectura funcional recomendada:

- `borrador`: aun editable por profesorado
- `enviada`: entregada y pendiente de clasificacion inicial
- `validada_automatica`: no ha saltado ninguna alerta automatica relevante
- `requiere_revision`: necesita revision humana antes de decidir
- `pendiente_subsanacion`: faltan datos o aclaraciones
- `autorizada_para_seneca`: validada internamente y lista para el paso oficial
- `presentada_en_seneca`: ya registrada en Seneca
- `aceptada`: resultado favorable tras presentacion
- `denegada`: resultado desfavorable
- `cerrada`: expediente finalizado sin mas gestion interna
- `cancelada`: retirada por profesorado antes del cierre del flujo

Transiciones validas del MVP:

| Origen | Destino | Rol habitual |
|---|---|---|
| `borrador` | `enviada` | profesorado |
| `borrador` | `cancelada` | profesorado |
| `enviada` | `validada_automatica` | automatizacion o direccion |
| `enviada` | `requiere_revision` | automatizacion o direccion |
| `enviada` | `cancelada` | profesorado |
| `validada_automatica` | `pendiente_subsanacion` | direccion |
| `validada_automatica` | `autorizada_para_seneca` | direccion |
| `validada_automatica` | `denegada` | direccion |
| `requiere_revision` | `pendiente_subsanacion` | direccion |
| `requiere_revision` | `autorizada_para_seneca` | direccion |
| `requiere_revision` | `denegada` | direccion |
| `pendiente_subsanacion` | `enviada` | profesorado |
| `pendiente_subsanacion` | `cancelada` | profesorado |
| `autorizada_para_seneca` | `presentada_en_seneca` | administracion |
| `presentada_en_seneca` | `aceptada` | administracion |
| `presentada_en_seneca` | `denegada` | administracion |
| `presentada_en_seneca` | `cerrada` | administracion |

Estados terminales del MVP:

- `aceptada`
- `denegada`
- `cerrada`
- `cancelada`

Reglas reforzadas en base de datos:

- no se permiten saltos de estado fuera de la tabla `core.estado_transicion_permitida`
- no se puede pasar a `presentada_en_seneca` sin venir de `autorizada_para_seneca`
- no se puede pasar a `aceptada` o `denegada` sin venir de `presentada_en_seneca`
- una solicitud en estado terminal no admite mas cambios

### Historial de estados

Registra todas las transiciones de estado, incluido el alta inicial.

Uso:

- trazabilidad
- auditoria
- investigacion de incidencias
- analitica futura

Campos relevantes:

- `solicitud_id`
- `estado_anterior`
- `estado_nuevo`
- `actor_usuario_id`
- `actor_rol`
- `creado_en`

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
