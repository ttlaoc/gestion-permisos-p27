# Diseño funcional

## Objetivo

Cubrir el circuito interno previo a Séneca para solicitudes P.27 durante período lectivo.

## Actores

- Profesorado: crea y corrige pre-solicitudes.
- Dirección: revisa, valida, autoriza, deniega o marca incidencias.
- Administración: mantiene configuración, calendario y registro interno de presentación en Séneca.

## Flujo funcional mínimo

1. El docente crea la pre-solicitud.
2. El sistema calcula días hábiles y marca revisión manual cuando corresponda.
3. Dirección revisa la solicitud.
4. Dirección puede:
   - pedir subsanación
   - clasificar para validación automática o revisión manual
   - autorizar para Séneca
   - denegar
   - registrar incidencia
5. Administración registra si la solicitud se ha presentado oficialmente en Séneca.
6. La solicitud se resuelve y se cierra cuando termina el circuito interno.

## Casos de uso MVP

- alta de solicitud
- consulta de estado por el docente
- revisión de solicitudes pendientes por dirección
- mantenimiento del calendario no lectivo
- mantenimiento de parámetros del sistema
- registro de incidencias y observaciones
- consulta de histórico de estados

## Operación prevista en AppSheet

La app del MVP se organiza por tres espacios operativos:

- profesorado: captura, envío, subsanación y consulta de sus solicitudes
- dirección: revisión, incidencias, subsanación, autorización y cierre cuando proceda
- administración: registro de presentación en Séneca, resolución y cierre

La guía práctica de construcción de AppSheet, con tablas, slices, filtros, acciones y vistas, queda documentada en `docs/integraciones/appsheet.md`.

## Reglas visibles para usuarios

- una solicitud P.27 siempre empieza como pre-solicitud interna
- el sistema puede marcar la solicitud para revisión manual
- la autorización interna no equivale a presentación oficial en Séneca
- el calendario no lectivo afecta al cómputo de días hábiles

## Fuera de alcance de esta fase

- subida de adjuntos
- firma digital
- notificaciones automáticas complejas
- sincronización automática con Séneca
