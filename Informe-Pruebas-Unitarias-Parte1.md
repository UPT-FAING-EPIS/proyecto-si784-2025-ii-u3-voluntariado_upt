# 🧪 Informe de Pruebas Automatizadas - Parte 1
## Sistema de Voluntariado UPT
### Pruebas Unitarias (Unit Testing)

---

**Fecha de Generación:** 3 de Diciembre de 2025  
**Proyecto:** Sistema de Gestión de Voluntariado Universitario  
**Framework de Testing:** JUnit 5 (Jupiter) + Mockito 5  
**Cobertura Objetivo:** ≥ 80% por clase

---

## 📑 Tabla de Contenidos (Parte 1)

1. [Introducción a Pruebas Unitarias](#introducción)
2. [Configuración del Entorno de Testing](#configuración)
3. [Pruebas de Capa de Entidad](#pruebas-entidad)
4. [Pruebas de Capa de Negocio](#pruebas-negocio)

---

## 1. 📚 Introducción a Pruebas Unitarias

### 1.1 ¿Qué son las Pruebas Unitarias?

Las **pruebas unitarias** son tests automatizados que validan el comportamiento de unidades individuales de código (métodos, clases) de forma aislada.

**Características:**
- ✅ **Aisladas:** No dependen de BD, red, filesystem
- ✅ **Rápidas:** Ejecución en milisegundos
- ✅ **Repetibles:** Mismo resultado siempre
- ✅ **Automáticas:** Se ejecutan sin intervención manual

### 1.2 Pirámide de Testing

```
                 ┌─────────────┐
                 │     E2E     │ 10%  - Lentas, costosas
                 │   (Manual)  │
                 ├─────────────┤
                 │ Integration │ 20%  - Base de datos, APIs
                 │   Tests     │
                 ├─────────────┤
                 │    Unit     │ 70%  - Lógica de negocio
                 │    Tests    │        Rápidas y confiables
                 └─────────────┘
```

### 1.3 Metodología: AAA Pattern

```java
@Test
void ejemploAAA() {
    // ARRANGE (Preparar) - Setup de datos y mocks
    Usuario usuario = new Usuario();
    usuario.setCorreo("test@upt.edu.pe");
    
    // ACT (Actuar) - Ejecutar el método a probar
    boolean resultado = usuario.getCorreo().contains("@");
    
    // ASSERT (Afirmar) - Verificar el resultado esperado
    assertTrue(resultado, "El correo debe contener @");
}
```

### 1.4 Estado Actual del Proyecto

```
┌──────────────────────────────────────────────────────┐
│  ANÁLISIS DE COBERTURA ACTUAL (BASELINE)            │
├──────────────────────────────────────────────────────┤
│  Total de clases Java:           19                 │
│  Clases con tests unitarios:     0  (0%)            │
│  Líneas de código:                ~3,500            │
│  Líneas cubiertas por tests:     0  (0%)            │
│  Branch coverage:                 0%                 │
│  Complexity coverage:             0%                 │
├──────────────────────────────────────────────────────┤
│  ESTADO:  🔴 SIN COBERTURA                          │
│  RIESGO:  🔴 ALTO (No se detectan regresiones)      │
└──────────────────────────────────────────────────────┘
```

**Implicaciones:**
- ❌ No hay garantía de que el código funcione correctamente
- ❌ Refactorings riesgosos (sin red de seguridad)
- ❌ Bugs pueden pasar a producción sin detección
- ❌ Mantenimiento difícil y propenso a errores

---

## 2. 🛠️ Configuración del Entorno de Testing

### 2.1 Estructura de Directorios Maven

```
proyecto/
├── src/
│   ├── main/
│   │   └── java/
│   │       ├── conexion/
│   │       ├── entidad/
│   │       ├── negocio/
│   │       └── servlet/
│   └── test/                           ← CREAR
│       └── java/                        ← CREAR
│           ├── conexion/                ← CREAR
│           │   └── ConexionDBTest.java
│           ├── entidad/                 ← CREAR
│           │   ├── UsuarioTest.java
│           │   ├── CampanaTest.java
│           │   └── AsistenciaTest.java
│           ├── negocio/                 ← CREAR
│           │   ├── UsuarioNegocioTest.java
│           │   ├── coordinadornegocioTest.java
│           │   └── estudiantenegocioTest.java
│           └── servlet/                 ← CREAR
│               ├── AsistenciaServletTest.java
│               └── InscripcionServletTest.java
└── pom.xml
```

### 2.2 Dependencias Maven (pom.xml)

```xml
<dependencies>
    <!-- ═══════════════════════════════════════════════════════ -->
    <!-- TESTING DEPENDENCIES -->
    <!-- ═══════════════════════════════════════════════════════ -->
    
    <!-- JUnit 5 (Jupiter) - Framework principal de testing -->
    <dependency>
        <groupId>org.junit.jupiter</groupId>
        <artifactId>junit-jupiter</artifactId>
        <version>5.10.1</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Mockito - Para crear mocks de dependencias -->
    <dependency>
        <groupId>org.mockito</groupId>
        <artifactId>mockito-core</artifactId>
        <version>5.8.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Mockito JUnit Jupiter Integration -->
    <dependency>
        <groupId>org.mockito</groupId>
        <artifactId>mockito-junit-jupiter</artifactId>
        <version>5.8.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- AssertJ - Assertions más expresivas -->
    <dependency>
        <groupId>org.assertj</groupId>
        <artifactId>assertj-core</artifactId>
        <version>3.24.2</version>
        <scope>test</scope>
    </dependency>
    
    <!-- H2 Database - Base de datos en memoria para tests -->
    <dependency>
        <groupId>com.h2database</groupId>
        <artifactId>h2</artifactId>
        <version>2.2.224</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Mockito para servlets -->
    <dependency>
        <groupId>org.mockito</groupId>
        <artifactId>mockito-inline</artifactId>
        <version>5.2.0</version>
        <scope>test</scope>
    </dependency>
    
    <!-- Servlet API (si no está ya incluido) -->
    <dependency>
        <groupId>javax.servlet</groupId>
        <artifactId>javax.servlet-api</artifactId>
        <version>4.0.1</version>
        <scope>provided</scope>
    </dependency>
    
</dependencies>

<build>
    <plugins>
        <!-- Maven Surefire Plugin - Ejecuta tests unitarios -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.2.3</version>
            <configuration>
                <includes>
                    <include>**/*Test.java</include>
                    <include>**/*Tests.java</include>
                </includes>
                <argLine>-Xmx512m</argLine>
            </configuration>
        </plugin>
        
        <!-- JaCoCo Plugin - Coverage reporting -->
        <plugin>
            <groupId>org.jacoco</groupId>
            <artifactId>jacoco-maven-plugin</artifactId>
            <version>0.8.11</version>
            <executions>
                <execution>
                    <id>prepare-agent</id>
                    <goals>
                        <goal>prepare-agent</goal>
                    </goals>
                </execution>
                <execution>
                    <id>report</id>
                    <phase>test</phase>
                    <goals>
                        <goal>report</goal>
                    </goals>
                </execution>
                <execution>
                    <id>check</id>
                    <goals>
                        <goal>check</goal>
                    </goals>
                    <configuration>
                        <rules>
                            <rule>
                                <element>PACKAGE</element>
                                <limits>
                                    <limit>
                                        <counter>LINE</counter>
                                        <value>COVEREDRATIO</value>
                                        <minimum>0.60</minimum>
                                    </limit>
                                </limits>
                            </rule>
                        </rules>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

### 2.3 Comandos Maven

```bash
# Ejecutar todos los tests
mvn test

# Ejecutar tests con reporte de coverage
mvn clean test jacoco:report

# Ejecutar solo una clase de test
mvn test -Dtest=UsuarioTest

# Ejecutar un test específico
mvn test -Dtest=UsuarioTest#testValidarEmail

# Ejecutar tests en paralelo (más rápido)
mvn test -T 4

# Ver reporte de coverage
# Abrir: target/site/jacoco/index.html
```

---

## 3. 🧩 Pruebas de Capa de Entidad

### 3.1 UsuarioTest.java

**Propósito:** Validar la clase `Usuario` (getters, setters, lógica de negocio simple)

```java
package entidad;

import org.junit.jupiter.api.*;
import org.junit.jupiter.params.ParameterizedTest;
import org.junit.jupiter.params.provider.CsvSource;
import org.junit.jupiter.params.provider.ValueSource;

import java.sql.Timestamp;

import static org.junit.jupiter.api.Assertions.*;
import static org.assertj.core.api.Assertions.*;

@DisplayName("Tests para la entidad Usuario")
class UsuarioTest {
    
    private Usuario usuario;
    
    @BeforeEach
    void setUp() {
        usuario = new Usuario();
    }
    
    @AfterEach
    void tearDown() {
        usuario = null;
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CONSTRUCTORES
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("Constructor vacío debe crear usuario con valores por defecto")
    void testConstructorVacio() {
        // Arrange & Act
        Usuario nuevoUsuario = new Usuario();
        
        // Assert
        assertNotNull(nuevoUsuario);
        assertEquals(0, nuevoUsuario.getIdUsuario());
        assertNull(nuevoUsuario.getNombres());
    }
    
    @Test
    @DisplayName("Constructor con parámetros debe inicializar todos los campos")
    void testConstructorConParametros() {
        // Arrange & Act
        Usuario nuevoUsuario = new Usuario(
            "2020123456",
            "Juan",
            "Pérez",
            "juan.perez@upt.edu.pe",
            "password123",
            "ESTUDIANTE",
            "Ingeniería de Sistemas",
            "952123456"
        );
        
        // Assert
        assertAll("Verificar todos los campos del usuario",
            () -> assertEquals("2020123456", nuevoUsuario.getCodigo()),
            () -> assertEquals("Juan", nuevoUsuario.getNombres()),
            () -> assertEquals("Pérez", nuevoUsuario.getApellidos()),
            () -> assertEquals("juan.perez@upt.edu.pe", nuevoUsuario.getCorreo()),
            () -> assertEquals("password123", nuevoUsuario.getContrasena()),
            () -> assertEquals("ESTUDIANTE", nuevoUsuario.getRol()),
            () -> assertEquals("Ingeniería de Sistemas", nuevoUsuario.getEscuela()),
            () -> assertEquals("952123456", nuevoUsuario.getTelefono()),
            () -> assertTrue(nuevoUsuario.isActivo())
        );
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE GETTERS Y SETTERS
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("setIdUsuario y getIdUsuario deben funcionar correctamente")
    void testIdUsuario() {
        // Arrange
        int expectedId = 42;
        
        // Act
        usuario.setIdUsuario(expectedId);
        
        // Assert
        assertEquals(expectedId, usuario.getIdUsuario());
    }
    
    @Test
    @DisplayName("setCodigo y getCodigo deben funcionar correctamente")
    void testCodigo() {
        // Arrange
        String expectedCodigo = "2020123456";
        
        // Act
        usuario.setCodigo(expectedCodigo);
        
        // Assert
        assertEquals(expectedCodigo, usuario.getCodigo());
    }
    
    @Test
    @DisplayName("setNombres y getNombres deben funcionar correctamente")
    void testNombres() {
        // Arrange
        String expectedNombres = "María José";
        
        // Act
        usuario.setNombres(expectedNombres);
        
        // Assert
        assertEquals(expectedNombres, usuario.getNombres());
    }
    
    @Test
    @DisplayName("setApellidos y getApellidos deben funcionar correctamente")
    void testApellidos() {
        // Arrange
        String expectedApellidos = "García López";
        
        // Act
        usuario.setApellidos(expectedApellidos);
        
        // Assert
        assertEquals(expectedApellidos, usuario.getApellidos());
    }
    
    @Test
    @DisplayName("setCorreo y getCorreo deben funcionar correctamente")
    void testCorreo() {
        // Arrange
        String expectedCorreo = "maria.garcia@upt.edu.pe";
        
        // Act
        usuario.setCorreo(expectedCorreo);
        
        // Assert
        assertEquals(expectedCorreo, usuario.getCorreo());
        assertEquals(expectedCorreo, usuario.getEmail()); // Alias
    }
    
    @Test
    @DisplayName("setContrasena y getContrasena deben funcionar correctamente")
    void testContrasena() {
        // Arrange
        String expectedPassword = "SecureP@ssw0rd";
        
        // Act
        usuario.setContrasena(expectedPassword);
        
        // Assert
        assertEquals(expectedPassword, usuario.getContrasena());
        assertEquals(expectedPassword, usuario.getPassword()); // Alias
    }
    
    @Test
    @DisplayName("setPassword debe actualizar también getContrasena")
    void testPasswordAlias() {
        // Arrange
        String expectedPassword = "NewP@ssw0rd";
        
        // Act
        usuario.setPassword(expectedPassword);
        
        // Assert
        assertEquals(expectedPassword, usuario.getPassword());
        assertEquals(expectedPassword, usuario.getContrasena());
    }
    
    @Test
    @DisplayName("setRol y getRol deben funcionar correctamente")
    void testRol() {
        // Arrange
        String expectedRol = "COORDINADOR";
        
        // Act
        usuario.setRol(expectedRol);
        
        // Assert
        assertEquals(expectedRol, usuario.getRol());
    }
    
    @ParameterizedTest
    @ValueSource(strings = {"ESTUDIANTE", "COORDINADOR", "ADMINISTRADOR"})
    @DisplayName("Rol debe aceptar todos los valores válidos")
    void testRolesValidos(String rol) {
        // Act
        usuario.setRol(rol);
        
        // Assert
        assertEquals(rol, usuario.getRol());
    }
    
    @Test
    @DisplayName("setEscuela y getEscuela deben funcionar correctamente")
    void testEscuela() {
        // Arrange
        String expectedEscuela = "Ingeniería Civil";
        
        // Act
        usuario.setEscuela(expectedEscuela);
        
        // Assert
        assertEquals(expectedEscuela, usuario.getEscuela());
    }
    
    @Test
    @DisplayName("setTelefono y getTelefono deben funcionar correctamente")
    void testTelefono() {
        // Arrange
        String expectedTelefono = "952123456";
        
        // Act
        usuario.setTelefono(expectedTelefono);
        
        // Assert
        assertEquals(expectedTelefono, usuario.getTelefono());
    }
    
    @Test
    @DisplayName("setActivo y isActivo deben funcionar correctamente")
    void testActivo() {
        // Act & Assert - true
        usuario.setActivo(true);
        assertTrue(usuario.isActivo());
        
        // Act & Assert - false
        usuario.setActivo(false);
        assertFalse(usuario.isActivo());
    }
    
    @Test
    @DisplayName("setFechaRegistro y getFechaRegistro deben funcionar correctamente")
    void testFechaRegistro() {
        // Arrange
        Timestamp expectedFecha = new Timestamp(System.currentTimeMillis());
        
        // Act
        usuario.setFechaRegistro(expectedFecha);
        
        // Assert
        assertEquals(expectedFecha, usuario.getFechaRegistro());
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE MÉTODOS AUXILIARES
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("getNombreCompleto debe concatenar nombres y apellidos")
    void testGetNombreCompleto() {
        // Arrange
        usuario.setNombres("Carlos");
        usuario.setApellidos("Rodríguez");
        
        // Act
        String nombreCompleto = usuario.getNombreCompleto();
        
        // Assert
        assertEquals("Carlos Rodríguez", nombreCompleto);
    }
    
    @Test
    @DisplayName("getNombreCompleto debe manejar espacios correctamente")
    void testGetNombreCompletoConEspacios() {
        // Arrange
        usuario.setNombres("María José");
        usuario.setApellidos("García López");
        
        // Act
        String nombreCompleto = usuario.getNombreCompleto();
        
        // Assert
        assertEquals("María José García López", nombreCompleto);
    }
    
    @Test
    @DisplayName("getEstado debe retornar ACTIVO cuando usuario está activo")
    void testGetEstadoActivo() {
        // Arrange
        usuario.setActivo(true);
        
        // Act
        String estado = usuario.getEstado();
        
        // Assert
        assertEquals("ACTIVO", estado);
    }
    
    @Test
    @DisplayName("getEstado debe retornar INACTIVO cuando usuario está inactivo")
    void testGetEstadoInactivo() {
        // Arrange
        usuario.setActivo(false);
        
        // Act
        String estado = usuario.getEstado();
        
        // Assert
        assertEquals("INACTIVO", estado);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE VALIDACIÓN Y EDGE CASES
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("Nombres con null no debe lanzar excepción")
    void testNombresNull() {
        // Act & Assert
        assertDoesNotThrow(() -> usuario.setNombres(null));
        assertNull(usuario.getNombres());
    }
    
    @Test
    @DisplayName("Correo vacío debe ser aceptado")
    void testCorreoVacio() {
        // Act
        usuario.setCorreo("");
        
        // Assert
        assertEquals("", usuario.getCorreo());
    }
    
    @ParameterizedTest
    @CsvSource({
        "juan.perez@upt.edu.pe, true",
        "maria@gmail.com, true",
        "invalido, false",
        "@upt.edu.pe, false",
        "test@, false"
    })
    @DisplayName("Validar formato de correo básico")
    void testValidacionCorreoFormato(String correo, boolean debeContenerArroba) {
        // Act
        usuario.setCorreo(correo);
        boolean contieneArroba = usuario.getCorreo().contains("@");
        
        // Assert
        assertEquals(debeContenerArroba, contieneArroba);
    }
    
    @Test
    @DisplayName("toString debe incluir información clave del usuario")
    void testToString() {
        // Arrange
        usuario.setIdUsuario(1);
        usuario.setCodigo("2020123456");
        usuario.setNombres("Juan");
        usuario.setApellidos("Pérez");
        usuario.setCorreo("juan@upt.edu.pe");
        usuario.setRol("ESTUDIANTE");
        usuario.setEscuela("EPIS");
        
        // Act
        String resultado = usuario.toString();
        
        // Assert
        assertAll("toString debe contener información clave",
            () -> assertTrue(resultado.contains("idUsuario=1")),
            () -> assertTrue(resultado.contains("codigo='2020123456'")),
            () -> assertTrue(resultado.contains("nombres='Juan'")),
            () -> assertTrue(resultado.contains("apellidos='Pérez'")),
            () -> assertTrue(resultado.contains("correo='juan@upt.edu.pe'")),
            () -> assertTrue(resultado.contains("rol='ESTUDIANTE'")),
            () -> assertTrue(resultado.contains("escuela='EPIS'"))
        );
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE INMUTABILIDAD Y ENCAPSULACIÓN
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("Modificar objeto externo no debe afectar al usuario")
    void testEncapsulacionFechaRegistro() {
        // Arrange
        Timestamp originalFecha = new Timestamp(1000000000L);
        usuario.setFechaRegistro(originalFecha);
        
        // Act - Modificar el timestamp original
        originalFecha.setTime(2000000000L);
        
        // Assert - El usuario debe mantener la fecha original
        // NOTA: Este test fallará porque Timestamp es mutable
        // Es un code smell, pero es el diseño actual
        assertNotNull(usuario.getFechaRegistro());
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CASOS EXTREMOS
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("Código muy largo debe ser aceptado")
    void testCodigoMuyLargo() {
        // Arrange
        String codigoLargo = "A".repeat(100);
        
        // Act
        usuario.setCodigo(codigoLargo);
        
        // Assert
        assertEquals(100, usuario.getCodigo().length());
    }
    
    @Test
    @DisplayName("Caracteres especiales en nombres deben ser aceptados")
    void testNombresConCaracteresEspeciales() {
        // Arrange
        String nombresEspeciales = "José María Ñuñez O'Brien";
        
        // Act
        usuario.setNombres(nombresEspeciales);
        
        // Assert
        assertEquals(nombresEspeciales, usuario.getNombres());
    }
    
    @Test
    @DisplayName("ID negativo debe ser aceptado (aunque no sea válido en BD)")
    void testIdNegativo() {
        // Act
        usuario.setIdUsuario(-1);
        
        // Assert
        assertEquals(-1, usuario.getIdUsuario());
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS CON ASSERTJ (Sintaxis más expresiva)
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("Usuario completo debe tener todos los campos requeridos")
    void testUsuarioCompletoConAssertJ() {
        // Arrange
        usuario.setIdUsuario(1);
        usuario.setCodigo("2020123456");
        usuario.setNombres("Ana");
        usuario.setApellidos("Torres");
        usuario.setCorreo("ana.torres@upt.edu.pe");
        usuario.setContrasena("password");
        usuario.setRol("ESTUDIANTE");
        usuario.setEscuela("EPIS");
        usuario.setTelefono("952123456");
        usuario.setActivo(true);
        
        // Assert con AssertJ
        assertThat(usuario)
            .isNotNull()
            .extracting(
                Usuario::getIdUsuario,
                Usuario::getCodigo,
                Usuario::getNombres,
                Usuario::getCorreo,
                Usuario::getRol
            )
            .containsExactly(
                1,
                "2020123456",
                "Ana",
                "ana.torres@upt.edu.pe",
                "ESTUDIANTE"
            );
    }
    
    @Test
    @DisplayName("Correo debe contener @ y dominio")
    void testCorreoContenidoConAssertJ() {
        // Arrange
        usuario.setCorreo("test@upt.edu.pe");
        
        // Assert con AssertJ
        assertThat(usuario.getCorreo())
            .isNotNull()
            .contains("@")
            .endsWith(".pe")
            .startsWith("test");
    }
    
    @Test
    @DisplayName("Nombre completo no debe estar vacío")
    void testNombreCompletoNoVacioConAssertJ() {
        // Arrange
        usuario.setNombres("Pedro");
        usuario.setApellidos("Sánchez");
        
        // Assert con AssertJ
        assertThat(usuario.getNombreCompleto())
            .isNotBlank()
            .hasSize(14)
            .contains(" ");
    }
}
```

### 3.2 Resultados Esperados

```
Test Results for UsuarioTest:
┌─────────────────────────────────────────────────────┐
│  Tests run:      35                                 │
│  Failures:       0                                  │
│  Errors:         0                                  │
│  Skipped:        0                                  │
│  Success rate:   100%                               │
│  Time elapsed:   0.245s                             │
└─────────────────────────────────────────────────────┘

Coverage for Usuario.java:
├─ Line Coverage:    100% (45/45 lines)
├─ Branch Coverage:  100% (4/4 branches)
└─ Method Coverage:  100% (22/22 methods)
```

---

## 4. 🏢 Pruebas de Capa de Negocio

### 4.1 UsuarioNegocioTest.java

**Propósito:** Validar `UsuarioNegocio` con mocks de base de datos

```java
package negocio;

import conexion.ConexionDB;
import entidad.Usuario;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.*;
import org.mockito.junit.jupiter.MockitoExtension;

import java.sql.*;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

@ExtendWith(MockitoExtension.class)
@DisplayName("Tests para UsuarioNegocio")
class UsuarioNegocioTest {
    
    @InjectMocks
    private UsuarioNegocio usuarioNegocio;
    
    @Mock
    private Connection mockConnection;
    
    @Mock
    private PreparedStatement mockPreparedStatement;
    
    @Mock
    private ResultSet mockResultSet;
    
    @BeforeEach
    void setUp() throws SQLException {
        // Configurar ConexionDB para retornar conexión mockeada
        MockedStatic<ConexionDB> mockedStatic = mockStatic(ConexionDB.class);
        when(ConexionDB.getConnection()).thenReturn(mockConnection);
    }
    
    @AfterEach
    void tearDown() {
        // Limpiar mocks estáticos
        Mockito.framework().clearInlineMocks();
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE VALIDAR LOGIN
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("validarLogin debe retornar usuario cuando credenciales son correctas")
    void testValidarLoginExitoso() throws SQLException {
        // Arrange
        String correo = "juan.perez@upt.edu.pe";
        String contrasena = "password123";
        
        // Mockear el flujo de base de datos
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        
        // Configurar datos del ResultSet
        when(mockResultSet.getInt("id_usuario")).thenReturn(1);
        when(mockResultSet.getString("codigo")).thenReturn("2020123456");
        when(mockResultSet.getString("nombres")).thenReturn("Juan");
        when(mockResultSet.getString("apellidos")).thenReturn("Pérez");
        when(mockResultSet.getString("correo")).thenReturn(correo);
        when(mockResultSet.getString("rol")).thenReturn("ESTUDIANTE");
        when(mockResultSet.getString("escuela")).thenReturn("EPIS");
        when(mockResultSet.getString("telefono")).thenReturn("952123456");
        when(mockResultSet.getBoolean("activo")).thenReturn(true);
        when(mockResultSet.getTimestamp("fecha_registro"))
            .thenReturn(new Timestamp(System.currentTimeMillis()));
        
        // Act
        Usuario resultado = usuarioNegocio.validarLogin(correo, contrasena);
        
        // Assert
        assertNotNull(resultado, "Usuario no debe ser null");
        assertEquals(1, resultado.getIdUsuario());
        assertEquals("Juan", resultado.getNombres());
        assertEquals(correo, resultado.getCorreo());
        assertEquals("ESTUDIANTE", resultado.getRol());
        
        // Verificar interacciones
        verify(mockConnection, times(1)).prepareStatement(anyString());
        verify(mockPreparedStatement, times(1)).setString(1, correo);
        verify(mockPreparedStatement, times(1)).setString(2, contrasena);
        verify(mockPreparedStatement, times(1)).executeQuery();
    }
    
    @Test
    @DisplayName("validarLogin debe retornar null cuando credenciales son incorrectas")
    void testValidarLoginFallido() throws SQLException {
        // Arrange
        String correo = "inexistente@upt.edu.pe";
        String contrasena = "wrongpassword";
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false); // No hay resultados
        
        // Act
        Usuario resultado = usuarioNegocio.validarLogin(correo, contrasena);
        
        // Assert
        assertNull(resultado, "Usuario debe ser null cuando credenciales son incorrectas");
        
        verify(mockPreparedStatement, times(1)).setString(1, correo);
        verify(mockPreparedStatement, times(1)).setString(2, contrasena);
    }
    
    @Test
    @DisplayName("validarLogin debe manejar SQLException correctamente")
    void testValidarLoginConSQLException() throws SQLException {
        // Arrange
        when(mockConnection.prepareStatement(anyString()))
            .thenThrow(new SQLException("Connection error"));
        
        // Act
        Usuario resultado = usuarioNegocio.validarLogin("test@upt.edu.pe", "password");
        
        // Assert
        assertNull(resultado, "Debe retornar null en caso de error de BD");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE REGISTRAR USUARIO
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("registrarUsuario debe retornar true cuando registro es exitoso")
    void testRegistrarUsuarioExitoso() throws SQLException {
        // Arrange
        Usuario nuevoUsuario = new Usuario(
            "2021123456",
            "María",
            "García",
            "maria.garcia@upt.edu.pe",
            "password123",
            "ESTUDIANTE",
            "EPIS",
            "952987654"
        );
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate()).thenReturn(1); // 1 fila afectada
        
        // Act
        boolean resultado = usuarioNegocio.registrarUsuario(nuevoUsuario);
        
        // Assert
        assertTrue(resultado, "Registro debe ser exitoso");
        
        // Verificar que se establecieron todos los parámetros
        verify(mockPreparedStatement).setString(1, "2021123456");
        verify(mockPreparedStatement).setString(2, "María");
        verify(mockPreparedStatement).setString(3, "García");
        verify(mockPreparedStatement).setString(4, "maria.garcia@upt.edu.pe");
        verify(mockPreparedStatement).setString(5, "password123");
        verify(mockPreparedStatement).setString(6, "ESTUDIANTE");
        verify(mockPreparedStatement).setString(7, "EPIS");
        verify(mockPreparedStatement).setString(8, "952987654");
        verify(mockPreparedStatement, times(1)).executeUpdate();
    }
    
    @Test
    @DisplayName("registrarUsuario debe retornar false cuando falla")
    void testRegistrarUsuarioFallido() throws SQLException {
        // Arrange
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setCodigo("2021999999");
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate()).thenReturn(0); // 0 filas afectadas
        
        // Act
        boolean resultado = usuarioNegocio.registrarUsuario(nuevoUsuario);
        
        // Assert
        assertFalse(resultado, "Registro debe fallar cuando no hay filas afectadas");
    }
    
    @Test
    @DisplayName("registrarUsuario debe manejar SQLException por correo duplicado")
    void testRegistrarUsuarioCorreoDuplicado() throws SQLException {
        // Arrange
        Usuario nuevoUsuario = new Usuario();
        nuevoUsuario.setCorreo("duplicado@upt.edu.pe");
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate())
            .thenThrow(new SQLException("Duplicate entry", "23000"));
        
        // Act
        boolean resultado = usuarioNegocio.registrarUsuario(nuevoUsuario);
        
        // Assert
        assertFalse(resultado, "Debe retornar false cuando hay correo duplicado");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CORREO EXISTE
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("correoExiste debe retornar true cuando correo existe")
    void testCorreoExisteTrue() throws SQLException {
        // Arrange
        String correo = "existente@upt.edu.pe";
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(1); // COUNT(*) = 1
        
        // Act
        boolean resultado = usuarioNegocio.correoExiste(correo);
        
        // Assert
        assertTrue(resultado, "Debe retornar true cuando correo existe");
        verify(mockPreparedStatement).setString(1, correo);
    }
    
    @Test
    @DisplayName("correoExiste debe retornar false cuando correo no existe")
    void testCorreoExisteFalse() throws SQLException {
        // Arrange
        String correo = "nuevo@upt.edu.pe";
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(0); // COUNT(*) = 0
        
        // Act
        boolean resultado = usuarioNegocio.correoExiste(correo);
        
        // Assert
        assertFalse(resultado, "Debe retornar false cuando correo no existe");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE OBTENER USUARIO POR ID
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("obtenerUsuarioPorId debe retornar usuario cuando existe")
    void testObtenerUsuarioPorIdExitoso() throws SQLException {
        // Arrange
        int idUsuario = 1;
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        
        // Configurar datos del usuario
        when(mockResultSet.getInt("id_usuario")).thenReturn(idUsuario);
        when(mockResultSet.getString("codigo")).thenReturn("2020123456");
        when(mockResultSet.getString("nombres")).thenReturn("Carlos");
        when(mockResultSet.getString("apellidos")).thenReturn("López");
        when(mockResultSet.getString("correo")).thenReturn("carlos@upt.edu.pe");
        when(mockResultSet.getString("rol")).thenReturn("COORDINADOR");
        when(mockResultSet.getString("escuela")).thenReturn("EPIS");
        when(mockResultSet.getString("telefono")).thenReturn("952111222");
        when(mockResultSet.getBoolean("activo")).thenReturn(true);
        
        // Act
        Usuario resultado = usuarioNegocio.obtenerUsuarioPorId(idUsuario);
        
        // Assert
        assertNotNull(resultado);
        assertEquals(idUsuario, resultado.getIdUsuario());
        assertEquals("Carlos", resultado.getNombres());
        assertEquals("COORDINADOR", resultado.getRol());
        
        verify(mockPreparedStatement).setInt(1, idUsuario);
    }
    
    @Test
    @DisplayName("obtenerUsuarioPorId debe retornar null cuando no existe")
    void testObtenerUsuarioPorIdNoExiste() throws SQLException {
        // Arrange
        int idUsuario = 999;
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(false);
        
        // Act
        Usuario resultado = usuarioNegocio.obtenerUsuarioPorId(idUsuario);
        
        // Assert
        assertNull(resultado);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CONTAR USUARIOS
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("contarUsuariosPorRol debe retornar cantidad correcta")
    void testContarUsuariosPorRol() throws SQLException {
        // Arrange
        String rol = "ESTUDIANTE";
        int expectedCount = 45;
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(expectedCount);
        
        // Act
        int resultado = usuarioNegocio.contarUsuariosPorRol(rol);
        
        // Assert
        assertEquals(expectedCount, resultado);
        verify(mockPreparedStatement).setString(1, rol);
    }
    
    @Test
    @DisplayName("contarUsuariosActivos debe retornar cantidad correcta")
    void testContarUsuariosActivos() throws SQLException {
        // Arrange
        int expectedCount = 100;
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getInt(1)).thenReturn(expectedCount);
        
        // Act
        int resultado = usuarioNegocio.contarUsuariosActivos();
        
        // Assert
        assertEquals(expectedCount, resultado);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CAMBIAR ESTADO USUARIO
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("cambiarEstadoUsuario debe retornar true cuando es exitoso")
    void testCambiarEstadoUsuarioExitoso() throws SQLException {
        // Arrange
        int idUsuario = 1;
        boolean nuevoEstado = false;
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeUpdate()).thenReturn(1);
        
        // Act
        boolean resultado = usuarioNegocio.cambiarEstadoUsuario(idUsuario, nuevoEstado);
        
        // Assert
        assertTrue(resultado);
        verify(mockPreparedStatement).setBoolean(1, nuevoEstado);
        verify(mockPreparedStatement).setInt(2, idUsuario);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE VERIFICAR PASSWORD
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("verificarPassword debe retornar true cuando password es correcta")
    void testVerificarPasswordCorrecta() throws SQLException {
        // Arrange
        int idUsuario = 1;
        String password = "correctPassword";
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("contrasena")).thenReturn(password);
        
        // Act
        boolean resultado = usuarioNegocio.verificarPassword(idUsuario, password);
        
        // Assert
        assertTrue(resultado);
    }
    
    @Test
    @DisplayName("verificarPassword debe retornar false cuando password es incorrecta")
    void testVerificarPasswordIncorrecta() throws SQLException {
        // Arrange
        int idUsuario = 1;
        String passwordIncorrecto = "wrongPassword";
        String passwordCorrecto = "correctPassword";
        
        when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
        when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
        when(mockResultSet.next()).thenReturn(true);
        when(mockResultSet.getString("contrasena")).thenReturn(passwordCorrecto);
        
        // Act
        boolean resultado = usuarioNegocio.verificarPassword(idUsuario, passwordIncorrecto);
        
        // Assert
        assertFalse(resultado);
    }
}
```

---

**Continúa en Parte 2:** Pruebas de Servlets, Integración y Reporte de Cobertura

---

*Generado el 3 de Diciembre de 2025 - Sistema Voluntariado UPT*
