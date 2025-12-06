---
name: 🔒 Reporte de Seguridad
about: Reportar una vulnerabilidad de seguridad (PRIVADO)
title: '[SECURITY] '
labels: security
assignees: ''
---

## ⚠️ ADVERTENCIA
**NO publiques vulnerabilidades de seguridad críticas en issues públicos.**

Para vulnerabilidades serias:
1. Contacta a los mantenedores por email privado
2. Usa GitHub Security Advisories (pestaña Security)
3. Espera respuesta antes de divulgar públicamente

---

## 🔒 Tipo de Vulnerabilidad
- [ ] Inyección SQL
- [ ] Cross-Site Scripting (XSS)
- [ ] Cross-Site Request Forgery (CSRF)
- [ ] Autenticación/Autorización
- [ ] Exposición de datos sensibles
- [ ] Configuración incorrecta de seguridad
- [ ] Dependencias vulnerables
- [ ] Otra: ___________

## 📝 Descripción de la Vulnerabilidad
Una descripción clara de la vulnerabilidad detectada (sin revelar detalles de explotación si es crítica).

## 🎯 Impacto
¿Qué impacto tendría esta vulnerabilidad si fuera explotada?
- [ ] Crítico: Compromiso total del sistema
- [ ] Alto: Acceso no autorizado a datos sensibles
- [ ] Medio: Exposición de información limitada
- [ ] Bajo: Impacto menor

## 🔍 Componente Afectado
¿Qué parte del sistema está afectada?
- Archivo(s): [ej: UsuarioNegocio.java]
- Funcionalidad: [ej: Login, Certificados]
- Endpoint: [ej: /servlet/LoginServlet]

## 🛠️ Versión Afectada
- Versión: [ej: 1.0, main branch]
- Commit: [si es conocido]

## 💡 Solución Propuesta
Si tienes una idea de cómo corregir la vulnerabilidad (sin revelar exploit).

## 📊 Severidad (CVSS)
Si puedes calcularlo: [Use https://nvd.nist.gov/vuln-metrics/cvss/v3-calculator]
- Score: [ej: 7.5]
- Vector: [ej: CVSS:3.1/AV:N/AC:L/PR:N/UI:N/S:U/C:H/I:H/A:N]

## 🔗 Referencias
Enlaces a CVEs similares, artículos de OWASP, etc.

## ✔️ Checklist
- [ ] He verificado que no es un falso positivo
- [ ] He evaluado el impacto real
- [ ] NO he incluido código de explotación funcional
- [ ] He considerado el nivel de severidad apropiadamente
