# 🔗 Informe de Pruebas de Integración - Parte 1
## Sistema de Voluntariado UPT
### Integration Testing con Testcontainers + Spring Boot Test

---

**Fecha:** 3 de Diciembre de 2025  
**Framework:** JUnit 5 + Testcontainers + Spring Boot Test  
**Base de Datos:** MySQL 8.0 (Testcontainers)

---

## 📑 Tabla de Contenidos (Parte 1)

1. [Introducción a Integration Testing](#introducción)
2. [Arquitectura de Tests de Integración](#arquitectura)
3. [Configuración del Entorno](#configuración)
4. [Testcontainers Setup](#testcontainers)
5. [Tests de Integración - Capa de Datos](#tests-datos)

---

## 1. 🎯 Introducción a Integration Testing

### 1.1 ¿Qué son las Pruebas de Integración?

```
┌─────────────────────────────────────────────────────────────┐
│  PIRÁMIDE DE TESTING                                        │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│                    /\         E2E Tests                     │
│                   /  \        (5%)                          │
│                  /────\                                     │
│                 /      \      Integration Tests             │
│                /        \     (15%)                         │
│               /──────────\                                  │
│              /            \   Unit Tests                    │
│             /              \  (80%)                         │
│            /────────────────\                               │
│                                                             │
│  UNIT TESTS:        Testean componentes aislados           │
│  INTEGRATION TESTS: Testean interacciones entre componentes│
│  E2E TESTS:         Testean flujos completos de usuario    │
└─────────────────────────────────────────────────────────────┘
```

### 1.2 Unit Tests vs Integration Tests

```java
// ═══════════════════════════════════════════════════════
// ❌ UNIT TEST - Con Mocks (No toca BD real)
// ═══════════════════════════════════════════════════════

@Test
void testRegistrarUsuarioUnitTest() {
    // Mock de Connection, PreparedStatement, ResultSet
    when(mockConnection.prepareStatement(anyString())).thenReturn(mockPreparedStatement);
    when(mockPreparedStatement.executeUpdate()).thenReturn(1);
    
    boolean resultado = usuarioNegocio.registrarUsuario(usuario);
    
    assertTrue(resultado);
    verify(mockPreparedStatement).executeUpdate();  // Solo verifica llamadas
}

PROBLEMAS:
├─ No detecta errores de SQL syntax
├─ No detecta problemas de constraints
├─ No detecta issues de transacciones
└─ No detecta problemas de encoding

// ═══════════════════════════════════════════════════════
// ✅ INTEGRATION TEST - Con BD Real (Testcontainers)
// ═══════════════════════════════════════════════════════

@Test
@Sql("/data/usuarios-test.sql")  // Datos de prueba
void testRegistrarUsuarioIntegrationTest() {
    // BD REAL en Docker (Testcontainers)
    Usuario usuario = new Usuario();
    usuario.setCodigo("2020123456");
    usuario.setCorreo("test@test.com");
    usuario.setContrasena("Pass123");
    
    boolean resultado = usuarioNegocio.registrarUsuario(usuario);
    
    // Verificar en BD REAL
    assertTrue(resultado);
    
    Usuario guardado = usuarioNegocio.obtenerPorCorreo("test@test.com");
    assertNotNull(guardado);
    assertEquals("2020123456", guardado.getCodigo());
    assertEquals("test@test.com", guardado.getCorreo());
}

VENTAJAS:
✅ Detecta errores de SQL reales
✅ Verifica constraints (UNIQUE, FK, etc.)
✅ Valida transacciones completas
✅ Verifica encoding y tipos de datos
✅ Mayor confianza en el código
```

### 1.3 Alcance de Integration Tests

```
╔════════════════════════════════════════════════════════════╗
║  QUÉ TESTEAR EN INTEGRATION TESTS                          ║
╚════════════════════════════════════════════════════════════╝

✅ INCLUIR:
├─ Interacciones con base de datos real
├─ Transacciones y rollbacks
├─ Constraints (PK, FK, UNIQUE, CHECK)
├─ Stored procedures y triggers
├─ Queries complejas con JOINs
├─ Concurrencia y bloqueos
├─ Conexiones y pools
└─ Migración de esquemas (Flyway/Liquibase)

✅ INCLUIR (APIs externas):
├─ Integración con servicios externos
├─ APIs REST (con WireMock o Testcontainers)
├─ Message queues (RabbitMQ, Kafka)
└─ Cache (Redis)

❌ EXCLUIR:
├─ Lógica de negocio pura (→ Unit tests)
├─ Validaciones simples (→ Unit tests)
├─ Getters/setters (→ Unit tests)
└─ UI/Frontend (→ E2E tests)
```

### 1.4 Beneficios y Costos

```
┌────────────────────┬─────────────────────────────────────┐
│ BENEFICIOS         │ COSTOS                              │
├────────────────────┼─────────────────────────────────────┤
│ ✅ Confianza real  │ ⏱️ Más lentos (segundos vs ms)     │
│ ✅ Detecta bugs DB │ 💰 Más recursos (Docker, BD)       │
│ ✅ Valida schema   │ 🔧 Más complejos de mantener       │
│ ✅ Tests E2E light │ 📦 Más dependencias                 │
│ ✅ CI/CD robusto   │ 🐛 Más difíciles de debuggear      │
└────────────────────┴─────────────────────────────────────┘

RECOMENDACIÓN:
├─ 80% Unit tests (rápidos, muchos)
├─ 15% Integration tests (medios, selectivos)
└─ 5% E2E tests (lentos, críticos)
```

---

## 2. 🏗️ Arquitectura de Tests de Integración

### 2.1 Estructura del Proyecto

```
proyecto/
├── src/
│   ├── main/
│   │   └── java/
│   │       ├── conexion/
│   │       │   └── ConexionDB.java
│   │       ├── entidad/
│   │       │   ├── Usuario.java
│   │       │   ├── Campana.java
│   │       │   └── Asistencia.java
│   │       ├── negocio/
│   │       │   ├── UsuarioNegocio.java
│   │       │   ├── coordinadornegocio.java
│   │       │   └── estudiantenegocio.java
│   │       └── servlet/
│   │           ├── AsistenciaServlet.java
│   │           └── InscripcionServlet.java
│   │
│   └── test/
│       ├── java/
│       │   ├── integration/          ← NUEVOS TESTS
│       │   │   ├── base/
│       │   │   │   ├── IntegrationTestBase.java
│       │   │   │   ├── DatabaseTestConfig.java
│       │   │   │   └── TestDataBuilder.java
│       │   │   ├── negocio/
│       │   │   │   ├── UsuarioNegocioIntegrationTest.java
│       │   │   │   ├── CampanaNegocioIntegrationTest.java
│       │   │   │   └── AsistenciaNegocioIntegrationTest.java
│       │   │   ├── dao/
│       │   │   │   ├── UsuarioDAOIntegrationTest.java
│       │   │   │   └── CampanaDAOIntegrationTest.java
│       │   │   └── transacciones/
│       │   │       ├── TransactionIntegrationTest.java
│       │   │       └── ConcurrencyIntegrationTest.java
│       │   │
│       │   └── unit/                  ← TESTS EXISTENTES
│       │       ├── entidad/
│       │       └── negocio/
│       │
│       └── resources/
│           ├── application-test.properties
│           ├── schema.sql             ← Schema de BD
│           ├── data/
│           │   ├── usuarios-test.sql
│           │   ├── campanas-test.sql
│           │   └── asistencias-test.sql
│           └── testcontainers.properties
```

### 2.2 Capas de Testing

```
┌─────────────────────────────────────────────────────────────┐
│  CAPAS DE INTEGRATION TESTING                               │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│  CAPA 1: Database Integration Tests                        │
│  ├─ DAO/Repository tests con BD real                       │
│  ├─ CRUD operations                                         │
│  ├─ Queries complejas                                       │
│  └─ Constraints validation                                  │
│                                                             │
│  CAPA 2: Business Logic Integration Tests                  │
│  ├─ Negocio + DAO + BD                                      │
│  ├─ Transacciones completas                                 │
│  ├─ Rollbacks en errores                                    │
│  └─ Múltiples tablas                                        │
│                                                             │
│  CAPA 3: Service Integration Tests                         │
│  ├─ Service + Negocio + DAO + BD                            │
│  ├─ Flujos completos                                        │
│  ├─ APIs externas (mocked)                                  │
│  └─ Message queues                                          │
│                                                             │
│  CAPA 4: API Integration Tests                             │
│  ├─ REST endpoints                                          │
│  ├─ Request/Response                                        │
│  ├─ Authentication                                          │
│  └─ Error handling                                          │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

## 3. ⚙️ Configuración del Entorno

### 3.1 Dependencias Maven

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    <modelVersion>4.0.0</modelVersion>
    
    <groupId>com.upt</groupId>
    <artifactId>voluntariado-upt</artifactId>
    <version>1.0-SNAPSHOT</version>
    
    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        
        <!-- Versions -->
        <junit.version>5.10.1</junit.version>
        <mockito.version>5.8.0</mockito.version>
        <testcontainers.version>1.19.3</testcontainers.version>
        <spring-test.version>5.3.31</spring-test.version>
        <assertj.version>3.24.2</assertj.version>
        <mysql.version>8.0.33</mysql.version>
        <hikari.version>5.1.0</hikari.version>
        <flyway.version>10.4.1</flyway.version>
    </properties>
    
    <dependencies>
        <!-- ============================================ -->
        <!-- DEPENDENCIAS EXISTENTES                      -->
        <!-- ============================================ -->
        
        <!-- JUnit 5 -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${junit.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- Mockito -->
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>${mockito.version}</version>
            <scope>test</scope>
        </dependency>
        
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-junit-jupiter</artifactId>
            <version>${mockito.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- AssertJ -->
        <dependency>
            <groupId>org.assertj</groupId>
            <artifactId>assertj-core</artifactId>
            <version>${assertj.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- MySQL Driver -->
        <dependency>
            <groupId>com.mysql</groupId>
            <artifactId>mysql-connector-j</artifactId>
            <version>${mysql.version}</version>
        </dependency>
        
        <!-- ============================================ -->
        <!-- NUEVAS DEPENDENCIAS PARA INTEGRATION TESTS   -->
        <!-- ============================================ -->
        
        <!-- Testcontainers BOM (Bill of Materials) -->
        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>testcontainers-bom</artifactId>
            <version>${testcontainers.version}</version>
            <type>pom</type>
            <scope>import</scope>
        </dependency>
        
        <!-- Testcontainers Core -->
        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>testcontainers</artifactId>
            <version>${testcontainers.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- Testcontainers JUnit 5 -->
        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>${testcontainers.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- Testcontainers MySQL -->
        <dependency>
            <groupId>org.testcontainers</groupId>
            <artifactId>mysql</artifactId>
            <version>${testcontainers.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- Spring Test (sin Spring Boot completo) -->
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-test</artifactId>
            <version>${spring-test.version}</version>
            <scope>test</scope>
        </dependency>
        
        <dependency>
            <groupId>org.springframework</groupId>
            <artifactId>spring-jdbc</artifactId>
            <version>${spring-test.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- HikariCP Connection Pool -->
        <dependency>
            <groupId>com.zaxxer</groupId>
            <artifactId>HikariCP</artifactId>
            <version>${hikari.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- Flyway para migraciones -->
        <dependency>
            <groupId>org.flywaydb</groupId>
            <artifactId>flyway-core</artifactId>
            <version>${flyway.version}</version>
            <scope>test</scope>
        </dependency>
        
        <dependency>
            <groupId>org.flywaydb</groupId>
            <artifactId>flyway-mysql</artifactId>
            <version>${flyway.version}</version>
            <scope>test</scope>
        </dependency>
        
        <!-- DBUnit para datos de prueba -->
        <dependency>
            <groupId>org.dbunit</groupId>
            <artifactId>dbunit</artifactId>
            <version>2.7.3</version>
            <scope>test</scope>
        </dependency>
        
        <!-- Awaitility para tests asíncronos -->
        <dependency>
            <groupId>org.awaitility</groupId>
            <artifactId>awaitility</artifactId>
            <version>4.2.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <!-- Surefire para unit tests -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-surefire-plugin</artifactId>
                <version>3.2.3</version>
                <configuration>
                    <includes>
                        <include>**/*Test.java</include>
                    </includes>
                    <excludes>
                        <exclude>**/*IntegrationTest.java</exclude>
                    </excludes>
                </configuration>
            </plugin>
            
            <!-- Failsafe para integration tests -->
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-failsafe-plugin</artifactId>
                <version>3.2.3</version>
                <configuration>
                    <includes>
                        <include>**/*IntegrationTest.java</include>
                        <include>**/*IT.java</include>
                    </includes>
                    <systemPropertyVariables>
                        <testcontainers.reuse.enable>true</testcontainers.reuse.enable>
                    </systemPropertyVariables>
                </configuration>
                <executions>
                    <execution>
                        <goals>
                            <goal>integration-test</goal>
                            <goal>verify</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

### 3.2 Configuración de Properties

```properties
# src/test/resources/application-test.properties

# ============================================
# DATABASE CONFIGURATION (Testcontainers)
# ============================================

# Estas propiedades se sobrescriben en runtime por Testcontainers
spring.datasource.url=jdbc:tc:mysql:8.0:///testdb
spring.datasource.driver-class-name=org.testcontainers.jdbc.ContainerDatabaseDriver
spring.datasource.username=test
spring.datasource.password=test

# Connection Pool (HikariCP)
spring.datasource.hikari.maximum-pool-size=5
spring.datasource.hikari.minimum-idle=2
spring.datasource.hikari.connection-timeout=30000
spring.datasource.hikari.idle-timeout=600000
spring.datasource.hikari.max-lifetime=1800000

# ============================================
# TESTCONTAINERS CONFIGURATION
# ============================================

# Reusable containers (más rápido en desarrollo)
testcontainers.reuse.enable=true

# Logging
testcontainers.logging.level=INFO

# ============================================
# FLYWAY CONFIGURATION
# ============================================

spring.flyway.enabled=true
spring.flyway.locations=classpath:db/migration
spring.flyway.baseline-on-migrate=true
spring.flyway.clean-disabled=false

# ============================================
# TEST CONFIGURATION
# ============================================

# Logs SQL
logging.level.org.hibernate.SQL=DEBUG
logging.level.org.hibernate.type.descriptor.sql.BasicBinder=TRACE

# Test data
test.data.cleanup=true
test.data.seed=true
```

```properties
# src/test/resources/testcontainers.properties

# Docker configuration
testcontainers.docker.client.strategy=org.testcontainers.dockerclient.EnvironmentAndSystemPropertyClientProviderStrategy

# Reuse containers between test runs (DESARROLLO)
testcontainers.reuse.enable=true

# Ryuk (container cleanup)
testcontainers.ryuk.disabled=false
```

---

## 4. 🐳 Testcontainers Setup

### 4.1 ¿Qué es Testcontainers?

```
Testcontainers es una librería Java que permite ejecutar
contenedores Docker desde tests JUnit.

┌────────────────────────────────────────────────────────┐
│  FLUJO DE TESTCONTAINERS                               │
├────────────────────────────────────────────────────────┤
│                                                        │
│  1. Test inicia                                        │
│     └─> Testcontainers detecta @Container             │
│                                                        │
│  2. Docker pull (si no existe)                         │
│     └─> docker pull mysql:8.0                          │
│                                                        │
│  3. Container start                                    │
│     └─> docker run -d -p RANDOM:3306 mysql:8.0        │
│                                                        │
│  4. Wait strategy                                      │
│     └─> Esperar hasta que MySQL esté ready            │
│                                                        │
│  5. Execute test                                       │
│     └─> Test usa la BD real en el container           │
│                                                        │
│  6. Container stop (automático)                        │
│     └─> docker stop <container-id>                     │
│     └─> docker rm <container-id>                       │
│                                                        │
└────────────────────────────────────────────────────────┘

VENTAJAS:
✅ BD real, no mocks
✅ Aislamiento completo
✅ Limpieza automática
✅ Portable (funciona en CI/CD)
✅ Múltiples DBs (MySQL, Postgres, MongoDB, etc.)
```

### 4.2 Clase Base para Integration Tests

```java
package integration.base;

import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;
import org.testcontainers.containers.MySQLContainer;
import org.testcontainers.junit.jupiter.Container;
import org.testcontainers.junit.jupiter.Testcontainers;
import org.testcontainers.utility.DockerImageName;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

/**
 * Clase base para todos los integration tests.
 * Proporciona un container MySQL compartido y utilidades comunes.
 */
@Testcontainers
public abstract class IntegrationTestBase {
    
    // ═══════════════════════════════════════════════════════
    // TESTCONTAINER MYSQL - COMPARTIDO ENTRE TESTS
    // ═══════════════════════════════════════════════════════
    
    @Container
    protected static final MySQLContainer<?> mysqlContainer = 
        new MySQLContainer<>(DockerImageName.parse("mysql:8.0.33"))
            .withDatabaseName("voluntariado_test")
            .withUsername("test_user")
            .withPassword("test_pass")
            .withInitScript("schema.sql")  // Script inicial
            .withReuse(true)  // Reutilizar container entre tests
            .withCommand(
                "--character-set-server=utf8mb4",
                "--collation-server=utf8mb4_unicode_ci",
                "--default-time-zone=America/Lima"
            );
    
    protected static HikariDataSource dataSource;
    
    // ═══════════════════════════════════════════════════════
    // SETUP - EJECUTAR UNA VEZ PARA TODOS LOS TESTS
    // ═══════════════════════════════════════════════════════
    
    @BeforeAll
    static void beforeAll() {
        // Verificar que el container está corriendo
        if (!mysqlContainer.isRunning()) {
            mysqlContainer.start();
        }
        
        // Configurar HikariCP connection pool
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl(mysqlContainer.getJdbcUrl());
        config.setUsername(mysqlContainer.getUsername());
        config.setPassword(mysqlContainer.getPassword());
        config.setDriverClassName(mysqlContainer.getDriverClassName());
        
        // Pool configuration
        config.setMaximumPoolSize(5);
        config.setMinimumIdle(2);
        config.setConnectionTimeout(30000);
        config.setIdleTimeout(600000);
        config.setMaxLifetime(1800000);
        
        // MySQL específico
        config.addDataSourceProperty("cachePrepStmts", "true");
        config.addDataSourceProperty("prepStmtCacheSize", "250");
        config.addDataSourceProperty("prepStmtCacheSqlLimit", "2048");
        config.addDataSourceProperty("useServerPrepStmts", "true");
        
        dataSource = new HikariDataSource(config);
        
        System.out.println("╔════════════════════════════════════════════════╗");
        System.out.println("║  TESTCONTAINERS MYSQL INICIADO                 ║");
        System.out.println("╚════════════════════════════════════════════════╝");
        System.out.println("  JDBC URL: " + mysqlContainer.getJdbcUrl());
        System.out.println("  Username: " + mysqlContainer.getUsername());
        System.out.println("  Database: " + mysqlContainer.getDatabaseName());
        System.out.println("  Host:     " + mysqlContainer.getHost());
        System.out.println("  Port:     " + mysqlContainer.getFirstMappedPort());
        System.out.println("════════════════════════════════════════════════");
    }
    
    @AfterAll
    static void afterAll() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // BEFORE EACH - LIMPIAR BD ANTES DE CADA TEST
    // ═══════════════════════════════════════════════════════
    
    @BeforeEach
    void beforeEach() throws SQLException {
        limpiarBaseDeDatos();
    }
    
    // ═══════════════════════════════════════════════════════
    // UTILIDADES PARA TESTS
    // ═══════════════════════════════════════════════════════
    
    /**
     * Obtiene una conexión del pool
     */
    protected Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
    
    /**
     * Limpia todas las tablas (mantiene schema)
     */
    protected void limpiarBaseDeDatos() throws SQLException {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Deshabilitar FK checks temporalmente
            stmt.execute("SET FOREIGN_KEY_CHECKS = 0");
            
            // Truncar tablas en orden (de dependientes a independientes)
            stmt.execute("TRUNCATE TABLE asistencias");
            stmt.execute("TRUNCATE TABLE inscripciones");
            stmt.execute("TRUNCATE TABLE campanas");
            stmt.execute("TRUNCATE TABLE usuarios");
            
            // Rehabilitar FK checks
            stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
        }
    }
    
    /**
     * Ejecuta un script SQL desde resources
     */
    protected void ejecutarScript(String scriptPath) throws Exception {
        String sql = new String(
            getClass().getClassLoader()
                .getResourceAsStream(scriptPath)
                .readAllBytes()
        );
        
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement()) {
            
            // Ejecutar cada statement (separados por ;)
            for (String statement : sql.split(";")) {
                if (!statement.trim().isEmpty()) {
                    stmt.execute(statement.trim());
                }
            }
        }
    }
    
    /**
     * Verifica que una tabla existe
     */
    protected boolean tablaExiste(String nombreTabla) throws SQLException {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             var rs = stmt.executeQuery(
                 "SHOW TABLES LIKE '" + nombreTabla + "'")) {
            return rs.next();
        }
    }
    
    /**
     * Cuenta registros en una tabla
     */
    protected int contarRegistros(String tabla) throws SQLException {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             var rs = stmt.executeQuery("SELECT COUNT(*) FROM " + tabla)) {
            
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    /**
     * Obtiene la URL de conexión para usar en clases de negocio
     */
    protected String getJdbcUrl() {
        return mysqlContainer.getJdbcUrl();
    }
    
    protected String getUsername() {
        return mysqlContainer.getUsername();
    }
    
    protected String getPassword() {
        return mysqlContainer.getPassword();
    }
}
```

### 4.3 Schema SQL

```sql
-- src/test/resources/schema.sql

-- ============================================
-- SCHEMA PARA INTEGRATION TESTS
-- ============================================

CREATE DATABASE IF NOT EXISTS voluntariado_test
    CHARACTER SET utf8mb4
    COLLATE utf8mb4_unicode_ci;

USE voluntariado_test;

-- ============================================
-- TABLA: usuarios
-- ============================================

CREATE TABLE IF NOT EXISTS usuarios (
    id_usuario INT AUTO_INCREMENT PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombres VARCHAR(100) NOT NULL,
    apellidos VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE NOT NULL,
    contrasena VARCHAR(255) NOT NULL,
    rol ENUM('ESTUDIANTE', 'COORDINADOR', 'ADMINISTRADOR') NOT NULL,
    escuela VARCHAR(100),
    telefono VARCHAR(15),
    activo BOOLEAN DEFAULT TRUE,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    INDEX idx_correo (correo),
    INDEX idx_rol (rol),
    INDEX idx_activo (activo)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: campanas
-- ============================================

CREATE TABLE IF NOT EXISTS campanas (
    id_campana INT AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(200) NOT NULL,
    descripcion TEXT,
    fecha_inicio DATE NOT NULL,
    fecha_fin DATE NOT NULL,
    ubicacion VARCHAR(200),
    cupos INT DEFAULT 0,
    horas_validadas INT DEFAULT 0,
    id_coordinador INT NOT NULL,
    estado ENUM('PLANIFICADA', 'ACTIVA', 'FINALIZADA', 'CANCELADA') DEFAULT 'PLANIFICADA',
    fecha_creacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (id_coordinador) REFERENCES usuarios(id_usuario),
    INDEX idx_estado (estado),
    INDEX idx_fecha_inicio (fecha_inicio),
    INDEX idx_coordinador (id_coordinador),
    
    CONSTRAINT chk_fechas CHECK (fecha_fin >= fecha_inicio),
    CONSTRAINT chk_cupos CHECK (cupos >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: inscripciones
-- ============================================

CREATE TABLE IF NOT EXISTS inscripciones (
    id_inscripcion INT AUTO_INCREMENT PRIMARY KEY,
    id_estudiante INT NOT NULL,
    id_campana INT NOT NULL,
    fecha_inscripcion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    estado ENUM('INSCRITO', 'ASISTIO', 'NO_ASISTIO', 'CANCELADO') DEFAULT 'INSCRITO',
    
    FOREIGN KEY (id_estudiante) REFERENCES usuarios(id_usuario),
    FOREIGN KEY (id_campana) REFERENCES campanas(id_campana),
    UNIQUE KEY uk_estudiante_campana (id_estudiante, id_campana),
    INDEX idx_estudiante (id_estudiante),
    INDEX idx_campana (id_campana)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TABLA: asistencias
-- ============================================

CREATE TABLE IF NOT EXISTS asistencias (
    id_asistencia INT AUTO_INCREMENT PRIMARY KEY,
    id_inscripcion INT NOT NULL,
    fecha_registro TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    validado BOOLEAN DEFAULT FALSE,
    observaciones TEXT,
    
    FOREIGN KEY (id_inscripcion) REFERENCES inscripciones(id_inscripcion),
    INDEX idx_inscripcion (id_inscripcion),
    INDEX idx_fecha_registro (fecha_registro)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- ============================================
-- TRIGGERS
-- ============================================

DELIMITER //

CREATE TRIGGER after_asistencia_insert
AFTER INSERT ON asistencias
FOR EACH ROW
BEGIN
    UPDATE inscripciones
    SET estado = 'ASISTIO'
    WHERE id_inscripcion = NEW.id_inscripcion;
END//

DELIMITER ;
```

---

## 5. 🗄️ Tests de Integración - Capa de Datos

### 5.1 UsuarioNegocioIntegrationTest.java

```java
package integration.negocio;

import entidad.Usuario;
import integration.base.IntegrationTestBase;
import negocio.UsuarioNegocio;
import org.junit.jupiter.api.*;

import java.sql.*;
import java.util.List;

import static org.assertj.core.assertj.Assertions.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Integration Tests - UsuarioNegocio con BD Real")
@TestMethodOrder(MethodOrderer.OrderAnnotation.class)
class UsuarioNegocioIntegrationTest extends IntegrationTestBase {
    
    private UsuarioNegocio usuarioNegocio;
    
    @BeforeEach
    void setUp() {
        // Configurar UsuarioNegocio para usar la BD de Testcontainers
        usuarioNegocio = new UsuarioNegocio(dataSource);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE REGISTRO DE USUARIOS
    // ═══════════════════════════════════════════════════════
    
    @Test
    @Order(1)
    @DisplayName("registrarUsuario debe insertar usuario en BD real")
    void testRegistrarUsuarioInsertaEnBD() throws SQLException {
        // Arrange
        Usuario usuario = crearUsuarioCompleto();
        
        // Act
        boolean resultado = usuarioNegocio.registrarUsuario(usuario);
        
        // Assert
        assertTrue(resultado, "Debe retornar true");
        
        // Verificar en BD directamente
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT * FROM usuarios WHERE correo = ?")) {
            
            pstmt.setString(1, usuario.getCorreo());
            ResultSet rs = pstmt.executeQuery();
            
            assertTrue(rs.next(), "Usuario debe existir en BD");
            assertEquals("2020123456", rs.getString("codigo"));
            assertEquals("Juan", rs.getString("nombres"));
            assertEquals("Pérez", rs.getString("apellidos"));
            assertEquals("juan.perez@upt.edu.pe", rs.getString("correo"));
            assertEquals("ESTUDIANTE", rs.getString("rol"));
            assertEquals("EPIS", rs.getString("escuela"));
            assertTrue(rs.getBoolean("activo"));
        }
    }
    
    @Test
    @Order(2)
    @DisplayName("registrarUsuario debe rechazar correo duplicado (UNIQUE constraint)")
    void testRegistrarUsuarioCorreoDuplicado() throws SQLException {
        // Arrange
        Usuario usuario1 = crearUsuarioCompleto();
        usuario1.setCorreo("duplicate@test.com");
        
        Usuario usuario2 = crearUsuarioCompleto();
        usuario2.setCodigo("2020999999");
        usuario2.setCorreo("duplicate@test.com");  // Mismo correo
        
        // Act
        boolean primero = usuarioNegocio.registrarUsuario(usuario1);
        
        // Assert
        assertTrue(primero, "Primer registro debe ser exitoso");
        
        // Segundo registro debe fallar
        assertThrows(SQLException.class, () -> {
            usuarioNegocio.registrarUsuario(usuario2);
        }, "Debe lanzar SQLException por correo duplicado");
        
        // Verificar que solo existe 1 usuario
        assertEquals(1, contarRegistros("usuarios"));
    }
    
    @Test
    @Order(3)
    @DisplayName("registrarUsuario debe rechazar código duplicado (UNIQUE constraint)")
    void testRegistrarUsuarioCodigoDuplicado() throws SQLException {
        // Arrange
        Usuario usuario1 = crearUsuarioCompleto();
        usuario1.setCodigo("2020111111");
        
        Usuario usuario2 = crearUsuarioCompleto();
        usuario2.setCodigo("2020111111");  // Mismo código
        usuario2.setCorreo("diferente@test.com");
        
        // Act & Assert
        assertTrue(usuarioNegocio.registrarUsuario(usuario1));
        
        assertThrows(SQLException.class, () -> {
            usuarioNegocio.registrarUsuario(usuario2);
        });
    }
    
    @Test
    @Order(4)
    @DisplayName("registrarUsuario debe validar rol ENUM")
    void testRegistrarUsuarioRolInvalido() throws SQLException {
        // Arrange
        Usuario usuario = crearUsuarioCompleto();
        
        // Act & Assert
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                 "VALUES (?, ?, ?, ?, ?, ?)")) {
            
            pstmt.setString(1, "2020888888");
            pstmt.setString(2, "Test");
            pstmt.setString(3, "User");
            pstmt.setString(4, "test@test.com");
            pstmt.setString(5, "pass123");
            pstmt.setString(6, "SUPERADMIN");  // Rol no válido
            
            assertThrows(SQLException.class, pstmt::executeUpdate);
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE VALIDACIÓN DE LOGIN
    // ═══════════════════════════════════════════════════════
    
    @Test
    @Order(5)
    @DisplayName("validarLogin debe autenticar usuario existente")
    void testValidarLoginExitoso() throws SQLException {
        // Arrange
        Usuario usuario = crearUsuarioCompleto();
        usuario.setContrasena("Password123");
        usuarioNegocio.registrarUsuario(usuario);
        
        // Act
        Usuario resultado = usuarioNegocio.validarLogin(
            "juan.perez@upt.edu.pe", 
            "Password123"
        );
        
        // Assert
        assertNotNull(resultado, "Debe retornar usuario");
        assertEquals("juan.perez@upt.edu.pe", resultado.getCorreo());
        assertEquals("Juan", resultado.getNombres());
        assertEquals("ESTUDIANTE", resultado.getRol());
    }
    
    @Test
    @Order(6)
    @DisplayName("validarLogin debe rechazar contraseña incorrecta")
    void testValidarLoginContrasenaIncorrecta() throws SQLException {
        // Arrange
        Usuario usuario = crearUsuarioCompleto();
        usuario.setContrasena("Password123");
        usuarioNegocio.registrarUsuario(usuario);
        
        // Act
        Usuario resultado = usuarioNegocio.validarLogin(
            "juan.perez@upt.edu.pe", 
            "WrongPassword"
        );
        
        // Assert
        assertNull(resultado, "No debe autenticar con contraseña incorrecta");
    }
    
    @Test
    @Order(7)
    @DisplayName("validarLogin debe rechazar usuario inactivo")
    void testValidarLoginUsuarioInactivo() throws SQLException {
        // Arrange
        Usuario usuario = crearUsuarioCompleto();
        usuario.setActivo(false);
        usuarioNegocio.registrarUsuario(usuario);
        
        // Act
        Usuario resultado = usuarioNegocio.validarLogin(
            usuario.getCorreo(), 
            usuario.getContrasena()
        );
        
        // Assert
        assertNull(resultado, "No debe autenticar usuario inactivo");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CONSULTAS
    // ═══════════════════════════════════════════════════════
    
    @Test
    @Order(8)
    @DisplayName("listarTodosUsuarios debe retornar todos los registros")
    void testListarTodosUsuarios() throws SQLException {
        // Arrange
        insertarUsuariosPrueba(5);
        
        // Act
        List<Usuario> usuarios = usuarioNegocio.listarTodosUsuarios();
        
        // Assert
        assertThat(usuarios)
            .hasSize(5)
            .allMatch(u -> u.getIdUsuario() > 0)
            .allMatch(u -> u.getCorreo() != null);
    }
    
    @Test
    @Order(9)
    @DisplayName("obtenerUsuarioPorId debe retornar usuario correcto")
    void testObtenerUsuarioPorId() throws SQLException {
        // Arrange
        Usuario usuario = crearUsuarioCompleto();
        usuarioNegocio.registrarUsuario(usuario);
        
        int id = obtenerUltimoIdInsertado();
        
        // Act
        Usuario obtenido = usuarioNegocio.obtenerUsuarioPorId(id);
        
        // Assert
        assertNotNull(obtenido);
        assertEquals(id, obtenido.getIdUsuario());
        assertEquals("juan.perez@upt.edu.pe", obtenido.getCorreo());
    }
    
    @Test
    @Order(10)
    @DisplayName("contarUsuariosPorRol debe contar correctamente")
    void testContarUsuariosPorRol() throws SQLException {
        // Arrange
        insertarUsuario("EST1", "ESTUDIANTE");
        insertarUsuario("EST2", "ESTUDIANTE");
        insertarUsuario("EST3", "ESTUDIANTE");
        insertarUsuario("COORD1", "COORDINADOR");
        insertarUsuario("ADMIN1", "ADMINISTRADOR");
        
        // Act
        int estudiantes = usuarioNegocio.contarUsuariosPorRol("ESTUDIANTE");
        int coordinadores = usuarioNegocio.contarUsuariosPorRol("COORDINADOR");
        int admins = usuarioNegocio.contarUsuariosPorRol("ADMINISTRADOR");
        
        // Assert
        assertEquals(3, estudiantes);
        assertEquals(1, coordinadores);
        assertEquals(1, admins);
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE ACTUALIZACIÓN
    // ═══════════════════════════════════════════════════════
    
    @Test
    @Order(11)
    @DisplayName("cambiarEstadoUsuario debe actualizar campo activo")
    void testCambiarEstadoUsuario() throws SQLException {
        // Arrange
        Usuario usuario = crearUsuarioCompleto();
        usuario.setActivo(true);
        usuarioNegocio.registrarUsuario(usuario);
        
        int id = obtenerUltimoIdInsertado();
        
        // Act - Desactivar
        boolean resultado1 = usuarioNegocio.cambiarEstadoUsuario(id, false);
        
        // Assert
        assertTrue(resultado1);
        Usuario desactivado = usuarioNegocio.obtenerUsuarioPorId(id);
        assertFalse(desactivado.isActivo());
        
        // Act - Activar
        boolean resultado2 = usuarioNegocio.cambiarEstadoUsuario(id, true);
        
        // Assert
        assertTrue(resultado2);
        Usuario activado = usuarioNegocio.obtenerUsuarioPorId(id);
        assertTrue(activado.isActivo());
    }
    
    @Test
    @Order(12)
    @DisplayName("actualizarUsuario debe modificar todos los campos")
    void testActualizarUsuario() throws SQLException {
        // Arrange
        Usuario original = crearUsuarioCompleto();
        usuarioNegocio.registrarUsuario(original);
        
        int id = obtenerUltimoIdInsertado();
        
        // Modificar datos
        Usuario modificado = new Usuario();
        modificado.setIdUsuario(id);
        modificado.setNombres("Pedro");
        modificado.setApellidos("García");
        modificado.setTelefono("999888777");
        modificado.setEscuela("EPIC");
        
        // Act
        boolean resultado = usuarioNegocio.actualizarUsuario(modificado);
        
        // Assert
        assertTrue(resultado);
        
        Usuario actualizado = usuarioNegocio.obtenerUsuarioPorId(id);
        assertEquals("Pedro", actualizado.getNombres());
        assertEquals("García", actualizado.getApellidos());
        assertEquals("999888777", actualizado.getTelefono());
        assertEquals("EPIC", actualizado.getEscuela());
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS AUXILIARES
    // ═══════════════════════════════════════════════════════
    
    private Usuario crearUsuarioCompleto() {
        Usuario usuario = new Usuario();
        usuario.setCodigo("2020123456");
        usuario.setNombres("Juan");
        usuario.setApellidos("Pérez");
        usuario.setCorreo("juan.perez@upt.edu.pe");
        usuario.setContrasena("Pass123");
        usuario.setRol("ESTUDIANTE");
        usuario.setEscuela("EPIS");
        usuario.setTelefono("987654321");
        usuario.setActivo(true);
        return usuario;
    }
    
    private void insertarUsuariosPrueba(int cantidad) throws SQLException {
        for (int i = 1; i <= cantidad; i++) {
            Usuario usuario = new Usuario();
            usuario.setCodigo("2020" + String.format("%06d", i));
            usuario.setNombres("Usuario" + i);
            usuario.setApellidos("Test" + i);
            usuario.setCorreo("usuario" + i + "@test.com");
            usuario.setContrasena("pass" + i);
            usuario.setRol("ESTUDIANTE");
            usuario.setEscuela("EPIS");
            usuario.setActivo(true);
            
            usuarioNegocio.registrarUsuario(usuario);
        }
    }
    
    private void insertarUsuario(String codigo, String rol) throws SQLException {
        Usuario usuario = new Usuario();
        usuario.setCodigo(codigo);
        usuario.setNombres("Test");
        usuario.setApellidos("User");
        usuario.setCorreo(codigo.toLowerCase() + "@test.com");
        usuario.setContrasena("pass123");
        usuario.setRol(rol);
        usuario.setActivo(true);
        
        usuarioNegocio.registrarUsuario(usuario);
    }
    
    private int obtenerUltimoIdInsertado() throws SQLException {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT LAST_INSERT_ID()")) {
            
            return rs.next() ? rs.getInt(1) : -1;
        }
    }
}
```

---

**Continúa en Parte 2:** Tests de Campañas, Transacciones y Concurrencia

---

*Generado el 3 de Diciembre de 2025*  
*Testcontainers 1.19.3 + JUnit 5 + MySQL 8.0*
