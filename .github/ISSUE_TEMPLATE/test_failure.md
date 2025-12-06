---
name: 🧪 Reporte de Fallo en Tests
about: Reportar tests que están fallando
title: '[TEST] '
labels: test, bug
assignees: ''
---

## 🧪 Tipo de Test Fallido
- [ ] Test Unitario (JUnit)
- [ ] Test de Integración
- [ ] Test de Mutación (PITest)
- [ ] Test UI (Selenium)
- [ ] Test BDD (Cucumber)
- [ ] Análisis Estático (SonarQube/Semgrep/Snyk)

## 📝 Descripción del Fallo
Una descripción clara de qué test está fallando y por qué.

## 📂 Ubicación del Test
- Archivo: [ej: UsuarioNegocioTest.java]
- Clase: [ej: UsuarioNegocioTest]
- Método: [ej: testValidarLogin()]
- Línea: [si es conocida]

## ❌ Mensaje de Error
```
Pega aquí el mensaje de error completo del test
```

## 🔄 ¿Es Intermitente?
- [ ] Sí, falla aleatoriamente
- [ ] No, siempre falla
- [ ] Solo falla en CI/CD
- [ ] Solo falla localmente

## 🖥️ Entorno donde Falla
**Local:**
- SO: [ej: Windows 11]
- Java: [ej: OpenJDK 11]
- Maven/Gradle: [ej: Maven 3.9.5]

**CI/CD:**
- [ ] GitHub Actions
- [ ] Otro: ___________

## 📊 Información del GitHub Actions
Si el test falla en CI/CD:
- Workflow: [ej: complete-test-suite.yml]
- Job: [ej: unit-tests]
- Run ID: [ej: #123]
- Link: [URL del workflow run]

## 🔍 Contexto Adicional
¿Cuándo empezó a fallar? ¿Después de qué cambio?

## 💡 Posible Causa
Si tienes idea de qué puede estar causando el fallo.

## ✔️ Checklist
- [ ] He verificado que el test falla consistentemente
- [ ] He incluido el mensaje de error completo
- [ ] He proporcionado información del entorno
- [ ] He verificado si es un problema conocido
