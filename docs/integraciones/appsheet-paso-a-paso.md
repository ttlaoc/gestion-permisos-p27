# AppSheet paso a paso para construir el MVP

## 0. Preparación mínima

Antes de entrar en AppSheet, confirma:

- la base PostgreSQL está aplicada
- existen datos seed
- AppSheet puede conectarse a PostgreSQL
- la cuenta usada por AppSheet tiene el rol `gp27_appsheet`

---

## 1. Crear la app y conectar datos

## Checklist

1. Crear una app nueva en AppSheet.
2. Elegir PostgreSQL como origen.
3. Conectar la base del MVP.
4. Añadir las tablas y vistas en este orden exacto:
   1. `core.usuario`
   2. `core.docente`
   3. `core.solicitud`
   4. `core.incidencia_solicitud`
   5. `core.calendario_no_lectivo`
   6. `config.parametro_sistema`
   7. `appsheet.vw_revision_solicitudes`
   8. `appsheet.vw_parametros_editables`
5. Marcar como solo lectura las vistas:
   - `appsheet.vw_revision_solicitudes`
   - `appsheet.vw_parametros_editables`
6. Regenerar estructura si AppSheet no detecta bien tipos y refs.

---

## 2. Configuración base por tabla

## `core.usuario`

- Name: `Usuarios`
- Key: `usuario_id`
- Label: `nombre_mostrar`
- Uso: lectura de perfil y refs
- Adds: OFF
- Updates: OFF
- Deletes: OFF

### Ocultar

- `proveedor_identidad`
- `referencia_externa`
- `creado_en`
- `actualizado_en`

### Solo lectura

- todas las columnas

## `core.docente`

- Name: `Docentes`
- Key: `docente_id`
- Label: `codigo_interno`
- Adds: ON
- Updates: ON
- Deletes: OFF

### Refs

- `usuario_id` ? `core.usuario`

### Ocultar

- `docente_id`
- `usuario_id`
- `documento_hash`
- `creado_en`
- `actualizado_en`

### Editables

- `codigo_interno`
- `nombre`
- `apellido_1`
- `apellido_2`
- `email_centro`
- `departamento`
- `activo`
- `inicial_desempate`
- `observaciones`

### Readonly

- `docente_id`
- `usuario_id`
- `documento_hash`
- `creado_en`
- `actualizado_en`

### Formulario

Usar:

- `codigo_interno`
- `nombre`
- `apellido_1`
- `apellido_2`
- `email_centro`
- `departamento`
- `activo`
- `inicial_desempate`
- `observaciones`

## `core.solicitud`

- Name: `Solicitudes`
- Key: `solicitud_id`
- Label: `codigo`
- Adds: ON
- Updates: ON
- Deletes: OFF

### Refs

- `docente_id` ? `core.docente`
- `creada_por_usuario_id` ? `core.usuario`
- `revisada_por_usuario_id` ? `core.usuario`

### Ocultar siempre

- `solicitud_id`
- `codigo` en formulario de alta
- `version_registro`
- `creada_en`
- `actualizada_en`

### Readonly siempre

- `codigo`
- `dias_habiles_solicitados`
- `es_consecutiva_real`
- `requiere_revision_manual`
- `version_registro`
- `creada_en`
- `actualizada_en`

### Formulario profesorado

Usar:

- `docente_id`
- `fecha_solicitud`
- `fecha_inicio`
- `fecha_fin`
- `motivo`
- `observaciones_docente`

Ocultar del formulario:

- `creada_por_usuario_id`
- `revisada_por_usuario_id`
- `observaciones_direccion`
- `estado_actual`
- `presentada_en_seneca`
- `fecha_presentacion_seneca`
- `referencia_seneca`

### Formulario direcci�n

Usar:

- `observaciones_direccion`

### Formulario administraci�n

Usar:

- `presentada_en_seneca`
- `fecha_presentacion_seneca`
- `referencia_seneca`

## `core.incidencia_solicitud`

- Name: `Incidencias`
- Key: `incidencia_id`
- Label: `descripcion`
- Adds: ON
- Updates: ON
- Deletes: OFF

### Refs

- `solicitud_id` ? `core.solicitud`
- `detectada_por_usuario_id` ? `core.usuario`
- `resuelta_por_usuario_id` ? `core.usuario`

### Ocultar

- `incidencia_id`
- `detectada_por_usuario_id`
- `creada_en`
- `actualizada_en`

