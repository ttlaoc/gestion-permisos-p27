# Este script supone que postgres está instalado en un contenedor Docker local
param(
    [string]$HostName = "aws-0-eu-west-1.pooler.supabase.com",
    [int]$Port = 5432,
    [string]$Database = "postgres",
    [string]$User = "postgres.TU_PROJECT_REF",
    [string]$Password = "",
    [string]$DockerImage = "postgres:16"
)

$ErrorActionPreference = "Stop"

if ([string]::IsNullOrWhiteSpace($Password)) {
    $Password = Read-Host "Introduce la clave de Supabase"
}

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
    docker run --rm -i `
        -e PGPASSWORD=$Password `
        $DockerImage `
        psql `
        "host=$HostName port=$Port dbname=$Database user=$User sslmode=require" `
        -v ON_ERROR_STOP=1

    if ($LASTEXITCODE -ne 0) {
        throw "Error aplicando $file"
    }
}

Write-Host "Esquema aplicado correctamente en Supabase." -ForegroundColor Green