# 🔬 GitHub Actions - Suite Completa de Pruebas
## Sistema de Voluntariado UPT

---

## 📋 Descripción General

Este workflow unificado ejecuta **todas las pruebas estáticas y dinámicas** del proyecto en una sola ejecución automatizada:

```
┌─────────────────────────────────────────────────────────────────┐
│                    FLUJO AUTOMATIZADO ÚNICO                      │
│                                                                 │
│  Stage 1: Análisis Estático (Paralelo)                         │
│    ├── SonarQube (Calidad de código + Coverage)                │
│    ├── Semgrep (Seguridad - OWASP Top 10)                      │
│    └── Snyk (Vulnerabilidades en dependencias)                 │
│                           ↓                                     │
│  Stage 2: Pruebas Unitarias                                    │
│    └── JUnit 5 + JaCoCo Coverage (>60%)                        │
│                           ↓                                     │
│  Stage 3: Mutation Testing (PITest)                            │
│    └── Solo si Stage 2 exitoso                                 │
│                           ↓                                     │
│  Stage 4: Pruebas de Integración                               │
│    └── Testcontainers + MySQL 8.0                              │
│                           ↓                                     │
│  Stage 5: Pruebas UI (Paralelo)                                │
│    ├── Selenium + Chrome (headless)                            │
│    └── Selenium + Firefox (headless)                           │
│                           ↓                                     │
│  Stage 6: Pruebas BDD (Paralelo)                               │
│    ├── Cucumber Smoke Tests                                    │
│    └── Cucumber Regression Tests                               │
│                           ↓                                     │
│  Stage 7: Consolidación de Resultados                          │
│    └── Reporte unificado + comentario en PR                    │
│                           ↓                                     │
│  Stage 8: Notificaciones                                       │
│    └── Email + Slack (solo en main)                            │
└─────────────────────────────────────────────────────────────────┘
```

---

## 🎯 Características Principales

### ✅ Análisis Estático (Seguridad + Calidad)

- **SonarQube**: 75+ reglas de calidad de código
- **Semgrep**: Detección de vulnerabilidades OWASP Top 10
- **Snyk**: Escaneo de CVEs en dependencias Maven

### ✅ Pruebas Dinámicas (Funcionalidad)

- **Unit Tests**: 77 tests con JaCoCo coverage
- **Mutation Tests**: PITest con 15 operadores de mutación
- **Integration Tests**: 42 tests con Testcontainers
- **UI Tests**: 45 tests con Selenium (Chrome + Firefox)
- **BDD Tests**: 100 escenarios Cucumber en Gherkin

### ✅ Reportes y Notificaciones

- Comentarios automáticos en Pull Requests
- Upload de artifacts (reportes, screenshots)
- Integración con Codecov
- Notificaciones por Email y Slack
- SARIF upload para GitHub Security

---

## 🚀 Triggers de Ejecución

### 1. Push a Ramas Principales

```yaml
on:
  push:
    branches: [ main, develop ]
```

**Ejemplo:**
```bash
git push origin main
# Ejecuta suite completa automáticamente
```

### 2. Pull Requests

```yaml
on:
  pull_request:
    branches: [ main, develop ]
```

**Ejemplo:**
```bash
# Crear PR desde feature branch
gh pr create --title "Nueva funcionalidad" --base main
# Ejecuta tests y comenta resultados en el PR
```

### 3. Ejecución Programada (Cron)

```yaml
on:
  schedule:
    - cron: '0 2 * * *'  # Todos los días a las 2 AM UTC
```

### 4. Ejecución Manual

```yaml
on:
  workflow_dispatch:
    inputs:
      test_level:
        description: 'Nivel de pruebas'
        type: choice
        options:
          - all              # Suite completa (~35 min)
          - static-only      # Solo análisis estático (~5 min)
          - dynamic-only     # Solo pruebas dinámicas (~30 min)
          - smoke            # Pruebas críticas (~8 min)
          - full-regression  # Regresión completa (~40 min)
```

**Ejemplo desde GitHub UI:**
1. Ir a **Actions** → **Complete Test Suite**
2. Click en **Run workflow**
3. Seleccionar nivel de pruebas
4. Click en **Run workflow**

