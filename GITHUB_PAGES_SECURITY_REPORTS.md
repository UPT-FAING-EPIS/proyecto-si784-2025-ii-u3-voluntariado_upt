# 📊 GitHub Pages - Reportes de Seguridad

Este documento describe el sistema automatizado de **publicación de reportes de seguridad** en **GitHub Pages** para el proyecto Sistema de Voluntariado UPT.

---

## 🎯 Objetivo

Publicar automáticamente los reportes de análisis de seguridad generados por **Semgrep** y **Snyk** en un sitio web accesible públicamente mediante GitHub Pages, facilitando la revisión y seguimiento de issues de seguridad.

---

## 🏗️ Arquitectura del Sistema

```
┌─────────────────────────────────────────────────────────────────┐
│                    GitHub Actions Workflow                       │
│                  (security-reports-gh-pages.yml)                 │
└─────────────────────────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────────┐
        │  Triggers (3 formas de activación)          │
        ├─────────────────────────────────────────────┤
        │  1. workflow_run: Después de Complete Test  │
        │  2. workflow_dispatch: Ejecución manual     │
        │  3. schedule: Lunes 3 AM (escaneo semanal)  │
        └─────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────────┐
        │         Análisis de Seguridad               │
        ├─────────────────────────────────────────────┤
        │  • Semgrep (OWASP, SQL Injection, XSS)      │
        │  • Snyk Code (vulnerabilidades en código)   │
        │  • Snyk Open Source (CVEs en dependencias)  │
        └─────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────────┐
        │      Generación de Reportes HTML            │
        ├─────────────────────────────────────────────┤
        │  • convert-sarif-to-html.py (Semgrep/Snyk)  │
        │  • convert-snyk-json-to-html.py (Deps)      │
        │  • Dashboard index.html principal           │
        └─────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────────┐
        │     Estructura de Directorios               │
        ├─────────────────────────────────────────────┤
        │  reports/                                   │
        │  ├── index.html (Dashboard principal)       │
        │  ├── .nojekyll (Bypass Jekyll)              │
        │  ├── semgrep/                               │
        │  │   ├── index.html                         │
        │  │   ├── semgrep-results.sarif              │
        │  │   └── semgrep-results.json               │
        │  ├── snyk/                                  │
        │  │   ├── code.html                          │
        │  │   ├── dependencies.html                  │
        │  │   ├── snyk-code-results.sarif            │
        │  │   └── snyk-test-results.json             │
        │  └── pitest/                                │
        │      ├── index.html                         │
        │      └── (reportes HTML de mutación)        │
        └─────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────────┐
        │    Deploy to GitHub Pages                   │
        ├─────────────────────────────────────────────┤
        │  • peaceiris/actions-gh-pages@v3            │
        │  • Branch: gh-pages                         │
        │  • Force orphan commit                      │
        └─────────────────────────────────────────────┘
                              ↓
        ┌─────────────────────────────────────────────┐
        │         Sitio Web Publicado                 │
        ├─────────────────────────────────────────────┤
        │  🌐 https://upt-faing-epis.github.io/       │
        │     proyecto-si784-2025-ii-u3-              │
        │     voluntariado_upt/                       │
        └─────────────────────────────────────────────┘
```

---

## ✨ Características Principales

### 1. **Dashboard Interactivo**
- Página principal responsive con diseño moderno
- Cards para cada tipo de reporte (Semgrep, Snyk Code, Snyk Dependencies)
- Gradientes visuales y animaciones CSS
- Información sobre actualización automática

### 2. **Reportes HTML Detallados**
- **Semgrep Report**: Issues de seguridad con location, línea, snippet de código
- **Snyk Code Report**: Vulnerabilidades en código con severidad y descripción
- **Snyk Dependencies Report**: CVEs en dependencias con package info
- **PITest Report**: Reportes de mutation testing con mutation score, mutantes generados y eliminados

