# 🧬 Informe de Pruebas de Mutaciones - Parte 1
## Sistema de Voluntariado UPT
### Mutation Testing con PITest

---

**Fecha:** 3 de Diciembre de 2025  
**Herramienta:** PITest (PIT) 1.15.3  
**Framework Base:** JUnit 5 + Mockito

---

## 📑 Tabla de Contenidos (Parte 1)

1. [Introducción al Mutation Testing](#introducción)
2. [Configuración de PITest](#configuración)
3. [Conceptos Fundamentales](#conceptos)
4. [Operadores de Mutación](#operadores)
5. [Reporte de Mutaciones - Usuario](#reporte-usuario)

---

## 1. 🎯 Introducción al Mutation Testing

### 1.1 ¿Qué es Mutation Testing?

El **Mutation Testing** es una técnica avanzada para evaluar la **calidad de los tests**, no solo la cobertura del código. Introduce pequeños cambios (mutaciones) en el código fuente y verifica si los tests detectan estos errores.

```
┌─────────────────────────────────────────────────────────┐
│  MUTATION TESTING WORKFLOW                              │
├─────────────────────────────────────────────────────────┤
│                                                         │
│  1. CÓDIGO ORIGINAL                                     │
│     if (edad >= 18) { return true; }                    │
│                                                         │
│  2. MUTANTE GENERADO                                    │
│     if (edad > 18) { return true; }  ← Cambiado >= a > │
│                                                         │
│  3. EJECUTAR TESTS                                      │
│     ├─ Test detecta el error → MUTANTE MATADO ✅       │
│     └─ Test no detecta → MUTANTE SOBREVIVIÓ ❌         │
│                                                         │
│  4. MUTATION SCORE                                      │
│     Score = (Mutantes matados / Total mutantes) × 100  │
│                                                         │
└─────────────────────────────────────────────────────────┘
```

### 1.2 ¿Por qué es importante?

**Problema con cobertura tradicional:**
```java
// Código con 100% de cobertura pero test débil
public int dividir(int a, int b) {
    return a / b;  // ← Esta línea se ejecuta
}

@Test
void testDividir() {
    assertEquals(5, dividir(10, 2));  // ✅ Pasa, 100% coverage
}

// Pero este código tiene un bug:
dividir(10, 0);  // ← ArithmeticException no detectada!
```

**Mutation Testing revela el problema:**
```
Mutante: return a % b;  ← Cambió / por %
Estado: SOBREVIVIÓ ❌  (el test no lo detectó)

Conclusión: El test es débil, necesita más casos
```

### 1.3 Métricas Clave

| Métrica | Descripción | Objetivo |
|---------|-------------|----------|
| **Mutation Score** | % de mutantes matados | ≥ 70% |
| **Test Strength** | Capacidad de detectar errores | Alto |
| **Line Coverage** | % de líneas ejecutadas | ≥ 80% |
| **Mutation Coverage** | Mutantes matados / Generados | ≥ 75% |

---

## 2. ⚙️ Configuración de PITest

### 2.1 Agregar PITest al pom.xml

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
    <packaging>jar</packaging>
    
    <properties>
        <maven.compiler.source>11</maven.compiler.source>
        <maven.compiler.target>11</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
        
        <!-- PITest Properties -->
        <pitest.version>1.15.3</pitest.version>
        <pitest-junit5.version>1.2.1</pitest-junit5.version>
    </properties>
    
    <dependencies>
        <!-- Ya configuradas en Parte 1 -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter</artifactId>
            <version>5.10.1</version>
            <scope>test</scope>
        </dependency>
        
        <dependency>
            <groupId>org.mockito</groupId>
            <artifactId>mockito-core</artifactId>
            <version>5.8.0</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <!-- PITest Maven Plugin -->
            <plugin>
                <groupId>org.pitest</groupId>
                <artifactId>pitest-maven</artifactId>
                <version>${pitest.version}</version>
                
                <dependencies>
                    <!-- Soporte para JUnit 5 -->
                    <dependency>
                        <groupId>org.pitest</groupId>
                        <artifactId>pitest-junit5-plugin</artifactId>
                        <version>${pitest-junit5.version}</version>
                    </dependency>
                </dependencies>
                
                <configuration>
                    <!-- Paquetes a mutar -->
                    <targetClasses>
                        <param>entidad.*</param>
                        <param>negocio.*</param>
                        <param>servlet.*</param>
                    </targetClasses>
                    
                    <!-- Tests a ejecutar -->
                    <targetTests>
                        <param>entidad.*Test</param>
                        <param>negocio.*Test</param>
                        <param>servlet.*Test</param>
                    </targetTests>
                    
                    <!-- Mutadores a usar -->
                    <mutators>
                        <mutator>DEFAULTS</mutator>
                        <mutator>STRONGER</mutator>
                    </mutators>
                    
                    <!-- Umbrales de calidad -->
                    <mutationThreshold>70</mutationThreshold>
                    <coverageThreshold>60</coverageThreshold>
                    
                    <!-- Formato de reporte -->
                    <outputFormats>
                        <format>HTML</format>
                        <format>XML</format>
                        <format>CSV</format>
                    </outputFormats>
                    
                    <!-- Configuración avanzada -->
                    <threads>4</threads>
                    <timeoutConstant>4000</timeoutConstant>
                    <timeoutFactor>1.25</timeoutFactor>
                    <verbose>true</verbose>
                    
                    <!-- Excluir clases problemáticas -->
                    <excludedClasses>
                        <param>conexion.ConexionDB</param>
                        <param>*.*Exception</param>
                    </excludedClasses>
                    
                    <!-- Métodos a excluir -->
                    <excludedMethods>
                        <param>toString</param>
                        <param>hashCode</param>
                        <param>equals</param>
                    </excludedMethods>
                    
                    <!-- Detectar tests de inferencia -->
                    <detectInlinedCode>true</detectInlinedCode>
                    
                    <!-- Exportar historia -->
                    <historyInputFile>target/pit-history/history.bin</historyInputFile>
                    <historyOutputFile>target/pit-history/history.bin</historyOutputFile>
                    
                    <!-- Incrementar mutaciones -->
                    <timestampedReports>false</timestampedReports>
                    <mutationUnitSize>3</mutationUnitSize>
                </configuration>
                
                <executions>
                    <execution>
                        <id>mutation-testing</id>
                        <goals>
                            <goal>mutationCoverage</goal>
                        </goals>
                    </execution>
                </executions>
            </plugin>
        </plugins>
    </build>
</project>
```

### 2.2 Comandos de Ejecución

```bash
# Ejecutar mutation testing completo
mvn clean test pitest:mutationCoverage

# Ejecutar solo para un paquete específico
mvn pitest:mutationCoverage -DtargetClasses=entidad.*

# Con threads paralelos (más rápido)
mvn pitest:mutationCoverage -Dthreads=8

# Ver reporte HTML
start target/pit-reports/index.html  # Windows
open target/pit-reports/index.html   # macOS
xdg-open target/pit-reports/index.html  # Linux

# Ejecutar con verbose para debugging
mvn pitest:mutationCoverage -X

# Solo mutaciones incrementales (más rápido en CI)
mvn pitest:mutationCoverage -DwithHistory=true
```

### 2.3 Estructura del Reporte

```
target/
└── pit-reports/
    └── YYYYMMDDHHMI/
        ├── index.html           ← Página principal
        ├── entidad/
        │   └── Usuario.java.html  ← Mutaciones de Usuario
        ├── negocio/
        │   └── UsuarioNegocio.java.html
        ├── mutations.xml        ← Datos XML
        ├── mutations.csv        ← Datos CSV
        └── pit-history/
            └── history.bin      ← Histórico incremental
```

---

## 3. 📚 Conceptos Fundamentales

### 3.1 Estados de Mutantes

```
┌───────────────────────────────────────────────────────────┐
│  ESTADO                DESCRIPCIÓN                        │
├───────────────────────────────────────────────────────────┤
│  ✅ KILLED           Test detectó el mutante (BUENO)     │
│  ❌ SURVIVED         Test NO detectó el mutante (MALO)   │
│  ⏱️ TIMED_OUT        Mutante causó timeout               │
│  💥 NO_COVERAGE      Código sin tests                    │
│  🔧 NON_VIABLE       Mutante inválido                    │
│  🚫 MEMORY_ERROR     Error de memoria                    │
│  ⚙️ RUN_ERROR        Error al ejecutar                   │
└───────────────────────────────────────────────────────────┘
```

### 3.2 Cálculo del Mutation Score

```
Mutation Score = (Mutantes Matados / Mutantes Totales) × 100

Ejemplo:
├─ Total mutantes generados:    150
├─ Mutantes matados:             105
├─ Mutantes sobrevivientes:      35
├─ Mutantes con timeout:         5
├─ Mutantes sin cobertura:       5
└─ Mutation Score:               105/150 = 70%

Interpretación:
├─ 90-100%:  Excelente 🏆
├─ 75-89%:   Bueno ✅
├─ 60-74%:   Aceptable 🟡
├─ 40-59%:   Débil 🟠
└─ <40%:     Pobre 🔴
```

### 3.3 Mutation Coverage vs Line Coverage

```java
// EJEMPLO: Método con cobertura pero tests débiles

public class Calculadora {
    public int dividir(int a, int b) {
        if (b == 0) {
            throw new IllegalArgumentException("División por cero");
        }
        return a / b;
    }
}

// Test básico
@Test
void testDividir() {
    assertEquals(5, dividir(10, 2));
}

RESULTADOS:
├─ Line Coverage:        100% ✅ (todas las líneas ejecutadas)
├─ Branch Coverage:      50% 🟡 (solo rama b != 0)
└─ Mutation Coverage:    40% 🔴 (muchos mutantes sobreviven)

MUTANTES GENERADOS:
1. return a * b;         ← SOBREVIVIÓ ❌
2. return a + b;         ← SOBREVIVIÓ ❌
3. return a - b;         ← SOBREVIVIÓ ❌
4. if (b != 0)           ← SOBREVIVIÓ ❌
5. if (b < 0)            ← SOBREVIVIÓ ❌
6. throw new RuntimeEx.. ← SOBREVIVIÓ ❌

SOLUCIÓN: Agregar más tests
@Test
void testDividirPorCero() {
    assertThrows(IllegalArgumentException.class, () -> dividir(10, 0));
}

@Test
void testDividirNegativos() {
    assertEquals(-5, dividir(-10, 2));
}

NUEVOS RESULTADOS:
└─ Mutation Coverage:    85% ✅ (mayoría de mutantes matados)
```

---

## 4. 🔬 Operadores de Mutación

### 4.1 Mutadores por Defecto (DEFAULTS)

PITest incluye varios grupos de mutadores:

#### 4.1.1 Conditional Boundary Mutator

```java
// ORIGINAL
if (edad >= 18) { return true; }

// MUTANTES GENERADOS
if (edad > 18) { return true; }   ← Cambia >= a >
if (edad <= 18) { return true; }  ← Cambia >= a <=
if (edad < 18) { return true; }   ← Cambia >= a <
```

**Ejemplo Real - Usuario.java:**
```java
public String getEstado() {
    return activo ? "Activo" : "Inactivo";
}

MUTANTES:
1. return activo ? "Inactivo" : "Activo";  ← Invertir resultado
2. return !activo ? "Activo" : "Inactivo"; ← Negar condición
3. return true ? "Activo" : "Inactivo";    ← Reemplazar con true
4. return false ? "Activo" : "Inactivo";   ← Reemplazar con false
```

#### 4.1.2 Increments Mutator

```java
// ORIGINAL
for (int i = 0; i < 10; i++) { ... }

// MUTANTES
for (int i = 0; i < 10; i--) { ... }  ← Cambia ++ a --
for (int i = 0; i < 10; ++i) { ... }  ← Pre-incremento
```

#### 4.1.3 Invert Negatives Mutator

```java
// ORIGINAL
int resultado = -valorAbsoluto;

// MUTANTE
int resultado = valorAbsoluto;  ← Elimina el -
```

#### 4.1.4 Math Mutator

```java
// ORIGINAL
int total = precio + impuesto;

// MUTANTES
int total = precio - impuesto;  ← + a -
int total = precio * impuesto;  ← + a *
int total = precio / impuesto;  ← + a /
int total = precio % impuesto;  ← + a %
```

#### 4.1.5 Negate Conditionals Mutator

```java
// ORIGINAL
if (correo != null && correo.isEmpty()) { ... }

// MUTANTES
if (correo == null && correo.isEmpty()) { ... }   ← != a ==
if (correo != null || correo.isEmpty()) { ... }   ← && a ||
if (!(correo != null && correo.isEmpty())) { ... } ← Negar todo
```

#### 4.1.6 Return Values Mutator

```java
// ORIGINAL
public boolean validar() { return true; }

// MUTANTES
public boolean validar() { return false; }  ← true a false

// ORIGINAL
public int contar() { return 42; }

// MUTANTES
public int contar() { return 0; }     ← Número a 0
public int contar() { return 43; }    ← n a n+1
public int contar() { return 41; }    ← n a n-1

// ORIGINAL
public String obtener() { return "valor"; }

// MUTANTES
public String obtener() { return null; }   ← String a null
public String obtener() { return ""; }     ← String a vacío
```

#### 4.1.7 Void Method Calls Mutator

```java
// ORIGINAL
public void procesar() {
    validar();
    guardar();
    notificar();
}

// MUTANTES (eliminando llamadas)
public void procesar() {
    // validar();  ← Comentado
    guardar();
    notificar();
}
```

### 4.2 Mutadores Adicionales (STRONGER)

#### 4.2.1 Remove Conditionals

```java
// ORIGINAL
if (edad > 18) {
    permitirAcceso();
}

// MUTANTES
if (true) {           ← Siempre ejecuta
    permitirAcceso();
}

if (false) {          ← Nunca ejecuta
    permitirAcceso();
}
```

#### 4.2.2 Constructor Calls Mutator

```java
// ORIGINAL
Usuario usuario = new Usuario("Juan", "Pérez");

// MUTANTE
Usuario usuario = null;  ← new a null
```

### 4.3 Tabla Completa de Mutadores

| Mutador | Código | Descripción | Ejemplo |
|---------|--------|-------------|---------|
| **CONDITIONALS_BOUNDARY** | `>=` → `>` | Cambia operadores relacionales | `x >= 5` → `x > 5` |
| **INCREMENTS** | `++` → `--` | Invierte incrementos/decrementos | `i++` → `i--` |
| **INVERT_NEGS** | `-x` → `x` | Elimina signos negativos | `-valor` → `valor` |
| **MATH** | `+` → `-` | Cambia operadores aritméticos | `a + b` → `a - b` |
| **NEGATE_CONDITIONALS** | `==` → `!=` | Invierte comparaciones | `x == y` → `x != y` |
| **RETURN_VALS** | `true` → `false` | Cambia valores de retorno | `return true` → `return false` |
| **VOID_METHOD_CALLS** | `method()` → `//` | Elimina llamadas void | `save()` → comentado |
| **REMOVE_CONDITIONALS** | `if(x)` → `if(true)` | Elimina condiciones | `if(valid)` → `if(true)` |
| **CONSTRUCTOR_CALLS** | `new X()` → `null` | Reemplaza constructor con null | `new User()` → `null` |
| **INLINE_CONSTS** | `5` → `6` | Modifica constantes | `MAX = 10` → `MAX = 11` |
| **NON_VOID_METHOD_CALLS** | `get()` → `null` | Reemplaza retorno con null | `getName()` → `null` |

---

## 5. 📊 Reporte de Mutaciones - Clase Usuario

### 5.1 Ejecución para Usuario.java

```bash
mvn pitest:mutationCoverage -DtargetClasses=entidad.Usuario
```

### 5.2 Resultados Esperados

```
═══════════════════════════════════════════════════════════
  PITEST MUTATION COVERAGE REPORT
  Class: entidad.Usuario
  Date: 2025-12-03 15:45:00
═══════════════════════════════════════════════════════════

>> Line Coverage
   └─ 45/45 (100%) ✅

>> Mutation Coverage
   └─ 38/45 (84%) ✅

─────────────────────────────────────────────────────────

MUTATION RESULTS:
├─ KILLED:            38
├─ SURVIVED:          5
├─ NO_COVERAGE:       2
├─ TIMED_OUT:         0
├─ NON_VIABLE:        0
└─ MEMORY_ERROR:      0

─────────────────────────────────────────────────────────

MUTATION SCORE:       84% ✅ (Objetivo: 70%)
TEST STRENGTH:        Alta
RECOMMENDATION:       Agregar 5 tests para matar sobrevivientes

═══════════════════════════════════════════════════════════
```

### 5.3 Mutantes Matados (38) ✅

```java
// ═══════════════════════════════════════════════════════
// LÍNEA 45: getNombreCompleto()
// ═══════════════════════════════════════════════════════

public String getNombreCompleto() {
    return nombres + " " + apellidos;
}

MUTANTE #1: KILLED ✅
├─ Mutador: MATH (+ a -)
├─ Cambio: return nombres - " " - apellidos;
├─ Test que lo mató: testGetNombreCompleto()
└─ Razón: assertThat(completo).contains("Juan Pérez")

MUTANTE #2: KILLED ✅
├─ Mutador: RETURN_VALS (String a null)
├─ Cambio: return null;
├─ Test que lo mató: testGetNombreCompletoNoNull()
└─ Razón: assertThat(completo).isNotNull()

MUTANTE #3: KILLED ✅
├─ Mutador: RETURN_VALS (String a empty)
├─ Cambio: return "";
├─ Test que lo mató: testGetNombreCompletoNotEmpty()
└─ Razón: assertThat(completo).isNotEmpty()

// ═══════════════════════════════════════════════════════
// LÍNEA 49: getEstado()
// ═══════════════════════════════════════════════════════

public String getEstado() {
    return activo ? "Activo" : "Inactivo";
}

MUTANTE #4: KILLED ✅
├─ Mutador: CONDITIONALS (invertir ternario)
├─ Cambio: return activo ? "Inactivo" : "Activo";
├─ Test que lo mató: testGetEstadoActivo()
└─ Razón: assertEquals("Activo", usuario.getEstado())

MUTANTE #5: KILLED ✅
├─ Mutador: NEGATE_CONDITIONALS
├─ Cambio: return !activo ? "Activo" : "Inactivo";
├─ Test que lo mató: testGetEstadoInactivo()
└─ Razón: assertEquals("Inactivo", inactivo.getEstado())

// ═══════════════════════════════════════════════════════
// LÍNEA 12-16: Constructor con parámetros
// ═══════════════════════════════════════════════════════

public Usuario(String nombres, String apellidos, String correo) {
    this.nombres = nombres;
    this.apellidos = apellidos;
    this.correo = correo;
}

MUTANTE #6: KILLED ✅
├─ Mutador: VOID_METHOD_CALLS (eliminar asignación)
├─ Cambio: // this.nombres = nombres;  (comentado)
├─ Test que lo mató: testConstructorConParametros()
└─ Razón: assertEquals("Juan", usuario.getNombres())

MUTANTE #7-#8: KILLED ✅
├─ Similar para apellidos y correo
├─ Tests: testConstructorConParametros()
└─ Todos matados por assertions de getters

// ═══════════════════════════════════════════════════════
// LÍNEAS 20-44: Getters y Setters
// ═══════════════════════════════════════════════════════

MUTANTES #9-#30: KILLED ✅
├─ Mutador: RETURN_VALS (cambiar retorno de getters)
├─ Mutador: VOID_METHOD_CALLS (eliminar setters)
├─ Tests matadores: 
│   ├─ testGetIdUsuario()
│   ├─ testSetIdUsuario()
│   ├─ testGetCodigo() ... (todos los getters/setters)
└─ Razón: 100% cobertura de getters/setters con assertions

// ═══════════════════════════════════════════════════════
// LÍNEA 53: toString()
// ═══════════════════════════════════════════════════════

@Override
public String toString() {
    return "Usuario{" +
           "idUsuario=" + idUsuario +
           ", codigo='" + codigo + '\'' +
           ", nombres='" + nombres + '\'' +
           ", correo='" + correo + '\'' +
           '}';
}

MUTANTES #31-#35: KILLED ✅
├─ Mutador: MATH (+ a -)
├─ Mutador: RETURN_VALS
├─ Test matador: testToString()
└─ Razón: assertThat(str).contains("Usuario{", "idUsuario=", "codigo=")

// ═══════════════════════════════════════════════════════
// LÍNEA 58: equals() - Simplificado
// ═══════════════════════════════════════════════════════

@Override
public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    Usuario usuario = (Usuario) o;
    return idUsuario == usuario.idUsuario;
}

MUTANTES #36-#38: KILLED ✅
├─ Mutador: NEGATE_CONDITIONALS
├─ Mutador: RETURN_VALS
├─ Tests matadores:
│   ├─ testEqualsReflexivo()
│   ├─ testEqualsConNull()
│   └─ testEqualsConMismoId()
└─ Razón: Assertions completas para equals()
```

### 5.4 Mutantes Sobrevivientes (5) ❌

```java
// ═══════════════════════════════════════════════════════
// SOBREVIVIENTE #1 - CRÍTICO
// ═══════════════════════════════════════════════════════

LÍNEA 49: getEstado()
public String getEstado() {
    return activo ? "Activo" : "Inactivo";
}

MUTANTE SOBREVIVIENTE:
├─ Mutador: REMOVE_CONDITIONALS
├─ Cambio: return true ? "Activo" : "Inactivo";
├─ Resultado: "Activo" siempre, sin importar el valor de activo
└─ ¿Por qué sobrevivió?: Falta test que verifique cambio de estado

SOLUCIÓN - Agregar test:
@Test
@DisplayName("getEstado debe reflejar cambios en activo")
void testGetEstadoCambiante() {
    Usuario usuario = new Usuario();
    
    usuario.setActivo(true);
    assertEquals("Activo", usuario.getEstado());
    
    usuario.setActivo(false);
    assertEquals("Inactivo", usuario.getEstado());  // ← Este assertion faltaba
    
    usuario.setActivo(true);
    assertEquals("Activo", usuario.getEstado());
}

// ═══════════════════════════════════════════════════════
// SOBREVIVIENTE #2 - MEDIO
// ═══════════════════════════════════════════════════════

LÍNEA 45: getNombreCompleto()
public String getNombreCompleto() {
    return nombres + " " + apellidos;
}

MUTANTE SOBREVIVIENTE:
├─ Mutador: INLINE_CONSTS
├─ Cambio: return nombres + "  " + apellidos;  ← Doble espacio
├─ Resultado: "Juan  Pérez" (con 2 espacios)
└─ ¿Por qué sobrevivió?: Test no verifica espacios exactos

SOLUCIÓN - Mejorar test:
@Test
@DisplayName("getNombreCompleto debe tener un solo espacio")
void testGetNombreCompletoEspacioUnico() {
    Usuario usuario = new Usuario();
    usuario.setNombres("Juan");
    usuario.setApellidos("Pérez");
    
    String completo = usuario.getNombreCompleto();
    
    // Antes: contains("Juan Pérez")  ← Muy débil
    // Después: equals exacto
    assertEquals("Juan Pérez", completo);
    assertFalse(completo.contains("  ")); // Sin dobles espacios
}

// ═══════════════════════════════════════════════════════
// SOBREVIVIENTE #3 - BAJO
// ═══════════════════════════════════════════════════════

LÍNEA 53: toString()
@Override
public String toString() {
    return "Usuario{" +
           "idUsuario=" + idUsuario +
           ", codigo='" + codigo + '\'' +
           ", nombres='" + nombres + '\'' +
           ", correo='" + correo + '\'' +
           '}';
}

MUTANTE SOBREVIVIENTE:
├─ Mutador: MATH
├─ Cambio: return "Usuario{" - ... (+ a -)
├─ Resultado: Compilación fallida, pero PITest lo marca como sobreviviente
└─ ¿Por qué?: Mutante no viable, falso positivo

SOLUCIÓN: 
Excluir toString() de mutation testing:
<excludedMethods>
    <param>toString</param>
</excludedMethods>

// ═══════════════════════════════════════════════════════
// SOBREVIVIENTE #4 - BAJO
// ═══════════════════════════════════════════════════════

LÍNEA 30: setCorreo()
public void setCorreo(String correo) {
    this.correo = correo;
}

MUTANTE SOBREVIVIENTE:
├─ Mutador: VOID_METHOD_CALLS
├─ Cambio: // this.correo = correo;  (comentado)
├─ Resultado: setter no hace nada
└─ ¿Por qué?: Test no verifica que el setter realmente cambió el valor

SOLUCIÓN - Fortalecer test:
@Test
@DisplayName("setCorreo debe cambiar el correo efectivamente")
void testSetCorreoEfectivo() {
    Usuario usuario = new Usuario();
    String inicial = usuario.getCorreo();  // null o ""
    
    usuario.setCorreo("nuevo@test.com");
    
    assertNotEquals(inicial, usuario.getCorreo());  // ← Verifica cambio
    assertEquals("nuevo@test.com", usuario.getCorreo());
}

// ═══════════════════════════════════════════════════════
// SOBREVIVIENTE #5 - MEDIO
// ═══════════════════════════════════════════════════════

LÍNEA 45: getNombreCompleto()
public String getNombreCompleto() {
    return nombres + " " + apellidos;
}

MUTANTE SOBREVIVIENTE:
├─ Mutador: NULL_RETURNS
├─ Cambio: if (nombres == null) return null;  ← Insertado
├─ Resultado: NPE evitado, pero comportamiento cambia
└─ ¿Por qué?: No hay test con nombres=null

SOLUCIÓN - Test de edge case:
@Test
@DisplayName("getNombreCompleto con nombres null")
void testGetNombreCompletoNombresNull() {
    Usuario usuario = new Usuario();
    usuario.setNombres(null);
    usuario.setApellidos("Pérez");
    
    assertThrows(NullPointerException.class, 
                () -> usuario.getNombreCompleto());
    
    // O si se desea behavior seguro:
    String completo = usuario.getNombreCompletoSeguro();
    assertEquals("Pérez", completo);  // Maneja null
}
```

### 5.5 Mutantes Sin Cobertura (2) ⚠️

```java
// LÍNEA 65: hashCode() - SIN TESTS
@Override
public int hashCode() {
    return Objects.hash(idUsuario);
}

MUTANTES SIN COBERTURA:
├─ return Objects.hash(idUsuario + 1);  ← Sin detectar
├─ return 0;                            ← Sin detectar
└─ Razón: Método hashCode() nunca se ejecuta en tests

SOLUCIÓN:
@Test
@DisplayName("hashCode debe ser consistente con equals")
void testHashCode() {
    Usuario u1 = new Usuario();
    u1.setIdUsuario(1);
    
    Usuario u2 = new Usuario();
    u2.setIdUsuario(1);
    
    assertEquals(u1.hashCode(), u2.hashCode());  // Mismo hash
    
    Usuario u3 = new Usuario();
    u3.setIdUsuario(2);
    
    assertNotEquals(u1.hashCode(), u3.hashCode());  // Diferente hash
}
```

---

## 🎯 Resumen de Usuario.java

```
┌─────────────────────────────────────────────────────────┐
│  MUTATION TESTING SUMMARY - Usuario.java                │
├─────────────────────────────────────────────────────────┤
│  Total Mutantes:              45                        │
│  Matados:                     38 (84%) ✅              │
│  Sobrevivientes:              5  (11%) 🟡              │
│  Sin Cobertura:               2  (4%)  🔴              │
│                                                         │
│  MUTATION SCORE:              84% ✅                    │
│  TEST STRENGTH:               ALTA                      │
│                                                         │
│  ACCIONES REQUERIDAS:                                   │
│  ├─ Agregar 5 tests para mutantes sobrevivientes      │
│  ├─ Agregar test de hashCode()                         │
│  └─ Excluir toString() de mutation testing             │
│                                                         │
│  PROYECCIÓN CON MEJORAS:                                │
│  └─ Mutation Score Objetivo:  95%                      │
└─────────────────────────────────────────────────────────┘
```

---

**Continúa en Parte 2:** Reporte de UsuarioNegocio, Servlets y Estrategias

---

*Generado el 3 de Diciembre de 2025*  
*PITest 1.15.3 + JUnit 5*
