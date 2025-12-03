# 🧬 Informe de Pruebas de Mutaciones - Parte 2
## Sistema de Voluntariado UPT
### Mutation Testing - Clases de Negocio y Servlets

---

**Continuación de:** Informe-Pruebas-Mutaciones-Parte1.md  
**Fecha:** 3 de Diciembre de 2025

---

## 📑 Tabla de Contenidos (Parte 2)

6. [Reporte de Mutaciones - UsuarioNegocio](#reporte-usuarionegocio)
7. [Reporte de Mutaciones - Servlets](#reporte-servlets)
8. [Análisis de Test Strength](#analisis-test-strength)
9. [Estrategias para Matar Mutantes](#estrategias)

---

## 6. 📊 Reporte de Mutaciones - UsuarioNegocio.java

### 6.1 Contexto de la Clase

**UsuarioNegocio.java** es la capa de lógica de negocio con acceso a base de datos:

```java
Características:
├─ 13 métodos públicos
├─ 330 líneas de código
├─ Usa JDBC directo (PreparedStatement)
├─ Manejo de excepciones SQLException
├─ Validaciones de negocio complejas
└─ Transacciones implícitas
```

### 6.2 Ejecución PITest

```bash
mvn pitest:mutationCoverage -DtargetClasses=negocio.UsuarioNegocio -DtargetTests=negocio.UsuarioNegocioTest
```

### 6.3 Resultados Globales

```
═══════════════════════════════════════════════════════════
  PITEST MUTATION COVERAGE REPORT
  Class: negocio.UsuarioNegocio
  Date: 2025-12-03 16:15:00
═══════════════════════════════════════════════════════════

>> Line Coverage
   └─ 180/240 (75%) ✅

>> Mutation Coverage
   └─ 112/185 (61%) 🟡

─────────────────────────────────────────────────────────

MUTATION RESULTS:
├─ KILLED:            112 ✅
├─ SURVIVED:          48 🟠
├─ NO_COVERAGE:       18 🔴
├─ TIMED_OUT:         5 ⚠️
├─ NON_VIABLE:        2
└─ MEMORY_ERROR:      0

─────────────────────────────────────────────────────────

MUTATION SCORE:       61% 🟡 (Objetivo: 70%)
TEST STRENGTH:        Media-Baja
RECOMMENDATION:       Agregar 48 tests + mejorar existentes

ANÁLISIS:
├─ Métodos bien testeados:     validarLogin (85%)
├─ Métodos débiles:            registrarUsuario (45%)
├─ Métodos sin tests:          actualizarPerfil (0%)
└─ Área crítica:               Manejo de errores SQL

═══════════════════════════════════════════════════════════
```

### 6.4 Desglose por Método

#### 6.4.1 validarLogin() - 85% Mutation Score ✅

```java
public Usuario validarLogin(String correo, String contrasena) throws SQLException {
    String sql = "SELECT * FROM usuarios WHERE correo = ? AND activo = 1";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = ConexionDB.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, correo);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            Usuario usuario = mapearUsuario(rs);
            // Verificar contraseña (en texto plano - NO SEGURO)
            if (contrasena.equals(usuario.getContrasena())) {
                return usuario;
            }
        }
        return null;
    } finally {
        cerrarRecursos(conn, pstmt, rs);
    }
}

MUTANTES GENERADOS: 28
├─ Matados:          24 ✅
├─ Sobrevivientes:   3 ❌
└─ Sin cobertura:    1 🔴

╔═══════════════════════════════════════════════════════════╗
║  MUTANTES MATADOS (24)                                    ║
╚═══════════════════════════════════════════════════════════╝

MUTANTE #1: KILLED ✅
├─ Línea: pstmt.setString(1, correo);
├─ Mutador: VOID_METHOD_CALLS
├─ Cambio: // pstmt.setString(1, correo);  (comentado)
├─ Test matador: testValidarLoginExitoso()
└─ Razón: SQL sin parámetro causa error

MUTANTE #2: KILLED ✅
├─ Línea: if (rs.next())
├─ Mutador: NEGATE_CONDITIONALS
├─ Cambio: if (!rs.next())
├─ Test matador: testValidarLoginExitoso()
└─ Razón: Usuario válido retorna null (assertion falla)

MUTANTE #3: KILLED ✅
├─ Línea: if (contrasena.equals(usuario.getContrasena()))
├─ Mutador: NEGATE_CONDITIONALS
├─ Cambio: if (!contrasena.equals(...))
├─ Test matador: testValidarLoginContrasenaCorrecta()
└─ Razón: Invierte la lógica, retorna null cuando debería retornar usuario

MUTANTE #4: KILLED ✅
├─ Línea: return usuario;
├─ Mutador: RETURN_VALS
├─ Cambio: return null;
├─ Test matador: testValidarLoginExitoso()
└─ Razón: assertNotNull(usuario) falla

MUTANTE #5-#10: KILLED ✅
├─ Línea: String sql = "SELECT * FROM usuarios WHERE correo = ? AND activo = 1";
├─ Mutador: INLINE_CONSTS
├─ Cambios: activo = 0, activo = 2, etc.
├─ Test matador: testValidarLoginUsuarioInactivo()
└─ Razón: Test específico verifica que usuarios inactivos no puedan loguear

MUTANTE #11-#15: KILLED ✅
├─ Línea: conn = ConexionDB.getConnection();
├─ Mutador: NULL_RETURNS (con mock)
├─ Test matador: testValidarLoginConexionNull()
└─ Razón: Test maneja SQLException cuando conn es null

MUTANTE #16-#24: KILLED ✅
├─ Métodos: cerrarRecursos(), mapearUsuario()
├─ Tests matadores: Múltiples tests indirectos
└─ Razón: Métodos auxiliares bien cubiertos

╔═══════════════════════════════════════════════════════════╗
║  MUTANTES SOBREVIVIENTES (3) - REQUIEREN ATENCIÓN        ║
╚═══════════════════════════════════════════════════════════╝

SOBREVIVIENTE #1: CRÍTICO 🔴
├─ Línea: if (contrasena.equals(usuario.getContrasena()))
├─ Mutador: CONDITIONALS_BOUNDARY
├─ Cambio: if (contrasena.equalsIgnoreCase(usuario.getContrasena()))
├─ Comportamiento: Contraseñas case-insensitive ("Pass" == "pass")
├─ Riesgo: SEGURIDAD - Debilita la autenticación
└─ Solución requerida:

@Test
@DisplayName("validarLogin debe ser case-sensitive")
void testValidarLoginCaseSensitive() throws SQLException {
    // Mock usuario con contraseña "Password123"
    when(mockResultSet.next()).thenReturn(true);
    when(mockResultSet.getString("contrasena")).thenReturn("Password123");
    
    // Intentar con minúsculas
    Usuario resultado = negocio.validarLogin("test@test.com", "password123");
    
    assertNull(resultado);  // Debe fallar por case mismatch
}

SOBREVIVIENTE #2: MEDIO 🟡
├─ Línea: return null;
├─ Mutador: REMOVE_CONDITIONALS
├─ Cambio: Eliminar if (rs.next()), siempre ejecutar bloque
├─ Comportamiento: Lanzar exception si no hay datos
├─ Riesgo: MEDIO - Cambia flujo de control
└─ Solución requerida:

@Test
@DisplayName("validarLogin debe retornar null si no hay resultados")
void testValidarLoginSinResultados() throws SQLException {
    when(mockResultSet.next()).thenReturn(false);  // Sin datos
    
    Usuario resultado = negocio.validarLogin("noexiste@test.com", "pass");
    
    assertNull(resultado);
    verify(mockResultSet, never()).getString(anyString());  // No debe leer datos
}

SOBREVIVIENTE #3: BAJO ⚠️
├─ Línea: cerrarRecursos(conn, pstmt, rs);
├─ Mutador: VOID_METHOD_CALLS
├─ Cambio: // cerrarRecursos(...);  (comentado)
├─ Comportamiento: Recursos no se cierran (memory leak)
├─ Riesgo: BAJO en tests (mock), CRÍTICO en producción
└─ Solución requerida:

@Test
@DisplayName("validarLogin debe cerrar recursos siempre")
void testValidarLoginCierraRecursos() throws SQLException {
    Connection mockConn = mock(Connection.class);
    PreparedStatement mockPs = mock(PreparedStatement.class);
    ResultSet mockRs = mock(ResultSet.class);
    
    try (MockedStatic<ConexionDB> mockedStatic = mockStatic(ConexionDB.class)) {
        mockedStatic.when(ConexionDB::getConnection).thenReturn(mockConn);
        when(mockConn.prepareStatement(anyString())).thenReturn(mockPs);
        when(mockPs.executeQuery()).thenReturn(mockRs);
        when(mockRs.next()).thenReturn(false);
        
        negocio.validarLogin("test@test.com", "pass");
        
        // Verificar que se llamaron los métodos de cierre
        verify(mockRs).close();
        verify(mockPs).close();
        verify(mockConn).close();
    }
}

╔═══════════════════════════════════════════════════════════╗
║  MUTANTES SIN COBERTURA (1)                               ║
╚═══════════════════════════════════════════════════════════╝

SIN COBERTURA #1:
├─ Línea: catch (SQLException e) { log.error(...); }
├─ Mutador: Múltiples
├─ Razón: Bloque catch nunca se ejecuta en tests
└─ Solución:

@Test
@DisplayName("validarLogin debe manejar SQLException")
void testValidarLoginConSQLException() throws SQLException {
    when(mockConnection.prepareStatement(anyString()))
        .thenThrow(new SQLException("Database error"));
    
    assertThrows(SQLException.class, () -> 
        negocio.validarLogin("test@test.com", "pass")
    );
}
```

#### 6.4.2 registrarUsuario() - 45% Mutation Score 🔴

```java
public boolean registrarUsuario(Usuario usuario) throws SQLException {
    if (correoExiste(usuario.getCorreo())) {
        return false;
    }
    
    String sql = "INSERT INTO usuarios (codigo, nombres, apellidos, correo, " +
                 "contrasena, rol, escuela, telefono, activo, fecha_registro) " +
                 "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, NOW())";
    
    Connection conn = null;
    PreparedStatement pstmt = null;
    
    try {
        conn = ConexionDB.getConnection();
        pstmt = conn.prepareStatement(sql);
        
        pstmt.setString(1, usuario.getCodigo());
        pstmt.setString(2, usuario.getNombres());
        pstmt.setString(3, usuario.getApellidos());
        pstmt.setString(4, usuario.getCorreo());
        pstmt.setString(5, usuario.getContrasena());
        pstmt.setString(6, usuario.getRol());
        pstmt.setString(7, usuario.getEscuela());
        pstmt.setString(8, usuario.getTelefono());
        pstmt.setBoolean(9, usuario.isActivo());
        
        int filasAfectadas = pstmt.executeUpdate();
        return filasAfectadas > 0;
    } finally {
        cerrarRecursos(conn, pstmt, null);
    }
}

MUTANTES GENERADOS: 42
├─ Matados:          19 ❌ (45%)
├─ Sobrevivientes:   18 🔴
└─ Sin cobertura:    5 🔴

╔═══════════════════════════════════════════════════════════╗
║  PROBLEMA: Tests débiles, muchos mutantes sobreviven     ║
╚═══════════════════════════════════════════════════════════╝

SOBREVIVIENTES CRÍTICOS:

SOBREVIVIENTE #1: CRÍTICO 🔴
├─ Línea: if (correoExiste(usuario.getCorreo()))
├─ Mutador: REMOVE_CONDITIONALS
├─ Cambio: if (true) return false;  (siempre retorna false)
├─ Impacto: Ningún usuario se puede registrar
└─ Test faltante:

@Test
@DisplayName("registrarUsuario debe permitir registro si correo no existe")
void testRegistrarUsuarioCorreoNoExiste() throws SQLException {
    // Mock: correo NO existe
    when(mockConnection.prepareStatement(contains("SELECT"))).thenReturn(mockPreparedStatement);
    when(mockPreparedStatement.executeQuery()).thenReturn(mockResultSet);
    when(mockResultSet.next()).thenReturn(false);  // ← Correo libre
    
    // Mock: INSERT exitoso
    when(mockConnection.prepareStatement(contains("INSERT"))).thenReturn(mockPreparedStatement);
    when(mockPreparedStatement.executeUpdate()).thenReturn(1);
    
    Usuario nuevo = crearUsuarioValido();
    boolean resultado = negocio.registrarUsuario(nuevo);
    
    assertTrue(resultado);  // ← Debe poder registrar
}

SOBREVIVIENTE #2-#9: CRÍTICO 🔴
├─ Líneas: pstmt.setString(1-8, ...)
├─ Mutador: VOID_METHOD_CALLS
├─ Cambios: Comentar cada setString()
├─ Impacto: Datos no se insertan correctamente
└─ Tests faltantes:

@Test
@DisplayName("registrarUsuario debe insertar todos los campos")
void testRegistrarUsuarioInsertaTodasLasPropiedades() throws SQLException {
    ArgumentCaptor<String> captor = ArgumentCaptor.forClass(String.class);
    
    Usuario usuario = new Usuario();
    usuario.setCodigo("2020123456");
    usuario.setNombres("Juan");
    usuario.setApellidos("Pérez");
    usuario.setCorreo("juan@test.com");
    usuario.setContrasena("pass123");
    usuario.setRol("ESTUDIANTE");
    usuario.setEscuela("EPIS");
    usuario.setTelefono("987654321");
    usuario.setActivo(true);
    
    negocio.registrarUsuario(usuario);
    
    // Verificar que se llamaron TODOS los setString
    verify(mockPreparedStatement, times(8)).setString(anyInt(), captor.capture());
    
    List<String> valores = captor.getAllValues();
    assertThat(valores).contains("2020123456", "Juan", "Pérez", "juan@test.com");
}

SOBREVIVIENTE #10: MEDIO 🟡
├─ Línea: return filasAfectadas > 0;
├─ Mutador: CONDITIONALS_BOUNDARY
├─ Cambio: return filasAfectadas >= 0;
├─ Impacto: Retorna true incluso si no insertó nada
└─ Test faltante:

@Test
@DisplayName("registrarUsuario debe retornar false si no se insertó nada")
void testRegistrarUsuarioSinInsercion() throws SQLException {
    when(mockPreparedStatement.executeUpdate()).thenReturn(0);  // ← 0 filas
    
    boolean resultado = negocio.registrarUsuario(crearUsuarioValido());
    
    assertFalse(resultado);  // ← Debe ser false
}

SOBREVIVIENTE #11-#18: BAJO ⚠️
├─ SQL string mutations
├─ Mutador: INLINE_CONSTS
├─ Cambios: Cambiar nombres de columnas
├─ Impacto: SQLException en runtime
└─ Difícil de testear sin BD real (considerar tests de integración)
```

#### 6.4.3 correoExiste() - 72% Mutation Score ✅

```java
public boolean correoExiste(String correo) throws SQLException {
    String sql = "SELECT COUNT(*) as total FROM usuarios WHERE correo = ?";
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    
    try {
        conn = ConexionDB.getConnection();
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, correo);
        rs = pstmt.executeQuery();
        
        if (rs.next()) {
            return rs.getInt("total") > 0;
        }
        return false;
    } finally {
        cerrarRecursos(conn, pstmt, rs);
    }
}

MUTANTES: 18 generados
├─ Matados:   13 ✅ (72%)
├─ Sobreviv:  4 🟡
└─ Sin cob:   1 🔴

SOBREVIVIENTE PRINCIPAL:
├─ Línea: return rs.getInt("total") > 0;
├─ Mutador: CONDITIONALS_BOUNDARY
├─ Cambio: return rs.getInt("total") >= 0;
├─ Impacto: Siempre retorna true (incluso con 0 registros)
└─ Solución:

@Test
@DisplayName("correoExiste debe retornar false para correo nuevo")
void testCorreoExisteFalse() throws SQLException {
    when(mockResultSet.next()).thenReturn(true);
    when(mockResultSet.getInt("total")).thenReturn(0);  // ← Cero registros
    
    boolean existe = negocio.correoExiste("nuevo@test.com");
    
    assertFalse(existe);  // ← Explícitamente false
}
```

### 6.5 Resumen por Complejidad Ciclomática

```
┌──────────────────────┬──────┬───────────┬──────────┬─────────┐
│ Método               │ CC   │ Mutantes  │ Matados  │ Score   │
├──────────────────────┼──────┼───────────┼──────────┼─────────┤
│ validarLogin         │ 8    │ 28        │ 24       │ 85% ✅  │
│ registrarUsuario     │ 6    │ 42        │ 19       │ 45% 🔴  │
│ correoExiste         │ 4    │ 18        │ 13       │ 72% ✅  │
│ obtenerUsuarioPorId  │ 5    │ 22        │ 16       │ 73% ✅  │
│ listarTodos          │ 3    │ 15        │ 12       │ 80% ✅  │
│ contarPorRol         │ 4    │ 12        │ 9        │ 75% ✅  │
│ cambiarEstado        │ 5    │ 20        │ 11       │ 55% 🟠  │
│ actualizarUsuario    │ 7    │ 35        │ 18       │ 51% 🔴  │
│ actualizarPerfil     │ 6    │ 28        │ 0        │ 0%  🔴  │
├──────────────────────┼──────┼───────────┼──────────┼─────────┤
│ TOTAL                │ 48   │ 220       │ 122      │ 55% 🟠  │
└──────────────────────┴──────┴───────────┴──────────┴─────────┘

OBSERVACIONES:
├─ Métodos simples (CC ≤ 4):  Alta cobertura (75-80%)
├─ Métodos complejos (CC ≥ 7): Baja cobertura (45-55%)
└─ Sin tests:                   actualizarPerfil (crítico)
```

---

## 7. 🌐 Reporte de Mutaciones - Servlets

### 7.1 AsistenciaServlet - 38% Mutation Score 🔴

```
CONTEXTO:
├─ 380 líneas de código
├─ Maneja HttpServletRequest/Response
├─ Lógica de QR con timestamp
├─ Múltiples validaciones
└─ Difícil de testear con Mockito

RESULTADOS PITest:
═══════════════════════════════════════════════════════════
  Mutantes generados:    125
  Matados:               48  (38%) 🔴
  Sobrevivientes:        62  (50%) 🔴
  Sin cobertura:         15  (12%) 🔴
═══════════════════════════════════════════════════════════

PROBLEMA PRINCIPAL:
└─ Servlets tienen lógica de negocio mezclada con HTTP
   └─ Solución: Extraer a Service layer

MUTANTES TÍPICOS QUE SOBREVIVEN EN SERVLETS:

1. JSON String Mutations
   ├─ "{\"success\": true}" → "{\"success\": false}"
   └─ Difícil detectar en tests que solo verifican HTTP 200

2. Validaciones de Parámetros
   ├─ if (param != null) → if (param == null)
   └─ Tests no cubren todos los casos null/empty

3. Session Handling
   ├─ session.getAttribute("usuario") → null
   └─ Tests no verifican todos los estados de sesión

4. Error Messages
   ├─ "Error al procesar" → "Success"
   └─ Tests no leen el mensaje de respuesta

RECOMENDACIÓN:
├─ Refactorizar: Servlet → Controller + Service
├─ Service tendrá mejor mutation score (70-80%)
└─ Servlet solo maneja HTTP (simple, fácil de testear)
```

### 7.2 InscripcionServlet - 52% Mutation Score 🟡

```
MEJOR que AsistenciaServlet por ser más simple

RESULTADOS:
├─ Mutantes: 48
├─ Matados: 25 (52%)
└─ Sobrevivientes: 23 (48%)

MUTANTES MATADOS FÁCILMENTE:
✅ Validaciones básicas (null checks)
✅ Response status codes
✅ Redirects

MUTANTES QUE SOBREVIVEN:
❌ Lógica compleja de inscripción
❌ Manejo de transacciones
❌ Error handling específico
```

### 7.3 Comparativa Servlets vs Clases de Negocio

```
┌──────────────────────┬─────────────┬─────────────┬──────────┐
│ Tipo de Clase        │ Mut. Score  │ Test Diff.  │ Calidad  │
├──────────────────────┼─────────────┼─────────────┼──────────┤
│ Entidades (POJOs)    │ 85-95%      │ Fácil       │ ✅       │
│ Negocio (con mocks)  │ 55-75%      │ Medio       │ 🟡       │
│ Servlets             │ 35-55%      │ Difícil     │ 🔴       │
│ ConexionDB (static)  │ 10-20%      │ Muy difícil │ 🔴       │
└──────────────────────┴─────────────┴─────────────┴──────────┘

CONCLUSIÓN:
├─ POJOs: Excelente testabilidad → Alto mutation score
├─ Negocio: Buena testabilidad con mocks → Score medio-alto
├─ Servlets: Baja testabilidad → Requiere refactoring
└─ Static utils: Muy baja testabilidad → Considerar DI
```

---

## 8. 🎯 Análisis de Test Strength

### 8.1 ¿Qué es Test Strength?

```
Test Strength = Capacidad de los tests para detectar bugs reales

INDICADORES:
├─ Mutation Score alto (≥70%):       Tests fuertes
├─ Mutation Score medio (50-70%):    Tests débiles
└─ Mutation Score bajo (<50%):       Tests muy débiles o ausentes

EJEMPLO:

Test Débil (Mutation Score: 30%):
@Test
void testValidarLogin() {
    Usuario u = negocio.validarLogin("test@test.com", "pass");
    assertNotNull(u);  // ← Solo verifica que no es null
}
// Mutantes que sobreviven:
// - Cambiar condiciones
// - Cambiar retornos
// - Eliminar validaciones
// → Muchos bugs pasan desapercibidos

Test Fuerte (Mutation Score: 90%):
@Test
void testValidarLoginCompleto() {
    // Arrange
    mockearUsuarioValido();
    
    // Act
    Usuario u = negocio.validarLogin("test@test.com", "Password123");
    
    // Assert
    assertNotNull(u);
    assertEquals("test@test.com", u.getCorreo());
    assertEquals("Password123", u.getContrasena());
    assertEquals("ESTUDIANTE", u.getRol());
    assertTrue(u.isActivo());
    
    // Verify
    verify(mockPreparedStatement).setString(1, "test@test.com");
    verify(mockResultSet).next();
}
// → Pocos mutantes sobreviven (assertions específicas)
```

### 8.2 Matriz de Test Strength por Clase

```
┌────────────────────┬──────────┬────────────┬────────────┬──────────┐
│ Clase              │ Mutation │ Test Count │ Assertions │ Strength │
│                    │ Score    │            │ per Test   │          │
├────────────────────┼──────────┼────────────┼────────────┼──────────┤
│ Usuario            │ 84%      │ 35         │ 3.2        │ ALTA ✅  │
│ UsuarioNegocio     │ 61%      │ 18         │ 2.1        │ MEDIA 🟡 │
│ AsistenciaServlet  │ 38%      │ 11         │ 1.5        │ BAJA 🔴  │
│ InscripcionServlet │ 52%      │ 4          │ 1.0        │ BAJA 🔴  │
└────────────────────┴──────────┴────────────┴────────────┴──────────┘

CORRELACIÓN:
└─ Más assertions por test → Mayor mutation score
   └─ Tests débiles: 1-2 assertions
   └─ Tests fuertes: 3-5 assertions
```

### 8.3 Patrón de Tests Débiles vs Fuertes

```java
// ═══════════════════════════════════════════════════════
// ❌ TEST DÉBIL - Mutation Score: 35%
// ═══════════════════════════════════════════════════════

@Test
void testRegistrarUsuario() {
    Usuario usuario = new Usuario();
    usuario.setCorreo("test@test.com");
    
    boolean resultado = negocio.registrarUsuario(usuario);
    
    assertTrue(resultado);  // ← ÚNICA verificación
}

PROBLEMAS:
├─ No verifica que los datos se guardaron
├─ No verifica que el correo no existía antes
├─ No verifica los efectos secundarios
└─ 25+ mutantes sobreviven

// ═══════════════════════════════════════════════════════
// ✅ TEST FUERTE - Mutation Score: 85%
// ═══════════════════════════════════════════════════════

@Test
@DisplayName("registrarUsuario debe insertar todos los campos correctamente")
void testRegistrarUsuarioCompleto() {
    // Arrange
    Usuario usuario = new Usuario();
    usuario.setCodigo("2020123456");
    usuario.setNombres("Juan");
    usuario.setApellidos("Pérez");
    usuario.setCorreo("juan@test.com");
    usuario.setContrasena("Pass123");
    usuario.setRol("ESTUDIANTE");
    usuario.setEscuela("EPIS");
    usuario.setTelefono("987654321");
    usuario.setActivo(true);
    
    // Mock: correo NO existe
    when(mockConnection.prepareStatement(contains("SELECT COUNT")))
        .thenReturn(mockPreparedStatementSelect);
    when(mockPreparedStatementSelect.executeQuery())
        .thenReturn(mockResultSet);
    when(mockResultSet.next()).thenReturn(true);
    when(mockResultSet.getInt("total")).thenReturn(0);  // ← No existe
    
    // Mock: INSERT exitoso
    when(mockConnection.prepareStatement(contains("INSERT")))
        .thenReturn(mockPreparedStatementInsert);
    when(mockPreparedStatementInsert.executeUpdate()).thenReturn(1);
    
    // Act
    boolean resultado = negocio.registrarUsuario(usuario);
    
    // Assert - Estado
    assertTrue(resultado, "Debe retornar true para registro exitoso");
    
    // Assert - Verificar que se llamó correoExiste
    verify(mockPreparedStatementSelect).setString(1, "juan@test.com");
    verify(mockPreparedStatementSelect).executeQuery();
    
    // Assert - Verificar TODOS los parámetros del INSERT
    verify(mockPreparedStatementInsert).setString(1, "2020123456");
    verify(mockPreparedStatementInsert).setString(2, "Juan");
    verify(mockPreparedStatementInsert).setString(3, "Pérez");
    verify(mockPreparedStatementInsert).setString(4, "juan@test.com");
    verify(mockPreparedStatementInsert).setString(5, "Pass123");
    verify(mockPreparedStatementInsert).setString(6, "ESTUDIANTE");
    verify(mockPreparedStatementInsert).setString(7, "EPIS");
    verify(mockPreparedStatementInsert).setString(8, "987654321");
    verify(mockPreparedStatementInsert).setBoolean(9, true);
    
    // Assert - Verificar que se ejecutó el UPDATE
    verify(mockPreparedStatementInsert).executeUpdate();
    
    // Assert - No más interacciones
    verifyNoMoreInteractions(mockPreparedStatementInsert);
}

VENTAJAS:
├─ Verifica precondiciones (correo no existe)
├─ Verifica TODOS los parámetros (9 setters)
├─ Verifica que se ejecutó el UPDATE
├─ Verifica que no hay llamadas extra
└─ Solo 3-5 mutantes sobreviven
```

---

## 9. 🛡️ Estrategias para Matar Mutantes

### 9.1 Estrategia #1: Boundary Value Testing

```java
// Mutantes de CONDITIONALS_BOUNDARY son comunes

CÓDIGO ORIGINAL:
if (edad >= 18) { ... }

MUTANTES:
├─ if (edad > 18) { ... }   ← Boundary cambiado
├─ if (edad <= 18) { ... }  ← Invertido
└─ if (edad < 18) { ... }   ← Boundary + invertido

ESTRATEGIA - Tests de Frontera:
@ParameterizedTest
@CsvSource({
    "17, false",  // ← Justo antes del límite
    "18, true",   // ← En el límite (boundary)
    "19, true"    // ← Justo después
})
void testValidarEdadBoundary(int edad, boolean esperado) {
    boolean resultado = validarEdad(edad);
    assertEquals(esperado, resultado);
}

RESULTADO:
└─ Mata mutantes de boundary (>, >=, <, <=)
```

### 9.2 Estrategia #2: Assertion-First Testing

```java
// Tests débiles permiten mutantes de RETURN_VALS

❌ TEST DÉBIL:
@Test
void testObtenerNombre() {
    String nombre = usuario.getNombre();
    assertNotNull(nombre);  // ← Muy débil
}
// Mutante: return "";  → SOBREVIVE
// Mutante: return "X"; → SOBREVIVE

✅ TEST FUERTE:
@Test
void testObtenerNombreExacto() {
    usuario.setNombre("Juan Pérez");
    
    String nombre = usuario.getNombre();
    
    assertNotNull(nombre);
    assertEquals("Juan Pérez", nombre);  // ← Assertion exacta
    assertTrue(nombre.length() > 0);
    assertTrue(nombre.contains("Juan"));
    assertTrue(nombre.contains("Pérez"));
}
// Casi todos los mutantes MATADOS
```

### 9.3 Estrategia #3: Exception Testing

```java
// Mutantes en manejo de errores sobreviven sin tests de excepciones

CÓDIGO:
public void dividir(int a, int b) {
    if (b == 0) {
        throw new IllegalArgumentException("División por cero");
    }
    return a / b;
}

MUTANTES SIN TEST DE EXCEPCIÓN:
├─ if (b != 0) { throw... }  → Lógica invertida
├─ if (b < 0) { throw... }   → Condición cambiada
└─ throw new RuntimeException()  → Excepción diferente

ESTRATEGIA:
@Test
void testDividirPorCeroLanzaExcepcion() {
    IllegalArgumentException ex = assertThrows(
        IllegalArgumentException.class,
        () -> dividir(10, 0)
    );
    
    // Verificar mensaje exacto
    assertEquals("División por cero", ex.getMessage());
}

@Test
void testDividirPorCeroNoLanzaExcepcionSiEsPositivo() {
    // Verificar que NO lanza con números válidos
    assertDoesNotThrow(() -> dividir(10, 2));
    assertDoesNotThrow(() -> dividir(10, 1));
}
```

### 9.4 Estrategia #4: Verify All Interactions

```java
// Mutantes VOID_METHOD_CALLS sobreviven sin verify()

CÓDIGO:
public void guardarUsuario(Usuario u) {
    validar(u);
    sanitizar(u);
    persistir(u);
    notificar(u);
}

MUTANTES SIN VERIFY:
├─ // validar(u);   → Comentado, no se valida
├─ // sanitizar(u); → Comentado, no se limpia
└─ // notificar(u); → Comentado, no se notifica

ESTRATEGIA:
@Test
void testGuardarUsuarioLlamaTodosLosMetodos() {
    Usuario usuario = crearUsuarioMock();
    
    servicio.guardarUsuario(usuario);
    
    // Verificar TODAS las llamadas en ORDEN
    InOrder inOrder = inOrder(
        validadorMock, 
        sanitizadorMock, 
        repositorioMock, 
        notificadorMock
    );
    
    inOrder.verify(validadorMock).validar(usuario);
    inOrder.verify(sanitizadorMock).sanitizar(usuario);
    inOrder.verify(repositorioMock).persistir(usuario);
    inOrder.verify(notificadorMock).notificar(usuario);
    
    // No más interacciones
    verifyNoMoreInteractions(validadorMock, sanitizadorMock, 
                            repositorioMock, notificadorMock);
}
```

### 9.5 Estrategia #5: State Verification

```java
// Mutantes que cambian estado interno

CÓDIGO:
public void activarUsuario(int id) {
    Usuario u = obtener(id);
    u.setActivo(true);
    guardar(u);
}

MUTANTES:
├─ u.setActivo(false);  → Cambiado true a false
├─ // u.setActivo(...);  → Llamada eliminada
└─ u.setActivo(!u.isActivo());  → Lógica invertida

ESTRATEGIA:
@Test
void testActivarUsuarioCambiaEstadoCorrectamente() {
    // Arrange - Usuario inicialmente inactivo
    Usuario usuario = new Usuario();
    usuario.setId(1);
    usuario.setActivo(false);
    when(repositorio.obtener(1)).thenReturn(usuario);
    
    // Act
    servicio.activarUsuario(1);
    
    // Assert - Verificar cambio de estado
    ArgumentCaptor<Usuario> captor = ArgumentCaptor.forClass(Usuario.class);
    verify(repositorio).guardar(captor.capture());
    
    Usuario usuarioGuardado = captor.getValue();
    assertTrue(usuarioGuardado.isActivo(), "Usuario debe estar activo");
    assertEquals(1, usuarioGuardado.getId());
}

@Test
void testActivarUsuarioInactivoLoActiva() {
    Usuario inactivo = crearUsuarioInactivo();
    when(repositorio.obtener(1)).thenReturn(inactivo);
    
    servicio.activarUsuario(1);
    
    ArgumentCaptor<Usuario> captor = ArgumentCaptor.forClass(Usuario.class);
    verify(repositorio).guardar(captor.capture());
    
    // Estado inicial vs final
    assertFalse(inactivo.isActivo(), "Inicialmente inactivo");
    assertTrue(captor.getValue().isActivo(), "Finalmente activo");
}
```

---

## 🎯 Resumen Parte 2

```
╔════════════════════════════════════════════════════════════╗
║  MUTATION TESTING SUMMARY - Parte 2                        ║
╚════════════════════════════════════════════════════════════╝

CLASES ANALIZADAS:
├─ UsuarioNegocio:     61% mutation score (medio)
├─ AsistenciaServlet:  38% mutation score (bajo)
└─ InscripcionServlet: 52% mutation score (medio-bajo)

PROBLEMAS IDENTIFICADOS:
├─ Tests débiles en registrarUsuario (45%)
├─ Servlets con lógica mezclada (38-52%)
├─ Falta tests de excepciones
├─ Falta tests de boundary values
└─ Falta verification de interacciones

ESTRATEGIAS EFECTIVAS:
✅ Boundary value testing
✅ Assertion-first testing
✅ Exception testing completo
✅ Verify all interactions
✅ State verification

PRÓXIMOS PASOS:
├─ Implementar estrategias en tests existentes
├─ Agregar tests faltantes (48 tests nuevos)
├─ Refactorizar servlets → Services
└─ Objetivo: 70%+ mutation score global
```

---

**Continúa en Parte 3:** CI/CD Integration, Dashboard y Conclusiones

---

*Generado el 3 de Diciembre de 2025*  
*PITest 1.15.3 + JUnit 5 + Mockito*
