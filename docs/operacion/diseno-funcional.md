# Diseno funcional

## Objetivo

Cubrir el circuito interno previo a Seneca para solicitudes P.27 durante periodo lectivo.

## Actores

- Profesorado: crea y corrige pre-solicitudes.
- Direccion: revisa, valida, autoriza, deniega o marca incidencias.
- Administracion: mantiene configuracion, calendario y registro interno de presentacion en Seneca.

## Flujo funcional minimo

1. El docente crea la pre-solicitud.
2. El sistema calcula dias habiles y marca revision manual cuando corresponda.
3. Direccion revisa la solicitud.
4. Direccion puede:
   - pedir subsanacion
   - validar internamente
   - autorizar
   - denegar
   - marcar incidencia
5. Administracion registra si la solicitud se ha presentado oficialmente en Seneca.
6. La solicitud se cierra cuando termina el circuito interno.

## Casos de uso MVP

- alta de solicitud
- consulta de estado por el docente
- revision de solicitudes pendientes por direccion
- mantenimiento del calendario no lectivo
- mantenimiento de parametros del sistema
- registro de incidencias y observaciones
- consulta de historico de estados

## Reglas visibles para usuarios

- una solicitud P.27 siempre empieza como pre-solicitud interna
- el sistema puede marcar la solicitud para revision manual
- la autorizacion interna no equivale a presentacion oficial en Seneca
- el calendario no lectivo afecta al computo de dias habiles

## Fuera de alcance de esta fase

- subida de adjuntos
- firma digital
- notificaciones automaticas complejas
- sincronizacion automatica con Seneca