### Editables

- `solicitud_id`
- `tipo_incidencia`
- `severidad`
- `descripcion`
- `abierta`
- `resuelta_por_usuario_id`
- `resuelta_en`

### Readonly

- `incidencia_id`
- `detectada_por_usuario_id`
- `creada_en`
- `actualizada_en`

### Formulario

Usar:

- `solicitud_id`
- `tipo_incidencia`
- `severidad`
- `descripcion`
- `abierta`

## `core.calendario_no_lectivo`

- Name: `Calendario no lectivo`
- Key: `calendario_no_lectivo_id`
- Label: `descripcion`
- Adds: ON
- Updates: ON
- Deletes: OFF

### Ocultar

- `calendario_no_lectivo_id`
- `creado_en`
- `actualizado_en`

### Editables

- `fecha`
- `descripcion`
- `ambito`
- `es_festivo`
- `es_no_lectivo`
- `origen`

### Readonly

- `calendario_no_lectivo_id`
- `creado_en`
- `actualizado_en`

### Formulario

Usar:

- `fecha`
- `descripcion`
- `ambito`
- `es_festivo`
- `es_no_lectivo`
- `origen`

## `config.parametro_sistema`

- Name: `Par�metros del sistema`
- Key: `parametro_id`
- Label: `clave`
- Adds: OFF
- Updates: ON
- Deletes: OFF

### Ocultar

- `parametro_id`
- `actualizado_por`
- `creado_en`

### Editables

- `tipo_valor`
- `valor_texto`

### Readonly

- `parametro_id`
- `clave`
- `categoria`
- `descripcion`
- `editable`
- `version`
- `actualizado_por`
- `actualizado_en`
- `creado_en`

### Formulario

Usar:

- `tipo_valor`
- `valor_texto`

## `appsheet.vw_revision_solicitudes`

- Name: `Panel de revisi�n`
- Key: `solicitud_id`
- Label: `codigo`
- Adds: OFF
- Updates: OFF
- Deletes: OFF

### Mostrar

- `codigo`
- `docente_codigo`
- `nombre`
- `apellido_1`
- `apellido_2`
- `departamento`
- `fecha_inicio`
- `fecha_fin`
- `dias_habiles_solicitados`
- `estado_actual`
- `es_consecutiva_real`
- `requiere_revision_manual`
- `presentada_en_seneca`
- `referencia_seneca`
- `actualizada_en`

## `appsheet.vw_parametros_editables`

- Name: `Panel de par�metros`
- Key: `parametro_id`
- Label: `clave`
- Adds: OFF
- Updates: OFF
- Deletes: OFF

---

## 3. Expresiones base reutilizables

## Rol actual

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal")
```

## Usuario actual

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "usuario_id")
```

## Docente actual

```appsheet
LOOKUP(USEREMAIL(), "core.docente", "email_centro", "docente_id")
```

## Es profesorado

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "profesorado"
```

## Es direcci�n

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "direccion"
```

