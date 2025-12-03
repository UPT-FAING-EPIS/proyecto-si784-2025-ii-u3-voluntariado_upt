<#
PowerShell helper para generar una estimación de costos con Infracost
- Requisitos: terraform en PATH, infracost en PATH y variable de entorno INFRACOST_API_KEY configurada.
- Ejecuta: desde la carpeta `terraform` -> `./cost_estimate.ps1`
- Resultado: crea `tfplan`, `tfplan.json`, `infracost.json` y `infracost.txt`. Luego añade un bloque con la tabla de Infracost a `FD01-Informe-Factibilidad.md` en el root del repo (si existe) o a `terraform/terraform_cost_report.md`.
#>

param(
    [string]$ProjectId
)

$ErrorActionPreference = 'Stop'
Push-Location $PSScriptRoot

function ExitWithMessage($msg) {
    Write-Error $msg
    Pop-Location
    exit 1
}

if (-not (Get-Command terraform -ErrorAction SilentlyContinue)) {
    ExitWithMessage "Terraform no está instalado o no está en el PATH. Instala Terraform y vuelve a intentarlo."
}

if (-not (Get-Command infracost -ErrorAction SilentlyContinue)) {
    ExitWithMessage "Infracost no está instalado o no está en el PATH. Instala Infracost (https://www.infracost.io) y configura INFRACOST_API_KEY."
}

Write-Host "Inicializando Terraform..."
terraform init -input=false

Write-Host "Generando plan de Terraform..."
$planFile = "tfplan"
terraform plan -out=$planFile -input=false

Write-Host "Exportando plan a JSON..."
terraform show -json $planFile > tfplan.json

Write-Host "Ejecutando Infracost..."
$infracostJson = "infracost.json"
$infracostTxt = "infracost.txt"

# Genera salida JSON y una tabla legible
infracost breakdown --path=tfplan.json --format json --out-file $infracostJson
infracost breakdown --path=tfplan.json --format table --no-color > $infracostTxt

# Determinar archivo del informe de factibilidad en el repo root
$repoRoot = Resolve-Path "$PSScriptRoot\.." | Select-Object -ExpandProperty Path
$reportFileCandidate = Join-Path $repoRoot 'FD01-Informe-Factibilidad.md'
if (Test-Path $reportFileCandidate) {
    $reportFile = $reportFileCandidate
} else {
    $reportFile = Join-Path $PSScriptRoot 'terraform_cost_report.md'
}

$timestamp = Get-Date -Format 'yyyy-MM-dd HH:mm:ss'
$header = "## Estimación de costos (Terraform) - $timestamp" + "`n"
$tableContent = Get-Content $infracostTxt -Raw
$body = "Fuente: Infracost (resultado del plan de Terraform).`n`n```text`n" + $tableContent + "`n```"

Write-Host "Añadiendo estimación al archivo: $reportFile"
Add-Content -Path $reportFile -Value "`n$header`n$body`n"

Pop-Location
Write-Host "Estimación completada. Archivos generados: tfplan.json, $infracostJson, $infracostTxt. Estimación añadida a: $reportFile"