### 3. **Múltiples Formatos de Salida**
- **HTML**: Visualización en navegador con estilos profesionales
- **SARIF**: Formato estándar para integración con herramientas (Semgrep, Snyk)
- **JSON**: Datos estructurados para procesamiento programático
- **XML**: Reportes de PITest en formato XML para integración con CI/CD

### 4. **Actualización Automática**
- **Después de CI/CD**: Se ejecuta automáticamente cuando el workflow "Complete Test Suite" termina
- **Programado**: Escaneo semanal cada lunes a las 3 AM UTC
- **Manual**: Ejecutable desde GitHub Actions tab

### 5. **Código de Colores por Severidad**
- 🔴 **Critical/Error**: Rojo (#dc3545, #8b0000)
- 🟡 **Warning/High**: Amarillo (#ffc107)
- 🔵 **Note/Medium**: Azul (#17a2b8)
- ⚪ **Low**: Gris claro

---

## 🚀 Activación del Sistema

### Prerequisito: Habilitar GitHub Pages

**Antes de ejecutar el workflow**, debes habilitar GitHub Pages en el repositorio:

1. Ve a **Settings** → **Pages** en tu repositorio
2. En **Source**, selecciona:
   - Branch: `gh-pages`
   - Folder: `/ (root)`
3. Click en **Save**
4. Espera a que se active (aparecerá un mensaje con la URL)

### Forma 1: Automático (Recomendado)

El workflow se ejecuta automáticamente después de que el workflow "Complete Test Suite" termine exitosamente:

```yaml
on:
  workflow_run:
    workflows: ["Complete Test Suite"]
    types:
      - completed
    branches:
      - main
```

**No requiere acción manual**. Cada push a `main` que ejecute tests también actualizará los reportes.

### Forma 2: Manual

Ejecutar manualmente desde GitHub:

```bash
# Usando GitHub CLI
gh workflow run security-reports-gh-pages.yml

# O desde la interfaz web:
# 1. Ir a Actions tab
# 2. Seleccionar "Security Reports to GitHub Pages"
# 3. Click en "Run workflow" → Run workflow
```

### Forma 3: Programado

Ejecución automática semanal:

```yaml
schedule:
  - cron: '0 3 * * 1'  # Cada lunes a las 3 AM UTC
```

Esto mantiene los reportes actualizados sin intervención manual.

---

## 📍 URLs de Acceso

Una vez desplegado, los reportes están disponibles en:

### Dashboard Principal
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/
```

### Reportes Individuales

**Semgrep Analysis:**
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/semgrep/
```

**Snyk Code Analysis:**
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/snyk/code.html
```

**Snyk Dependencies:**
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/snyk/dependencies.html
```

**PITest Mutation Testing:**
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/pitest/
```

### Archivos SARIF/JSON

**Semgrep SARIF:**
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/semgrep/semgrep-results.sarif
```

**Snyk Code SARIF:**
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/snyk/snyk-code-results.sarif
```

**Snyk Dependencies JSON:**
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/snyk/snyk-test-results.json
```

---

## 🔧 Configuración de Secrets

El workflow requiere los siguientes secrets configurados en GitHub:

| Secret | Descripción | Cómo obtenerlo |
|--------|-------------|----------------|
| `SNYK_TOKEN` | Token de autenticación de Snyk | [snyk.io](https://app.snyk.io/account) → Settings → API Token |
| `GITHUB_TOKEN` | Token automático de GitHub Actions | Proporcionado automáticamente por GitHub |

### Configurar Snyk Token:

1. Crear cuenta en [snyk.io](https://snyk.io/)
2. Ir a **Account Settings** → **API Token**
3. Click en **Show** → Copiar token
4. En GitHub: **Settings** → **Secrets and variables** → **Actions**
5. Click **New repository secret**
6. Name: `SNYK_TOKEN`, Value: [tu token]
7. Click **Add secret**

---

## 📊 Estructura de los Reportes HTML

### Dashboard Principal (`index.html`)

```html
┌────────────────────────────────────────────┐
│  🔒 Security Reports Dashboard             │
│  Sistema de Voluntariado UPT               │
│  [Badge: Auto] [Badge: Weekly Scan]        │
└────────────────────────────────────────────┘
│                                            │
│  ┌──────────┐  ┌──────────┐  ┌──────────┐│
│  │ Semgrep  │  │ Snyk Code│  │Snyk Deps ││
│  │ 🔍       │  │ 🛡️       │  │ 📦       ││
│  │ [Ver]    │  │ [Ver]    │  │ [Ver]    ││
│  │ [SARIF]  │  │ [SARIF]  │  │ [JSON]   ││
│  └──────────┘  └──────────┘  └──────────┘│
│                                            │
│  ℹ️ Acerca de estos reportes               │
│  • Generación automática                  │
│  • Herramientas utilizadas                │
│  • Repositorio                            │
└────────────────────────────────────────────┘
```

### Reporte Individual (Semgrep/Snyk)

```html
┌────────────────────────────────────────────┐
│  🔒 Semgrep Security Report                │
│  Generado: 2025-12-03 15:30:45 UTC         │
└────────────────────────────────────────────┘
│                                            │
│  ┌────────┐ ┌────────┐ ┌────────┐ ┌────────┐│
│  │   5    │ │   12   │ │   8    │ │   25   ││
│  │ Errors │ │Warnings│ │ Notes  │ │ Total  ││
│  └────────┘ └────────┘ └────────┘ └────────┘│
│                                            │
│  [← Volver al Dashboard]                   │
│                                            │
│  ┌──────────────────────────────────────┐ │
│  │ #1: sql-injection.java-sqli          │ │
│  │ [ERROR] ───────────────────────────  │ │
│  │ Potential SQL injection vulnerability│ │
│  │ 📁 src/servlet/UsuarioServlet.java   │ │
│  │ 📍 Línea 45                          │ │
│  │ ┌─────────────────────────────────┐  │ │
│  │ │ String query = "SELECT * FROM"   │  │ │
│  │ └─────────────────────────────────┘  │ │
│  └──────────────────────────────────────┘ │
│                                            │
│  [... más issues ...]                      │
└────────────────────────────────────────────┘
```

---

## 🎨 Personalización del Dashboard

### Modificar Colores del Gradiente

Editar en el workflow, sección "Create Reports Dashboard":

```css
body {
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
}
```

Cambiar `#667eea` (azul) y `#764ba2` (morado) por tus colores preferidos.

### Agregar Logo de la Universidad

En el dashboard HTML, agregar en `.header`:

```html
<div class="header">
    <img src="logo-upt.png" alt="UPT Logo" style="width: 150px; margin-bottom: 20px;">
    <h1>🔒 Security Reports Dashboard</h1>
    ...
</div>
```

Luego subir `logo-upt.png` al directorio `reports/`.

### Cambiar Iconos de Cards

Reemplazar emojis en las cards:

```html
<div class="card-icon">🔍</div>  <!-- Semgrep -->
<div class="card-icon">🛡️</div>  <!-- Snyk Code -->
<div class="card-icon">📦</div>  <!-- Snyk Deps -->
```

---

## 📈 Interpretación de Resultados

### Semgrep Report

| Severidad | Significado | Acción Recomendada |
|-----------|-------------|-------------------|
| **ERROR** | Vulnerabilidad crítica detectada | Corregir inmediatamente antes de merge |
| **WARNING** | Problema de seguridad potencial | Revisar y corregir si aplica |
| **NOTE** | Sugerencia de mejora | Considerar para refactoring |

### Snyk Code Report

| Severidad | Significado | Prioridad |
|-----------|-------------|-----------|
| **CRITICAL** | Exploit activo conocido | 🔴 Alta - Fix inmediato |
| **HIGH** | Vulnerabilidad seria | 🟠 Alta - Fix en sprint |
| **MEDIUM** | Riesgo moderado | 🟡 Media - Planificar fix |
| **LOW** | Riesgo menor | 🟢 Baja - Backlog |

### Snyk Dependencies Report

**CVE (Common Vulnerabilities and Exposures)**:
- Cada vulnerabilidad tiene un ID CVE único
- Link a base de datos nacional de vulnerabilidades (NVD)
- Información sobre parches disponibles

**Ejemplo de issue**:
```
📦 Package: org.apache.struts:struts2-core@2.3.24
🔖 CVE: CVE-2017-5638
🔴 Severity: CRITICAL
⚡ CVSS Score: 10.0

Descripción: Remote Code Execution via Content-Type header
Fix: Actualizar a versión 2.3.32 o superior
```

---

## 🔄 Flujo de Actualización

### Ciclo Completo de Actualización

```
1. Developer hace push a main
        ↓
2. Se ejecuta "Complete Test Suite"
        ↓
3. Al completar, trigger workflow_run
        ↓
4. "Security Reports to GitHub Pages" inicia
        ↓
5. Ejecuta Semgrep + Snyk análisis
        ↓
6. Genera reportes HTML desde SARIF/JSON
        ↓
7. Crea dashboard index.html
        ↓
8. Deploy a gh-pages branch
        ↓
9. GitHub Pages actualiza sitio automáticamente
        ↓
10. Reportes disponibles en URL pública (~2 min)
```

### Tiempo de Propagación

- **Workflow execution**: 5-8 minutos
- **GitHub Pages deploy**: 1-2 minutos
- **Total desde push**: ~10 minutos máximo

---

## 🛠️ Troubleshooting

### Problema 1: Sitio no se actualiza

**Síntoma**: Los reportes no cambian después de ejecutar el workflow.

**Solución**:
```bash
# Verificar que el workflow terminó exitosamente
gh run list --workflow=security-reports-gh-pages.yml

# Ver logs del último run
gh run view --log

# Force refresh en navegador (Ctrl+Shift+R o Cmd+Shift+R)
```

### Problema 2: Error "SNYK_TOKEN not found"

**Síntoma**: Workflow falla en el step de Snyk Analysis.

**Solución**:
1. Verificar que `SNYK_TOKEN` está configurado:
   - Settings → Secrets and variables → Actions
2. Token debe empezar con formato UUID
3. Re-generar token si es necesario en [snyk.io](https://app.snyk.io/account)

### Problema 3: SARIF file empty o no se genera HTML

**Síntoma**: Reportes HTML vacíos o error en conversión.

**Solución**:
```bash
# Verificar que los análisis generaron archivos
- name: Debug SARIF files
  run: |
    ls -la *.sarif *.json
    cat semgrep-results.sarif | head -50

# Verificar formato SARIF válido
npm install -g @microsoft/sarif-multitool
sarif-multitool validate semgrep-results.sarif
```

### Problema 4: 404 en GitHub Pages

**Síntoma**: `https://upt-faing-epis.github.io/...` devuelve 404.

**Solución**:
1. Verificar que GitHub Pages está habilitado:
   - Settings → Pages → Source debe ser `gh-pages` branch
2. Verificar que existe branch `gh-pages`:
   ```bash
   git fetch origin gh-pages
   git checkout gh-pages
   ls -la
   ```
3. Esperar 2-3 minutos para propagación DNS

### Problema 5: CSS no se aplica (estilos sin efecto)

**Síntoma**: HTML se muestra pero sin estilos (texto plano).

**Solución**:
1. Verificar que existe archivo `.nojekyll` en `reports/`:
   ```bash
   git checkout gh-pages
   ls -la .nojekyll
   ```
2. Si no existe, agregarlo manualmente:
   ```bash
   git checkout gh-pages
   touch .nojekyll
   git add .nojekyll
   git commit -m "Add .nojekyll"
   git push origin gh-pages
   ```

---

## 📦 Descarga de Reportes

### Desde GitHub UI

1. Ir a **Actions** tab
2. Click en el run de "Security Reports to GitHub Pages"
3. Scroll down a **Artifacts**
4. Download `security-reports-html.zip` (retention: 90 días)

### Desde GitHub CLI

```bash
# Listar artifacts del último run
gh run list --workflow=security-reports-gh-pages.yml --limit 1

# Descargar artifact
gh run download <RUN_ID> -n security-reports-html

# Descargar del último run automáticamente
gh run download $(gh run list --workflow=security-reports-gh-pages.yml --limit 1 --json databaseId -q '.[0].databaseId') -n security-reports-html
```

### Desde URL directa

```bash
# Descargar SARIF/JSON directamente desde GitHub Pages
curl -O https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/semgrep/semgrep-results.sarif

curl -O https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/snyk/snyk-test-results.json
```

---

## 🔐 Seguridad y Privacidad

### ⚠️ Consideraciones Importantes

**Los reportes publicados en GitHub Pages son PÚBLICOS**. Esto significa:

1. ✅ **Adecuado para**:
   - Proyectos open source
   - Repositorios públicos educativos
   - Mostrar calidad de código a comunidad

2. ❌ **NO adecuado para**:
   - Proyectos con código propietario
   - Información sensible de seguridad no parchada
   - Datos de clientes o credenciales

### Alternativas para Proyectos Privados

Si necesitas reportes privados:

1. **GitHub Actions Artifacts** (Recomendado):
   - Solo accesibles para colaboradores del repo
   - Retention configurable (1-90 días)
   - Descargables con autenticación

2. **Branch privado protegido**:
   ```yaml
   - name: Deploy to protected branch
     run: |
       git checkout -b security-reports
       cp -r reports/* .
       git add .
       git commit -m "Update security reports"
       git push origin security-reports
   ```
   - Configurar branch protection rules
   - Solo accesible para usuarios autorizados

3. **External storage con autenticación**:
   - AWS S3 con CloudFront + Basic Auth
   - Azure Blob Storage con SAS tokens
   - Google Cloud Storage con IAM

---

## 📊 Integración con Otras Herramientas

### SonarQube Integration

Para agregar reportes de SonarQube al dashboard:

1. Exportar SonarQube issues como JSON
2. Crear script de conversión similar a SARIF
3. Agregar card en dashboard:

```html
<div class="card">
    <div class="card-icon">📊</div>
    <div class="card-title">SonarQube Analysis</div>
    <div class="card-links">
        <a href="sonarqube/index.html" class="card-link">Ver Reporte</a>
    </div>
</div>
```

### Codecov Integration

Agregar badge de cobertura en dashboard:

```html
<img src="https://codecov.io/gh/UPT-FAING-EPIS/proyecto-si784-2025-ii-u3-voluntariado_upt/branch/main/graph/badge.svg" 
     alt="Codecov Coverage">
```

---

## 📚 Recursos Adicionales

### Documentación Oficial

- **Semgrep**: [https://semgrep.dev/docs/](https://semgrep.dev/docs/)
- **Snyk**: [https://docs.snyk.io/](https://docs.snyk.io/)
- **GitHub Pages**: [https://docs.github.com/en/pages](https://docs.github.com/en/pages)
- **SARIF Specification**: [https://sarifweb.azurewebsites.net/](https://sarifweb.azurewebsites.net/)

### Rulesets Recomendados

**Semgrep**:
- `p/owasp-top-ten`: OWASP Top 10 vulnerabilities
- `p/security-audit`: Comprehensive security audit
- `p/sql-injection`: SQL injection patterns
- `p/xss`: Cross-Site Scripting detection
- `p/insecure-transport`: Insecure data transmission

**Snyk**:
- Severity threshold: `low` (catch everything)
- Monitor mode: Track vulnerabilities over time
- Auto PR creation: Automatic fix PRs

---

## 🎓 Mejores Prácticas

### 1. Revisar Reportes Regularmente

- **Diariamente**: Revisar errores críticos en dashboard
- **Semanalmente**: Analizar tendencias y patrones
- **Antes de merge**: Verificar que no hay nuevas vulnerabilidades

### 2. Configurar Alertas

Agregar paso de notificación en workflow:

```yaml
- name: Notify on critical issues
  if: steps.semgrep.outputs.critical_count > 0
  uses: slackapi/slack-github-action@v1
  with:
    webhook-url: ${{ secrets.SLACK_WEBHOOK_URL }}
    payload: |
      {
        "text": "🚨 Critical security issues found! Check: https://upt-faing-epis.github.io/..."
      }
```

### 3. Documentar Falsos Positivos

Si un issue es falso positivo, documentarlo:

```yaml
# En semgrep, agregar a .semgrepignore:
# nosemgrep: sql-injection
db.query("SELECT * FROM users WHERE id = ?", [userId])
```

### 4. Actualizar Dependencias Proactivamente

Usar reportes de Snyk Dependencies para:
- Priorizar actualizaciones de seguridad
- Planificar sprints de mantenimiento
- Evitar deuda técnica de seguridad

---

## 🏆 Métricas de Éxito

### Indicadores Clave (KPIs)

| Métrica | Objetivo | Frecuencia |
|---------|----------|------------|
| Critical issues | 0 | Diario |
| High severity issues | < 5 | Semanal |
| Time to fix critical | < 24h | Por issue |
| Dependency updates | < 30 días desactualizadas | Mensual |
| Report views | Trackear con Google Analytics | Mensual |

### Dashboard de Métricas

Para agregar gráficos de tendencias, integrar con:
- **GitHub Insights**: Issues over time
- **Custom JSON API**: Parsear SARIF history
- **Chart.js**: Visualizaciones en dashboard

---

## 🆘 Soporte

### Contacto

- **Curso**: Calidad y Pruebas de Software
- **Universidad**: Universidad Privada de Tacna - FAING EPIS
- **Repositorio**: [UPT-FAING-EPIS/proyecto-si784-2025-ii-u3-voluntariado_upt](https://github.com/UPT-FAING-EPIS/proyecto-si784-2025-ii-u3-voluntariado_upt)

### Reportar Problemas

Para reportar bugs en este sistema:

```bash
# Crear issue en GitHub
gh issue create \
  --title "GitHub Pages: [descripción del problema]" \
  --body "Descripción detallada, logs, screenshots"
```

---

## 📝 Changelog

### v1.0.0 (2025-12-03)
- ✨ Sistema inicial de publicación automática
- ✨ Dashboard interactivo con diseño responsive
- ✨ Conversión SARIF/JSON a HTML
- ✨ Integración con Semgrep y Snyk
- ✨ Múltiples triggers (workflow_run, schedule, manual)
- ✨ Artifacts con retention de 90 días

---

## 🔮 Roadmap Futuro

### Próximas Funcionalidades

- [ ] **Gráficos de tendencias**: Issues over time con Chart.js
- [ ] **Comparación de branches**: Main vs develop
- [ ] **Filtros interactivos**: Por severidad, archivo, tipo
- [ ] **Exportación a PDF**: Reportes ejecutivos
- [ ] **Integración con JIRA**: Crear tickets automáticamente
- [ ] **Dark mode**: Tema oscuro para dashboard
- [ ] **Multi-idioma**: Soporte para inglés/español

---

## ✅ Checklist de Implementación

Para implementar este sistema en tu proyecto:

- [ ] Configurar secret `SNYK_TOKEN` en GitHub
- [ ] Habilitar GitHub Pages (Settings → Pages → gh-pages branch)
- [ ] Crear workflow `.github/workflows/security-reports-gh-pages.yml`
- [ ] Ejecutar workflow manualmente la primera vez
- [ ] Verificar que sitio está accesible en URL de GitHub Pages
- [ ] Agregar badge al README con link al dashboard
- [ ] Configurar alertas de Slack (opcional)
- [ ] Documentar proceso para el equipo
- [ ] Agregar revisión de reportes a Definition of Done
- [ ] Establecer política de no-merge con critical issues

---

**¡Sistema listo para producción!** 🚀

Una vez ejecutado el workflow, los reportes estarán disponibles en:
```
https://upt-faing-epis.github.io/proyecto-si784-2025-ii-u3-voluntariado_upt/
```