**Ejemplo con GitHub CLI:**
```bash
# Suite completa
gh workflow run complete-test-suite.yml

# Solo análisis estático
gh workflow run complete-test-suite.yml -f test_level=static-only

# Solo smoke tests
gh workflow run complete-test-suite.yml -f test_level=smoke
```

---

## ⚙️ Configuración de Secrets

### Secrets Requeridos

Configurar en: **Settings → Secrets and variables → Actions → New repository secret**

| Secret | Descripción | Ejemplo |
|--------|-------------|---------|
| `SONAR_TOKEN` | Token de autenticación SonarQube | `squ_abc123...` |
| `SONAR_HOST_URL` | URL del servidor SonarQube | `https://sonarcloud.io` |
| `SNYK_TOKEN` | Token API de Snyk | `abc-123-def-456` |
| `CODECOV_TOKEN` | Token de Codecov para coverage | `abc123def456` |
| `EMAIL_USERNAME` | Email para notificaciones | `github-actions@upt.edu.pe` |
| `EMAIL_PASSWORD` | Password del email (app password) | `xxxx yyyy zzzz wwww` |
| `SLACK_WEBHOOK_URL` | Webhook de Slack | `https://hooks.slack.com/...` |

### Secrets Opcionales

| Secret | Descripción | Uso |
|--------|-------------|-----|
| `GITHUB_TOKEN` | Token automático de GitHub | Ya disponible por defecto |

### Cómo Obtener Tokens

#### 1. SonarQube Token

```bash
# En SonarCloud.io:
1. Login → My Account → Security
2. Generate Tokens
3. Name: "GitHub Actions"
4. Type: Project Analysis Token
5. Copiar token generado
```

#### 2. Snyk Token

```bash
# En Snyk.io:
1. Login → Account Settings
2. API Token → Show
3. Copiar token
```

#### 3. Codecov Token

```bash
# En Codecov.io:
1. Login → Select Repository
2. Settings → General
3. Copiar token de la sección "Repository Upload Token"
```

#### 4. Slack Webhook

```bash
# En Slack:
1. Ir a api.slack.com/apps
2. Create New App → From scratch
3. Incoming Webhooks → Activate
4. Add New Webhook to Workspace
5. Copiar Webhook URL
```

---

## 📊 Interpretación de Resultados

### Resultado EXITOSO ✅

```
✅ All critical tests passed!

Static Analysis: ✅ (SonarQube, Semgrep, Snyk)
Unit Tests: ✅ (Coverage 66.8%)
Integration Tests: ✅ (42 tests passed)
```

**Significado:** Código listo para merge/deploy

### Resultado CON WARNINGS ⚠️

```
⚠️ Some non-critical tests failed

Static Analysis: ✅
Unit Tests: ✅
Integration Tests: ✅
Mutation Tests: ❌ (Mutation score: 58% < 60%)
UI Tests: ⚠️ (2 tests flaky)
```

**Significado:** Pruebas críticas OK, pero hay mejoras recomendadas

### Resultado FALLIDO ❌

```
❌ Critical tests failed!

Static Analysis: ❌ (12 security issues)
Unit Tests: ❌ (5 tests failed)
```

**Significado:** NO mergear, arreglar tests críticos primero

---

## 📁 Artifacts Generados

Los reportes se guardan como artifacts en GitHub Actions:

| Artifact | Contenido | Retención |
|----------|-----------|-----------|
| `static-analysis-sonarqube` | Reporte de SonarQube | 30 días |
| `static-analysis-semgrep` | SARIF de Semgrep | 30 días |
| `static-analysis-snyk` | SARIF de Snyk | 30 días |
| `unit-test-results` | Reportes JUnit + JaCoCo | 30 días |
| `mutation-test-results` | Reportes PITest | 30 días |
| `integration-test-results` | Reportes Failsafe | 30 días |
| `ui-test-results-chrome` | Reportes Selenium Chrome | 30 días |
| `ui-test-results-firefox` | Reportes Selenium Firefox | 30 días |
| `ui-test-screenshots-chrome` | Screenshots (solo en failure) | 7 días |
| `bdd-test-results-smoke` | Reportes Cucumber smoke | 30 días |
| `bdd-test-results-regression` | Reportes Cucumber regression | 30 días |
| `consolidated-test-report` | Reporte consolidado final | 90 días |