## Es administraci�n

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "administracion"
```

---

## 4. Security filters exactos

## `core.usuario`

```appsheet
OR(
  [email] = USEREMAIL(),
  IN(
    LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
    {"direccion", "administracion"}
  )
)
```

## `core.docente`

```appsheet
OR(
  [email_centro] = USEREMAIL(),
  IN(
    LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
    {"direccion", "administracion"}
  )
)
```

## `core.solicitud`

```appsheet
IFS(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "profesorado",
    [docente_id] = LOOKUP(USEREMAIL(), "core.docente", "email_centro", "docente_id"),

  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "direccion",
    TRUE,

  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "administracion",
    IN(
      [estado_actual],
      {
        "autorizada_para_seneca",
        "presentada_en_seneca",
        "aceptada",
        "denegada",
        "cerrada"
      }
    ),

  FALSE
)
```

## `core.incidencia_solicitud`

```appsheet
IN(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
  {"direccion", "administracion"}
)
```

## `core.calendario_no_lectivo`

```appsheet
IN(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
  {"direccion", "administracion"}
)
```

## `config.parametro_sistema`

```appsheet
IN(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
  {"direccion", "administracion"}
)
```

## `appsheet.vw_revision_solicitudes`

```appsheet
IN(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
  {"direccion", "administracion"}
)
```

## `appsheet.vw_parametros_editables`

```appsheet
IN(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
  {"direccion", "administracion"}
)
```

---

## 5. Slices exactos

## Profesorado

### `sl_mis_solicitudes`

```appsheet
[docente_id] = LOOKUP(USEREMAIL(), "core.docente", "email_centro", "docente_id")
```

### `sl_mis_borradores`

```appsheet
AND(
  [docente_id] = LOOKUP(USEREMAIL(), "core.docente", "email_centro", "docente_id"),
  [estado_actual] = "borrador"
)
```

### `sl_mis_subsanaciones`

```appsheet
AND(
  [docente_id] = LOOKUP(USEREMAIL(), "core.docente", "email_centro", "docente_id"),
  [estado_actual] = "pendiente_subsanacion"
)
```

### `sl_mis_cerradas`

```appsheet
AND(
  [docente_id] = LOOKUP(USEREMAIL(), "core.docente", "email_centro", "docente_id"),
  IN([estado_actual], {"aceptada", "denegada", "cerrada", "cancelada"})
)
```

## Direcci�n

### `sl_solicitudes_pendientes_revision`

```appsheet
IN([estado_actual], {"enviada", "validada_automatica", "requiere_revision", "pendiente_subsanacion"})
```

### `sl_solicitudes_autorizadas_seneca`

```appsheet
[estado_actual] = "autorizada_para_seneca"
```

### `sl_solicitudes_presentadas_seneca`

```appsheet
[estado_actual] = "presentada_en_seneca"
```

### `sl_solicitudes_cerradas`

```appsheet
IN([estado_actual], {"aceptada", "denegada", "cerrada", "cancelada"})
```

### `sl_incidencias`

```appsheet
TRUE
```

## Administraci�n

### `sl_adm_autorizadas_seneca`

```appsheet
[estado_actual] = "autorizada_para_seneca"
```

### `sl_adm_presentadas_seneca`

```appsheet
[estado_actual] = "presentada_en_seneca"
```

### `sl_adm_pendientes_cierre`

```appsheet
IN([estado_actual], {"aceptada", "denegada"})
```

## Configuraci�n

### `sl_configuracion_editable`

```appsheet
[editable] = TRUE
```

---

## 6. Acciones exactas de cambio de estado

Crear todas como:

- Behavior
- `Data: set the values of some columns in this row`
- tabla objetivo: `core.solicitud`

## `ac_enviar_solicitud`

### Set these columns

- `estado_actual` = `"enviada"`
- `creada_por_usuario_id` = `LOOKUP(USEREMAIL(), "core.usuario", "email", "usuario_id")`

### Only if

```appsheet
AND(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "profesorado",
  IN([estado_actual], {"borrador", "pendiente_subsanacion"})
)
```

## `ac_pasar_subsanacion`

### Set these columns

- `estado_actual` = `"pendiente_subsanacion"`
- `revisada_por_usuario_id` = `LOOKUP(USEREMAIL(), "core.usuario", "email", "usuario_id")`

### Only if

```appsheet
AND(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "direccion",
  IN([estado_actual], {"validada_automatica", "requiere_revision"})
)
```

## `ac_autorizar_seneca`

### Set these columns

- `estado_actual` = `"autorizada_para_seneca"`
- `revisada_por_usuario_id` = `LOOKUP(USEREMAIL(), "core.usuario", "email", "usuario_id")`

### Only if

```appsheet
AND(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "direccion",
  IN([estado_actual], {"validada_automatica", "requiere_revision"})
)
```

## `ac_marcar_presentada_seneca`

### Set these columns

- `estado_actual` = `"presentada_en_seneca"`
- `presentada_en_seneca` = `TRUE`
- `fecha_presentacion_seneca` = `TODAY()`

### Only if

```appsheet
AND(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "administracion",
  [estado_actual] = "autorizada_para_seneca"
)
```

## `ac_aceptar`

### Set these columns

- `estado_actual` = `"aceptada"`

### Only if

```appsheet
AND(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "administracion",
  [estado_actual] = "presentada_en_seneca"
)
```

## `ac_denegar`

### Set these columns

- `estado_actual` = `"denegada"`
- `revisada_por_usuario_id` = `LOOKUP(USEREMAIL(), "core.usuario", "email", "usuario_id")`

### Only if

```appsheet
AND(
  IN(
    LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
    {"direccion", "administracion"}
  ),
  IN([estado_actual], {"validada_automatica", "requiere_revision", "presentada_en_seneca"})
)
```

## `ac_cerrar`

### Set these columns

- `estado_actual` = `"cerrada"`

### Only if

```appsheet
AND(
  IN(
    LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
    {"direccion", "administracion"}
  ),
  IN([estado_actual], {"aceptada", "denegada"})
)
```

## Recomendadas adicionales

## `ac_cancelar_solicitud`

### Set these columns

- `estado_actual` = `"cancelada"`

### Only if

```appsheet
AND(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "profesorado",
  IN([estado_actual], {"borrador", "enviada", "pendiente_subsanacion"})
)
```

---

## 7. Visibilidad por rol

## Mostrar men� profesorado

Usar esta condici�n en las vistas de profesorado:

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "profesorado"
```

