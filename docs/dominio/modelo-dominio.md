# Modelo de dominio

## Objetivo del dominio

Gestionar el ciclo interno de una solicitud P.27 antes de su presentación oficial en Séneca, con validación, revisión, seguimiento y trazabilidad.

## Entidades principales

### Docente

Representa a la persona que solicita el permiso.

Campos clave:

- identificador técnico `docente_id`
- `codigo_interno`
- nombre y apellidos
- `email_centro`
- `departamento`
- `inicial_desempate`
- `activo`

Notas:

- `inicial_desempate` deja preparado el uso del criterio por letra.
- `documento_hash` permite referencia técnica sin guardar el documento en claro.

### Usuario

Representa a la identidad operativa en el sistema.

Roles base:

- profesorado
- dirección
- administración
- automatización
- consulta

### Solicitud

Es la agregación principal del dominio.

Campos clave:

- `codigo`
- `docente_id`
- fechas de inicio y fin
- motivo y observaciones
- `estado_actual`
- `dias_habiles_solicitados`
- `es_consecutiva_real`
- `requiere_revision_manual`
- metadatos de Séneca

Reglas relevantes:

- el rango de fechas no puede invertirse
- el cálculo de días hábiles usa calendario no lectivo
- la consecutividad real ignora días no hábiles
- una solicitud puede requerir revisión manual sin quedar denegada

### Máquina de estados de solicitud

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

- `borrador`: aún editable por profesorado
- `enviada`: entregada y pendiente de clasificación inicial
- `validada_automatica`: no ha saltado ninguna alerta automática relevante
- `requiere_revision`: necesita revisión humana antes de decidir
- `pendiente_subsanacion`: faltan datos o aclaraciones
- `autorizada_para_seneca`: validada internamente y lista para el paso oficial
- `presentada_en_seneca`: ya registrada en Séneca
- `aceptada`: resultado favorable tras la presentación
- `denegada`: resultado desfavorable
- `cerrada`: expediente finalizado sin más gestión interna
- `cancelada`: retirada por profesorado antes del cierre del flujo

Transiciones válidas del MVP:

| Origen | Destino | Rol habitual |
|---|---|---|
| `borrador` | `enviada` | profesorado |
| `borrador` | `cancelada` | profesorado |
| `enviada` | `validada_automatica` | automatización o dirección |
| `enviada` | `requiere_revision` | automatización o dirección |
| `enviada` | `cancelada` | profesorado |
| `validada_automatica` | `pendiente_subsanacion` | dirección |
| `validada_automatica` | `autorizada_para_seneca` | dirección |
| `validada_automatica` | `denegada` | dirección |
| `requiere_revision` | `pendiente_subsanacion` | dirección |
| `requiere_revision` | `autorizada_para_seneca` | dirección |
| `requiere_revision` | `denegada` | dirección |
| `pendiente_subsanacion` | `enviada` | profesorado |
| `pendiente_subsanacion` | `cancelada` | profesorado |
| `autorizada_para_seneca` | `presentada_en_seneca` | administración |
| `presentada_en_seneca` | `aceptada` | administración |
| `presentada_en_seneca` | `denegada` | administración |
| `aceptada` | `cerrada` | administración |
| `denegada` | `cerrada` | dirección o administración |

Estados terminales del MVP:

- `cerrada`
- `cancelada`

Reglas reforzadas en base de datos:

- no se permiten saltos de estado fuera de la tabla `core.estado_transicion_permitida`
- no se puede pasar a `presentada_en_seneca` sin venir de `autorizada_para_seneca`
- no se puede pasar a `aceptada` o `denegada` sin venir de `presentada_en_seneca`
- una solicitud en `cerrada` o `cancelada` no admite más cambios

### Historial de estados

Registra todas las transiciones de estado, incluido el alta inicial.

Uso:

- trazabilidad
- auditoría
- investigación de incidencias
- analítica futura

Campos relevantes:

- `solicitud_id`
- `estado_anterior`
- `estado_nuevo`
- `actor_usuario_id`
- `actor_rol`
- `creado_en`

### Incidencia de solicitud

Registra hallazgos o bloqueos de revisión.

Casos típicos:

- cupo diario superado
- máximo anual orientativo superado
- consecutividad real
- datos incompletos
- conflicto con calendario

### Calendario no lectivo

Determina días que no deben computarse como hábiles.

Uso:

- cálculo de días hábiles
- detección de consecutividad real
- futuras sincronizaciones y comprobaciones

### Parámetro de sistema

Configura reglas funcionales sin tocar código.

Ejemplos:

- cupo diario
- máximo anual por docente
- activación de reglas
- metadatos del centro

Modelado MVP:

- `tipo_valor` para tipado funcional simple
- `valor_texto` para edición administrativa desde AppSheet
- conversión interna a JSONB solo cuando se necesita un formato técnico uniforme

## Invariantes del dominio

- cada solicitud tiene un estado actual único
- toda transición de estado debe ser auditable
- la configuración editable tiene historial
- los datos de auditoría no se mezclan con tablas operativas
- los secretos técnicos no se almacenan como parámetros funcionales

## Reglas iniciales modeladas

- cálculo de días hábiles por `generate_series` y calendario no lectivo
- consecutividad real por día hábil anterior y siguiente
- marcaje de revisión manual por:
  - cupo diario
  - máximo anual orientativo
  - consecutividad real

## Reglas que quedan preparadas pero no cerradas

- TODO: criterio exacto de desempate por letra según normativa interna.
- TODO: definir si el cupo diario aplica por centro, etapa, turno o departamento.
- TODO: definir si algunas incidencias bloquean transición o solo exigen revisión humana.