### Descargar Artifacts

**Desde GitHub UI:**
1. Ir a **Actions** → Seleccionar workflow run
2. Scroll down a **Artifacts**
3. Click en artifact para descargar

**Desde GitHub CLI:**
```bash
# Listar artifacts del último run
gh run list --workflow=complete-test-suite.yml --limit 1

# Descargar todos los artifacts
gh run download <RUN_ID>

# Descargar artifact específico
gh run download <RUN_ID> -n consolidated-test-report
```

---

## 🔍 Monitoreo y Debugging

### Ver Logs en Tiempo Real

```bash
# Ver logs del último run
gh run view --log

# Ver logs de un job específico
gh run view <RUN_ID> --log --job=unit-tests
```

### Debugging de Fallas

#### 1. Static Analysis Failed

```bash
# Ver detalles en SonarQube
1. Abrir link en el comentario del PR
2. Revisar "Issues" por severidad
3. Filtrar por "New Code" para ver solo cambios recientes
```

#### 2. Unit Tests Failed

```bash
# Descargar reporte
gh run download <RUN_ID> -n unit-test-results

# Ver reporte local
cd unit-test-results/surefire-reports
cat TEST-*.xml | grep -A 10 "FAILURE"
```

#### 3. UI Tests Failed (Screenshots disponibles)

```bash
# Descargar screenshots
gh run download <RUN_ID> -n ui-test-screenshots-chrome

# Ver screenshots
open screenshots/*.png
```

### Re-ejecutar Jobs Fallidos

```bash
# Re-ejecutar solo jobs fallidos
gh run rerun <RUN_ID> --failed

# Re-ejecutar workflow completo
gh run rerun <RUN_ID>
```

---

## ⏱️ Tiempos de Ejecución Estimados

| Nivel | Stages Ejecutados | Tiempo | Uso |
|-------|------------------|--------|-----|
| **smoke** | Static + Unit + Integration (smoke) | ~8 min | Desarrollo diario |
| **static-only** | Solo Stage 1 | ~5 min | Pre-commit checks |
| **dynamic-only** | Stages 2-6 | ~30 min | Validar funcionalidad |
| **all** | Stages 1-8 completos | ~35 min | Pull Requests |
| **full-regression** | All + mutation + UI full | ~45 min | Pre-release |

**Optimizaciones Aplicadas:**
- ✅ Paralelización de análisis estático (3 herramientas en paralelo)
- ✅ Paralelización de UI tests (Chrome + Firefox en paralelo)
- ✅ Paralelización de BDD tests (Smoke + Regression en paralelo)
- ✅ Cache de Maven dependencies
- ✅ Conditional execution (skip stages según input)

---

## 🎨 Comentarios en Pull Requests

El workflow genera automáticamente comentarios en PRs con resultados:

```markdown
# 🔬 Consolidated Test Results

**Workflow Run:** #123
**Branch:** feature/nueva-funcionalidad
**Commit:** abc1234
**Triggered by:** desarrollador
**Timestamp:** 2025-12-03 14:30:00 UTC

## 📋 Test Suite Summary

| Stage | Status | Details |
|-------|--------|---------|
| 🔍 Static Analysis | ✅ success | SonarQube, Semgrep, Snyk |
| 🧪 Unit Tests | ✅ success | JUnit + JaCoCo Coverage |
| 🧬 Mutation Tests | ✅ success | PITest |
| 🔗 Integration Tests | ✅ success | Testcontainers + MySQL |
| 🖥️ UI Tests | ✅ success | Selenium (Chrome + Firefox) |
| 🥒 BDD Tests | ✅ success | Cucumber + Gherkin |

## 📈 Coverage Metrics

- **Unit Test Coverage:** 66.8%
- **Mutation Score:** 63%
- **Integration Coverage:** 82.3%

## 🔗 Detailed Reports

- [View All Artifacts](https://github.com/UPT-FAING-EPIS/voluntariado-upt/actions/runs/123)
- [SonarQube Dashboard](https://sonarcloud.io/dashboard?id=voluntariado-upt)
- [Codecov Report](https://codecov.io/gh/UPT-FAING-EPIS/voluntariado-upt)
```