## Mostrar men� direcci�n

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "direccion"
```

## Mostrar men� administraci�n

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "administracion"
```

---

## 8. Pasos concretos para profesorado

1. Crear slice `sl_mis_solicitudes`.
2. Crear slice `sl_mis_borradores`.
3. Crear slice `sl_mis_subsanaciones`.
4. Crear slice `sl_mis_cerradas`.
5. Crear vista `Mis solicitudes` sobre `sl_mis_solicitudes`.
6. Crear vista `Borradores` sobre `sl_mis_borradores`.
7. Crear vista `Pendientes de subsanaci�n` sobre `sl_mis_subsanaciones`.
8. Crear vista `Hist�rico personal` sobre `sl_mis_cerradas`.
9. Crear formulario `Nueva solicitud` sobre `core.solicitud`.
10. En `core.solicitud`, definir:
    - `docente_id` Initial value:

```appsheet
LOOKUP(USEREMAIL(), "core.docente", "email_centro", "docente_id")
```

   - `creada_por_usuario_id` Initial value:

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "usuario_id")
```

   - `fecha_solicitud` Initial value:

```appsheet
TODAY()
```

   - `estado_actual` Initial value:

```appsheet
"borrador"
```

11. En `fecha_inicio`, `fecha_fin`, `motivo`, `observaciones_docente`, poner `Editable_If`:

```appsheet
AND(
  LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "profesorado",
  IN([estado_actual], {"borrador", "pendiente_subsanacion"})
)
```

12. Crear acciones:
    - `ac_enviar_solicitud`
    - `ac_cancelar_solicitud`
13. Mostrar acciones en la vista Detail.
14. Crear dashboard `Inicio profesorado`.

---

## 9. Pasos concretos para direcci�n

1. Crear slice `sl_solicitudes_pendientes_revision`.
2. Crear slice `sl_solicitudes_autorizadas_seneca`.
3. Crear slice `sl_solicitudes_presentadas_seneca`.
4. Crear slice `sl_solicitudes_cerradas`.
5. Crear slice `sl_incidencias`.
6. Crear vista `Pendientes de revisi�n`.
7. Crear vista `Autorizadas para S�neca`.
8. Crear vista `Panel de revisi�n` sobre `appsheet.vw_revision_solicitudes`.
9. Crear vista `Incidencias`.
10. En `core.solicitud[observaciones_direccion]`, poner `Editable_If`:

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "direccion"
```

11. En `core.solicitud[revisada_por_usuario_id]`, Initial value:

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "usuario_id")
```

12. Crear acciones:
    - `ac_pasar_subsanacion`
    - `ac_autorizar_seneca`
    - `ac_denegar`
    - `ac_cerrar`
13. Crear formulario de incidencia en `core.incidencia_solicitud`.
14. En `detectada_por_usuario_id`, Initial value:

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "usuario_id")
```

15. Crear dashboard `Panel revisi�n`.

---

## 10. Pasos concretos para administraci�n

1. Crear slice `sl_adm_autorizadas_seneca`.
2. Crear slice `sl_adm_presentadas_seneca`.
3. Crear slice `sl_adm_pendientes_cierre`.
4. Crear slice `sl_configuracion_editable`.
5. Crear vista `Autorizadas para S�neca`.
6. Crear vista `Presentadas en S�neca`.
7. Crear vista `Pendientes de cierre`.
8. Crear vista `Calendario no lectivo`.
9. Crear vista `Configuraci�n`.
10. En `config.parametro_sistema`, poner `Editable_If` en `tipo_valor` y `valor_texto`:

```appsheet
AND(
  IN(
    LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal"),
    {"direccion", "administracion"}
  ),
  [editable] = TRUE
)
```

11. En `core.solicitud[referencia_seneca]`, `Show_If`:

```appsheet
LOOKUP(USEREMAIL(), "core.usuario", "email", "rol_principal") = "administracion"
```

12. Crear acciones:
    - `ac_marcar_presentada_seneca`
    - `ac_aceptar`
    - `ac_denegar`
    - `ac_cerrar`
13. Crear dashboard `Operaci�n S�neca`.

---

## 11. Vistas recomendadas finales

## Profesorado

- `Inicio profesorado` ? Dashboard
- `Mis solicitudes` ? Deck o Table
- `Borradores` ? Table
- `Pendientes de subsanaci�n` ? Table
- `Hist�rico personal` ? Table
- `Nueva solicitud` ? Form
- `Detalle solicitud` ? Detail

## Direcci�n

- `Panel revisi�n` ? Dashboard
- `Pendientes de revisi�n` ? Table
- `Panel de revisi�n` ? Table
- `Autorizadas para S�neca` ? Table
- `Incidencias` ? Table

## Administraci�n

- `Operaci�n S�neca` ? Dashboard
- `Autorizadas para S�neca` ? Table
- `Presentadas en S�neca` ? Table
- `Pendientes de cierre` ? Table
- `Calendario no lectivo` ? Table
- `Configuraci�n` ? Table

---

## 12. Verificaci�n final

## Verificaci�n de datos base

1. Entrar como profesorado.
2. Confirmar que solo ve:
   - su usuario
   - su docente
   - sus solicitudes
3. Entrar como direcci�n.
4. Confirmar que ve todas las solicitudes.
5. Entrar como administraci�n.
6. Confirmar que no ve borradores ni enviadas ni pendientes de subsanaci�n.

## Verificaci�n de formularios

## Profesorado

1. Crear solicitud nueva.
2. Confirmar que:
   - aparece en `Borradores`
   - `estado_actual = borrador`
   - se calculan d�as h�biles al guardar
3. Editar borrador.
4. Confirmar que solo puede editar:
   - fechas
   - motivo
   - observaciones del profesorado

## Direcci�n

1. Abrir una solicitud enviada o en revisi�n.
2. Confirmar que puede escribir `observaciones_direccion`.
3. Crear una incidencia.
4. Confirmar que queda vinculada a la solicitud.

## Administraci�n

1. Abrir una solicitud autorizada para S�neca.
2. Confirmar que puede informar:
   - presentaci�n
   - fecha
   - referencia

## Verificaci�n de acciones

1. `ac_enviar_solicitud`
   - visible solo a profesorado
   - cambia de `borrador` o `pendiente_subsanacion` a `enviada`
2. `ac_pasar_subsanacion`
   - visible solo a direcci�n
   - cambia a `pendiente_subsanacion`
3. `ac_autorizar_seneca`
   - visible solo a direcci�n
   - cambia a `autorizada_para_seneca`
4. `ac_marcar_presentada_seneca`
   - visible solo a administraci�n
   - cambia a `presentada_en_seneca`
5. `ac_aceptar`
   - visible solo a administraci�n
   - cambia a `aceptada`
6. `ac_denegar`
   - visible solo al rol permitido
7. `ac_cerrar`
   - visible solo al rol permitido
   - cambia a `cerrada`

## Verificaci�n de slices

1. `sl_mis_solicitudes` solo devuelve registros del docente actual.
2. `sl_mis_borradores` solo devuelve borradores propios.
3. `sl_solicitudes_pendientes_revision` muestra estados de revisi�n.
4. `sl_adm_autorizadas_seneca` solo muestra autorizadas.
5. `sl_configuracion_editable` no muestra par�metros no editables.

## Verificaci�n de vistas

1. Cada vista aparece solo al rol correcto.
2. Los dashboards cargan sin errores.
3. Las tablas muestran columnas �tiles y no exponen columnas t�cnicas.
4. Las vistas `appsheet.*` no permiten edici�n.

## Criterio de cierre

La app est� lista para construcci�n funcional real cuando:

- cada rol ve solo lo que debe ver
- cada acci�n aparece solo cuando corresponde
- las transiciones v�lidas funcionan
- las inv�lidas quedan bloqueadas por la base de datos
- la configuraci�n editable se puede mantener sin tocar SQL
