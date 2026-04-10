# Guia de trabajo futuro para agentes

## Objetivo

Dar continuidad al proyecto sin perder las decisiones base del MVP.

## Reglas

- tratar PostgreSQL como fuente de verdad
- no mover reglas criticas a la interfaz sin justificarlo
- documentar toda decision relevante
- mantener la separacion entre `config`, `core`, `audit`, `integration` y `appsheet`
- evitar deuda tecnica silenciosa: si algo queda abierto, dejar `TODO`

## Siguiente foco recomendado

1. validar el dominio con personas del centro
2. conectar AppSheet a tablas base y vistas de apoyo segun la estrategia MVP
3. probar transiciones reales y permisos por rol
4. ajustar seeds y parametros al curso real
