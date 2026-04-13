param(
    [string]$ContainerName = "gestion-permisos-p27-db",
    [string]$Database = "gestion_permisos_p27",
    [string]$User = "gp27_owner"
)

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $PSScriptRoot

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
    $fullPath = Join-Path $repoRoot $file

    if (-not (Test-Path $fullPath)) {
        throw "No se encuentra el archivo: $fullPath"
    }

    Write-Host "Aplicando $file ..." -ForegroundColor Cyan

    Get-Content $fullPath -Raw |
    docker exec -i $ContainerName psql -U $User -d $Database -v ON_ERROR_STOP=1

    if ($LASTEXITCODE -ne 0) {
        throw "Error aplicando $file"
    }
}

Write-Host "Esquema aplicado correctamente." -ForegroundColor Green