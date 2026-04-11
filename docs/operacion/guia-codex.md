# Guía de trabajo futuro para agentes

## Objetivo

Dar continuidad al proyecto sin perder las decisiones base del MVP.

## Reglas

- tratar PostgreSQL como fuente de verdad
- no mover reglas críticas a la interfaz sin justificarlo
- documentar toda decisión relevante
- mantener la separación entre `config`, `core`, `audit`, `integration` y `appsheet`
- evitar deuda técnica silenciosa: si algo queda abierto, dejar `TODO`

## Siguiente foco recomendado

1. validar el dominio con personas del centro
2. conectar AppSheet a tablas base y vistas de apoyo según la estrategia del MVP
3. probar transiciones reales y permisos por rol
4. ajustar semillas y parámetros al curso real