---

## 📧 Notificaciones

### Email (Solo en Main Branch)

**Se envía cuando:**
- ❌ Algún test crítico falla en `main`
- ✅ Suite completa exitosa después de una falla previa

**Destinatarios:**
- `qa-team@upt.edu.pe`

**Contenido:**
```
Subject: ❌ Test Suite Failed - voluntariado-upt

Test suite failed for commit abc1234

Branch: main
Workflow: Complete Test Suite
Run: https://github.com/UPT-FAING-EPIS/voluntariado-upt/actions/runs/123

Static Analysis: ✅
Unit Tests: ❌ 5 failures
Integration Tests: ⚠️ 2 flaky tests
```

### Slack (Solo en Main Branch)

**Canal:** `#qa-alerts` (configurar webhook)

**Mensaje:**
```
🔬 Test Suite Complete
Status: ❌ failure
Branch: main
Commit: abc1234

[View Results] → https://github.com/.../actions/runs/123
```

---

## 🔄 Integración con Branch Protection

Configurar en: **Settings → Branches → Branch protection rules**

### Recomendación para `main`:

```yaml
Require status checks to pass before merging: ✅
  Status checks that are required:
    - static-analysis
    - unit-tests
    - integration-tests
    
Require branches to be up to date before merging: ✅
Require linear history: ✅ (opcional)
Require deployments to succeed before merging: ❌
```

### Recomendación para `develop`:

```yaml
Require status checks to pass before merging: ✅
  Status checks that are required:
    - unit-tests
    
Require branches to be up to date before merging: ⚠️ (recomendado pero no obligatorio)
```

---

## 🛠️ Troubleshooting

### Problema 1: Timeout en UI Tests

**Síntoma:**
```
Error: The operation was canceled.
Timeout after 60 minutes
```

**Solución:**
```yaml
# En el job ui-tests, agregar:
timeout-minutes: 90
```

### Problema 2: MySQL Service No Responde

**Síntoma:**
```
ERROR: Connection refused to MySQL
```

**Solución:**
```yaml
# Verificar health check en services:
options: >-
  --health-cmd="mysqladmin ping"
  --health-interval=10s
  --health-timeout=5s
  --health-retries=5  # Aumentar reintentos
```

### Problema 3: Out of Memory en Maven

**Síntoma:**
```
java.lang.OutOfMemoryError: Java heap space
```

**Solución:**
```yaml
env:
  MAVEN_OPTS: -Xmx3072m  # Aumentar de 2GB a 3GB
```

### Problema 4: Artifacts No Se Generan

**Síntoma:**
```
Warning: No files were found with the provided path
```

**Solución:**
```yaml
# Verificar que el path sea correcto
- uses: actions/upload-artifact@v4
  with:
    path: proyecto/target/surefire-reports/  # Path correcto
    if-no-files-found: warn  # Cambiar a 'error' para debugging
```

---

## 📚 Referencias

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Maven Surefire Plugin](https://maven.apache.org/surefire/maven-surefire-plugin/)
- [SonarQube Scanner for Maven](https://docs.sonarqube.org/latest/analysis/scan/sonarscanner-for-maven/)
- [Semgrep Rules](https://semgrep.dev/explore)
- [Snyk GitHub Actions](https://github.com/snyk/actions)
- [Selenium Documentation](https://www.selenium.dev/documentation/)
- [Cucumber Documentation](https://cucumber.io/docs/cucumber/)

---

## 📞 Soporte

**Equipo QA UPT:**
- Email: qa-team@upt.edu.pe
- Slack: `#qa-support`
- Issues: [GitHub Issues](https://github.com/UPT-FAING-EPIS/voluntariado-upt/issues)

---

**Última actualización:** 3 de Diciembre de 2025  
**Versión del Workflow:** 1.0.0
