# 🤝 Guía de Contribución
## Sistema de Voluntariado UPT

¡Gracias por tu interés en contribuir al proyecto! Esta guía te ayudará a realizar contribuciones de manera efectiva.

---

## 📋 Tabla de Contenidos
- [Código de Conducta](#código-de-conducta)
- [¿Cómo puedo contribuir?](#cómo-puedo-contribuir)
- [Proceso de Desarrollo](#proceso-de-desarrollo)
- [Configuración del Entorno](#configuración-del-entorno)
- [Estándares de Código](#estándares-de-código)
- [Proceso de Pull Request](#proceso-de-pull-request)
- [Reportar Bugs](#reportar-bugs)
- [Sugerir Mejoras](#sugerir-mejoras)

---

## 📜 Código de Conducta

Este proyecto se adhiere a un Código de Conducta. Al participar, se espera que respetes estos lineamientos. Por favor, lee [CODE_OF_CONDUCT.md](CODE_OF_CONDUCT.md) para más detalles.

---

## 🎯 ¿Cómo puedo contribuir?

Hay muchas formas de contribuir al proyecto:

### 🐛 Reportar Bugs
- Verifica que el bug no haya sido reportado previamente en [Issues](../../issues)
- Usa la plantilla de issue para bugs
- Incluye pasos detallados para reproducir el problema
- Proporciona capturas de pantalla si es posible

### ✨ Sugerir Mejoras
- Abre un issue describiendo la mejora propuesta
- Explica por qué esta mejora sería útil
- Proporciona ejemplos de uso si es posible

### 📝 Mejorar Documentación
- Correcciones de typos
- Aclaraciones en la documentación
- Ejemplos adicionales
- Traducciones

### 💻 Contribuir con Código
- Implementar nuevas funcionalidades
- Corregir bugs existentes
- Mejorar el rendimiento
- Refactorización de código
- Agregar o mejorar tests

---

## 🔧 Proceso de Desarrollo

### 1. Fork del Repositorio

```bash
# Haz clic en el botón "Fork" en GitHub
# Luego clona tu fork
git clone https://github.com/TU-USUARIO/proyecto-si784-2025-ii-u3-voluntariado_upt.git
cd proyecto-si784-2025-ii-u3-voluntariado_upt
```

### 2. Configurar Remote Upstream

```bash
git remote add upstream https://github.com/UPT-FAING-EPIS/proyecto-si784-2025-ii-u3-voluntariado_upt.git
git fetch upstream
```

### 3. Crear una Rama de Trabajo

```bash
# Sincroniza con la rama principal
git checkout main
git pull upstream main

# Crea una nueva rama descriptiva
git checkout -b feature/nombre-descriptivo
# o
git checkout -b fix/nombre-del-bug
# o
git checkout -b docs/descripcion-cambio
```

**Convenciones para nombres de ramas:**
- `feature/`: Nuevas funcionalidades
- `fix/`: Corrección de bugs
- `docs/`: Cambios en documentación
- `refactor/`: Refactorización de código
- `test/`: Agregar o modificar tests
- `chore/`: Tareas de mantenimiento

---

## 🛠️ Configuración del Entorno

### Requisitos Previos

- **Java**: JDK 11 o superior
- **Maven**: 3.6+ o **Gradle**: 7.0+
- **MySQL/MariaDB**: 8.0+
- **Apache Tomcat**: 10.x
- **Git**: 2.x+
- **IDE recomendado**: IntelliJ IDEA, Eclipse o NetBeans

### Instalación

1. **Clonar el repositorio**
```bash
git clone https://github.com/TU-USUARIO/proyecto-si784-2025-ii-u3-voluntariado_upt.git
cd proyecto-si784-2025-ii-u3-voluntariado_upt
```

2. **Configurar la base de datos**
```bash
# Crear base de datos
mysql -u root -p < base_de_datos/completo.sql
```

3. **Configurar conexión a BD**
Edita `proyecto/src/java/conexion/Conexion.java` con tus credenciales locales.

4. **Compilar el proyecto**
```bash
cd proyecto
# Si usas Maven
mvn clean install

# Si usas Gradle
gradle build
```

5. **Ejecutar tests**
```bash
# Maven
mvn test

# Gradle
gradle test
```

6. **Desplegar en Tomcat**
- Copia el WAR generado a `TOMCAT_HOME/webapps/`
- O configura tu IDE para despliegue automático

---

## 📏 Estándares de Código

### Convenciones Java

- **Nomenclatura**:
  - Clases: `PascalCase` (ej: `UsuarioNegocio`)
  - Métodos: `camelCase` (ej: `validarLogin`)
  - Constantes: `UPPER_SNAKE_CASE` (ej: `MAX_INTENTOS`)
  - Variables: `camelCase` (ej: `nombreUsuario`)

- **Formato**:
  - Indentación: 4 espacios (no tabs)
  - Longitud máxima de línea: 120 caracteres
  - Llaves en la misma línea (estilo Java)

- **Buenas Prácticas**:
  - Siempre cerrar recursos (usar try-with-resources)
  - Validar entradas del usuario
  - Manejar excepciones apropiadamente
  - Escribir código autodocumentado
  - Agregar JavaDoc para métodos públicos

### Ejemplo de Código Bien Formateado

```java
/**
 * Valida las credenciales del usuario.
 * 
 * @param correo Correo electrónico del usuario
 * @param password Contraseña del usuario
 * @return Usuario si las credenciales son válidas, null en caso contrario
 * @throws SQLException Si hay un error en la base de datos
 */
public Usuario validarLogin(String correo, String password) throws SQLException {
    if (correo == null || correo.trim().isEmpty()) {
        throw new IllegalArgumentException("El correo no puede estar vacío");
    }
    
    try (Connection conn = Conexion.getConexion()) {
        // Lógica de validación
        return usuario;
    }
}
```

### Estándares para JSP/HTML

- Usar Bootstrap para estilos consistentes
- Separar lógica de presentación
- Incluir validación client-side y server-side
- Usar JSTL en lugar de scriptlets cuando sea posible

### Estándares SQL

- Usar prepared statements (prevenir SQL injection)
- Nombres de tablas en snake_case
- Nombres descriptivos para columnas

---

## ✅ Proceso de Pull Request

### Antes de Enviar

1. **Asegúrate que tu código compile**
```bash
mvn clean install
```

2. **Ejecuta todos los tests**
```bash
mvn test
```

3. **Verifica el análisis estático**
```bash
# SonarQube (si está configurado localmente)
mvn sonar:sonar
```

4. **Actualiza la documentación** si es necesario

5. **Commit con mensajes claros**
```bash
git add .
git commit -m "tipo: descripción breve del cambio"
```

**Convenciones para commits:**
- `feat:` Nueva funcionalidad
- `fix:` Corrección de bug
- `docs:` Cambios en documentación
- `style:` Cambios de formato (no afectan lógica)
- `refactor:` Refactorización de código
- `test:` Agregar o modificar tests
- `chore:` Tareas de mantenimiento

**Ejemplos:**
```bash
git commit -m "feat: agregar validación de correo en registro"
git commit -m "fix: corregir error en generación de certificados"
git commit -m "docs: actualizar guía de instalación"
```

### Enviar Pull Request

1. **Push a tu fork**
```bash
git push origin feature/nombre-descriptivo
```

2. **Crear Pull Request en GitHub**
- Ve a tu fork en GitHub
- Haz clic en "Compare & pull request"
- Usa la plantilla de PR
- Describe claramente los cambios realizados
- Referencia issues relacionados (ej: "Closes #123")

3. **Espera revisión**
- Los mantenedores revisarán tu PR
- Puede haber comentarios o solicitudes de cambios
- Realiza los cambios solicitados
- Una vez aprobado, tu PR será fusionado

### Checklist del Pull Request

- [ ] El código compila sin errores
- [ ] Todos los tests pasan
- [ ] Se agregaron tests para nuevas funcionalidades
- [ ] La documentación está actualizada
- [ ] El código sigue los estándares del proyecto
- [ ] Los commits tienen mensajes descriptivos
- [ ] No hay conflictos con la rama main
- [ ] Se probó manualmente la funcionalidad

---

## 🐛 Reportar Bugs

Al reportar un bug, incluye:

1. **Descripción clara** del problema
2. **Pasos para reproducir**:
   - Paso 1
   - Paso 2
   - Paso 3
3. **Comportamiento esperado**
4. **Comportamiento actual**
5. **Capturas de pantalla** (si aplica)
6. **Entorno**:
   - SO: [ej: Windows 11]
   - Navegador: [ej: Chrome 120]
   - Java: [ej: OpenJDK 11]
   - MySQL: [ej: 8.0.32]
7. **Logs de error** (si están disponibles)

---

## 💡 Sugerir Mejoras

Al sugerir una mejora, incluye:

1. **Descripción clara** de la mejora
2. **Justificación**: ¿Por qué es útil?
3. **Propuesta de implementación** (si tienes ideas)
4. **Alternativas consideradas**
5. **Ejemplos de uso**

---

## 🧪 Ejecutar Tests

### Tests Unitarios
```bash
mvn test
```

### Tests de Integración
```bash
mvn verify -P integration-tests
```

### Tests de Mutación
```bash
mvn test pitest:mutationCoverage
```

### Tests UI (Selenium)
```bash
mvn test -P ui-tests
```

### Coverage Report
```bash
mvn clean test jacoco:report
# Ver en: target/site/jacoco/index.html
```

---

## 🔍 Análisis de Código

### SonarQube Local
```bash
mvn clean verify sonar:sonar
```

### Checkstyle
```bash
mvn checkstyle:check
```

---

## 📞 Contacto y Soporte

- **Issues**: [GitHub Issues](../../issues)
- **Discussions**: [GitHub Discussions](../../discussions)
- **Email**: Contacta a los mantenedores del proyecto

---

## 🎓 Recursos Adicionales

- [Documentación del Proyecto](README.md)
- [Arquitectura del Sistema](FD04-EPIS-Informe%20Arquitectura%20de%20Software.md)
- [Guía de Testing](GITHUB_ACTIONS_TESTING.md)
- [Configuración de GitHub Actions](GITHUB_SECRETS_SETUP.md)

---

## 🏆 Reconocimientos

¡Todos los contribuidores son importantes! Tu nombre será agregado a la lista de contribuidores automáticamente cuando tu PR sea aceptado.

---

## ❓ Preguntas Frecuentes

### ¿Puedo trabajar en un issue que ya está asignado?
No, por favor busca issues sin asignar o crea uno nuevo.

### ¿Cuánto tiempo toma la revisión de un PR?
Generalmente 2-5 días hábiles. Ten paciencia.

### ¿Qué hago si mi PR tiene conflictos?
```bash
git fetch upstream
git rebase upstream/main
# Resuelve conflictos
git push --force-with-lease origin tu-rama
```

### ¿Puedo contribuir si soy principiante?
¡Absolutamente! Busca issues etiquetados con `good first issue` o `help wanted`.

---

**¡Gracias por contribuir al Sistema de Voluntariado UPT! 🎉**
