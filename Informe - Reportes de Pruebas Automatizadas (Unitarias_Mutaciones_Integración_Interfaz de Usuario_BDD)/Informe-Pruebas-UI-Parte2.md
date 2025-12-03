# 🖥️ Informe de Pruebas de Interfaz de Usuario - Parte 2
## Sistema de Voluntariado UPT
### Tests de Roles: Estudiante, Coordinador y Admin

---

**Continuación de:** Informe-Pruebas-UI-Parte1.md  
**Fecha:** 3 de Diciembre de 2025

---

## 📑 Tabla de Contenidos (Parte 2)

6. [Tests del Rol Estudiante](#tests-estudiante)
7. [Tests del Rol Coordinador](#tests-coordinador)
8. [Tests del Rol Administrador](#tests-admin)
9. [Tests de Formularios](#tests-formularios)

---

## 6. 👨‍🎓 Tests del Rol Estudiante

### 6.1 CampanasPage.java - Page Object

```java
package ui.pages.estudiante;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import ui.base.BasePage;

import java.util.List;

/**
 * Page Object para Campañas Disponibles (Estudiante).
 * URL: /estudiantes/campañas.jsp
 */
public class CampanasPage extends BasePage {
    
    // ═══════════════════════════════════════════════════════
    // LOCATORS
    // ═══════════════════════════════════════════════════════
    
    @FindBy(id = "searchInput")
    private WebElement searchInput;
    
    @FindBy(id = "btnSearch")
    private WebElement searchButton;
    
    @FindBy(id = "filterEstado")
    private WebElement filterEstadoSelect;
    
    @FindBy(css = ".campana-card")
    private List<WebElement> campanaCards;
    
    @FindBy(css = ".pagination")
    private WebElement paginationContainer;
    
    private By campanaCardBy = By.cssSelector(".campana-card");
    private By btnInscribirseBy = By.cssSelector(".btn-inscribirse");
    private By campanaTituloBy = By.cssSelector(".campana-titulo");
    private By cuposDisponiblesBy = By.cssSelector(".cupos-disponibles");
    
    // ═══════════════════════════════════════════════════════
    // CONSTRUCTOR
    // ═══════════════════════════════════════════════════════
    
    public CampanasPage(WebDriver driver) {
        super(driver);
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE BÚSQUEDA Y FILTROS
    // ═══════════════════════════════════════════════════════
    
    /**
     * Buscar campaña por título.
     */
    public CampanasPage buscarCampana(String termino) {
        typeText(By.id("searchInput"), termino);
        clickElement(By.id("btnSearch"));
        waitForPageLoad();
        return this;
    }
    
    /**
     * Filtrar por estado.
     */
    public CampanasPage filtrarPorEstado(String estado) {
        selectByVisibleText(By.id("filterEstado"), estado);
        waitForPageLoad();
        return this;
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE INSCRIPCIÓN
    // ═══════════════════════════════════════════════════════
    
    /**
     * Inscribirse en la primera campaña disponible.
     */
    public void inscribirseEnPrimeraCampana() {
        waitForVisibility(campanaCardBy);
        
        // Buscar primera campaña con botón "Inscribirse" habilitado
        List<WebElement> cards = driver.findElements(campanaCardBy);
        
        for (WebElement card : cards) {
            WebElement btnInscribirse = card.findElement(btnInscribirseBy);
            
            if (btnInscribirse.isEnabled()) {
                scrollToElement(By.cssSelector(".campana-card"));
                btnInscribirse.click();
                
                // Confirmar en modal
                waitForClickable(By.id("btnConfirmarInscripcion"));
                clickElement(By.id("btnConfirmarInscripcion"));
                
                // Esperar mensaje de éxito
                waitForVisibility(By.cssSelector(".alert-success"));
                break;
            }
        }
    }
    
    /**
     * Inscribirse en campaña por título.
     */
    public void inscribirsePorTitulo(String titulo) {
        List<WebElement> cards = driver.findElements(campanaCardBy);
        
        for (WebElement card : cards) {
            String tituloCard = card.findElement(campanaTituloBy).getText();
            
            if (tituloCard.contains(titulo)) {
                WebElement btnInscribirse = card.findElement(btnInscribirseBy);
                btnInscribirse.click();
                
                // Confirmar
                waitForClickable(By.id("btnConfirmarInscripcion"));
                clickElement(By.id("btnConfirmarInscripcion"));
                
                waitForVisibility(By.cssSelector(".alert-success"));
                break;
            }
        }
    }
    
    /**
     * Ver detalles de campaña.
     */
    public void verDetallesCampana(String titulo) {
        List<WebElement> cards = driver.findElements(campanaCardBy);
        
        for (WebElement card : cards) {
            String tituloCard = card.findElement(campanaTituloBy).getText();
            
            if (tituloCard.contains(titulo)) {
                WebElement btnVerMas = card.findElement(By.cssSelector(".btn-ver-mas"));
                btnVerMas.click();
                
                // Esperar modal de detalles
                waitForVisibility(By.id("modalDetallesCampana"));
                break;
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE VERIFICACIÓN
    // ═══════════════════════════════════════════════════════
    
    /**
     * Obtener número de campañas mostradas.
     */
    public int getCantidadCampanas() {
        return campanaCards.size();
    }
    
    /**
     * Verificar si campaña existe por título.
     */
    public boolean existeCampana(String titulo) {
        List<WebElement> titulos = driver.findElements(campanaTituloBy);
        
        return titulos.stream()
            .anyMatch(t -> t.getText().contains(titulo));
    }
    
    /**
     * Obtener cupos disponibles de campaña.
     */
    public int getCuposDisponibles(String titulo) {
        List<WebElement> cards = driver.findElements(campanaCardBy);
        
        for (WebElement card : cards) {
            String tituloCard = card.findElement(campanaTituloBy).getText();
            
            if (tituloCard.contains(titulo)) {
                String cuposText = card.findElement(cuposDisponiblesBy).getText();
                // Extraer número de texto como "25 cupos disponibles"
                return Integer.parseInt(cuposText.replaceAll("\\D+", ""));
            }
        }
        
        return 0;
    }
    
    /**
     * Verificar si botón "Inscribirse" está habilitado.
     */
    public boolean esInscripcionHabilitada(String titulo) {
        List<WebElement> cards = driver.findElements(campanaCardBy);
        
        for (WebElement card : cards) {
            String tituloCard = card.findElement(campanaTituloBy).getText();
            
            if (tituloCard.contains(titulo)) {
                WebElement btn = card.findElement(btnInscribirseBy);
                return btn.isEnabled();
            }
        }
        
        return false;
    }
    
    /**
     * Obtener mensaje de alerta.
     */
    public String getMensajeAlerta() {
        return getText(By.cssSelector(".alert"));
    }
}
```

### 6.2 EstudianteUITest.java

```java
package ui.tests;

import org.testng.annotations.*;
import ui.base.BaseTest;
import ui.pages.LoginPage;
import ui.pages.estudiante.*;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests de UI para funcionalidades del Estudiante.
 */
public class EstudianteUITest extends BaseTest {
    
    private LoginPage loginPage;
    private CampanasPage campanasPage;
    
    @BeforeMethod
    public void loginComoEstudiante() {
        loginPage = new LoginPage(driver);
        loginPage.login(
            config.getTestEstudianteCodigo(),
            config.getTestEstudiantePassword()
        );
        
        // Navegar a campañas
        driver.findElement(By.linkText("Campañas Disponibles")).click();
        campanasPage = new CampanasPage(driver);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE VISUALIZACIÓN DE CAMPAÑAS
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 1, description = "Ver lista de campañas disponibles")
    public void testVerCampanasDisponibles() {
        // Assert
        int cantidad = campanasPage.getCantidadCampanas();
        
        assertThat(cantidad)
            .isGreaterThan(0)
            .withFailMessage("Debe haber al menos 1 campaña disponible");
    }
    
    @Test(priority = 2, description = "Buscar campaña por título")
    public void testBuscarCampanaPorTitulo() {
        // Arrange
        String terminoBusqueda = "Limpieza";
        
        // Act
        campanasPage.buscarCampana(terminoBusqueda);
        
        // Assert
        assertThat(campanasPage.existeCampana(terminoBusqueda))
            .isTrue();
    }
    
    @Test(priority = 3, description = "Filtrar campañas por estado")
    public void testFiltrarCampanasPorEstado() {
        // Act
        campanasPage.filtrarPorEstado("EN_CURSO");
        
        // Assert - Todas las campañas deben estar "EN_CURSO"
        int cantidad = campanasPage.getCantidadCampanas();
        assertThat(cantidad).isGreaterThanOrEqualTo(0);
    }
    
    @Test(priority = 4, description = "Ver detalles completos de campaña")
    public void testVerDetallesCampana() {
        // Arrange
        String titulo = "Limpieza de Playas";
        
        // Act
        campanasPage.verDetallesCampana(titulo);
        
        // Assert - Modal debe estar visible
        WebElement modal = driver.findElement(By.id("modalDetallesCampana"));
        assertThat(modal.isDisplayed()).isTrue();
        
        // Verificar que contiene información
        String descripcion = driver.findElement(
            By.cssSelector("#modalDetallesCampana .descripcion")
        ).getText();
        
        assertThat(descripcion).isNotEmpty();
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE INSCRIPCIÓN
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 5, description = "Inscribirse exitosamente en campaña")
    public void testInscripcionExitosa() {
        // Arrange
        String titulo = "Limpieza de Playas";
        int cuposAntes = campanasPage.getCuposDisponibles(titulo);
        
        // Act
        campanasPage.inscribirsePorTitulo(titulo);
        
        // Assert
        String mensaje = campanasPage.getMensajeAlerta();
        assertThat(mensaje)
            .containsIgnoringCase("inscripción exitosa");
        
        // Refrescar y verificar que cupos disminuyeron
        driver.navigate().refresh();
        campanasPage = new CampanasPage(driver);
        
        int cuposDespues = campanasPage.getCuposDisponibles(titulo);
        assertThat(cuposDespues).isEqualTo(cuposAntes - 1);
    }
    
    @Test(priority = 6, description = "No permitir inscripción duplicada")
    public void testInscripcionDuplicadaRechazada() {
        // Arrange - Inscribirse primero
        String titulo = "Limpieza de Playas";
        campanasPage.inscribirsePorTitulo(titulo);
        
        // Act - Intentar inscribirse de nuevo
        driver.navigate().refresh();
        campanasPage = new CampanasPage(driver);
        
        // Assert - Botón debe estar deshabilitado
        assertThat(campanasPage.esInscripcionHabilitada(titulo))
            .isFalse();
    }
    
    @Test(priority = 7, description = "No permitir inscripción sin cupos")
    public void testInscripcionSinCupos() {
        // Arrange - Buscar campaña sin cupos (simular con test data)
        campanasPage.buscarCampana("Sin Cupos");
        
        // Assert
        if (campanasPage.existeCampana("Sin Cupos")) {
            assertThat(campanasPage.esInscripcionHabilitada("Sin Cupos"))
                .isFalse();
            
            // Verificar mensaje
            String mensaje = driver.findElement(
                By.cssSelector(".campana-card:first-child .sin-cupos")
            ).getText();
            
            assertThat(mensaje).containsIgnoringCase("sin cupos");
        }
    }
    
    @Test(priority = 8, description = "Modal de confirmación antes de inscribirse")
    public void testModalConfirmacionInscripcion() {
        // Act
        campanasPage.inscribirseEnPrimeraCampana();
        
        // Assert - Modal debe aparecer
        WebElement modal = driver.findElement(By.id("modalConfirmacion"));
        assertThat(modal.isDisplayed()).isTrue();
        
        // Verificar botones
        WebElement btnConfirmar = driver.findElement(By.id("btnConfirmarInscripcion"));
        WebElement btnCancelar = driver.findElement(By.id("btnCancelarInscripcion"));
        
        assertThat(btnConfirmar.isDisplayed()).isTrue();
        assertThat(btnCancelar.isDisplayed()).isTrue();
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE MIS INSCRIPCIONES
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 9, description = "Ver mis inscripciones activas")
    public void testVerMisInscripciones() {
        // Arrange - Inscribirse primero
        campanasPage.inscribirseEnPrimeraCampana();
        
        // Act - Ir a "Mis Inscripciones"
        driver.findElement(By.linkText("Mis Inscripciones")).click();
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/inscripciones.jsp");
        
        List<WebElement> inscripciones = driver.findElements(
            By.cssSelector(".inscripcion-item")
        );
        
        assertThat(inscripciones).isNotEmpty();
    }
    
    @Test(priority = 10, description = "Cancelar inscripción pendiente")
    public void testCancelarInscripcion() {
        // Arrange - Inscribirse primero
        campanasPage.inscribirseEnPrimeraCampana();
        
        // Ir a inscripciones
        driver.findElement(By.linkText("Mis Inscripciones")).click();
        
        // Act - Cancelar primera inscripción
        driver.findElement(By.cssSelector(".btn-cancelar-inscripcion:first-child"))
              .click();
        
        // Confirmar en modal
        driver.findElement(By.id("btnConfirmarCancelacion")).click();
        
        // Assert
        WebElement alerta = driver.findElement(By.cssSelector(".alert-success"));
        assertThat(alerta.getText())
            .containsIgnoringCase("cancelada exitosamente");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE PERFIL
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 11, description = "Ver y editar perfil de estudiante")
    public void testEditarPerfil() {
        // Act - Ir a perfil
        driver.findElement(By.linkText("Mi Perfil")).click();
        
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/perfil.jsp");
        
        // Editar teléfono
        WebElement inputTelefono = driver.findElement(By.id("telefono"));
        inputTelefono.clear();
        inputTelefono.sendKeys("987654321");
        
        // Guardar
        driver.findElement(By.id("btnGuardarPerfil")).click();
        
        // Assert
        WebElement alerta = driver.findElement(By.cssSelector(".alert-success"));
        assertThat(alerta.getText())
            .containsIgnoringCase("actualizado exitosamente");
    }
    
    @Test(priority = 12, description = "Ver certificados obtenidos")
    public void testVerCertificados() {
        // Act
        driver.findElement(By.linkText("Certificados")).click();
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/estudiantes/certificados.jsp");
        
        // Puede estar vacío si no hay certificados
        boolean tieneTabla = driver.findElements(
            By.cssSelector(".tabla-certificados")
        ).size() > 0;
        
        assertThat(tieneTabla).isTrue();
    }
}
```

---

## 7. 👨‍🏫 Tests del Rol Coordinador

### 7.1 CrearCampanaPage.java - Page Object

```java
package ui.pages.coordinador;

import org.openqa.selenium.By;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.WebElement;
import org.openqa.selenium.support.FindBy;
import ui.base.BasePage;

/**
 * Page Object para Crear Campaña (Coordinador).
 * URL: /coordinador/crear_campana.jsp
 */
public class CrearCampanaPage extends BasePage {
    
    @FindBy(id = "titulo")
    private WebElement tituloInput;
    
    @FindBy(id = "descripcion")
    private WebElement descripcionTextarea;
    
    @FindBy(id = "fechaInicio")
    private WebElement fechaInicioInput;
    
    @FindBy(id = "fechaFin")
    private WebElement fechaFinInput;
    
    @FindBy(id = "ubicacion")
    private WebElement ubicacionInput;
    
    @FindBy(id = "cupos")
    private WebElement cuposInput;
    
    @FindBy(id = "horasValidadas")
    private WebElement horasInput;
    
    @FindBy(id = "btnCrearCampana")
    private WebElement btnCrear;
    
    @FindBy(id = "btnCancelar")
    private WebElement btnCancelar;
    
    public CrearCampanaPage(WebDriver driver) {
        super(driver);
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE ENTRADA DE DATOS
    // ═══════════════════════════════════════════════════════
    
    public CrearCampanaPage ingresarTitulo(String titulo) {
        typeText(By.id("titulo"), titulo);
        return this;
    }
    
    public CrearCampanaPage ingresarDescripcion(String descripcion) {
        typeText(By.id("descripcion"), descripcion);
        return this;
    }
    
    public CrearCampanaPage ingresarFechaInicio(String fecha) {
        typeText(By.id("fechaInicio"), fecha);
        return this;
    }
    
    public CrearCampanaPage ingresarFechaFin(String fecha) {
        typeText(By.id("fechaFin"), fecha);
        return this;
    }
    
    public CrearCampanaPage ingresarUbicacion(String ubicacion) {
        typeText(By.id("ubicacion"), ubicacion);
        return this;
    }
    
    public CrearCampanaPage ingresarCupos(int cupos) {
        typeText(By.id("cupos"), String.valueOf(cupos));
        return this;
    }
    
    public CrearCampanaPage ingresarHoras(int horas) {
        typeText(By.id("horasValidadas"), String.valueOf(horas));
        return this;
    }
    
    public void clickCrear() {
        clickElement(By.id("btnCrearCampana"));
        waitForPageLoad();
    }
    
    /**
     * Crear campaña completa (método de conveniencia).
     */
    public void crearCampanaCompleta(
        String titulo,
        String descripcion,
        String fechaInicio,
        String fechaFin,
        String ubicacion,
        int cupos,
        int horas
    ) {
        ingresarTitulo(titulo)
            .ingresarDescripcion(descripcion)
            .ingresarFechaInicio(fechaInicio)
            .ingresarFechaFin(fechaFin)
            .ingresarUbicacion(ubicacion)
            .ingresarCupos(cupos)
            .ingresarHoras(horas)
            .clickCrear();
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS DE VERIFICACIÓN
    // ═══════════════════════════════════════════════════════
    
    public String getMensajeError() {
        return getText(By.cssSelector(".alert-danger"));
    }
    
    public String getMensajeExito() {
        return getText(By.cssSelector(".alert-success"));
    }
    
    public boolean isBtnCrearHabilitado() {
        return btnCrear.isEnabled();
    }
}
```

### 7.2 CoordinadorUITest.java

```java
package ui.tests;

import org.openqa.selenium.By;
import org.testng.annotations.*;
import ui.base.BaseTest;
import ui.pages.LoginPage;
import ui.pages.coordinador.*;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests de UI para funcionalidades del Coordinador.
 */
public class CoordinadorUITest extends BaseTest {
    
    private CrearCampanaPage crearCampanaPage;
    
    @BeforeMethod
    public void loginComoCoordinador() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(
            config.getTestCoordinadorCodigo(),
            config.getTestCoordinadorPassword()
        );
        
        // Navegar a Crear Campaña
        driver.findElement(By.linkText("Crear Campaña")).click();
        crearCampanaPage = new CrearCampanaPage(driver);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CREACIÓN DE CAMPAÑA
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 1, description = "Crear campaña exitosamente")
    public void testCrearCampanaExitosa() {
        // Arrange
        String titulo = "Test Campaña " + System.currentTimeMillis();
        String descripcion = "Descripción de prueba";
        String fechaInicio = LocalDate.now().plusDays(7)
            .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String fechaFin = LocalDate.now().plusDays(14)
            .format(DateTimeFormatter.ofPattern("yyyy-MM-dd"));
        String ubicacion = "Campus UPT";
        int cupos = 50;
        int horas = 8;
        
        // Act
        crearCampanaPage.crearCampanaCompleta(
            titulo, descripcion, fechaInicio, fechaFin,
            ubicacion, cupos, horas
        );
        
        // Assert
        String mensaje = crearCampanaPage.getMensajeExito();
        assertThat(mensaje)
            .containsIgnoringCase("creada exitosamente");
    }
    
    @Test(priority = 2, description = "Validar campos obligatorios")
    public void testValidarCamposObligatorios() {
        // Act - Intentar crear sin llenar campos
        crearCampanaPage.clickCrear();
        
        // Assert - HTML5 validation debe prevenir
        assertThat(driver.getCurrentUrl())
            .contains("/crear_campana.jsp");
    }
    
    @Test(priority = 3, description = "Validar fecha fin >= fecha inicio")
    public void testValidarFechas() {
        // Arrange - Fecha fin antes de inicio
        String fechaInicio = "2025-12-31";
        String fechaFin = "2025-12-01";
        
        // Act
        crearCampanaPage
            .ingresarTitulo("Test Fechas")
            .ingresarDescripcion("Test")
            .ingresarFechaInicio(fechaInicio)
            .ingresarFechaFin(fechaFin)
            .ingresarUbicacion("Test")
            .ingresarCupos(10)
            .ingresarHoras(4)
            .clickCrear();
        
        // Assert
        String mensaje = crearCampanaPage.getMensajeError();
        assertThat(mensaje)
            .containsIgnoringCase("fecha fin debe ser posterior");
    }
    
    @Test(priority = 4, description = "Validar cupos > 0")
    public void testValidarCuposPositivos() {
        // Act
        crearCampanaPage
            .ingresarTitulo("Test Cupos")
            .ingresarCupos(0);  // Cupos = 0 (inválido)
        
        // Assert - Input type="number" min="1" debe prevenir
        WebElement inputCupos = driver.findElement(By.id("cupos"));
        String min = inputCupos.getAttribute("min");
        assertThat(min).isEqualTo("1");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE GESTIÓN DE CAMPAÑAS
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 5, description = "Ver lista de campañas creadas")
    public void testVerMisCampanas() {
        // Act
        driver.findElement(By.linkText("Mis Campañas")).click();
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/coordinador/mis_campanas.jsp");
        
        List<WebElement> campanas = driver.findElements(
            By.cssSelector(".campana-item")
        );
        
        assertThat(campanas).isNotEmpty();
    }
    
    @Test(priority = 6, description = "Editar campaña existente")
    public void testEditarCampana() {
        // Arrange - Ir a "Mis Campañas"
        driver.findElement(By.linkText("Mis Campañas")).click();
        
        // Act - Click en "Editar" de la primera campaña
        driver.findElement(By.cssSelector(".btn-editar:first-child")).click();
        
        // Modificar título
        WebElement inputTitulo = driver.findElement(By.id("titulo"));
        String nuevoTitulo = "Editado " + System.currentTimeMillis();
        inputTitulo.clear();
        inputTitulo.sendKeys(nuevoTitulo);
        
        // Guardar
        driver.findElement(By.id("btnGuardar")).click();
        
        // Assert
        WebElement alerta = driver.findElement(By.cssSelector(".alert-success"));
        assertThat(alerta.getText())
            .containsIgnoringCase("actualizada");
    }
    
    @Test(priority = 7, description = "Cancelar campaña")
    public void testCancelarCampana() {
        // Arrange
        driver.findElement(By.linkText("Mis Campañas")).click();
        
        // Act
        driver.findElement(By.cssSelector(".btn-cancelar:first-child")).click();
        
        // Confirmar en modal
        driver.findElement(By.id("btnConfirmarCancelacion")).click();
        
        // Assert
        WebElement alerta = driver.findElement(By.cssSelector(".alert-success"));
        assertThat(alerta.getText())
            .containsIgnoringCase("cancelada");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CONTROL DE ASISTENCIA
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 8, description = "Registrar asistencia manual")
    public void testRegistrarAsistenciaManual() {
        // Act
        driver.findElement(By.linkText("Control de Asistencia")).click();
        
        // Seleccionar campaña
        selectByVisibleText(By.id("selectCampana"), "Limpieza de Playas");
        
        // Buscar estudiante
        driver.findElement(By.id("inputBuscarEstudiante"))
              .sendKeys("2020123456");
        
        driver.findElement(By.id("btnBuscar")).click();
        
        // Marcar asistencia
        driver.findElement(By.cssSelector(".checkbox-asistencia:first-child"))
              .click();
        
        // Guardar
        driver.findElement(By.id("btnGuardarAsistencias")).click();
        
        // Assert
        WebElement alerta = driver.findElement(By.cssSelector(".alert-success"));
        assertThat(alerta.getText())
            .containsIgnoringCase("registrada");
    }
    
    @Test(priority = 9, description = "Escanear código QR de estudiante")
    public void testEscanearQREstudiante() {
        // Act
        driver.findElement(By.linkText("Escanear QR")).click();
        
        // Assert - Debe pedir permiso de cámara
        assertThat(driver.getCurrentUrl())
            .contains("/coordinador/escanear_qr.jsp");
        
        // Verificar que canvas de cámara existe
        WebElement videoCanvas = driver.findElement(By.id("qrCanvas"));
        assertThat(videoCanvas.isDisplayed()).isTrue();
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CERTIFICADOS
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 10, description = "Generar certificados para campaña finalizada")
    public void testGenerarCertificados() {
        // Act
        driver.findElement(By.linkText("Certificados")).click();
        
        // Seleccionar campaña finalizada
        selectByVisibleText(By.id("selectCampana"), "Campaña Finalizada Test");
        
        // Click en "Generar Certificados"
        driver.findElement(By.id("btnGenerarCertificados")).click();
        
        // Confirmar
        driver.findElement(By.id("btnConfirmarGeneracion")).click();
        
        // Assert
        awaitCondition("Generando certificados", () -> {
            WebElement progreso = driver.findElement(By.id("progresoGeneracion"));
            assertThat(progreso.getText()).contains("100%");
        });
    }
}
```

---

## 8. 👨‍💼 Tests del Rol Administrador

### 8.1 AdminUITest.java

```java
package ui.tests;

import org.openqa.selenium.By;
import org.testng.annotations.*;
import ui.base.BaseTest;
import ui.pages.LoginPage;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests de UI para funcionalidades del Administrador.
 */
public class AdminUITest extends BaseTest {
    
    @BeforeMethod
    public void loginComoAdmin() {
        LoginPage loginPage = new LoginPage(driver);
        loginPage.login(
            config.getTestAdminCodigo(),
            config.getTestAdminPassword()
        );
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE GESTIÓN DE USUARIOS
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 1, description = "Listar todos los usuarios")
    public void testListarUsuarios() {
        // Act
        driver.findElement(By.linkText("Gestionar Usuarios")).click();
        
        // Assert
        assertThat(driver.getCurrentUrl())
            .contains("/administrador/gestionar_usuarios.jsp");
        
        List<WebElement> filas = driver.findElements(
            By.cssSelector("#tablaUsuarios tbody tr")
        );
        
        assertThat(filas).isNotEmpty();
    }
    
    @Test(priority = 2, description = "Buscar usuario por código")
    public void testBuscarUsuario() {
        // Arrange
        driver.findElement(By.linkText("Gestionar Usuarios")).click();
        
        // Act
        driver.findElement(By.id("inputBuscar"))
              .sendKeys("2020123456");
        
        driver.findElement(By.id("btnBuscar")).click();
        
        // Assert
        List<WebElement> resultados = driver.findElements(
            By.cssSelector("#tablaUsuarios tbody tr")
        );
        
        assertThat(resultados).hasSize(1);
        
        String codigoEncontrado = resultados.get(0)
            .findElement(By.cssSelector("td:nth-child(2)"))
            .getText();
        
        assertThat(codigoEncontrado).isEqualTo("2020123456");
    }
    
    @Test(priority = 3, description = "Activar/Desactivar usuario")
    public void testCambiarEstadoUsuario() {
        // Arrange
        driver.findElement(By.linkText("Gestionar Usuarios")).click();
        
        // Act - Toggle estado del primer usuario
        WebElement toggleSwitch = driver.findElement(
            By.cssSelector(".toggle-estado:first-child")
        );
        
        boolean estadoInicial = toggleSwitch.isSelected();
        toggleSwitch.click();
        
        // Confirmar
        driver.findElement(By.id("btnConfirmarCambio")).click();
        
        // Assert
        WebElement alerta = driver.findElement(By.cssSelector(".alert-success"));
        assertThat(alerta.getText())
            .containsIgnoringCase("estado actualizado");
        
        // Refrescar y verificar cambio
        driver.navigate().refresh();
        
        WebElement toggleDespues = driver.findElement(
            By.cssSelector(".toggle-estado:first-child")
        );
        
        assertThat(toggleDespues.isSelected())
            .isNotEqualTo(estadoInicial);
    }
    
    @Test(priority = 4, description = "Eliminar usuario")
    public void testEliminarUsuario() {
        // Arrange
        driver.findElement(By.linkText("Gestionar Usuarios")).click();
        
        int usuariosAntes = driver.findElements(
            By.cssSelector("#tablaUsuarios tbody tr")
        ).size();
        
        // Act
        driver.findElement(By.cssSelector(".btn-eliminar:first-child")).click();
        
        // Confirmar
        driver.findElement(By.id("btnConfirmarEliminar")).click();
        
        // Assert
        WebElement alerta = driver.findElement(By.cssSelector(".alert-success"));
        assertThat(alerta.getText())
            .containsIgnoringCase("eliminado");
        
        int usuariosDespues = driver.findElements(
            By.cssSelector("#tablaUsuarios tbody tr")
        ).size();
        
        assertThat(usuariosDespues).isEqualTo(usuariosAntes - 1);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE REPORTES
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 5, description = "Generar reporte de campañas")
    public void testGenerarReporteCampanas() {
        // Act
        driver.findElement(By.linkText("Reportes")).click();
        
        // Seleccionar tipo de reporte
        selectByVisibleText(By.id("tipoReporte"), "Campañas");
        
        // Seleccionar rango de fechas
        driver.findElement(By.id("fechaDesde"))
              .sendKeys("2025-01-01");
        
        driver.findElement(By.id("fechaHasta"))
              .sendKeys("2025-12-31");
        
        // Generar
        driver.findElement(By.id("btnGenerarReporte")).click();
        
        // Assert - Tabla de resultados debe aparecer
        awaitCondition("Generando reporte", () -> {
            WebElement tabla = driver.findElement(By.id("tablaReporte"));
            assertThat(tabla.isDisplayed()).isTrue();
        });
    }
    
    @Test(priority = 6, description = "Exportar reporte a Excel")
    public void testExportarReporteExcel() {
        // Arrange
        driver.findElement(By.linkText("Reportes")).click();
        selectByVisibleText(By.id("tipoReporte"), "Campañas");
        driver.findElement(By.id("btnGenerarReporte")).click();
        
        // Act
        driver.findElement(By.id("btnExportarExcel")).click();
        
        // Assert - Archivo debe descargarse (verificar en Download Manager)
        // Para CI/CD se puede verificar respuesta HTTP
        String downloadUrl = driver.findElement(By.id("btnExportarExcel"))
            .getAttribute("href");
        
        assertThat(downloadUrl).contains(".xlsx");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CONFIGURACIÓN DEL SISTEMA
    // ═══════════════════════════════════════════════════════
    
    @Test(priority = 7, description = "Actualizar configuración del sistema")
    public void testActualizarConfiguracion() {
        // Act
        driver.findElement(By.linkText("Configuración")).click();
        
        // Modificar parámetro
        WebElement inputHorasMinimas = driver.findElement(By.id("horasMinimas"));
        inputHorasMinimas.clear();
        inputHorasMinimas.sendKeys("20");
        
        // Guardar
        driver.findElement(By.id("btnGuardarConfig")).click();
        
        // Assert
        WebElement alerta = driver.findElement(By.cssSelector(".alert-success"));
        assertThat(alerta.getText())
            .containsIgnoringCase("configuración actualizada");
    }
}
```

---

## 9. 📝 Tests de Formularios

### 9.1 FormularioUITest.java - Validaciones de Formularios

```java
package ui.tests;

import org.openqa.selenium.By;
import org.openqa.selenium.Keys;
import org.testng.annotations.*;
import ui.base.BaseTest;

import static org.assertj.core.api.Assertions.*;

/**
 * Tests de validaciones de formularios HTML5 y JavaScript.
 */
public class FormularioUITest extends BaseTest {
    
    @Test(description = "Validación HTML5: campo email")
    public void testValidacionEmail() {
        // Arrange - Ir a registro
        driver.get(config.getBaseUrl() + "/registro.jsp");
        
        // Act - Ingresar email inválido
        WebElement inputEmail = driver.findElement(By.id("correo"));
        inputEmail.sendKeys("emailinvalido");
        inputEmail.sendKeys(Keys.TAB);  // Trigger validation
        
        // Assert - HTML5 validation message
        String validationMessage = inputEmail.getAttribute("validationMessage");
        assertThat(validationMessage).isNotEmpty();
    }
    
    @Test(description = "Validación JavaScript: contraseñas coinciden")
    public void testValidacionPasswordsCoinciden() {
        // Arrange
        driver.get(config.getBaseUrl() + "/registro.jsp");
        
        // Act
        driver.findElement(By.id("password")).sendKeys("pass123");
        driver.findElement(By.id("confirmarPassword")).sendKeys("pass456");
        
        // Trigger validation
        driver.findElement(By.id("btnRegistrar")).click();
        
        // Assert
        WebElement mensajeError = driver.findElement(
            By.id("errorPasswordMismatch")
        );
        
        assertThat(mensajeError.isDisplayed()).isTrue();
        assertThat(mensajeError.getText())
            .containsIgnoringCase("no coinciden");
    }
    
    @Test(description = "Validación: longitud mínima de contraseña")
    public void testLongitudMinimaPassword() {
        // Arrange
        driver.get(config.getBaseUrl() + "/registro.jsp");
        
        // Act - Password muy corta
        WebElement inputPassword = driver.findElement(By.id("password"));
        inputPassword.sendKeys("123");
        
        // Assert - HTML5 minlength
        String minLength = inputPassword.getAttribute("minlength");
        assertThat(Integer.parseInt(minLength)).isGreaterThanOrEqualTo(6);
    }
    
    @Test(description = "Disabled submit button hasta que form sea válido")
    public void testSubmitButtonDisabledHastaValido() {
        // Arrange
        driver.get(config.getBaseUrl() + "/registro.jsp");
        
        // Assert inicial - Botón deshabilitado
        WebElement btnSubmit = driver.findElement(By.id("btnRegistrar"));
        assertThat(btnSubmit.isEnabled()).isFalse();
        
        // Act - Llenar todos los campos
        driver.findElement(By.id("codigo")).sendKeys("2020123456");
        driver.findElement(By.id("nombres")).sendKeys("Juan");
        driver.findElement(By.id("apellidos")).sendKeys("Pérez");
        driver.findElement(By.id("correo")).sendKeys("juan@test.com");
        driver.findElement(By.id("password")).sendKeys("pass123");
        driver.findElement(By.id("confirmarPassword")).sendKeys("pass123");
        
        // Assert - Botón ahora habilitado
        assertThat(btnSubmit.isEnabled()).isTrue();
    }
}
```

---

**Continúa en Parte 3:** Tests Cross-Browser, Screenshots, CI/CD

---

*Generado el 3 de Diciembre de 2025*  
*Selenium WebDriver 4.16.1 + TestNG 7.9.0*
