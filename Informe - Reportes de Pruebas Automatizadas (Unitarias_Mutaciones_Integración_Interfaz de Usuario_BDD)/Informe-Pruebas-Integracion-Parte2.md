# 🔗 Informe de Pruebas de Integración - Parte 2
## Sistema de Voluntariado UPT
### Tests Avanzados: Transacciones, Concurrencia y Relaciones

---

**Continuación de:** Informe-Pruebas-Integracion-Parte1.md  
**Fecha:** 3 de Diciembre de 2025

---

## 📑 Tabla de Contenidos (Parte 2)

6. [Tests de Relaciones entre Tablas](#tests-relaciones)
7. [Tests de Transacciones](#tests-transacciones)
8. [Tests de Concurrencia](#tests-concurrencia)
9. [Tests de Performance](#tests-performance)
10. [CI/CD Integration](#cicd-integration)

---

## 6. 🔗 Tests de Relaciones entre Tablas

### 6.1 CampanaNegocioIntegrationTest.java

```java
package integration.negocio;

import entidad.Campana;
import entidad.Usuario;
import integration.base.IntegrationTestBase;
import negocio.CampanaNegocio;
import negocio.UsuarioNegocio;
import org.junit.jupiter.api.*;

import java.sql.*;
import java.time.LocalDate;
import java.util.List;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Integration Tests - CampanaNegocio con FK Relations")
class CampanaNegocioIntegrationTest extends IntegrationTestBase {
    
    private CampanaNegocio campanaNegocio;
    private UsuarioNegocio usuarioNegocio;
    private int idCoordinador;
    
    @BeforeEach
    void setUp() throws SQLException {
        campanaNegocio = new CampanaNegocio(dataSource);
        usuarioNegocio = new UsuarioNegocio(dataSource);
        
        // Crear coordinador para las pruebas
        Usuario coordinador = new Usuario();
        coordinador.setCodigo("COORD001");
        coordinador.setNombres("Carlos");
        coordinador.setApellidos("Coordinador");
        coordinador.setCorreo("coord@test.com");
        coordinador.setContrasena("pass123");
        coordinador.setRol("COORDINADOR");
        coordinador.setActivo(true);
        
        usuarioNegocio.registrarUsuario(coordinador);
        idCoordinador = obtenerUltimoIdInsertado("usuarios");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE FOREIGN KEY CONSTRAINTS
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("crear campaña debe respetar FK con usuarios (coordinador)")
    void testCrearCampanaConCoordinadorValido() throws SQLException {
        // Arrange
        Campana campana = crearCampanaCompleta(idCoordinador);
        
        // Act
        boolean resultado = campanaNegocio.crearCampana(campana);
        
        // Assert
        assertTrue(resultado);
        
        // Verificar que se guardó con el coordinador correcto
        int idCampana = obtenerUltimoIdInsertado("campanas");
        Campana guardada = campanaNegocio.obtenerPorId(idCampana);
        
        assertEquals(idCoordinador, guardada.getIdCoordinador());
    }
    
    @Test
    @DisplayName("crear campaña debe fallar con coordinador inexistente (FK constraint)")
    void testCrearCampanaCoordinadorInexistente() {
        // Arrange
        Campana campana = crearCampanaCompleta(99999);  // ID que no existe
        
        // Act & Assert
        assertThrows(SQLException.class, () -> {
            campanaNegocio.crearCampana(campana);
        }, "Debe lanzar SQLException por violación de FK");
    }
    
    @Test
    @DisplayName("eliminar coordinador debe fallar si tiene campañas (FK constraint)")
    void testEliminarCoordinadorConCampanas() throws SQLException {
        // Arrange
        Campana campana = crearCampanaCompleta(idCoordinador);
        campanaNegocio.crearCampana(campana);
        
        // Act & Assert
        assertThrows(SQLException.class, () -> {
            try (Connection conn = getConnection();
                 PreparedStatement pstmt = conn.prepareStatement(
                     "DELETE FROM usuarios WHERE id_usuario = ?")) {
                
                pstmt.setInt(1, idCoordinador);
                pstmt.executeUpdate();
            }
        }, "No se puede eliminar coordinador con campañas asociadas");
    }
    
    @Test
    @DisplayName("CASCADE DELETE: eliminar campaña debe eliminar inscripciones")
    void testCascadeDeleteCampana() throws SQLException {
        // Arrange
        Campana campana = crearCampanaCompleta(idCoordinador);
        campanaNegocio.crearCampana(campana);
        int idCampana = obtenerUltimoIdInsertado("campanas");
        
        // Crear estudiante e inscripción
        Usuario estudiante = crearEstudiante("EST001");
        usuarioNegocio.registrarUsuario(estudiante);
        int idEstudiante = obtenerUltimoIdInsertado("usuarios");
        
        insertarInscripcion(idEstudiante, idCampana);
        
        // Verificar que existe inscripción
        assertEquals(1, contarInscripciones(idCampana));
        
        // Act - Eliminar campaña
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "DELETE FROM campanas WHERE id_campana = ?")) {
            
            pstmt.setInt(1, idCampana);
            pstmt.executeUpdate();
        }
        
        // Assert - Inscripciones deben haberse eliminado también
        assertEquals(0, contarInscripciones(idCampana));
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CHECK CONSTRAINTS
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("crear campaña debe validar CHECK: fecha_fin >= fecha_inicio")
    void testCheckConstraintFechas() {
        // Arrange
        Campana campana = crearCampanaCompleta(idCoordinador);
        campana.setFechaInicio(LocalDate.of(2025, 12, 31));
        campana.setFechaFin(LocalDate.of(2025, 12, 1));  // Antes del inicio
        
        // Act & Assert
        assertThrows(SQLException.class, () -> {
            campanaNegocio.crearCampana(campana);
        }, "Fecha fin no puede ser anterior a fecha inicio");
    }
    
    @Test
    @DisplayName("crear campaña debe validar CHECK: cupos >= 0")
    void testCheckConstraintCupos() throws SQLException {
        // Arrange
        Campana campana = crearCampanaCompleta(idCoordinador);
        
        // Act & Assert
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "INSERT INTO campanas (titulo, fecha_inicio, fecha_fin, cupos, id_coordinador) " +
                 "VALUES (?, ?, ?, ?, ?)")) {
            
            pstmt.setString(1, "Test");
            pstmt.setDate(2, Date.valueOf(LocalDate.now()));
            pstmt.setDate(3, Date.valueOf(LocalDate.now().plusDays(7)));
            pstmt.setInt(4, -5);  // Cupos negativos
            pstmt.setInt(5, idCoordinador);
            
            assertThrows(SQLException.class, pstmt::executeUpdate,
                "Cupos no pueden ser negativos");
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CONSULTAS CON JOIN
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("listarCampanasConCoordinador debe hacer JOIN correctamente")
    void testJoinCampanasConCoordinador() throws SQLException {
        // Arrange
        Campana campana1 = crearCampanaCompleta(idCoordinador);
        campana1.setTitulo("Campaña 1");
        campanaNegocio.crearCampana(campana1);
        
        Campana campana2 = crearCampanaCompleta(idCoordinador);
        campana2.setTitulo("Campaña 2");
        campanaNegocio.crearCampana(campana2);
        
        // Act
        List<Campana> campanas = campanaNegocio.listarPorCoordinador(idCoordinador);
        
        // Assert
        assertThat(campanas)
            .hasSize(2)
            .extracting(Campana::getIdCoordinador)
            .containsOnly(idCoordinador);
        
        assertThat(campanas)
            .extracting(Campana::getTitulo)
            .containsExactlyInAnyOrder("Campaña 1", "Campaña 2");
    }
    
    @Test
    @DisplayName("obtener campañas con inscripciones debe calcular cupos disponibles")
    void testObtenerCampanasConCuposDisponibles() throws SQLException {
        // Arrange
        Campana campana = crearCampanaCompleta(idCoordinador);
        campana.setCupos(10);
        campanaNegocio.crearCampana(campana);
        int idCampana = obtenerUltimoIdInsertado("campanas");
        
        // Crear 3 estudiantes inscritos
        for (int i = 1; i <= 3; i++) {
            Usuario est = crearEstudiante("EST00" + i);
            usuarioNegocio.registrarUsuario(est);
            int idEst = obtenerUltimoIdInsertado("usuarios");
            insertarInscripcion(idEst, idCampana);
        }
        
        // Act - Query con LEFT JOIN para contar inscripciones
        int cuposDisponibles = campanaNegocio.obtenerCuposDisponibles(idCampana);
        
        // Assert
        assertEquals(7, cuposDisponibles, "10 cupos - 3 inscritos = 7 disponibles");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE INTEGRIDAD REFERENCIAL COMPLEJA
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("inscripción completa: estudiante -> campaña -> coordinador")
    void testInscripcionCompletaCadenaFK() throws SQLException {
        // Arrange - Crear toda la cadena
        Campana campana = crearCampanaCompleta(idCoordinador);
        campanaNegocio.crearCampana(campana);
        int idCampana = obtenerUltimoIdInsertado("campanas");
        
        Usuario estudiante = crearEstudiante("EST001");
        usuarioNegocio.registrarUsuario(estudiante);
        int idEstudiante = obtenerUltimoIdInsertado("usuarios");
        
        // Act - Crear inscripción
        insertarInscripcion(idEstudiante, idCampana);
        int idInscripcion = obtenerUltimoIdInsertado("inscripciones");
        
        // Assert - Verificar toda la cadena con JOIN
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT i.id_inscripcion, u.nombres AS estudiante, " +
                 "       c.titulo AS campana, coord.nombres AS coordinador " +
                 "FROM inscripciones i " +
                 "JOIN usuarios u ON i.id_estudiante = u.id_usuario " +
                 "JOIN campanas c ON i.id_campana = c.id_campana " +
                 "JOIN usuarios coord ON c.id_coordinador = coord.id_usuario " +
                 "WHERE i.id_inscripcion = ?")) {
            
            pstmt.setInt(1, idInscripcion);
            ResultSet rs = pstmt.executeQuery();
            
            assertTrue(rs.next());
            assertEquals("Test", rs.getString("estudiante"));
            assertTrue(rs.getString("campana").contains("Limpieza"));
            assertEquals("Carlos", rs.getString("coordinador"));
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS AUXILIARES
    // ═══════════════════════════════════════════════════════
    
    private Campana crearCampanaCompleta(int idCoord) {
        Campana campana = new Campana();
        campana.setTitulo("Limpieza de Playas");
        campana.setDescripcion("Campaña de limpieza ambiental");
        campana.setFechaInicio(LocalDate.now().plusDays(7));
        campana.setFechaFin(LocalDate.now().plusDays(14));
        campana.setUbicacion("Playa Boca del Río");
        campana.setCupos(50);
        campana.setHorasValidadas(8);
        campana.setIdCoordinador(idCoord);
        campana.setEstado("PLANIFICADA");
        return campana;
    }
    
    private Usuario crearEstudiante(String codigo) {
        Usuario est = new Usuario();
        est.setCodigo(codigo);
        est.setNombres("Test");
        est.setApellidos("Estudiante");
        est.setCorreo(codigo.toLowerCase() + "@test.com");
        est.setContrasena("pass123");
        est.setRol("ESTUDIANTE");
        est.setActivo(true);
        return est;
    }
    
    private void insertarInscripcion(int idEst, int idCamp) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "INSERT INTO inscripciones (id_estudiante, id_campana, estado) " +
                 "VALUES (?, ?, 'INSCRITO')")) {
            
            pstmt.setInt(1, idEst);
            pstmt.setInt(2, idCamp);
            pstmt.executeUpdate();
        }
    }
    
    private int contarInscripciones(int idCampana) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT COUNT(*) FROM inscripciones WHERE id_campana = ?")) {
            
            pstmt.setInt(1, idCampana);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
    
    private int obtenerUltimoIdInsertado(String tabla) throws SQLException {
        try (Connection conn = getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT LAST_INSERT_ID()")) {
            
            return rs.next() ? rs.getInt(1) : -1;
        }
    }
}
```

---

## 7. 💱 Tests de Transacciones

### 7.1 TransactionIntegrationTest.java

```java
package integration.transacciones;

import entidad.Asistencia;
import entidad.Campana;
import entidad.Inscripcion;
import entidad.Usuario;
import integration.base.IntegrationTestBase;
import org.junit.jupiter.api.*;

import java.sql.*;
import java.time.LocalDate;

import static org.assertj.core.api.Assertions.*;
import static org.junit.jupiter.api.Assertions.*;

@DisplayName("Integration Tests - Transacciones ACID")
class TransactionIntegrationTest extends IntegrationTestBase {
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE ATOMICIDAD
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("ATOMICITY: Rollback completo si falla una operación")
    void testAtomicityRollbackCompleto() throws SQLException {
        Connection conn = null;
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false);  // Iniciar transacción
            
            // Operación 1: Insertar usuario (exitosa)
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                "VALUES (?, ?, ?, ?, ?, ?)")) {
                
                pstmt.setString(1, "2020111111");
                pstmt.setString(2, "Juan");
                pstmt.setString(3, "Pérez");
                pstmt.setString(4, "juan@test.com");
                pstmt.setString(5, "pass123");
                pstmt.setString(6, "ESTUDIANTE");
                pstmt.executeUpdate();
            }
            
            // Operación 2: Insertar campaña con FK inválido (fallará)
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO campanas (titulo, fecha_inicio, fecha_fin, id_coordinador) " +
                "VALUES (?, ?, ?, ?)")) {
                
                pstmt.setString(1, "Campaña Test");
                pstmt.setDate(2, Date.valueOf(LocalDate.now()));
                pstmt.setDate(3, Date.valueOf(LocalDate.now().plusDays(7)));
                pstmt.setInt(4, 99999);  // Coordinador que no existe
                
                pstmt.executeUpdate();
            }
            
            conn.commit();  // No debería llegar aquí
            fail("Debería haber lanzado SQLException");
            
        } catch (SQLException e) {
            // Rollback automático
            if (conn != null) {
                conn.rollback();
            }
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        
        // Assert - NADA debe haberse guardado
        assertEquals(0, contarRegistros("usuarios"), "Usuario NO debe existir (rollback)");
        assertEquals(0, contarRegistros("campanas"), "Campaña NO debe existir (rollback)");
    }
    
    @Test
    @DisplayName("ATOMICITY: Commit exitoso de múltiples operaciones")
    void testAtomicityCommitExitoso() throws SQLException {
        Connection conn = null;
        int idCoordinador = -1;
        int idCampana = -1;
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Op 1: Insertar coordinador
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                "VALUES (?, ?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {
                
                pstmt.setString(1, "COORD001");
                pstmt.setString(2, "Carlos");
                pstmt.setString(3, "Coordinador");
                pstmt.setString(4, "coord@test.com");
                pstmt.setString(5, "pass123");
                pstmt.setString(6, "COORDINADOR");
                pstmt.executeUpdate();
                
                ResultSet keys = pstmt.getGeneratedKeys();
                if (keys.next()) {
                    idCoordinador = keys.getInt(1);
                }
            }
            
            // Op 2: Insertar campaña con el coordinador creado
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO campanas (titulo, fecha_inicio, fecha_fin, cupos, id_coordinador) " +
                "VALUES (?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {
                
                pstmt.setString(1, "Campaña Test");
                pstmt.setDate(2, Date.valueOf(LocalDate.now()));
                pstmt.setDate(3, Date.valueOf(LocalDate.now().plusDays(7)));
                pstmt.setInt(4, 50);
                pstmt.setInt(5, idCoordinador);
                pstmt.executeUpdate();
                
                ResultSet keys = pstmt.getGeneratedKeys();
                if (keys.next()) {
                    idCampana = keys.getInt(1);
                }
            }
            
            // Op 3: Insertar estudiante
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                "VALUES (?, ?, ?, ?, ?, ?)")) {
                
                pstmt.setString(1, "2020111111");
                pstmt.setString(2, "Juan");
                pstmt.setString(3, "Pérez");
                pstmt.setString(4, "juan@test.com");
                pstmt.setString(5, "pass123");
                pstmt.setString(6, "ESTUDIANTE");
                pstmt.executeUpdate();
            }
            
            conn.commit();  // ✅ Todas las operaciones exitosas
            
        } catch (SQLException e) {
            if (conn != null) {
                conn.rollback();
            }
            throw e;
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        
        // Assert - TODO debe haberse guardado
        assertEquals(2, contarRegistros("usuarios"), "Debe haber 2 usuarios");
        assertEquals(1, contarRegistros("campanas"), "Debe haber 1 campaña");
        
        // Verificar relación FK
        Campana campana = obtenerCampana(idCampana);
        assertEquals(idCoordinador, campana.getIdCoordinador());
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE CONSISTENCIA
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("CONSISTENCY: Constraints se mantienen durante transacción")
    void testConsistencyConstraints() throws SQLException {
        Connection conn = null;
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Insertar usuario
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                "VALUES (?, ?, ?, ?, ?, ?)")) {
                
                pstmt.setString(1, "2020111111");
                pstmt.setString(2, "Juan");
                pstmt.setString(3, "Pérez");
                pstmt.setString(4, "juan@test.com");
                pstmt.setString(5, "pass123");
                pstmt.setString(6, "ESTUDIANTE");
                pstmt.executeUpdate();
            }
            
            // Intentar insertar duplicado (UNIQUE constraint)
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                "VALUES (?, ?, ?, ?, ?, ?)")) {
                
                pstmt.setString(1, "2020111111");  // Código duplicado
                pstmt.setString(2, "Pedro");
                pstmt.setString(3, "García");
                pstmt.setString(4, "pedro@test.com");
                pstmt.setString(5, "pass456");
                pstmt.setString(6, "ESTUDIANTE");
                
                assertThrows(SQLException.class, pstmt::executeUpdate,
                    "UNIQUE constraint debe validarse en transacción");
            }
            
            conn.rollback();  // Rollback por el error
            
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE AISLAMIENTO
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("ISOLATION: Dirty Read Prevention (READ_COMMITTED)")
    void testIsolationDirtyReadPrevention() throws Exception {
        // Thread 1: Transacción que modifica pero no commitea
        Thread thread1 = new Thread(() -> {
            try (Connection conn = getConnection()) {
                conn.setAutoCommit(false);
                conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
                
                // Insertar usuario
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                    "VALUES (?, ?, ?, ?, ?, ?)")) {
                    
                    pstmt.setString(1, "2020111111");
                    pstmt.setString(2, "Juan");
                    pstmt.setString(3, "Pérez");
                    pstmt.setString(4, "juan@test.com");
                    pstmt.setString(5, "pass123");
                    pstmt.setString(6, "ESTUDIANTE");
                    pstmt.executeUpdate();
                }
                
                // Esperar sin hacer commit
                Thread.sleep(2000);
                
                conn.rollback();  // Finalmente hacer rollback
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        
        thread1.start();
        Thread.sleep(500);  // Dar tiempo a que thread1 inserte
        
        // Thread 2: Intentar leer el dato no commiteado
        try (Connection conn = getConnection()) {
            conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
            
            try (PreparedStatement pstmt = conn.prepareStatement(
                "SELECT COUNT(*) FROM usuarios WHERE codigo = ?")) {
                
                pstmt.setString(1, "2020111111");
                ResultSet rs = pstmt.executeQuery();
                rs.next();
                
                int count = rs.getInt(1);
                assertEquals(0, count, "NO debe ver datos no commiteados (Dirty Read Prevention)");
            }
        }
        
        thread1.join();
    }
    
    @Test
    @DisplayName("ISOLATION: Phantom Read con REPEATABLE_READ")
    void testIsolationPhantomRead() throws Exception {
        // Insertar datos iniciales
        insertarUsuarioPrueba("2020111111");
        
        final int[] count1 = new int[1];
        final int[] count2 = new int[1];
        
        Thread reader = new Thread(() -> {
            try (Connection conn = getConnection()) {
                conn.setAutoCommit(false);
                conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
                
                // Primera lectura
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM usuarios")) {
                    
                    ResultSet rs = pstmt.executeQuery();
                    rs.next();
                    count1[0] = rs.getInt(1);
                }
                
                Thread.sleep(2000);  // Esperar que otro thread inserte
                
                // Segunda lectura
                try (PreparedStatement pstmt = conn.prepareStatement(
                    "SELECT COUNT(*) FROM usuarios")) {
                    
                    ResultSet rs = pstmt.executeQuery();
                    rs.next();
                    count2[0] = rs.getInt(1);
                }
                
                conn.commit();
                
            } catch (Exception e) {
                e.printStackTrace();
            }
        });
        
        reader.start();
        Thread.sleep(500);
        
        // Insertar nuevo usuario en otra transacción
        insertarUsuarioPrueba("2020222222");
        
        reader.join();
        
        // Assert - En REPEATABLE_READ, los counts deben ser iguales
        // (MySQL InnoDB previene phantom reads)
        assertEquals(count1[0], count2[0], 
            "REPEATABLE_READ debe prevenir Phantom Reads");
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE DURABILIDAD
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("DURABILITY: Datos persisten después de commit")
    void testDurabilityDatosPersisten() throws SQLException {
        int idUsuario;
        
        // Transacción 1: Insertar y commit
        try (Connection conn = getConnection()) {
            conn.setAutoCommit(false);
            
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                "VALUES (?, ?, ?, ?, ?, ?)",
                Statement.RETURN_GENERATED_KEYS)) {
                
                pstmt.setString(1, "2020111111");
                pstmt.setString(2, "Juan");
                pstmt.setString(3, "Pérez");
                pstmt.setString(4, "juan@test.com");
                pstmt.setString(5, "pass123");
                pstmt.setString(6, "ESTUDIANTE");
                pstmt.executeUpdate();
                
                ResultSet keys = pstmt.getGeneratedKeys();
                keys.next();
                idUsuario = keys.getInt(1);
            }
            
            conn.commit();  // COMMIT persistente
        }
        
        // Simular "reinicio" - nueva conexión
        try (Connection conn = getConnection()) {
            try (PreparedStatement pstmt = conn.prepareStatement(
                "SELECT * FROM usuarios WHERE id_usuario = ?")) {
                
                pstmt.setInt(1, idUsuario);
                ResultSet rs = pstmt.executeQuery();
                
                assertTrue(rs.next(), "Datos deben persistir después de commit");
                assertEquals("Juan", rs.getString("nombres"));
            }
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // TESTS DE SAVEPOINTS
    // ═══════════════════════════════════════════════════════
    
    @Test
    @DisplayName("SAVEPOINT: Rollback parcial a savepoint")
    void testSavepointRollbackParcial() throws SQLException {
        Connection conn = null;
        
        try {
            conn = getConnection();
            conn.setAutoCommit(false);
            
            // Operación 1: Insertar coordinador
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                "VALUES (?, ?, ?, ?, ?, ?)")) {
                
                pstmt.setString(1, "COORD001");
                pstmt.setString(2, "Carlos");
                pstmt.setString(3, "Coordinador");
                pstmt.setString(4, "coord@test.com");
                pstmt.setString(5, "pass123");
                pstmt.setString(6, "COORDINADOR");
                pstmt.executeUpdate();
            }
            
            Savepoint savepoint1 = conn.setSavepoint("afterCoordinador");
            
            // Operación 2: Insertar estudiante
            try (PreparedStatement pstmt = conn.prepareStatement(
                "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                "VALUES (?, ?, ?, ?, ?, ?)")) {
                
                pstmt.setString(1, "2020111111");
                pstmt.setString(2, "Juan");
                pstmt.setString(3, "Pérez");
                pstmt.setString(4, "juan@test.com");
                pstmt.setString(5, "pass123");
                pstmt.setString(6, "ESTUDIANTE");
                pstmt.executeUpdate();
            }
            
            // Rollback solo al savepoint (mantiene coordinador)
            conn.rollback(savepoint1);
            
            conn.commit();
            
        } finally {
            if (conn != null) {
                conn.setAutoCommit(true);
                conn.close();
            }
        }
        
        // Assert - Solo coordinador debe existir
        assertEquals(1, contarRegistros("usuarios"));
        assertEquals(1, contarUsuariosPorRol("COORDINADOR"));
        assertEquals(0, contarUsuariosPorRol("ESTUDIANTE"));
    }
    
    // ═══════════════════════════════════════════════════════
    // MÉTODOS AUXILIARES
    // ═══════════════════════════════════════════════════════
    
    private void insertarUsuarioPrueba(String codigo) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "INSERT INTO usuarios (codigo, nombres, apellidos, correo, contrasena, rol) " +
                 "VALUES (?, ?, ?, ?, ?, ?)")) {
            
            pstmt.setString(1, codigo);
            pstmt.setString(2, "Test");
            pstmt.setString(3, "User");
            pstmt.setString(4, codigo + "@test.com");
            pstmt.setString(5, "pass123");
            pstmt.setString(6, "ESTUDIANTE");
            pstmt.executeUpdate();
        }
    }
    
    private Campana obtenerCampana(int id) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT * FROM campanas WHERE id_campana = ?")) {
            
            pstmt.setInt(1, id);
            ResultSet rs = pstmt.executeQuery();
            
            if (rs.next()) {
                Campana c = new Campana();
                c.setIdCampana(rs.getInt("id_campana"));
                c.setIdCoordinador(rs.getInt("id_coordinador"));
                c.setTitulo(rs.getString("titulo"));
                return c;
            }
            return null;
        }
    }
    
    private int contarUsuariosPorRol(String rol) throws SQLException {
        try (Connection conn = getConnection();
             PreparedStatement pstmt = conn.prepareStatement(
                 "SELECT COUNT(*) FROM usuarios WHERE rol = ?")) {
            
            pstmt.setString(1, rol);
            ResultSet rs = pstmt.executeQuery();
            return rs.next() ? rs.getInt(1) : 0;
        }
    }
}
```

---

**Continúa en Parte 3:** Tests de Concurrencia, Performance y CI/CD

---

*Generado el 3 de Diciembre de 2025*  
*Testcontainers 1.19.3 + MySQL 8.0 + ACID Tests*
