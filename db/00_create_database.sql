-- Ejecutar con un usuario con privilegios de creación de base de datos.
-- Ajustar propietario y locale según el entorno real.

CREATE DATABASE gestion_permisos_p27
    WITH
    OWNER = postgres
    ENCODING = 'UTF8'
    TEMPLATE = template0;

COMMENT ON DATABASE gestion_permisos_p27 IS
'Sistema interno de gestión de permisos P.27 previo a Séneca.';
