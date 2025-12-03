Instrucciones rápidas para usar Terraform en este directorio

Requisitos previos
- Tener instalado terraform (v1.x o superior).
- Tener credenciales válidas de GCP para el proyecto deseado (service account con permisos necesarios o ADC).

Autenticación recomendada (elige una):
1) GOOGLE_CREDENTIALS (recomendado para CI):
   - Exporta la variable de entorno con el JSON de la llave del service account:
     - PowerShell (Windows):
       $env:GOOGLE_CREDENTIALS = Get-Content C:\path\to\key.json -Raw
     - Linux/macOS:
       export GOOGLE_CREDENTIALS="$(cat /path/to/key.json)"

2) Application Default Credentials (local dev):
   gcloud auth application-default login

3) Archivo de credenciales (menos recomendado):
   - No guardes la llave en el repo. Si la usas, pasa la ruta con la variable `credentials_file` y ajusta el provider.

Pasos básicos (PowerShell):

# inicializar el directorio de Terraform
terraform init

# validar la configuración
terraform validate

# ver un plan (se pedirá autenticación si no está configurada)
terraform plan -var "project_id=TU_PROJECT_ID"

# aplicar (revisar el plan antes de aplicar)
terraform apply -var "project_id=TU_PROJECT_ID"

Notas
- El archivo `variables.tf` contiene las variables necesarias: `project_id`, `region`, `firestore_location`.
- No se incluyeron credenciales en el repo. Configura autenticación como se indica arriba.
- Si quieres usar un backend remoto (ej. GCS) para el estado, puedo agregar un `backend.tf` con la configuración requerida.

Estimación de costos con Infracost
---------------------------------

Este proyecto incluye un helper para generar una estimación de costos a partir del plan de Terraform usando Infracost.

Requisitos:
- Tener `terraform` y `infracost` instalados y en el PATH.
- Configurar la variable de entorno `INFRACOST_API_KEY` (Infracost requiere una API key para obtener precios actualizados). Puedes obtener una clave en la página de Infracost.

Comandos rápidos (PowerShell):

1) Desde la carpeta `terraform` ejecuta:

```powershell
./cost_estimate.ps1
```

Esto hará:
- `terraform init`
- `terraform plan -out=tfplan`
- `terraform show -json tfplan > tfplan.json`
- `infracost breakdown --path=tfplan.json` para generar `infracost.json` y `infracost.txt`.
- Añadirá la tabla de Infracost al final del archivo `FD01-Informe-Factibilidad.md` en la raíz del repo (si existe). Si el archivo no existe, se creará `terraform/terraform_cost_report.md`.

2) Si prefieres ejecutar los pasos manualmente:

```powershell
terraform init
terraform plan -out=tfplan
terraform show -json tfplan > tfplan.json
infracost breakdown --path=tfplan.json --format table --no-color > infracost.txt
```

Notas:
- No se guardan claves ni secretos en el repositorio.
- Para uso en CI/CD puedo añadir un workflow (GitHub Actions/GitLab CI) que ejecute Infracost y guarde el resultado como artefacto o lo comente en los PRs.
