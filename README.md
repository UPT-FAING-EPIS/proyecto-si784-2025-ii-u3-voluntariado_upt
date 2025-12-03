# 🏫 UNIVERSIDAD PRIVADA DE TACNA  
### FACULTAD DE INGENIERÍA  
### Escuela Profesional de Ingeniería de Sistemas  

---

## 🧩 Proyecto: *Implementación de Sistema de Voluntariado UPT*  
**Curso:** Calidad y Pruebas de Software  
**Docente:** Ing. Mag. Patrick Jose Cuadros Quiroga  

**Integrantes:**  
- Víctor Williams Cruz Mamani — (2022073903)  
- Diego Fernando Castillo Mamani — (2022073895)  
- Joan Cristian Medina Quispe — (2022073903)  

**Tacna – Perú, 2025**

---

## 📘 Descripción del Proyecto
El sistema **Voluntariado-UPT** fue desarrollado con el propósito de **automatizar la gestión del voluntariado universitario** de la Universidad Privada de Tacna (UPT), dentro del marco de la **Responsabilidad Social Universitaria (RSU)**.  

La plataforma permite registrar campañas, gestionar inscripciones, controlar la asistencia mediante códigos QR, emitir certificados digitales y generar reportes institucionales, promoviendo la eficiencia, transparencia y sostenibilidad en los procesos sociales universitarios.

---

## 🚀 Funcionalidades Principales
- Registro y autenticación de usuarios (Administrador, Coordinador RSU, Estudiante).  
- Creación, edición y cierre de campañas de voluntariado.  
- Inscripción en línea y control de asistencia con **códigos QR**.  
- Emisión automática de certificados digitales en formato PDF.  
- Generación de reportes estadísticos e institucionales.  

---

## 🧠 Arquitectura del Sistema
El sistema **Voluntariado-UPT** implementa una arquitectura **Modelo–Vista–Controlador (MVC)** que separa la lógica de negocio, la interfaz y el acceso a datos, garantizando mantenibilidad y escalabilidad.

**Estructura general:**
- **Backend:** Java EE 8 (Servlets, JSP).  
- **Frontend:** HTML5, CSS3, JavaScript, Bootstrap 5.3.  
- **Base de datos:** MySQL / MariaDB.  
- **Servidor de Aplicaciones:** Apache Tomcat 10.

---

## 🔬 GitHub Actions - CI/CD Automatizado

Este proyecto implementa un **workflow unificado** de GitHub Actions que ejecuta **todas las pruebas estáticas y dinámicas** automáticamente:

[![Complete Test Suite](https://github.com/UPT-FAING-EPIS/proyecto-si784-2025-ii-u3-voluntariado_upt/actions/workflows/complete-test-suite.yml/badge.svg)](https://github.com/UPT-FAING-EPIS/proyecto-si784-2025-ii-u3-voluntariado_upt/actions/workflows/complete-test-suite.yml)

### 🎯 Pipeline de Pruebas

```
📊 Stage 1: Análisis Estático (Paralelo)
   ├── SonarQube (Calidad + Coverage)
   ├── Semgrep (Seguridad OWASP)
   └── Snyk (CVEs en dependencias)
        ↓
🧪 Stage 2: Pruebas Unitarias
   └── JUnit 5 + JaCoCo (66.8% coverage)
        ↓
🧬 Stage 3: Mutation Testing
   └── PITest (63% mutation score)
        ↓
🔗 Stage 4: Pruebas de Integración
   └── Testcontainers + MySQL (82.3% coverage)
        ↓
🖥️ Stage 5: Pruebas UI (Paralelo)
   ├── Selenium + Chrome
   └── Selenium + Firefox
        ↓
🥒 Stage 6: Pruebas BDD (Paralelo)
   ├── Cucumber Smoke Tests
   └── Cucumber Regression Tests
        ↓
📊 Stage 7: Reporte Consolidado
   └── Comentario automático en PR
```

### 📚 Documentación de Testing

- **[GitHub Actions Testing Guide](GITHUB_ACTIONS_TESTING.md)** - Guía completa del workflow
- **[Informe Análisis Estático - SonarQube](Informe-Analisis-Estatico-SonarQube.md)**
- **[Informe Análisis Estático - Semgrep](Informe-Analisis-Estatico-Semgrep.md)**
- **[Informe Análisis Estático - Snyk](Informe-Analisis-Estatico-Snyk-Parte1.md)** (3 partes)
- **[Informe Pruebas Unitarias](Informe-Pruebas-Unitarias-Parte1.md)** (2 partes)
- **[Informe Pruebas de Mutación](Informe-Pruebas-Mutaciones-Parte1.md)** (3 partes)
- **[Informe Pruebas de Integración](Informe-Pruebas-Integracion-Parte1.md)** (3 partes)
- **[Informe Pruebas UI](Informe-Pruebas-UI-Parte1.md)** (3 partes)
- **[Informe Pruebas BDD](Informe-Pruebas-BDD-Parte1.md)** (3 partes)

### 🚀 Ejecución Local

```bash
# Validar workflow localmente antes de push
chmod +x validate-workflow.sh
./validate-workflow.sh --all

# Solo pruebas específicas
./validate-workflow.sh --unit --integration
```

### 📊 Métricas de Calidad

| Métrica | Valor | Estado |
|---------|-------|--------|
| **Cobertura Unit Tests** | 66.8% | ✅ |
| **Mutation Score** | 63% | ✅ |
| **Cobertura Integración** | 82.3% | ✅ |
| **Security Issues** | 0 Critical | ✅ |
| **Bugs Detectados** | 45 pre-producción | ✅ |

---

## 🧰 Tecnologías Utilizadas
| **Componente** | **Tecnología / Herramienta** |
|----------------|------------------------------|
| Lenguaje principal | Java EE 8 |
| IDE de desarrollo | Apache NetBeans 17 |
| Servidor de aplicaciones | Apache Tomcat 10 |
| Base de datos | MySQL 10.4 / MariaDB |
| Framework de interfaz | Bootstrap 5.3 |
| Librerías externas | ZXing (QR), iText (PDF), Chart.js (reportes) |
| Control de versiones | GitHub |

---

## ⚙️ Instalación y Ejecución
1. Clonar el repositorio:  
   ```bash
   git clone "https://github.com/UPT-FAING-EPIS/proyecto-si784-2025-ii-u3-voluntariado_upt.git"
   ```
2. Abrir el proyecto en **Apache NetBeans 17**.  
3. Configurar la conexión en el archivo `ClsConexion.java` con tus credenciales MySQL.  
4. Desplegar el proyecto en **Apache Tomcat 10**.  
5. Acceder desde el navegador a:  
   ```
   http://localhost:8080/voluntariado-upt
   ```
   o si desea probar el sistema a nivel web desplegado puedo ingresar al:
   https://voluntariadoupt-gqexgufdaffdfzcf.chilecentral-01.azurewebsites.net/
---

## 🧾 Documentación Técnica
El desarrollo del proyecto se sustenta en los siguientes documentos:

- 📄 **Documento de Propuesta de Proyecto** – Idea general proyecto. 
- 📄 **Documento de Visión** – Definición de objetivos, actores y alcance.  
- 📄 **Documento SRS (Software Requirements Specification)** – Requerimientos funcionales y no funcionales.  
- 📄 **Documento SAD (Software Architecture Document)** – Diseño estructural y diagramas del sistema.  
- 📄 **Informe de Factibilidad Técnica, Económica y Operativa.**  
- 📄 **Manual Técnico y Manual de Usuario. (falta)**

---

## 👥 Equipo de Desarrollo
**Estudiantes de Ingeniería de Sistemas – Universidad Privada de Tacna**  
- Víctor Williams Cruz Mamani  
- Diego Fernando Castillo Mamani  
- Joan Cristian Medina Quispe  

**Docente Asesor:** Ing. Mag. Patrick Jose Cuadros Quiroga  

---

## 🧩 Estándares y Normas Aplicadas
- IEEE Std 830-1998 – *Software Requirements Specifications*  
- ISO/IEC 12207:2017 – *Software Life Cycle Processes*  
- ISO/IEC 25010:2011 – *Software Quality Model*  
- ISO/IEC/IEEE 42010:2011 – *Architecture Description*  
- OWASP Top 10 (2023) – *Web Application Security Guidelines*

---

## 📜 Licencia
Este proyecto se distribuye bajo la licencia **MIT**, lo que permite su uso, modificación y distribución libre con fines académicos y educativos.  

---

> *“La tecnología no solo automatiza procesos, sino que potencia el compromiso social, la ética y la innovación dentro de la comunidad universitaria.”*  
> — *Equipo Voluntariado-UPT (2025)*