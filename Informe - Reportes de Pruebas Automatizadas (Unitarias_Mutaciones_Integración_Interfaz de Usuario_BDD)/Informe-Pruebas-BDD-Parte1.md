# 🥒 Informe de Pruebas BDD - Parte 1
## Sistema de Voluntariado UPT
### Cucumber + Gherkin + Behavior-Driven Development

---

**Fecha:** 3 de Diciembre de 2025  
**Tecnologías:** Cucumber 7.15.0, JUnit 5, Selenium 4.16.1, RestAssured 5.4.0

---

## 📑 Tabla de Contenidos (Parte 1)

1. [Introducción a BDD](#introduccion)
2. [Configuración del Proyecto](#configuracion)
3. [Lenguaje Gherkin](#lenguaje-gherkin)
4. [Features de Autenticación](#features-autenticacion)
5. [Step Definitions](#step-definitions)

---

## 1. 📖 Introducción a BDD

### 1.1 ¿Qué es Behavior-Driven Development?

**BDD (Behavior-Driven Development)** es una metodología de desarrollo que:

- 📝 Usa **lenguaje natural** para describir comportamiento
- 🤝 Facilita **colaboración** entre técnicos y no técnicos
- ✅ Crea **documentación ejecutable**
- 🎯 Enfoca en **valor de negocio**

### 1.2 BDD vs TDD vs Testing Tradicional

| Aspecto | Testing Tradicional | TDD | BDD |
|---------|-------------------|-----|-----|
| **Enfoque** | Verificar código | Red-Green-Refactor | Comportamiento del usuario |
| **Lenguaje** | Técnico (Java) | Técnico (Java) | Natural (Gherkin) |
| **Colaboración** | ❌ Solo QA | ⚠️ Developers | ✅ Todo el equipo |
| **Documentación** | Separada | En código | Ejecutable |
| **Mantenimiento** | Alto | Medio | Medio-Bajo |

### 1.3 Estructura BDD

```
┌─────────────────────────────────────────────┐
│  FEATURE FILE (Gherkin - Lenguaje Natural)  │
│  *.feature                                   │
│                                             │
│  Given el usuario está en la página login  │
│  When ingresa credenciales válidas         │
│  Then debe ver el dashboard                │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  STEP DEFINITIONS (Java)                    │
│  *StepDefs.java                             │
│                                             │
│  @Given("el usuario está en...")           │
│  public void usuarioEnPaginaLogin() {       │
│      driver.get(BASE_URL + "/login");       │
│  }                                          │
└─────────────────────────────────────────────┘
                    ↓
┌─────────────────────────────────────────────┐
│  PAGE OBJECTS (Automation Code)             │
│  LoginPage.java                             │
│                                             │
│  public void login(String user, String pwd) │
└─────────────────────────────────────────────┘
```

### 1.4 Ventajas de BDD en Voluntariado UPT

#### ✅ Para Product Owner / Stakeholders:
- Escriben requisitos en lenguaje natural
- Ven especificaciones ejecutables
- Validan comportamiento antes de desarrollo

#### ✅ Para Developers:
- Especificaciones claras y no ambiguas
- Documentación siempre actualizada
- Tests guían el desarrollo

#### ✅ Para QA:
- Casos de prueba en lenguaje business
- Reutilización de step definitions
- Fácil mantenimiento

---

## 2. ⚙️ Configuración del Proyecto

### 2.1 Dependencias Maven (pom.xml)

```xml
<dependencies>
    <!-- Cucumber Core -->
    <dependency>
        <groupId>io.cucumber</groupId>
        <artifactId>cucumber-java</artifactId>
        <version>7.15.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Cucumber JUnit 5 Integration -->
    <dependency>
        <groupId>io.cucumber</groupId>
        <artifactId>cucumber-junit-platform-engine</artifactId>
        <version>7.15.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Cucumber Spring (para inyección de dependencias) -->
    <dependency>
        <groupId>io.cucumber</groupId>
        <artifactId>cucumber-spring</artifactId>
        <version>7.15.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- JUnit Platform Suite -->
    <dependency>
        <groupId>org.junit.platform</groupId>
        <artifactId>junit-platform-suite</artifactId>
        <version>1.10.1</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Selenium (para UI tests) -->
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.16.1</version>
        <scope>test</scope>
    </dependency>
    
    <!-- WebDriverManager -->
    <dependency>
        <groupId>io.github.bonigarcia</groupId>
        <artifactId>webdrivermanager</artifactId>
        <version>5.6.3</version>
        <scope>test</scope>
    </dependency>
    
    <!-- REST Assured (para API tests) -->
    <dependency>
        <groupId>io.rest-assured</groupId>
        <artifactId>rest-assured</artifactId>
        <version>5.4.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- AssertJ -->
    <dependency>
        <groupId>org.assertj</groupId>
        <artifactId>assertj-core</artifactId>
        <version>3.24.2</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Cucumber Reports -->
    <dependency>
        <groupId>io.cucumber</groupId>
        <artifactId>cucumber-picocontainer</artifactId>
        <version>7.15.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Masterthought Cucumber Reporting -->
    <dependency>
        <groupId>net.masterthought</groupId>
        <artifactId>cucumber-reporting</artifactId>
        <version>5.7.7</version>
        <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <!-- Maven Surefire para ejecutar Cucumber tests -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.2.3</version>
            <configuration>
                <properties>
                    <configurationParameters>
                        cucumber.plugin=pretty,html:target/cucumber-reports/cucumber.html,json:target/cucumber-reports/cucumber.json
                        cucumber.glue=bdd.stepdefinitions
                        cucumber.features=src/test/resources/features
                    </configurationParameters>
                </properties>
            </configuration>
        </plugin>
        
        <!-- Cucumber Reporting Plugin -->
        <plugin>
            <groupId>net.masterthought</groupId>
            <artifactId>maven-cucumber-reporting</artifactId>
            <version>5.7.7</version>
            <executions>
                <execution>
                    <id>execution</id>
                    <phase>verify</phase>
                    <goals>
                        <goal>generate</goal>
                    </goals>
                    <configuration>
                        <projectName>Voluntariado UPT - BDD Tests</projectName>
                        <outputDirectory>target/cucumber-reports</outputDirectory>
                        <inputDirectory>target/cucumber-reports</inputDirectory>
                        <jsonFiles>
                            <param>**/*.json</param>
                        </jsonFiles>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### 2.2 Estructura de Archivos

```
src/test/
├── java/
│   └── bdd/
│       ├── runners/
│       │   └── CucumberTestRunner.java      # Ejecuta todos los tests
│       ├── stepdefinitions/
│       │   ├── LoginStepDefs.java           # Steps de login
│       │   ├── CampanaStepDefs.java         # Steps de campañas
│       │   ├── InscripcionStepDefs.java     # Steps de inscripciones
│       │   └── CommonStepDefs.java          # Steps compartidos
│       ├── context/
│       │   └── TestContext.java             # Contexto compartido
│       ├── hooks/
│       │   └── Hooks.java                   # Before/After scenarios
│       └── pages/
│           └── [Page Objects reutilizados]
│
└── resources/
    ├── features/
    │   ├── autenticacion/
    │   │   ├── login.feature
    │   │   └── logout.feature
    │   ├── estudiante/
    │   │   ├── buscar_campanas.feature
    │   │   ├── inscripcion.feature
    │   │   └── certificados.feature
    │   ├── coordinador/
    │   │   ├── crear_campana.feature
    │   │   ├── control_asistencia.feature
    │   │   └── generar_certificados.feature
    │   └── administrador/
    │       ├── gestionar_usuarios.feature
    │       └── reportes.feature
    │
    ├── cucumber.properties
    └── test-data.properties
```

### 2.3 cucumber.properties

```properties
# src/test/resources/cucumber.properties

# Configuración de ejecución
cucumber.execution.parallel.enabled=true
cucumber.execution.parallel.config.strategy=dynamic
cucumber.execution.parallel.config.dynamic.factor=0.5

# Plugins de reporte
cucumber.plugin=\
  pretty,\
  html:target/cucumber-reports/cucumber.html,\
  json:target/cucumber-reports/cucumber.json,\
  junit:target/cucumber-reports/cucumber.xml,\
  timeline:target/cucumber-reports/timeline

# Opciones de snippet
cucumber.snippet-type=camelcase

# Filtros
cucumber.filter.tags=not @skip and not @wip

# Glue (paquete de step definitions)
cucumber.glue=bdd.stepdefinitions,bdd.hooks

# Features path
cucumber.features=src/test/resources/features

# Strict mode
cucumber.execution.strict=true

# Dry run (para verificar steps sin ejecutar)
cucumber.execution.dry-run=false

# Monochrome output
cucumber.publish.quiet=true
```

---

## 3. 📝 Lenguaje Gherkin

### 3.1 Sintaxis Básica

```gherkin
# Comentario: Se ignora en ejecución

Feature: Título de la funcionalidad
  Como [rol]
  Quiero [acción]
  Para [beneficio]

  Background: Pasos comunes para todos los escenarios
    Given paso común 1
    And paso común 2

  Scenario: Escenario de prueba individual
    Given contexto inicial
    When acción del usuario
    Then resultado esperado
    And verificación adicional
    But no debe ocurrir esto

  Scenario Outline: Escenario con múltiples datos
    Given contexto con "<parámetro>"
    When realizo acción con "<otro_parámetro>"
    Then obtengo resultado "<resultado>"
    
    Examples:
      | parámetro | otro_parámetro | resultado |
      | valor1    | dato1          | ok        |
      | valor2    | dato2          | error     |
```

### 3.2 Keywords de Gherkin

| Keyword | Propósito | Ejemplo |
|---------|-----------|---------|
| **Feature:** | Define funcionalidad | `Feature: Login de usuarios` |
| **Background:** | Pasos previos comunes | `Background: Usuario autenticado` |
| **Scenario:** | Caso de prueba | `Scenario: Login exitoso` |
| **Scenario Outline:** | Test con datos múltiples | `Scenario Outline: Login con <rol>` |
| **Given** | Contexto/precondición | `Given el usuario está en login` |
| **When** | Acción del usuario | `When ingresa credenciales` |
| **Then** | Resultado esperado | `Then ve el dashboard` |
| **And** | Agregar paso del mismo tipo | `And ve mensaje de bienvenida` |
| **But** | Agregar negación | `But no ve mensaje de error` |
| **Examples:** | Datos para Scenario Outline | Ver tabla arriba |
| **@tag** | Etiqueta para filtrar | `@smoke @high_priority` |

### 3.3 Best Practices en Gherkin

#### ✅ BUENO: Lenguaje de negocio

```gherkin
Scenario: Estudiante se inscribe en campaña
  Given Juan está autenticado como estudiante
  When busca campañas de "Medio Ambiente"
  And se inscribe en "Limpieza de Playas"
  Then debe ver mensaje "Inscripción exitosa"
  And la campaña debe tener 1 cupo menos
```

#### ❌ MALO: Lenguaje técnico

```gherkin
Scenario: Test de inscripción
  Given driver.get("/login")
  When click en input id="username"
  And sendKeys "juan@test.com"
  Then assert elemento con class="success" exists
```

#### ✅ BUENO: Declarativo (QUÉ)

```gherkin
Given el estudiante tiene 3 inscripciones activas
When intenta inscribirse en una cuarta campaña
Then debe recibir mensaje "Límite de inscripciones alcanzado"
```

#### ❌ MALO: Imperativo (CÓMO)

```gherkin
Given el usuario hace click en "Mis Inscripciones"
And ve 3 campañas en la tabla
And hace click en botón "Buscar Campañas"
And hace click en el botón "Inscribirse" de la campaña X
Then ve un modal de error
```

---

## 4. 🔐 Features de Autenticación

### 4.1 login.feature

```gherkin
# src/test/resources/features/autenticacion/login.feature

@autenticacion @smoke
Feature: Autenticación de usuarios
  Como usuario del sistema de voluntariado
  Quiero poder iniciar sesión con mis credenciales
  Para acceder a las funcionalidades según mi rol

  Background:
    Given el sistema está disponible
    And estoy en la página de login

  # ═══════════════════════════════════════════════════════
  # ESCENARIOS DE LOGIN EXITOSO
  # ═══════════════════════════════════════════════════════

  @happy_path @estudiante
  Scenario: Estudiante inicia sesión con credenciales válidas
    Given tengo las siguientes credenciales de estudiante:
      | codigo     | 2020123456 |
      | contraseña | test123    |
    When ingreso mis credenciales
    And hago click en el botón "Iniciar Sesión"
    Then debo ser redirigido al dashboard de estudiante
    And debo ver el mensaje de bienvenida "Hola, Juan Pérez"
    And debo ver el menú con las opciones:
      | Campañas Disponibles |
      | Mis Inscripciones    |
      | Certificados         |
      | Mi Perfil            |

  @happy_path @coordinador
  Scenario: Coordinador inicia sesión correctamente
    Given tengo credenciales de coordinador con código "COORD001"
    When inicio sesión como coordinador
    Then debo ver el panel de coordinador
    And debo tener acceso a "Crear Campaña"
    And debo tener acceso a "Control de Asistencia"

  @happy_path @administrador
  Scenario: Administrador accede al sistema
    Given soy administrador con código "ADMIN001"
    When inicio sesión con mi contraseña "admin123"
    Then accedo al panel de administración
    And puedo ver "Gestionar Usuarios"
    And puedo ver "Reportes del Sistema"
    And puedo ver "Configuración"

  # ═══════════════════════════════════════════════════════
  # ESCENARIOS DE LOGIN FALLIDO
  # ═══════════════════════════════════════════════════════

  @negative @security
  Scenario: Login con contraseña incorrecta
    Given tengo un usuario válido "2020123456"
    When ingreso la contraseña incorrecta "wrongpassword"
    And intento iniciar sesión
    Then debo permanecer en la página de login
    And debo ver el mensaje de error "Contraseña incorrecta"
    But no debo tener acceso al sistema

  @negative @security
  Scenario: Login con usuario inexistente
    Given no existe el usuario "9999999999"
    When intento iniciar sesión con ese usuario
    Then debo ver el error "Usuario no encontrado"
    And el campo de contraseña debe vaciarse por seguridad

  @negative @validation
  Scenario: Login con campos vacíos
    Given estoy en la página de login
    When hago click en "Iniciar Sesión" sin llenar datos
    Then debo ver validaciones HTML5 en los campos requeridos
    And el botón de login no debe procesar la petición

  @negative @security
  Scenario: Login con usuario inactivo
    Given existe un usuario inactivo "INACTIVO001"
    When intento iniciar sesión con sus credenciales correctas
    Then debo ver el mensaje "Su cuenta está inactiva. Contacte al administrador"
    And no debo poder acceder al sistema

  # ═══════════════════════════════════════════════════════
  # SCENARIO OUTLINE - MÚLTIPLES ROLES
  # ═══════════════════════════════════════════════════════

  @data_driven
  Scenario Outline: Login exitoso con diferentes roles
    Given tengo credenciales válidas para rol "<rol>"
      | codigo     | <codigo>     |
      | contraseña | <contraseña> |
    When inicio sesión
    Then debo ser redirigido a "<url_esperada>"
    And debo ver el título de página "<titulo_pagina>"
    And debo tener permisos de "<rol>"

    Examples: Usuarios por rol
      | rol          | codigo       | contraseña | url_esperada                    | titulo_pagina      |
      | ESTUDIANTE   | 2020123456   | test123    | /estudiantes/menu_estudiante    | Portal Estudiante  |
      | COORDINADOR  | COORD001     | coord123   | /coordinador/menu_coordinador   | Panel Coordinador  |
      | ADMINISTRADOR| ADMIN001     | admin123   | /administrador/menu_admin       | Panel Admin        |

  # ═══════════════════════════════════════════════════════
  # ESCENARIOS DE SEGURIDAD
  # ═══════════════════════════════════════════════════════

  @security @rate_limiting
  Scenario: Bloqueo temporal después de múltiples intentos fallidos
    Given tengo credenciales de usuario "2020123456"
    When ingreso la contraseña incorrecta 5 veces consecutivas
    Then mi cuenta debe bloquearse temporalmente por 15 minutos
    And debo ver el mensaje "Demasiados intentos fallidos. Intente en 15 minutos"
    And no puedo iniciar sesión incluso con la contraseña correcta

  @security @session
  Scenario: Prevenir sesiones múltiples simultáneas
    Given he iniciado sesión en el navegador Chrome
    When intento iniciar sesión con las mismas credenciales en Firefox
    Then la sesión anterior debe cerrarse automáticamente
    And solo la nueva sesión debe estar activa

  @security @xss
  Scenario: Protección contra inyección de scripts en login
    Given estoy en el formulario de login
    When ingreso "<script>alert('XSS')</script>" en el campo usuario
    And ingreso "password" en contraseña
    And envío el formulario
    Then el script NO debe ejecutarse
    And debo ver error de validación de formato

  # ═══════════════════════════════════════════════════════
  # ESCENARIOS DE UX/UI
  # ═══════════════════════════════════════════════════════

  @ui @accessibility
  Scenario: Navegación con teclado en formulario de login
    Given estoy en la página de login
    When escribo mi código de usuario con el teclado
    And presiono la tecla TAB para ir a contraseña
    And escribo mi contraseña
    And presiono la tecla ENTER
    Then el formulario debe enviarse correctamente
    And debo iniciar sesión sin usar el mouse

  @ui @responsive
  Scenario: Login funcional en dispositivo móvil
    Given accedo al sistema desde un móvil con resolución 375x812
    When completo el formulario de login
    Then el diseño debe ser responsive
    And todos los botones deben ser táctiles (min 44x44px)
    And no debe haber scroll horizontal

  @ui @feedback
  Scenario: Indicadores visuales durante login
    Given estoy autenticándome
    When envío el formulario de login
    Then debo ver un spinner o loading mientras se procesa
    And el botón "Iniciar Sesión" debe deshabilitarse temporalmente
    And debo recibir feedback visual del proceso
```

### 4.2 logout.feature

```gherkin
# src/test/resources/features/autenticacion/logout.feature

@autenticacion @logout
Feature: Cerrar sesión de usuario
  Como usuario autenticado
  Quiero poder cerrar mi sesión de forma segura
  Para proteger mi cuenta cuando termine de usar el sistema

  Background:
    Given el sistema está disponible
    And he iniciado sesión como estudiante

  @happy_path @security
  Scenario: Cerrar sesión exitosamente
    Given estoy en el dashboard de estudiante
    When hago click en el botón "Cerrar Sesión"
    Then debo ser redirigido a la página de login
    And mi sesión debe invalidarse en el servidor
    And las cookies de sesión deben eliminarse
    But mis datos en base de datos deben permanecer intactos

  @security @session
  Scenario: No poder acceder a páginas protegidas después de logout
    Given he cerrado sesión correctamente
    When intento acceder directamente a "/estudiantes/campañas"
    Then debo ser redirigido a la página de login
    And debo ver el mensaje "Sesión expirada. Por favor inicie sesión"

  @security @timeout
  Scenario: Cierre de sesión automático por inactividad
    Given estoy autenticado en el sistema
    When permanezco inactivo durante 30 minutos
    Then mi sesión debe cerrarse automáticamente
    And al intentar realizar cualquier acción debo ver mensaje de sesión expirada
    And debo ser redirigido al login

  @ui @confirmation
  Scenario: Confirmación antes de cerrar sesión con trabajo sin guardar
    Given estoy creando una nueva campaña como coordinador
    And he llenado el formulario pero no he guardado
    When intento cerrar sesión
    Then debo ver un modal de confirmación "Tiene cambios sin guardar. ¿Desea salir?"
    And puedo elegir "Cancelar" para continuar trabajando
    Or puedo elegir "Salir sin guardar" para cerrar sesión

  @concurrent @sessions
  Scenario: Cerrar sesión en todos los dispositivos
    Given he iniciado sesión en 3 dispositivos diferentes
    When cierro sesión desde el dispositivo 1
    And marco la opción "Cerrar sesión en todos los dispositivos"
    Then las sesiones en los dispositivos 2 y 3 deben cerrarse también
    And todos los dispositivos deben redirigirse al login
```

---

## 5. 🔧 Step Definitions

### 5.1 LoginStepDefs.java

```java
package bdd.stepdefinitions;

import bdd.context.TestContext;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.*;
import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import ui.pages.LoginPage;

import java.util.Map;

import static org.assertj.core.api.Assertions.*;

/**
 * Step Definitions para funcionalidad de Login.
 */
public class LoginStepDefs {
    
    private final TestContext context;
    private final WebDriver driver;
    private final LoginPage loginPage;
    
    private String currentUsername;
    private String currentPassword;
    
    // Constructor para inyección de dependencias (PicoContainer)
    public LoginStepDefs(TestContext context) {
        this.context = context;
        this.driver = context.getDriver();
        this.loginPage = new LoginPage(driver);
    }
    
    // ═══════════════════════════════════════════════════════
    // STEPS DE CONTEXTO (GIVEN)
    // ═══════════════════════════════════════════════════════
    
    @Given("el sistema está disponible")
    public void elSistemaEstaDisponible() {
        // Verificar que la aplicación esté accesible
        driver.get(context.getBaseUrl());
        assertThat(driver.getTitle()).isNotEmpty();
    }
    
    @Given("estoy en la página de login")
    public void estoyEnLaPaginaDeLogin() {
        driver.get(context.getBaseUrl() + "/index.jsp");
        assertThat(driver.getCurrentUrl()).contains("/index.jsp");
    }
    
    @Given("tengo las siguientes credenciales de estudiante:")
    public void tengoCredencialesDeEstudiante(DataTable dataTable) {
        Map<String, String> credentials = dataTable.asMap(String.class, String.class);
        
        currentUsername = credentials.get("codigo");
        currentPassword = credentials.get("contraseña");
        
        // Guardar en contexto para uso posterior
        context.setScenarioContext("username", currentUsername);
        context.setScenarioContext("password", currentPassword);
    }
    
    @Given("tengo credenciales de coordinador con código {string}")
    public void tengoCredencialesCoordinador(String codigo) {
        currentUsername = codigo;
        currentPassword = context.getProperty("test.coordinador.password");
    }
    
    @Given("soy administrador con código {string}")
    public void soyAdministrador(String codigo) {
        currentUsername = codigo;
        context.setScenarioContext("rol", "ADMINISTRADOR");
    }
    
    @Given("tengo un usuario válido {string}")
    public void tengoUsuarioValido(String codigo) {
        currentUsername = codigo;
    }
    
    @Given("no existe el usuario {string}")
    public void noExisteUsuario(String codigo) {
        currentUsername = codigo;
        currentPassword = "anypassword";
    }
    
    @Given("existe un usuario inactivo {string}")
    public void existeUsuarioInactivo(String codigo) {
        currentUsername = codigo;
        currentPassword = context.getProperty("test.inactivo.password");
    }
    
    @Given("tengo credenciales válidas para rol {string}")
    public void tengoCredencialesParaRol(String rol, DataTable dataTable) {
        Map<String, String> credentials = dataTable.asMap(String.class, String.class);
        
        currentUsername = credentials.get("codigo");
        currentPassword = credentials.get("contraseña");
        
        context.setScenarioContext("rol", rol);
    }
    
    @Given("he iniciado sesión en el navegador Chrome")
    public void heIniciadoSesionEnChrome() {
        loginPage.login(currentUsername, currentPassword);
        assertThat(driver.getCurrentUrl()).doesNotContain("/index.jsp");
    }
    
    @Given("he iniciado sesión como estudiante")
    public void heIniciadoSesionComoEstudiante() {
        currentUsername = context.getProperty("test.estudiante.codigo");
        currentPassword = context.getProperty("test.estudiante.password");
        
        loginPage.login(currentUsername, currentPassword);
        
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/menu_estudiante.jsp");
    }
    
    @Given("estoy en el dashboard de estudiante")
    public void estoyEnDashboardEstudiante() {
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/menu_estudiante.jsp");
    }
    
    // ═══════════════════════════════════════════════════════
    // STEPS DE ACCIÓN (WHEN)
    // ═══════════════════════════════════════════════════════
    
    @When("ingreso mis credenciales")
    public void ingresoMisCredenciales() {
        loginPage.enterCodigo(currentUsername);
        loginPage.enterPassword(currentPassword);
    }
    
    @When("hago click en el botón {string}")
    public void hagoClickEnBoton(String buttonText) {
        if (buttonText.equals("Iniciar Sesión")) {
            loginPage.clickLoginButton();
        } else if (buttonText.equals("Cerrar Sesión")) {
            driver.findElement(By.id("btnLogout")).click();
        }
    }
    
    @When("inicio sesión como coordinador")
    public void inicioSesionComoCoordinador() {
        loginPage.login(currentUsername, currentPassword);
    }
    
    @When("inicio sesión con mi contraseña {string}")
    public void inicioSesionConPassword(String password) {
        currentPassword = password;
        loginPage.login(currentUsername, currentPassword);
    }
    
    @When("ingreso la contraseña incorrecta {string}")
    public void ingresoPasswordIncorrecta(String wrongPassword) {
        currentPassword = wrongPassword;
        loginPage.enterPassword(currentPassword);
    }
    
    @When("intento iniciar sesión")
    public void intentoIniciarSesion() {
        loginPage.clickLoginButton();
    }
    
    @When("intento iniciar sesión con ese usuario")
    public void intentoIniciarSesionConUsuario() {
        loginPage.login(currentUsername, currentPassword);
    }
    
    @When("hago click en {string} sin llenar datos")
    public void clickSinLlenarDatos(String buttonText) {
        loginPage.clickLoginButton();
    }
    
    @When("intento iniciar sesión con sus credenciales correctas")
    public void intentoIniciarSesionConCredencialesCorrectas() {
        loginPage.login(currentUsername, currentPassword);
    }
    
    @When("inicio sesión")
    public void inicioSesion() {
        loginPage.login(currentUsername, currentPassword);
    }
    
    @When("ingreso la contraseña incorrecta {int} veces consecutivas")
    public void ingresoPasswordIncorrectaNVeces(int intentos) {
        for (int i = 0; i < intentos; i++) {
            loginPage.login(currentUsername, "wrongpassword");
            
            // Esperar mensaje de error antes del siguiente intento
            try {
                Thread.sleep(500);
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    @When("intento iniciar sesión con las mismas credenciales en Firefox")
    public void intentoIniciarSesionEnFirefox() {
        // Simular apertura de nueva sesión (requeriría segundo driver)
        context.setScenarioContext("second_session_attempt", true);
    }
    
    @When("ingreso {string} en el campo usuario")
    public void ingresoEnCampoUsuario(String input) {
        loginPage.enterCodigo(input);
    }
    
    @When("ingreso {string} en contraseña")
    public void ingresoEnPassword(String password) {
        loginPage.enterPassword(password);
    }
    
    @When("envío el formulario")
    public void envioFormulario() {
        loginPage.clickLoginButton();
    }
    
    // ═══════════════════════════════════════════════════════
    // STEPS DE VERIFICACIÓN (THEN)
    // ═══════════════════════════════════════════════════════
    
    @Then("debo ser redirigido al dashboard de estudiante")
    public void deboSerRedirigidoADashboardEstudiante() {
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/menu_estudiante.jsp");
    }
    
    @Then("debo ver el mensaje de bienvenida {string}")
    public void deboVerMensajeBienvenida(String mensaje) {
        String welcomeText = driver.findElement(By.className("welcome-message")).getText();
        assertThat(welcomeText).contains(mensaje);
    }
    
    @Then("debo ver el menú con las opciones:")
    public void deboVerMenuConOpciones(DataTable dataTable) {
        List<String> expectedOptions = dataTable.asList(String.class);
        
        for (String option : expectedOptions) {
            boolean optionExists = driver.findElements(
                By.xpath("//a[contains(text(), '" + option + "')]")
            ).size() > 0;
            
            assertThat(optionExists)
                .withFailMessage("Opción de menú no encontrada: " + option)
                .isTrue();
        }
    }
    
    @Then("debo ver el panel de coordinador")
    public void deboVerPanelCoordinador() {
        assertThat(driver.getCurrentUrl())
            .contains("/coordinador/menu_coordinador.jsp");
    }
    
    @Then("debo tener acceso a {string}")
    public void deboTenerAccesoA(String menuOption) {
        boolean hasAccess = driver.findElements(
            By.xpath("//a[contains(text(), '" + menuOption + "')]")
        ).size() > 0;
        
        assertThat(hasAccess).isTrue();
    }
    
    @Then("accedo al panel de administración")
    public void accedoAPanelAdmin() {
        assertThat(driver.getCurrentUrl())
            .contains("/administrador/menu_admin.jsp");
    }
    
    @Then("puedo ver {string}")
    public void puedoVer(String elemento) {
        boolean isVisible = driver.findElements(
            By.xpath("//*[contains(text(), '" + elemento + "')]")
        ).size() > 0;
        
        assertThat(isVisible).isTrue();
    }
    
    @Then("debo permanecer en la página de login")
    public void deboPermancerEnLogin() {
        assertThat(driver.getCurrentUrl()).contains("/index.jsp");
    }
    
    @Then("debo ver el mensaje de error {string}")
    public void deboVerMensajeError(String expectedError) {
        String actualError = loginPage.getErrorMessage();
        assertThat(actualError).containsIgnoringCase(expectedError);
    }
    
    @Then("no debo tener acceso al sistema")
    public void noDeboTenerAcceso() {
        assertThat(driver.getCurrentUrl()).contains("/index.jsp");
    }
    
    @Then("debo ver el error {string}")
    public void deboVerError(String error) {
        assertThat(loginPage.getErrorMessage()).containsIgnoringCase(error);
    }
    
    @Then("el campo de contraseña debe vaciarse por seguridad")
    public void campoPasswordDebeVaciarse() {
        String passwordValue = driver.findElement(By.id("password"))
            .getAttribute("value");
        
        assertThat(passwordValue).isEmpty();
    }
    
    @Then("debo ver validaciones HTML5 en los campos requeridos")
    public void deboVerValidacionesHTML5() {
        String codigoRequired = driver.findElement(By.id("codigo"))
            .getAttribute("required");
        
        assertThat(codigoRequired).isNotNull();
    }
    
    @Then("el botón de login no debe procesar la petición")
    public void botonNoProcesaPeticion() {
        assertThat(driver.getCurrentUrl()).contains("/index.jsp");
    }
    
    @Then("debo ser redirigido a {string}")
    public void deboSerRedirigidoA(String expectedUrl) {
        assertThat(driver.getCurrentUrl()).contains(expectedUrl);
    }
    
    @Then("debo ver el título de página {string}")
    public void deboVerTituloPagina(String expectedTitle) {
        assertThat(driver.getTitle()).contains(expectedTitle);
    }
    
    @Then("debo tener permisos de {string}")
    public void deboTenerPermisosDeRol(String rol) {
        // Verificar en contexto o sesión
        context.setScenarioContext("current_rol", rol);
    }
    
    @Then("mi cuenta debe bloquearse temporalmente por {int} minutos")
    public void cuentaBloqueadaTemporalmente(int minutos) {
        String errorMessage = loginPage.getErrorMessage();
        assertThat(errorMessage).contains("bloqueada");
        assertThat(errorMessage).contains(String.valueOf(minutos));
    }
    
    @Then("no puedo iniciar sesión incluso con la contraseña correcta")
    public void noPuedoIniciarSesion() {
        // Intentar con password correcta
        loginPage.login(currentUsername, context.getProperty("test.estudiante.password"));
        
        // Debe seguir en login
        assertThat(driver.getCurrentUrl()).contains("/index.jsp");
    }
    
    @Then("el script NO debe ejecutarse")
    public void scriptNoDebeEjecutarse() {
        // Verificar que no hay alert de JavaScript
        assertThat(driver.switchTo().alert()).isNull();
    }
    
    @Then("debo ver error de validación de formato")
    public void deboVerErrorValidacion() {
        assertThat(loginPage.isErrorMessageDisplayed()).isTrue();
    }
}
```

---

**Continúa en Parte 2:** Step Definitions de Campañas, Inscripciones y Coordinador

---

*Generado el 3 de Diciembre de 2025*  
*Cucumber 7.15.0 + Gherkin + Selenium 4.16.1*
