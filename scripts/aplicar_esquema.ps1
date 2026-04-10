param(
    [string]$HostName = "localhost",
    [int]$Port = 5432,
    [string]$Database = "gestion_permisos_p27",
    [string]$User = "postgres"
)

$ErrorActionPreference = "Stop"

$files = @(
    "db/01_extensions.sql",
    "db/02_schemas.sql",
    "db/03_types.sql",
    "db/04_tables_core.sql",
    "db/05_constraints.sql",
    "db/06_indexes.sql",
    "db/07_functions.sql",
    "db/08_triggers.sql",
    "db/09_views_appsheet.sql",
    "db/10_roles.sql",
    "db/11_seed_minimo.sql"
)

foreach ($file in $files) {
    Write-Host "Aplicando $file"
    psql -h $HostName -p $Port -U $User -d $Database -v ON_ERROR_STOP=1 -f $file
}

Write-Host "Esquema aplicado correctamente."
