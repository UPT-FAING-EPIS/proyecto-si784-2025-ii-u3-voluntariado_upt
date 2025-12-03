# 🖥️ Informe de Pruebas de Interfaz de Usuario - Parte 1
## Sistema de Voluntariado UPT
### Selenium WebDriver + Page Object Pattern

---

**Fecha:** 3 de Diciembre de 2025  
**Tecnologías:** Selenium 4.16.1, WebDriverManager 5.6.3, TestNG 7.9.0

---

## 📑 Tabla de Contenidos (Parte 1)

1. [Introducción a las Pruebas de UI](#introduccion)
2. [Configuración del Proyecto](#configuracion)
3. [Page Object Model (POM)](#page-object-model)
4. [Tests de Login y Autenticación](#tests-login)
5. [Tests de Navegación](#tests-navegacion)

---

## 1. 📖 Introducción a las Pruebas de UI

### 1.1 ¿Qué son las Pruebas de UI?

Las pruebas de Interfaz de Usuario (UI Testing) son tests automatizados que **interactúan con la aplicación web como lo haría un usuario real**, validando:

- ✅ Funcionalidad de formularios y botones
- ✅ Navegación entre páginas
- ✅ Validaciones del lado del cliente (JavaScript)
- ✅ Responsive design
- ✅ Compatibilidad cross-browser

### 1.2 Selenium WebDriver

**Selenium** es el framework líder para automatización de navegadores web:

```
┌─────────────────────────────────────────┐
│  Test Code (Java + JUnit/TestNG)       │
├─────────────────────────────────────────┤
│  Selenium WebDriver API                 │
├─────────────────────────────────────────┤
│  Browser Driver (ChromeDriver, etc.)    │
├─────────────────────────────────────────┤
│  Browser (Chrome, Firefox, Edge)        │
└─────────────────────────────────────────┘
```

### 1.3 Comparación: Unit vs Integration vs UI Tests

| Aspecto | Unit Tests | Integration Tests | UI Tests |
|---------|-----------|-------------------|----------|
| **Velocidad** | ⚡ 50ms | 🐢 2-5s | 🐌 10-30s |
| **Scope** | Método individual | Múltiples capas + DB | Aplicación completa |
| **Browser** | ❌ No | ❌ No | ✅ Sí |
| **JavaScript** | ❌ No ejecuta | ❌ No ejecuta | ✅ Ejecuta |
| **Usuario Real** | ❌ Mock | ⚠️ Parcial | ✅ Simula usuario |
| **Flakiness** | ✅ Bajo | ⚠️ Medio | ⚠️ Alto |
| **Mantenimiento** | ✅ Fácil | ⚠️ Medio | ❌ Difícil |

### 1.4 Pirámide de Testing

```
         🔺
        /   \
       / UI  \          ← 10% (Selenium) ✅ ESTA GUÍA
      /-------\
     /  API    \        ← 15% (REST Tests)
    / Integration\      ← 15% (Testcontainers) ✅ COMPLETADO
   /-------------\
  /  Unit Tests  \      ← 60% (JUnit + Mockito) ✅ COMPLETADO
 /_________________\
```

**Filosofía:** Pocos tests de UI (lentos, frágiles), pero críticos para validar flujos end-to-end.

---

## 2. ⚙️ Configuración del Proyecto

### 2.1 Dependencias Maven (pom.xml)

```xml
<dependencies>
    <!-- Selenium WebDriver -->
    <dependency>
        <groupId>org.seleniumhq.selenium</groupId>
        <artifactId>selenium-java</artifactId>
        <version>4.16.1</version>
        <scope>test</scope>
    </dependency>
    
    <!-- WebDriverManager (gestión automática de drivers) -->
    <dependency>
        <groupId>io.github.bonigarcia</groupId>
        <artifactId>webdrivermanager</artifactId>
        <version>5.6.3</version>
        <scope>test</scope>
    </dependency>
    
    <!-- TestNG (alternativa a JUnit para UI tests) -->
    <dependency>
        <groupId>org.testng</groupId>
        <artifactId>testng</artifactId>
        <version>7.9.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- AssertJ para assertions fluidas -->
    <dependency>
        <groupId>org.assertj</groupId>
        <artifactId>assertj-core</artifactId>
        <version>3.24.2</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Awaitility para esperas inteligentes -->
    <dependency>
        <groupId>org.awaitility</groupId>
        <artifactId>awaitility</artifactId>
        <version>4.2.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- ExtentReports para reportes visuales -->
    <dependency>
        <groupId>com.aventstack</groupId>
        <artifactId>extentreports</artifactId>
        <version>5.1.1</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Screenshot utility -->
    <dependency>
        <groupId>commons-io</groupId>
        <artifactId>commons-io</artifactId>
        <version>2.15.1</version>
        <scope>test</scope>
    </dependency>
</dependencies>

<build>
    <plugins>
        <!-- Maven Surefire para ejecutar tests -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.2.3</version>
            <configuration>
                <suiteXmlFiles>
                    <suiteXmlFile>src/test/resources/testng.xml</suiteXmlFile>
                </suiteXmlFiles>
                <systemPropertyVariables>
                    <browser>${browser}</browser>
                    <headless>${headless}</headless>
                </systemPropertyVariables>
            </configuration>
        </plugin>
    </plugins>
</build>
```

### 2.2 Configuración TestNG (testng.xml)

```xml
<!DOCTYPE suite SYSTEM "https://testng.org/testng-1.0.dtd">
<suite name="Voluntariado UPT UI Test Suite" parallel="classes" thread-count="3">
    
    <listeners>
        <listener class-name="ui.listeners.TestListener"/>
        <listener class-name="ui.listeners.ScreenshotListener"/>
    </listeners>
    
    <test name="Login Tests">
        <classes>
            <class name="ui.tests.LoginUITest"/>
        </classes>
    </test>
    
    <test name="Estudiante Tests">
        <classes>
            <class name="ui.tests.EstudianteUITest"/>
        </classes>
    </test>
    
    <test name="Coordinador Tests">
        <classes>
            <class name="ui.tests.CoordinadorUITest"/>
        </classes>
    </test>
    
    <test name="Admin Tests">
        <classes>
            <class name="ui.tests.AdminUITest"/>
        </classes>
    </test>
    
</suite>
```

### 2.3 Propiedades de Configuración (config.properties)

```properties
# src/test/resources/config.properties

# Base URL
base.url=http://localhost:8080/proyecto

# Browser Configuration
browser=chrome
# Opciones: chrome, firefox, edge, safari

# Headless Mode (para CI/CD)
headless=false

# Timeouts (en segundos)
implicit.wait=10
explicit.wait=15
page.load.timeout=30

# Screenshots
screenshot.on.failure=true
screenshot.on.pass=false
screenshot.dir=target/screenshots

# Test Data
test.estudiante.codigo=2020123456
test.estudiante.password=test123
test.coordinador.codigo=COORD001
test.coordinador.password=coord123
test.admin.codigo=ADMIN001
test.admin.password=admin123

# Database (para setup/teardown)
db.url=jdbc:mysql://localhost:3306/voluntariado_test
db.username=root
db.password=root
```

---

## 3. 🏗️ Page Object Model (POM)

### 3.1 ¿Qué es el Page Object Pattern?

El **Page Object Model** es un patrón de diseño que:

1. **Encapsula** elementos de UI en clases Java
2. **Separa** lógica de prueba de implementación de UI
3. **Reduce duplicación** de código
4. **Facilita mantenimiento** cuando cambia la UI

### 3.2 Estructura de Archivos

```
src/test/java/
├── ui/
│   ├── base/
│   │   ├── BaseTest.java           # Configuración común
│   │   └── BasePage.java           # Métodos reutilizables
│   ├── pages/
│   │   ├── LoginPage.java          # Page Object: Login
│   │   ├── EstudianteDashboardPage.java
│   │   ├── CampanasPage.java
│   │   ├── InscripcionesPage.java
│   │   └── PerfilPage.java
│   ├── tests/
│   │   ├── LoginUITest.java        # Tests de login
│   │   ├── EstudianteUITest.java
│   │   └── CoordinadorUITest.java
│   ├── listeners/
│   │   ├── TestListener.java       # Logging
│   │   └── ScreenshotListener.java # Capturas
│   └── utils/
│       ├── ConfigReader.java       # Lee config.properties
│       ├── DriverFactory.java      # Gestión de WebDriver
│       └── ScreenshotUtil.java     # Capturas de pantalla
```

### 3.3 BasePage.java - Clase Base para Page Objects

```java
package ui.base;

import org.openqa.selenium.*;
import org.openqa.selenium.support.PageFactory;
import org.openqa.selenium.support.ui.*;

import java.time.Duration;

import static org.awaitility.Awaitility.*;

/**
 * Clase base para todos los Page Objects.
 * Contiene métodos reutilizables para interacción con elementos.
 */
public abstract class BasePage {
    
    protected WebDriver driver;
    protected WebDriverWait wait;
    
    public BasePage(WebDriver driver) {
        this.driver = driver;
        this.wait = new WebDriverWait(driver, Duration.ofSeconds(15));
        PageFactory.initElements(driver, this);
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE ESPERA
    // ═══════════════════════════════════════════════════════
    
    /**
     * Espera hasta que el elemento sea visible.
     */
    protected WebElement waitForVisibility(By locator) {
        return wait.until(ExpectedConditions.visibilityOfElementLocated(locator));
    }
    
    /**
     * Espera hasta que el elemento sea clickeable.
     */
    protected WebElement waitForClickable(By locator) {
        return wait.until(ExpectedConditions.elementToBeClickable(locator));
    }
    
    /**
     * Espera hasta que el elemento desaparezca.
     */
    protected void waitForInvisibility(By locator) {
        wait.until(ExpectedConditions.invisibilityOfElementLocated(locator));
    }
    
    /**
     * Espera con Awaitility (para AJAX/JavaScript).
     */
    protected void awaitCondition(String description, Runnable condition) {
        await()
            .atMost(Duration.ofSeconds(10))
            .pollInterval(Duration.ofMillis(500))
            .untilAsserted(() -> condition.run());
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE INTERACCIÓN
    // ═══════════════════════════════════════════════════════
    
    /**
     * Click con espera implícita.
     */
    protected void clickElement(By locator) {
        waitForClickable(locator).click();
    }
    
    /**
     * Click con JavaScript (para elementos ocultos).
     */
    protected void clickWithJS(By locator) {
        WebElement element = driver.findElement(locator);
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("arguments[0].click();", element);
    }
    
    /**
     * Escribir texto con limpieza previa.
     */
    protected void typeText(By locator, String text) {
        WebElement element = waitForVisibility(locator);
        element.clear();
        element.sendKeys(text);
    }
    
    /**
     * Seleccionar opción de dropdown por texto visible.
     */
    protected void selectByVisibleText(By locator, String text) {
        WebElement element = waitForVisibility(locator);
        Select select = new Select(element);
        select.selectByVisibleText(text);
    }
    
    /**
     * Obtener texto de un elemento.
     */
    protected String getText(By locator) {
        return waitForVisibility(locator).getText();
    }
    
    /**
     * Verificar si elemento está presente.
     */
    protected boolean isElementPresent(By locator) {
        try {
            driver.findElement(locator);
            return true;
        } catch (NoSuchElementException e) {
            return false;
        }
    }
    
    /**
     * Scroll hasta elemento.
     */
    protected void scrollToElement(By locator) {
        WebElement element = driver.findElement(locator);
        JavascriptExecutor js = (JavascriptExecutor) driver;
        js.executeScript("arguments[0].scrollIntoView(true);", element);
    }
    
    /**
     * Esperar a que la página cargue completamente.
     */
    protected void waitForPageLoad() {
        wait.until(webDriver -> 
            ((JavascriptExecutor) webDriver)
                .executeScript("return document.readyState")
                .equals("complete")
        );
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE UTILIDAD
    // ═══════════════════════════════════════════════════════
    
    /**
     * Obtener título de la página.
     */
    public String getPageTitle() {
        return driver.getTitle();
    }
    
    /**
     * Obtener URL actual.
     */
    public String getCurrentUrl() {
        return driver.getCurrentUrl();
    }
    
    /**
     * Refrescar página.
     */
    public void refreshPage() {
        driver.navigate().refresh();
        waitForPageLoad();
    }
    
    /**
     * Aceptar alert de JavaScript.
     */
    protected void acceptAlert() {
        wait.until(ExpectedConditions.alertIsPresent());
        driver.switchTo().alert().accept();
    }
    
    /**
     * Obtener texto de alert.
     */
    protected String getAlertText() {
        Alert alert = wait.until(ExpectedConditions.alertIsPresent());
        return alert.getText();
    }
}
```

### 3.4 BaseTest.java - Configuración Común de Tests

```java
package ui.base;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;
import org.openqa.selenium.firefox.FirefoxDriver;
import org.openqa.selenium.firefox.FirefoxOptions;
import org.testng.annotations.*;
import ui.utils.ConfigReader;

import java.time.Duration;

/**
 * Clase base para todos los tests de UI.
 * Configura WebDriver antes de cada test.
 */
public abstract class BaseTest {
    
    protected WebDriver driver;
    protected ConfigReader config;
    
    @BeforeClass
    public void setUpClass() {
        config = new ConfigReader();
        setupDriver();
    }
    
    @BeforeMethod
    public void setUp() {
        // Navegar a página de login antes de cada test
        driver.get(config.getBaseUrl() + "/index.jsp");
    }
    
    @AfterMethod
    public void tearDown() {
        // Limpiar cookies y sesión
        if (driver != null) {
            driver.manage().deleteAllCookies();
        }
    }
    
    @AfterClass
    public void tearDownClass() {
        if (driver != null) {
            driver.quit();
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // CONFIGURACIÓN DE DRIVER
    // ═══════════════════════════════════════════════════════
    
    private void setupDriver() {
        String browser = config.getBrowser();
        boolean headless = config.isHeadless();
        
        switch (browser.toLowerCase()) {
            case "chrome":
                WebDriverManager.chromedriver().setup();
                ChromeOptions chromeOptions = new ChromeOptions();
                
                if (headless) {
                    chromeOptions.addArguments("--headless=new");
                }
                
                chromeOptions.addArguments("--disable-gpu");
                chromeOptions.addArguments("--no-sandbox");
                chromeOptions.addArguments("--disable-dev-shm-usage");
                chromeOptions.addArguments("--window-size=1920,1080");
                chromeOptions.addArguments("--disable-extensions");
                chromeOptions.addArguments("--disable-notifications");
                
                driver = new ChromeDriver(chromeOptions);
                break;
                
            case "firefox":
                WebDriverManager.firefoxdriver().setup();
                FirefoxOptions firefoxOptions = new FirefoxOptions();
                
                if (headless) {
                    firefoxOptions.addArguments("--headless");
                }
                
                driver = new FirefoxDriver(firefoxOptions);
                break;
                
            default:
                throw new IllegalArgumentException("Browser no soportado: " + browser);
        }
        
        // Configurar timeouts
        driver.manage().timeouts()
            .implicitlyWait(Duration.ofSeconds(config.getImplicitWait()));
        
        driver.manage().timeouts()
            .pageLoadTimeout(Duration.ofSeconds(config.getPageLoadTimeout()));
        
        // Maximizar ventana
        driver.manage().window().maximize();
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE UTILIDAD PARA TESTS
    // ═══════════════════════════════════════════════════════
    
    protected void login(String codigo, String password) {
        driver.get(config.getBaseUrl() + "/index.jsp");
        driver.findElement(By.id("codigo")).sendKeys(codigo);
        driver.findElement(By.id("password")).sendKeys(password);
        driver.findElement(By.id("btnLogin")).click();
    }
    
    protected void logout() {
        driver.findElement(By.id("btnLogout")).click();
    }
}
```

---

## 4. 🔐 Tests de Login y Autenticación

### 4.1 LoginPage.java - Page Object

```java
package ui.pages;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import ui.base.BasePage;

/**
 * Page Object para la página de Login.
 * URL: /proyecto/index.jsp
 */
public class LoginPage extends BasePage {
    
    // ═══════════════════════════════════════════════════════
    // LOCATORS (usando @FindBy)
    // ═══════════════════════════════════════════════════════
    
    @FindBy(id = "codigo")
    private WebElement codigoInput;
    
    @FindBy(id = "password")
    private WebElement passwordInput;
    
    @FindBy(id = "btnLogin")
    private WebElement loginButton;
    
    @FindBy(className = "error-message")
    private WebElement errorMessage;
    
    @FindBy(linkText = "¿Olvidaste tu contraseña?")
    private WebElement forgotPasswordLink;
    
    // Locators como By (para métodos que requieren By)
    private By codigoBy = By.id("codigo");
    private By passwordBy = By.id("password");
    private By loginButtonBy = By.id("btnLogin");
    private By errorMessageBy = By.className("error-message");
    
    // ═══════════════════════════════════════════════════════
    // CONSTRUCTOR
    // ═══════════════════════════════════════════════════════
    
    public LoginPage(WebDriver driver) {
        super(driver);
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE ACCIÓN
    // ═══════════════════════════════════════════════════════
    
    /**
     * Ingresar código de usuario.
     */
    public LoginPage enterCodigo(String codigo) {
        waitForVisibility(codigoBy);
        typeText(codigoBy, codigo);
        return this;
    }
    
    /**
     * Ingresar contraseña.
     */
    public LoginPage enterPassword(String password) {
        waitForVisibility(passwordBy);
        typeText(passwordBy, password);
        return this;
    }
    
    /**
     * Click en botón Login.
     */
    public void clickLoginButton() {
        waitForClickable(loginButtonBy);
        clickElement(loginButtonBy);
        waitForPageLoad();
    }
    
    /**
     * Login completo (método de conveniencia).
     */
    public void login(String codigo, String password) {
        enterCodigo(codigo)
            .enterPassword(password)
            .clickLoginButton();
    }
    
    /**
     * Click en "¿Olvidaste tu contraseña?".
     */
    public void clickForgotPassword() {
        forgotPasswordLink.click();
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE VERIFICACIÓN
    // ═══════════════════════════════════════════════════════
    
    /**
     * Obtener mensaje de error.
     */
    public String getErrorMessage() {
        waitForVisibility(errorMessageBy);
        return getText(errorMessageBy);
    }
    
    /**
     * Verificar si hay mensaje de error.
     */
    public boolean isErrorMessageDisplayed() {
        return isElementPresent(errorMessageBy);
    }
    
    /**
     * Verificar si el botón de login está habilitado.
     */
    public boolean isLoginButtonEnabled() {
        return loginButton.isEnabled();
    }
    
    /**
     * Obtener texto del placeholder del campo código.
     */
    public String getCodigoPlaceholder() {
        return codigoInput.getAttribute("placeholder");
    }
}
```

### 4.2 LoginUITest.java - Tests de Login

```java
package ui.tests;

import org.testng.annotations.*;
import ui.base.BaseTest;
import ui.pages.LoginPage;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests de UI para funcionalidad de Login.
 */
public class LoginUITest extends BaseTest {
    
    private LoginPage loginPage;
    
    @BeforeMethod
    public void setUpTest() {
        loginPage = new LoginPage(driver);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE LOGIN EXITOSO
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 1, description = "Login exitoso como estudiante")
    public void testLoginEstudianteExitoso() {
        // Arrange
        String codigo = config.getTestEstudianteCodigo();
        String password = config.getTestEstudiantePassword();
        
        // Act
        loginPage.login(codigo, password);
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/menu_estudiante.jsp");
        
        assertThat(driver.getTitle())
            .contains("Portal Estudiante");
    }
    
    @Test(priority = 2, description = "Login exitoso como coordinador")
    public void testLoginCoordinadorExitoso() {
        // Arrange
        String codigo = config.getTestCoordinadorCodigo();
        String password = config.getTestCoordinadorPassword();
        
        // Act
        loginPage.login(codigo, password);
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/coordinador/menu_coordinador.jsp");
    }
    
    @Test(priority = 3, description = "Login exitoso como administrador")
    public void testLoginAdminExitoso() {
        // Arrange
        String codigo = config.getTestAdminCodigo();
        String password = config.getTestAdminPassword();
        
        // Act
        loginPage.login(codigo, password);
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/administrador/menu_admin.jsp");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE LOGIN FALLIDO
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 4, description = "Login con contraseña incorrecta")
    public void testLoginPasswordIncorrecta() {
        // Arrange
        String codigo = config.getTestEstudianteCodigo();
        String passwordIncorrecta = "wrongpassword123";
        
        // Act
        loginPage.login(codigo, passwordIncorrecta);
        
        // Assert
        assertThat(loginPage.isErrorMessageDisplayed())
            .isTrue();
        
        assertThat(loginPage.getErrorMessage())
            .containsIgnoringCase("contraseña incorrecta");
        
        // Debe permanecer en página de login
        assertThat(driver.getCurrentUrl())
            .contains("/index.jsp");
    }
    
    @Test(priority = 5, description = "Login con usuario inexistente")
    public void testLoginUsuarioInexistente() {
        // Arrange
        String codigoInexistente = "9999999999";
        String password = "anypassword";
        
        // Act
        loginPage.login(codigoInexistente, password);
        
        // Assert
        assertThat(loginPage.isErrorMessageDisplayed())
            .isTrue();
        
        assertThat(loginPage.getErrorMessage())
            .containsIgnoringCase("usuario no encontrado");
    }
    
    @Test(priority = 6, description = "Login con campos vacíos")
    public void testLoginCamposVacios() {
        // Act
        loginPage.clickLoginButton();
        
        // Assert - HTML5 validation debe prevenir el submit
        assertThat(driver.getCurrentUrl())
            .contains("/index.jsp");
        
        // Verificar que los campos tienen atributo 'required'
        String codigoRequired = driver.findElement(By.id("codigo"))
            .getAttribute("required");
        
        assertThat(codigoRequired).isNotNull();
    }
    
    @Test(priority = 7, description = "Login con usuario inactivo")
    public void testLoginUsuarioInactivo() {
        // Arrange - Asumir que existe usuario de prueba inactivo
        String codigoInactivo = "INACTIVO001";
        String password = "pass123";
        
        // Act
        loginPage.login(codigoInactivo, password);
        
        // Assert
        assertThat(loginPage.isErrorMessageDisplayed())
            .isTrue();
        
        assertThat(loginPage.getErrorMessage())
            .containsIgnoringCase("usuario inactivo");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE VALIDACIONES DE FORMULARIO
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 8, description = "Placeholder visible en campos vacíos")
    public void testPlaceholdersVisibles() {
        // Assert
        assertThat(loginPage.getCodigoPlaceholder())
            .isNotEmpty();
    }
    
    @Test(priority = 9, description = "Botón login habilitado con campos llenos")
    public void testBotonLoginHabilitado() {
        // Arrange
        loginPage.enterCodigo("2020123456")
                 .enterPassword("test123");
        
        // Assert
        assertThat(loginPage.isLoginButtonEnabled())
            .isTrue();
    }
    
    @Test(priority = 10, description = "JavaScript trim espacios en blanco")
    public void testTrimEspaciosEnBlanco() {
        // Arrange
        String codigoConEspacios = "  2020123456  ";
        String password = "test123";
        
        // Act
        loginPage.login(codigoConEspacios, password);
        
        // Assert - Debe hacer trim y autenticar correctamente
        assertThat(driver.getCurrentUrl())
            .doesNotContain("/index.jsp");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE NAVEGACIÓN
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 11, description = "Click en 'Olvidé mi contraseña'")
    public void testOlvideContrasena() {
        // Act
        loginPage.clickForgotPassword();
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/recuperar_password.jsp");
    }
    
    @Test(priority = 12, description = "Presionar Enter en campo password")
    public void testEnterEnPassword() {
        // Arrange
        loginPage.enterCodigo(config.getTestEstudianteCodigo());
        
        // Act - Presionar Enter en lugar de click
        driver.findElement(By.id("password"))
              .sendKeys(config.getTestEstudiantePassword());
        
        driver.findElement(By.id("password"))
              .sendKeys(Keys.ENTER);
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/menu_estudiante.jsp");
    }
}
```

---

## 5. 🧭 Tests de Navegación

### 5.1 NavigationUITest.java

```java
package ui.tests;

import org.openqa.selenium.By;
import org.testng.annotations.*;
import ui.base.BaseTest;
import ui.pages.LoginPage;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests de navegación entre páginas.
 */
public class NavigationUITest extends BaseTest {
    
    @Test(description = "Navegación completa: Login → Dashboard → Campañas → Inscripciones")
    public void testFlujoNavegacionCompleto() {
        // 1. Login
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(
            config.getTestEstudianteCodigo(),
            config.getTestEstudiantePassword()
        );
        
        // Verificar dashboard
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/menu_estudiante.jsp");
        
        // 2. Ir a Campañas
        driver.findElement(By.linkText("Campañas Disponibles")).click();
        
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/campañas.jsp");
        
        // 3. Ir a Mis Inscripciones
        driver.findElement(By.linkText("Mis Inscripciones")).click();
        
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/inscripciones.jsp");
        
        // 4. Volver al Dashboard
        driver.findElement(By.linkText("Dashboard")).click();
        
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/menu_estudiante.jsp");
    }
    
    @Test(description = "Breadcrumb navigation funcional")
    public void testBreadcrumbNavigation() {
        // Login
        new LoginPage(driver).login(
            config.getTestEstudianteCodigo(),
            config.getTestEstudiantePassword()
        );
        
        // Ir a página profunda
        driver.findElement(By.linkText("Campañas Disponibles")).click();
        
        // Click en breadcrumb para volver
        driver.findElement(By.cssSelector(".breadcrumb a[href*='menu_estudiante']"))
              .click();
        
        // Verificar retorno
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/menu_estudiante.jsp");
    }
    
    @Test(description = "Menú lateral colapsable funciona correctamente")
    public void testMenuLateralColapsable() {
        // Login
        new LoginPage(driver).login(
            config.getTestEstudianteCodigo(),
            config.getTestEstudiantePassword()
        );
        
        // Verificar menú visible
        WebElement menu = driver.findElement(By.id("sidebar"));
        assertThat(menu.isDisplayed()).isTrue();
        
        // Colapsar menú
        driver.findElement(By.id("sidebarToggle")).click();
        
        // Verificar clase "collapsed"
        String menuClass = menu.getAttribute("class");
        assertThat(menuClass).contains("collapsed");
    }
    
    @Test(description = "Botón 'Volver' del navegador funciona correctamente")
    public void testBotonVolverNavegador() {
        // Login y navegar
        new LoginPage(driver).login(
            config.getTestEstudianteCodigo(),
            config.getTestEstudiantePassword()
        );
        
        driver.findElement(By.linkText("Campañas Disponibles")).click();
        
        String urlCampanas = driver.getCurrentUrl();
        
        // Usar botón volver del navegador
        driver.navigate().back();
        
        // Verificar que volvió
        assertThat(driver.getCurrentUrl())
            .doesNotContain(urlCampanas);
    }
}
```

---

**Continúa en Parte 2:** Tests de Estudiante, Coordinador y Admin

---

*Generado el 3 de Diciembre de 2025*  
*Selenium WebDriver 4.16.1 + TestNG 7.9.0*
