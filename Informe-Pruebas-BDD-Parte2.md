# 🥒 Informe de Pruebas BDD - Parte 2
## Sistema de Voluntariado UPT
### Features de Campañas e Inscripciones

---

## 📑 Tabla de Contenidos (Parte 2)

6. [Features de Estudiante](#features-estudiante)
7. [Features de Coordinador](#features-coordinador)
8. [Features de Administrador](#features-administrador)
9. [Step Definitions Avanzadas](#step-definitions-avanzadas)
10. [Hooks y Contexto Compartido](#hooks-contexto)

---

## 6. 🎓 Features de Estudiante

### 6.1 buscar_campanas.feature

```gherkin
# src/test/resources/features/estudiante/buscar_campanas.feature

@estudiante @campanas
Feature: Búsqueda y filtrado de campañas
  Como estudiante del sistema de voluntariado
  Quiero buscar y filtrar campañas disponibles
  Para encontrar oportunidades que me interesen

  Background:
    Given he iniciado sesión como estudiante
    And estoy en la página de campañas disponibles

  @search @smoke
  Scenario: Buscar campaña por título
    Given existen las siguientes campañas:
      | título                  | estado  | cupos |
      | Limpieza de Playas      | ACTIVA  | 20    |
      | Reforestación Urbana    | ACTIVA  | 15    |
      | Donación de Sangre      | ACTIVA  | 30    |
    When busco por el término "Limpieza"
    Then debo ver 1 campaña en los resultados
    And la campaña mostrada debe ser "Limpieza de Playas"

  @search
  Scenario: Buscar campaña sin resultados
    When busco por el término "XYZ123NoExiste"
    Then no debo ver campañas en los resultados
    And debo ver el mensaje "No se encontraron campañas con ese criterio"

  @filter @happy_path
  Scenario: Filtrar campañas por estado
    Given existen campañas con diferentes estados:
      | título      | estado      |
      | Campaña A   | ACTIVA      |
      | Campaña B   | FINALIZADA  |
      | Campaña C   | CANCELADA   |
    When filtro por estado "ACTIVA"
    Then solo debo ver campañas con estado "ACTIVA"
    And no debo ver campañas finalizadas ni canceladas

  @filter
  Scenario: Filtrar campañas por rango de fechas
    Given existen campañas en diferentes fechas
    When filtro campañas entre "01/12/2025" y "31/12/2025"
    Then debo ver solo campañas que inicien en ese rango
    And las campañas deben estar ordenadas por fecha de inicio

  @filter @combinado
  Scenario: Aplicar múltiples filtros simultáneamente
    When filtro por estado "ACTIVA"
    And filtro por ubicación "Tacna"
    And busco por término "Medio Ambiente"
    Then debo ver solo campañas que cumplan TODOS los criterios
    And el contador de resultados debe actualizarse correctamente

  @ui @pagination
  Scenario: Paginación de resultados de búsqueda
    Given existen 25 campañas activas
    When veo la página de campañas
    Then debo ver 10 campañas por página
    And debo ver botones de paginación para navegar
    When hago click en "Página 2"
    Then debo ver las siguientes 10 campañas
    And la página 2 debe estar resaltada como activa

  @details
  Scenario: Ver detalles completos de una campaña
    Given existe una campaña "Limpieza de Playas"
    When hago click en "Ver Detalles"
    Then debo ver un modal con toda la información:
      | Título             |
      | Descripción        |
      | Fecha de inicio    |
      | Fecha de fin       |
      | Ubicación          |
      | Cupos disponibles  |
      | Horas de voluntariado |
      | Coordinador        |
    And debo ver el botón "Inscribirse"
```

### 6.2 inscripcion.feature

```gherkin
# src/test/resources/features/estudiante/inscripcion.feature

@estudiante @inscripcion
Feature: Inscripción a campañas de voluntariado
  Como estudiante
  Quiero inscribirme en campañas de voluntariado
  Para participar y obtener horas de servicio social

  Background:
    Given he iniciado sesión como estudiante "2020123456"
    And estoy en la página de campañas disponibles

  # ═══════════════════════════════════════════════════════
  # ESCENARIOS DE INSCRIPCIÓN EXITOSA
  # ═══════════════════════════════════════════════════════

  @happy_path @smoke
  Scenario: Inscripción exitosa en campaña con cupos disponibles
    Given existe la campaña "Limpieza de Playas" con 20 cupos disponibles
    When hago click en "Inscribirse" en esa campaña
    Then debo ver el modal de confirmación "¿Confirma su inscripción?"
    When confirmo la inscripción
    Then debo ver el mensaje "Inscripción exitosa"
    And la campaña debe tener 19 cupos disponibles
    And debo recibir un email de confirmación
    And la campaña debe aparecer en "Mis Inscripciones"

  @notification
  Scenario: Recibir confirmación por email después de inscripción
    Given me inscribo en la campaña "Donación de Sangre"
    Then debo recibir un email a mi correo institucional
    And el email debe contener:
      | Nombre de la campaña      |
      | Fecha y hora              |
      | Ubicación                 |
      | Instrucciones especiales  |
      | Datos del coordinador     |

  # ═══════════════════════════════════════════════════════
  # ESCENARIOS DE INSCRIPCIÓN FALLIDA
  # ═══════════════════════════════════════════════════════

  @negative @business_rule
  Scenario: No poder inscribirse en campaña sin cupos
    Given existe la campaña "Reforestación" con 0 cupos disponibles
    When intento inscribirme en esa campaña
    Then el botón "Inscribirse" debe estar deshabilitado
    And debo ver el mensaje "No hay cupos disponibles"

  @negative @duplicate
  Scenario: Prevenir inscripción duplicada
    Given ya estoy inscrito en la campaña "Limpieza de Playas"
    When intento inscribirme nuevamente en la misma campaña
    Then debo ver el mensaje de error "Ya está inscrito en esta campaña"
    And el botón de inscripción debe mostrar "Ya inscrito"
    But no debe crearse una segunda inscripción

  @negative @business_rule
  Scenario: Límite de inscripciones simultáneas
    Given tengo 3 inscripciones activas
    And el sistema permite máximo 3 inscripciones simultáneas por estudiante
    When intento inscribirme en una cuarta campaña
    Then debo ver el mensaje "Ha alcanzado el límite de inscripciones simultáneas"
    And debo poder ver el enlace "Gestionar mis inscripciones"

  @negative @dates
  Scenario: No poder inscribirse en campaña ya iniciada
    Given existe una campaña "Campaña Pasada" que inició hace 2 días
    When intento inscribirme
    Then debo ver "Esta campaña ya ha iniciado. Inscripciones cerradas"
    And el botón de inscripción debe estar deshabilitado

  @negative @inactive_user
  Scenario: Usuario inactivo no puede inscribirse
    Given mi cuenta está marcada como inactiva
    When intento inscribirme en cualquier campaña
    Then debo ver "Su cuenta está inactiva. Contacte al administrador"
    And no debe procesarse la inscripción

  # ═══════════════════════════════════════════════════════
  # GESTIÓN DE INSCRIPCIONES
  # ═══════════════════════════════════════════════════════

  @manage @cancelacion
  Scenario: Cancelar inscripción antes de que inicie la campaña
    Given estoy inscrito en la campaña "Limpieza de Playas"
    And la campaña inicia en 5 días
    When voy a "Mis Inscripciones"
    And hago click en "Cancelar Inscripción"
    Then debo ver modal de confirmación "¿Está seguro de cancelar?"
    When confirmo la cancelación
    Then la inscripción debe eliminarse
    And el cupo debe liberarse (de 19 a 20 cupos)
    And debo recibir email de confirmación de cancelación

  @manage @restriction
  Scenario: No poder cancelar inscripción si la campaña ya inició
    Given estoy inscrito en una campaña que inició hace 1 día
    When voy a "Mis Inscripciones"
    Then NO debo ver el botón "Cancelar Inscripción"
    And debo ver el estado "En curso"

  @ui @list
  Scenario: Ver lista de mis inscripciones con filtros
    Given tengo las siguientes inscripciones:
      | campaña              | estado      | fecha_inicio |
      | Limpieza Playas      | PENDIENTE   | 15/12/2025   |
      | Donación Sangre      | EN_CURSO    | 01/12/2025   |
      | Reforestación        | COMPLETADA  | 20/11/2025   |
      | Visita Asilos        | CANCELADA   | 10/11/2025   |
    When voy a "Mis Inscripciones"
    Then debo ver las 4 inscripciones
    When filtro por estado "COMPLETADA"
    Then debo ver solo 1 inscripción
    And debe ser "Reforestación"

  # ═══════════════════════════════════════════════════════
  # SCENARIO OUTLINE - INSCRIPCIONES CON DATOS VARIABLES
  # ═══════════════════════════════════════════════════════

  @data_driven
  Scenario Outline: Inscripción según disponibilidad de cupos
    Given existe la campaña "<campaña>" con <cupos_disponibles> cupos
    When intento inscribirme
    Then debo ver el resultado "<resultado>"
    And el botón debe tener estado "<estado_boton>"

    Examples:
      | campaña              | cupos_disponibles | resultado                     | estado_boton |
      | Campaña Con Cupos    | 10                | Inscripción exitosa           | habilitado   |
      | Campaña Último Cupo  | 1                 | Inscripción exitosa           | habilitado   |
      | Campaña Sin Cupos    | 0                 | No hay cupos disponibles      | deshabilitado|
      | Campaña Llena        | 0                 | Lista de espera disponible    | espera       |
```

### 6.3 certificados.feature

```gherkin
# src/test/resources/features/estudiante/certificados.feature

@estudiante @certificados
Feature: Gestión de certificados de voluntariado
  Como estudiante que ha completado campañas
  Quiero poder visualizar y descargar mis certificados
  Para acreditar mis horas de voluntariado

  Background:
    Given he iniciado sesión como estudiante "2020123456"
    And he completado al menos 1 campaña de voluntariado

  @happy_path @download
  Scenario: Descargar certificado de campaña completada
    Given he completado la campaña "Limpieza de Playas" con 8 horas
    And el coordinador ha generado mi certificado
    When voy a la sección "Certificados"
    Then debo ver el certificado de "Limpieza de Playas"
    When hago click en "Descargar PDF"
    Then debe descargarse un archivo PDF
    And el PDF debe contener:
      | Mi nombre completo             |
      | Nombre de la campaña           |
      | Fecha de realización           |
      | 8 horas de voluntariado        |
      | Firma digital del coordinador  |
      | Código QR de verificación      |

  @verification @qr
  Scenario: Certificado con código QR para verificación
    Given descargo mi certificado
    When escaneo el código QR del certificado
    Then debo ser redirigido a página de verificación pública
    And debe mostrar:
      | Estado: VÁLIDO                 |
      | Estudiante: Juan Pérez         |
      | Campaña: Limpieza de Playas    |
      | Fecha emisión: 01/12/2025      |
    But NO debe mostrar información sensible del estudiante

  @list @filter
  Scenario: Ver historial completo de certificados
    Given he completado 5 campañas en total
    When voy a "Certificados"
    Then debo ver una tabla con mis 5 certificados
    And la tabla debe mostrar:
      | Campaña         |
      | Fecha           |
      | Horas           |
      | Estado          |
      | Acciones        |
    When ordeno por "Fecha" descendente
    Then los certificados más recientes deben aparecer primero

  @negative @not_available
  Scenario: Certificado no disponible si campaña no completada
    Given estoy inscrito en "Donación de Sangre" pero no he asistido
    When voy a "Certificados"
    Then NO debo ver certificado de "Donación de Sangre"
    And debe aparecer solo en "Inscripciones Pendientes"

  @summary
  Scenario: Ver resumen total de horas de voluntariado
    Given tengo los siguientes certificados:
      | campaña              | horas |
      | Limpieza Playas      | 8     |
      | Reforestación        | 6     |
      | Donación Sangre      | 4     |
    When voy a "Certificados"
    Then debo ver un resumen con:
      | Total de horas acumuladas: 18  |
      | Campañas completadas: 3        |
      | Última participación: [fecha]  |
    And debo ver un gráfico de progreso hacia las 60 horas requeridas
```

---

## 7. 👨‍💼 Features de Coordinador

### 7.1 crear_campana.feature

```gherkin
# src/test/resources/features/coordinador/crear_campana.feature

@coordinador @campanas @crud
Feature: Creación y gestión de campañas
  Como coordinador de voluntariado
  Quiero crear y administrar campañas
  Para organizar actividades de servicio social

  Background:
    Given he iniciado sesión como coordinador "COORD001"
    And estoy en el módulo de gestión de campañas

  # ═══════════════════════════════════════════════════════
  # CREAR CAMPAÑA
  # ═══════════════════════════════════════════════════════

  @create @happy_path
  Scenario: Crear campaña con todos los datos obligatorios
    When hago click en "Nueva Campaña"
    And completo el formulario con:
      | campo          | valor                        |
      | Título         | Limpieza de Playas 2025      |
      | Descripción    | Actividad de limpieza costera|
      | Fecha inicio   | 15/12/2025                   |
      | Fecha fin      | 15/12/2025                   |
      | Ubicación      | Playa Boca del Río, Tacna    |
      | Cupos          | 30                           |
      | Horas          | 8                            |
    And hago click en "Crear Campaña"
    Then debo ver el mensaje "Campaña creada exitosamente"
    And la campaña debe aparecer en "Mis Campañas"
    And el estado inicial debe ser "ACTIVA"

  @create @validation
  Scenario: Validar campos obligatorios al crear campaña
    When hago click en "Nueva Campaña"
    And intento guardar sin llenar campos
    Then debo ver mensajes de validación en:
      | Título es obligatorio         |
      | Descripción es obligatoria    |
      | Fecha de inicio es obligatoria|
      | Cupos debe ser mayor a 0      |
    And el botón "Crear" debe estar deshabilitado hasta completar

  @create @business_rule
  Scenario: Validar que fecha de fin sea mayor o igual a fecha de inicio
    When creo una campaña con:
      | Fecha inicio | 20/12/2025 |
      | Fecha fin    | 15/12/2025 |
    Then debo ver el error "La fecha de fin no puede ser anterior a la fecha de inicio"
    And la campaña NO debe crearse

  @create @business_rule
  Scenario: Cupos mínimos y máximos
    When intento crear una campaña con 0 cupos
    Then debo ver "El número de cupos debe ser al menos 1"
    When intento crear una campaña con 1000 cupos
    Then debo ver una advertencia "¿Está seguro? 1000 cupos es un número muy alto"
    But puedo confirmar y crear la campaña si es intencional

  # ═══════════════════════════════════════════════════════
  # EDITAR CAMPAÑA
  # ═══════════════════════════════════════════════════════

  @update @happy_path
  Scenario: Editar información de campaña antes de que inicie
    Given he creado la campaña "Limpieza de Playas"
    And la campaña aún no ha iniciado
    When voy a "Mis Campañas"
    And hago click en "Editar" en esa campaña
    And modifico el título a "Limpieza de Playas - EDICIÓN VERANO"
    And modifico los cupos de 30 a 40
    And guardo los cambios
    Then debo ver "Campaña actualizada exitosamente"
    And los cambios deben reflejarse inmediatamente

  @update @restriction
  Scenario: No poder editar cupos si ya hay inscritos
    Given he creado una campaña con 30 cupos
    And ya hay 15 estudiantes inscritos
    When intento reducir los cupos a 10
    Then debo ver el error "No puede reducir cupos por debajo del número de inscritos (15)"
    But puedo aumentar los cupos a 40 sin problema

  @update @restriction
  Scenario: Restricciones para editar campaña ya iniciada
    Given tengo una campaña que ya inició
    When intento editarla
    Then solo debo poder modificar:
      | Descripción |
      | Ubicación   |
    But NO debo poder modificar:
      | Fecha de inicio |
      | Cupos           |
      | Horas           |

  # ═══════════════════════════════════════════════════════
  # CANCELAR CAMPAÑA
  # ═══════════════════════════════════════════════════════

  @delete @confirmation
  Scenario: Cancelar campaña con confirmación
    Given he creado la campaña "Campaña de Prueba"
    And tiene 5 estudiantes inscritos
    When hago click en "Cancelar Campaña"
    Then debo ver modal de advertencia:
      """
      ¿Está seguro de cancelar esta campaña?
      Hay 5 estudiantes inscritos que serán notificados.
      Esta acción no se puede deshacer.
      """
    When confirmo la cancelación
    Then la campaña debe cambiar a estado "CANCELADA"
    And los 5 estudiantes deben recibir email de notificación
    And la campaña NO debe aparecer en búsquedas de estudiantes

  @delete @restriction
  Scenario: No poder eliminar campaña con asistencias registradas
    Given tengo una campaña finalizada
    And ya se registraron asistencias de estudiantes
    When intento eliminar la campaña
    Then debo ver "No se puede eliminar. Ya tiene asistencias registradas"
    And solo puedo archivar la campaña

  # ═══════════════════════════════════════════════════════
  # SCENARIO OUTLINE - CREAR CAMPAÑAS CON DIFERENTES DATOS
  # ═══════════════════════════════════════════════════════

  @data_driven
  Scenario Outline: Crear campañas de diferentes tipos
    When creo una campaña de tipo "<tipo>" con:
      | Título      | <titulo>      |
      | Duración    | <duracion>    |
      | Cupos       | <cupos>       |
      | Horas       | <horas>       |
    Then la campaña debe crearse con éxito
    And debe categorizar automáticamente como "<categoria>"

    Examples:
      | tipo              | titulo                | duracion | cupos | horas | categoria        |
      | Medio Ambiente    | Limpieza              | 1 día    | 30    | 8     | AMBIENTAL        |
      | Salud             | Donación de Sangre    | 1 día    | 50    | 4     | SALUD            |
      | Educación         | Tutorías              | 5 días   | 15    | 20    | EDUCATIVA        |
      | Social            | Visita Asilos         | 1 día    | 20    | 6     | SOCIAL           |
```

### 7.2 control_asistencia.feature

```gherkin
# src/test/resources/features/coordinador/control_asistencia.feature

@coordinador @asistencia
Feature: Control de asistencia de estudiantes
  Como coordinador
  Quiero registrar la asistencia de estudiantes
  Para validar su participación en campañas

  Background:
    Given he iniciado sesión como coordinador
    And tengo una campaña "Limpieza de Playas" con 10 estudiantes inscritos
    And la campaña se está realizando hoy

  @manual @happy_path
  Scenario: Registrar asistencia manual de estudiantes
    When voy a "Control de Asistencia"
    And selecciono la campaña "Limpieza de Playas"
    Then debo ver la lista de 10 estudiantes inscritos
    When marco como "PRESENTE" a 8 estudiantes
    And marco como "AUSENTE" a 2 estudiantes
    And guardo el registro
    Then debo ver "Asistencia registrada exitosamente"
    And los 8 estudiantes presentes deben poder generar certificado
    But los 2 ausentes NO deben poder generar certificado

  @qr @happy_path
  Scenario: Registrar asistencia mediante escaneo de QR
    Given cada estudiante tiene un código QR único
    When voy a "Escanear QR"
    And escaneo el código QR del estudiante "Juan Pérez"
    Then debo ver "Asistencia registrada para Juan Pérez"
    And su estado debe cambiar a "PRESENTE" automáticamente
    When escaneo el mismo QR nuevamente
    Then debo ver "Ya se registró la asistencia de este estudiante"

  @qr @bulk
  Scenario: Registro masivo de asistencias por QR
    When inicio el modo "Escaneo Continuo"
    And escaneo los códigos QR de 10 estudiantes consecutivamente
    Then cada escaneo exitoso debe:
      | Mostrar nombre del estudiante        |
      | Emitir sonido de confirmación        |
      | Actualizar contador de presentes     |
    And al finalizar debo ver resumen:
      | Presentes: 10 |
      | Ausentes: 0   |

  @late_arrival
  Scenario: Registrar llegada tardía
    When registro la asistencia de "Juan Pérez"
    And marco como "LLEGADA TARDÍA"
    And especifico "Llegó 30 minutos tarde"
    Then su asistencia debe quedar registrada como "PRESENTE CON OBSERVACIÓN"
    And debe poder generar certificado
    But el certificado debe incluir la observación

  @early_departure
  Scenario: Registrar salida anticipada
    Given "María López" está marcada como presente
    When registro una "SALIDA ANTICIPADA"
    And especifico el motivo "Emergencia familiar"
    Then su asistencia debe cambiar a "PRESENTE CON OBSERVACIÓN"
    And las horas efectivas deben calcularse según tiempo real de permanencia

  @bulk_actions
  Scenario: Acciones masivas de asistencia
    When selecciono 5 estudiantes de la lista
    And hago click en "Marcar como Presente" en acciones masivas
    Then los 5 estudiantes seleccionados deben marcarse como presentes
    And debo ver confirmación "5 asistencias registradas"

  @export
  Scenario: Exportar reporte de asistencias
    Given he registrado la asistencia de todos los estudiantes
    When hago click en "Exportar Reporte"
    And selecciono formato "Excel"
    Then debe descargarse un archivo .xlsx
    And el archivo debe contener:
      | Código estudiante     |
      | Nombre completo       |
      | Estado (Presente/Ausente) |
      | Hora de registro      |
      | Observaciones         |

  @statistics
  Scenario: Ver estadísticas de asistencia de la campaña
    Given he registrado asistencia con:
      | 8 presentes |
      | 1 ausente   |
      | 1 llegada tardía |
    When veo el resumen de asistencias
    Then debo ver:
      | Porcentaje de asistencia: 90% |
      | Presentes: 9/10               |
      | Ausentes: 1/10                |
      | Observaciones: 1              |
    And debo ver un gráfico circular con la distribución
```

### 7.3 generar_certificados.feature

```gherkin
# src/test/resources/features/coordinador/generar_certificados.feature

@coordinador @certificados @generation
Feature: Generación de certificados de voluntariado
  Como coordinador
  Quiero generar certificados para estudiantes que completaron campañas
  Para acreditar oficialmente sus horas de voluntariado

  Background:
    Given he iniciado sesión como coordinador
    And tengo una campaña "Limpieza de Playas" finalizada
    And 8 estudiantes asistieron completamente

  @generate @individual
  Scenario: Generar certificado individual para un estudiante
    When voy a la lista de estudiantes que completaron la campaña
    And selecciono a "Juan Pérez"
    And hago click en "Generar Certificado"
    Then debo ver preview del certificado con:
      | Logo UPT                              |
      | Nombre: Juan Pérez                    |
      | Código: 2020123456                    |
      | Campaña: Limpieza de Playas           |
      | Fecha: 15/12/2025                     |
      | Horas: 8                              |
      | Mi firma digital como coordinador     |
      | Código QR de verificación             |
    When confirmo la generación
    Then el certificado debe guardarse en el sistema
    And el estudiante debe recibir notificación por email

  @generate @bulk
  Scenario: Generación masiva de certificados
    When voy a "Certificados de Campaña"
    And hago click en "Generar Todos los Certificados"
    Then debo ver lista de 8 estudiantes elegibles
    When confirmo la generación masiva
    Then debe iniciarse un proceso en segundo plano
    And debo ver barra de progreso "Generando 8 certificados..."
    When el proceso finaliza
    Then los 8 certificados deben estar disponibles
    And todos los estudiantes deben recibir email

  @template @customization
  Scenario: Personalizar plantilla de certificado
    When voy a "Configuración de Certificados"
    And selecciono "Editar Plantilla"
    Then puedo modificar:
      | Texto del encabezado         |
      | Formato de fecha             |
      | Posición del logo            |
      | Tamaño de letra              |
    When guardo la plantilla personalizada
    And genero un nuevo certificado
    Then debe usar la plantilla personalizada

  @validation @prerequisites
  Scenario: Validar requisitos antes de generar certificado
    Given un estudiante "Pedro Gómez" asistió pero llegó muy tarde
    And solo completó 3 de las 8 horas de la campaña
    When intento generar su certificado
    Then debo ver advertencia:
      """
      Este estudiante no completó las horas mínimas requeridas (3/8).
      ¿Desea generar el certificado de todas formas?
      """
    When elijo "No"
    Then el certificado NO debe generarse
    When elijo "Sí, generar con observación"
    Then el certificado debe indicar "Asistencia parcial: 3 horas"

  @signature @digital
  Scenario: Firma digital del coordinador en certificado
    Given tengo configurada mi firma digital
    When genero un certificado
    Then debe incluir mi firma escaneada
    And debe incluir mi sello oficial
    And debe incluir fecha de generación
    And todo debe estar encriptado con hash SHA-256

  @qr @verification
  Scenario: Código QR de verificación en certificado
    When genero un certificado para "Juan Pérez"
    Then el PDF debe contener un código QR único
    When alguien escanea ese código QR
    Then debe redirigir a URL pública del tipo:
      """
      https://voluntariado.upt.edu.pe/verificar/ABC123XYZ789
      """
    And debe mostrar:
      | Estado: VÁLIDO                    |
      | Estudiante: Juan Pérez            |
      | Campaña: Limpieza de Playas       |
      | Horas: 8                          |
      | Fecha emisión: 16/12/2025         |
      | Coordinador: [mi nombre]          |
```

---

## 8. 🔧 Step Definitions Avanzadas

### 8.1 CampanaStepDefs.java

```java
package bdd.stepdefinitions;

import bdd.context.TestContext;
import io.cucumber.datatable.DataTable;
import io.cucumber.java.en.*;
import org.openqa.selenium.WebDriver;
import ui.pages.CampanasPage;
import ui.pages.CrearCampanaPage;

import java.util.List;
import java.util.Map;

import static org.assertj.core.api.Assertions.*;

/**
 * Step Definitions para funcionalidad de Campañas.
 */
public class CampanaStepDefs {
    
    private final TestContext context;
    private final WebDriver driver;
    private final CampanasPage campanasPage;
    private final CrearCampanaPage crearCampanaPage;
    
    public CampanaStepDefs(TestContext context) {
        this.context = context;
        this.driver = context.getDriver();
        this.campanasPage = new CampanasPage(driver);
        this.crearCampanaPage = new CrearCampanaPage(driver);
    }
    
    // ═══════════════════════════════════════════════════════
    // GIVEN - Contexto de campañas
    // ═══════════════════════════════════════════════════════
    
    @Given("estoy en la página de campañas disponibles")
    public void estoyEnPaginaCampanas() {
        driver.get(context.getBaseUrl() + "/estudiantes/campañas.jsp");
        assertThat(driver.getCurrentUrl()).contains("/campañas.jsp");
    }
    
    @Given("existen las siguientes campañas:")
    public void existenCampanas(DataTable dataTable) {
        List<Map<String, String>> campanasData = dataTable.asMaps(String.class, String.class);
        
        // Crear campañas via API o setup en BD
        for (Map<String, String> campana : campanasData) {
            context.getApiHelper().crearCampana(
                campana.get("título"),
                campana.get("estado"),
                Integer.parseInt(campana.get("cupos"))
            );
        }
        
        // Guardar en contexto
        context.setScenarioContext("campañas_creadas", campanasData.size());
    }
    
    @Given("existen campañas con diferentes estados:")
    public void existenCampanasConEstados(DataTable dataTable) {
        List<Map<String, String>> campanasData = dataTable.asMaps(String.class, String.class);
        
        for (Map<String, String> campana : campanasData) {
            context.getApiHelper().crearCampana(
                campana.get("título"),
                campana.get("estado"),
                20 // cupos default
            );
        }
    }
    
    @Given("existe la campaña {string} con {int} cupos disponibles")
    public void existeCampanaConCupos(String titulo, int cupos) {
        context.getApiHelper().crearCampana(titulo, "ACTIVA", cupos);
        context.setScenarioContext("campana_actual", titulo);
        context.setScenarioContext("cupos_iniciales", cupos);
    }
    
    @Given("ya estoy inscrito en la campaña {string}")
    public void yaEstoyInscrito(String titulo) {
        String codigoEstudiante = (String) context.getScenarioContext("username");
        context.getApiHelper().inscribirEstudiante(codigoEstudiante, titulo);
    }
    
    @Given("tengo {int} inscripciones activas")
    public void tengoNInscripciones(int cantidad) {
        String codigoEstudiante = (String) context.getScenarioContext("username");
        
        for (int i = 1; i <= cantidad; i++) {
            context.getApiHelper().crearCampana("Campaña " + i, "ACTIVA", 20);
            context.getApiHelper().inscribirEstudiante(codigoEstudiante, "Campaña " + i);
        }
    }
    
    @Given("he creado la campaña {string}")
    public void heCreado Campaña(String titulo) {
        String codigoCoordinador = (String) context.getScenarioContext("username");
        context.getApiHelper().crearCampanaComoCoordinador(
            titulo, 
            "Descripción de prueba", 
            codigoCoordinador
        );
    }
    
    // ═══════════════════════════════════════════════════════
    // WHEN - Acciones sobre campañas
    // ═══════════════════════════════════════════════════════
    
    @When("busco por el término {string}")
    public void buscoPorTermino(String termino) {
        campanasPage.buscarCampana(termino);
        context.setScenarioContext("termino_busqueda", termino);
    }
    
    @When("filtro por estado {string}")
    public void filtroPorEstado(String estado) {
        campanasPage.filtrarPorEstado(estado);
        context.setScenarioContext("filtro_estado", estado);
    }
    
    @When("hago click en {string} en esa campaña")
    public void clickEnAccionCampana(String accion) {
        String tituloCampana = (String) context.getScenarioContext("campana_actual");
        
        if (accion.equals("Inscribirse")) {
            campanasPage.inscribirsePorTitulo(tituloCampana);
        } else if (accion.equals("Ver Detalles")) {
            campanasPage.verDetallesCampana(tituloCampana);
        }
    }
    
    @When("confirmo la inscripción")
    public void confirmoInscripcion() {
        campanasPage.confirmarModalInscripcion();
    }
    
    @When("hago click en {string}")
    public void hagoClickEn(String elemento) {
        switch (elemento) {
            case "Nueva Campaña":
                driver.findElement(By.id("btnNuevaCampana")).click();
                break;
            case "Crear Campaña":
                crearCampanaPage.clickCrear();
                break;
            default:
                throw new IllegalArgumentException("Elemento no reconocido: " + elemento);
        }
    }
    
    @When("completo el formulario con:")
    public void completoFormulario(DataTable dataTable) {
        Map<String, String> datos = dataTable.asMap(String.class, String.class);
        
        if (datos.containsKey("Título")) {
            crearCampanaPage.ingresarTitulo(datos.get("Título"));
        }
        if (datos.containsKey("Descripción")) {
            crearCampanaPage.ingresarDescripcion(datos.get("Descripción"));
        }
        if (datos.containsKey("Fecha inicio")) {
            crearCampanaPage.ingresarFechaInicio(datos.get("Fecha inicio"));
        }
        if (datos.containsKey("Fecha fin")) {
            crearCampanaPage.ingresarFechaFin(datos.get("Fecha fin"));
        }
        if (datos.containsKey("Ubicación")) {
            crearCampanaPage.ingresarUbicacion(datos.get("Ubicación"));
        }
        if (datos.containsKey("Cupos")) {
            crearCampanaPage.ingresarCupos(Integer.parseInt(datos.get("Cupos")));
        }
        if (datos.containsKey("Horas")) {
            crearCampanaPage.ingresarHoras(Integer.parseInt(datos.get("Horas")));
        }
    }
    
    // ═══════════════════════════════════════════════════════
    // THEN - Verificaciones
    // ═══════════════════════════════════════════════════════
    
    @Then("debo ver {int} campaña en los resultados")
    @Then("debo ver {int} campañas en los resultados")
    public void deboVerNCampanas(int cantidad) {
        int cantidadActual = campanasPage.getCantidadCampanas();
        assertThat(cantidadActual).isEqualTo(cantidad);
    }
    
    @Then("la campaña mostrada debe ser {string}")
    public void campanaMostradaDebeSer(String titulo) {
        assertThat(campanasPage.existeCampana(titulo)).isTrue();
    }
    
    @Then("no debo ver campañas en los resultados")
    public void noDeboVerCampanas() {
        assertThat(campanasPage.getCantidadCampanas()).isZero();
    }
    
    @Then("debo ver el mensaje {string}")
    public void deboVerMensaje(String mensaje) {
        String mensajeActual = driver.findElement(By.className("alert-message")).getText();
        assertThat(mensajeActual).containsIgnoringCase(mensaje);
    }
    
    @Then("solo debo ver campañas con estado {string}")
    public void soloDeboVerCampanasConEstado(String estado) {
        List<String> estados = campanasPage.obtenerEstadosDeCampanas();
        
        assertThat(estados).allMatch(e -> e.equals(estado));
    }
    
    @Then("la campaña debe tener {int} cupos disponibles")
    public void campanaTieneCupos(int cuposEsperados) {
        String tituloCampana = (String) context.getScenarioContext("campana_actual");
        int cuposActuales = campanasPage.getCuposDisponibles(tituloCampana);
        
        assertThat(cuposActuales).isEqualTo(cuposEsperados);
    }
    
    @Then("debo recibir un email de confirmación")
    public void deboRecibirEmail() {
        // Verificar email via mock o servicio de email testing
        String emailEstudiante = context.getProperty("test.estudiante.email");
        
        boolean emailRecibido = context.getEmailService()
            .verificarEmailEnviado(emailEstudiante, "Confirmación de inscripción");
        
        assertThat(emailRecibido).isTrue();
    }
    
    @Then("la campaña debe aparecer en {string}")
    public void campanaApareceEn(String seccion) {
        driver.get(context.getBaseUrl() + "/estudiantes/inscripciones.jsp");
        
        String tituloCampana = (String) context.getScenarioContext("campana_actual");
        boolean existe = campanasPage.existeCampana(tituloCampana);
        
        assertThat(existe).isTrue();
    }
    
    @Then("el botón {string} debe estar deshabilitado")
    public void botonDebeEstarDeshabilitado(String botonTexto) {
        WebElement boton = campanasPage.obtenerBotonInscripcion();
        assertThat(boton.isEnabled()).isFalse();
    }
    
    @Then("la campaña debe crearse con éxito")
    public void campanaSeCreoConExito() {
        String mensaje = driver.findElement(By.className("success-message")).getText();
        assertThat(mensaje).containsIgnoringCase("creada exitosamente");
    }
    
    @Then("debe categorizar automáticamente como {string}")
    public void debeCategorizarComo(String categoriaEsperada) {
        String categoriaActual = driver.findElement(By.className("badge-categoria")).getText();
        assertThat(categoriaActual).isEqualTo(categoriaEsperada);
    }
}
```

### 8.2 InscripcionStepDefs.java

```java
package bdd.stepdefinitions;

import bdd.context.TestContext;
import io.cucumber.java.en.*;
import org.openqa.selenium.WebDriver;
import ui.pages.InscripcionesPage;

import static org.assertj.core.api.Assertions.*;

/**
 * Step Definitions para gestión de inscripciones.
 */
public class InscripcionStepDefs {
    
    private final TestContext context;
    private final WebDriver driver;
    private final InscripcionesPage inscripcionesPage;
    
    public InscripcionStepDefs(TestContext context) {
        this.context = context;
        this.driver = context.getDriver();
        this.inscripcionesPage = new InscripcionesPage(driver);
    }
    
    @Given("tengo las siguientes inscripciones:")
    public void tengoInscripciones(DataTable dataTable) {
        List<Map<String, String>> inscripciones = dataTable.asMaps(String.class, String.class);
        String codigoEstudiante = (String) context.getScenarioContext("username");
        
        for (Map<String, String> inscripcion : inscripciones) {
            context.getApiHelper().crearInscripcion(
                codigoEstudiante,
                inscripcion.get("campaña"),
                inscripcion.get("estado"),
                inscripcion.get("fecha_inicio")
            );
        }
    }
    
    @When("voy a {string}")
    public void voyA(String seccion) {
        String url = switch (seccion) {
            case "Mis Inscripciones" -> "/estudiantes/inscripciones.jsp";
            case "Certificados" -> "/estudiantes/certificados.jsp";
            case "Control de Asistencia" -> "/coordinador/control_asistencia.jsp";
            default -> throw new IllegalArgumentException("Sección no reconocida: " + seccion);
        };
        
        driver.get(context.getBaseUrl() + url);
    }
    
    @When("filtro por estado {string}")
    public void filtroPorEstadoInscripcion(String estado) {
        inscripcionesPage.filtrarPorEstado(estado);
    }
    
    @Then("debo ver solo {int} inscripción")
    @Then("debo ver solo {int} inscripciones")
    public void deboVerNInscripciones(int cantidad) {
        int cantidadActual = inscripcionesPage.getCantidadInscripciones();
        assertThat(cantidadActual).isEqualTo(cantidad);
    }
    
    @Then("debe ser {string}")
    public void debeSer(String tituloCampana) {
        List<String> titulos = inscripcionesPage.obtenerTitulosCampanas();
        assertThat(titulos).hasSize(1);
        assertThat(titulos.get(0)).isEqualTo(tituloCampana);
    }
}
```

---

## 9. 🎯 Hooks y Contexto Compartido

### 9.1 Hooks.java

```java
package bdd.hooks;

import bdd.context.TestContext;
import io.cucumber.java.*;
import org.openqa.selenium.OutputType;
import org.openqa.selenium.TakesScreenshot;
import org.openqa.selenium.WebDriver;

/**
 * Hooks de Cucumber para ejecutar código antes/después de cada escenario.
 */
public class Hooks {
    
    private final TestContext context;
    
    public Hooks(TestContext context) {
        this.context = context;
    }
    
    /**
     * Se ejecuta UNA VEZ antes de todas las pruebas.
     */
    @BeforeAll
    public static void setupSuite() {
        System.out.println("═══════════════════════════════════════════");
        System.out.println("   INICIANDO SUITE DE PRUEBAS BDD");
        System.out.println("═══════════════════════════════════════════");
        
        // Configurar base de datos de pruebas
        // Inicializar servicios externos si es necesario
    }
    
    /**
     * Se ejecuta ANTES de cada escenario.
     */
    @Before
    public void beforeScenario(Scenario scenario) {
        System.out.println("\n▶ Iniciando: " + scenario.getName());
        
        // Inicializar WebDriver
        context.initializeDriver();
        
        // Limpiar datos del escenario anterior
        context.clearScenarioContext();
        
        // Log de tags
        System.out.println("  Tags: " + scenario.getSourceTagNames());
    }
    
    /**
     * Hook condicional: solo para escenarios con tag @database.
     */
    @Before("@database")
    public void beforeDatabaseScenario() {
        System.out.println("  → Limpiando base de datos...");
        context.getDatabaseHelper().limpiarDatos();
    }
    
    /**
     * Hook condicional: solo para escenarios con tag @api.
     */
    @Before("@api")
    public void beforeApiScenario() {
        System.out.println("  → Configurando API mock server...");
        context.getApiHelper().inicializarMockServer();
    }
    
    /**
     * Se ejecuta DESPUÉS de cada escenario.
     */
    @After
    public void afterScenario(Scenario scenario) {
        // Capturar screenshot si el escenario falló
        if (scenario.isFailed()) {
            captureScreenshot(scenario);
        }
        
        // Cerrar WebDriver
        context.quitDriver();
        
        // Log de resultado
        String status = scenario.getStatus().toString();
        System.out.println("✓ Finalizado: " + scenario.getName() + " - " + status);
    }
    
    /**
     * Hook condicional: solo después de escenarios con tag @cleanup.
     */
    @After("@cleanup")
    public void afterCleanupScenario() {
        System.out.println("  → Limpiando archivos temporales...");
        context.getFileHelper().eliminarArchivosTemporales();
    }
    
    /**
     * Se ejecuta UNA VEZ después de todas las pruebas.
     */
    @AfterAll
    public static void teardownSuite() {
        System.out.println("\n═══════════════════════════════════════════");
        System.out.println("   SUITE DE PRUEBAS BDD FINALIZADA");
        System.out.println("═══════════════════════════════════════════");
    }
    
    /**
     * Captura screenshot y lo adjunta al reporte de Cucumber.
     */
    private void captureScreenshot(Scenario scenario) {
        try {
            WebDriver driver = context.getDriver();
            
            if (driver != null) {
                byte[] screenshot = ((TakesScreenshot) driver).getScreenshotAs(OutputType.BYTES);
                scenario.attach(screenshot, "image/png", scenario.getName());
                System.out.println("  📸 Screenshot capturado");
            }
        } catch (Exception e) {
            System.err.println("  ❌ Error al capturar screenshot: " + e.getMessage());
        }
    }
}
```

### 9.2 TestContext.java

```java
package bdd.context;

import io.github.bonigarcia.wdm.WebDriverManager;
import org.openqa.selenium.WebDriver;
import org.openqa.selenium.chrome.ChromeDriver;
import org.openqa.selenium.chrome.ChromeOptions;

import java.io.IOException;
import java.io.InputStream;
import java.time.Duration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

/**
 * Contexto compartido entre todos los step definitions.
 * Permite compartir estado entre pasos de un mismo escenario.
 */
public class TestContext {
    
    private WebDriver driver;
    private Properties properties;
    private Map<String, Object> scenarioContext;
    
    private ApiHelper apiHelper;
    private DatabaseHelper databaseHelper;
    private EmailService emailService;
    private FileHelper fileHelper;
    
    public TestContext() {
        scenarioContext = new HashMap<>();
        loadProperties();
        initializeHelpers();
    }
    
    /**
     * Carga propiedades de configuración desde archivo.
     */
    private void loadProperties() {
        properties = new Properties();
        try (InputStream input = getClass().getClassLoader()
                .getResourceAsStream("test-data.properties")) {
            
            if (input != null) {
                properties.load(input);
            }
        } catch (IOException e) {
            throw new RuntimeException("Error al cargar propiedades", e);
        }
    }
    
    /**
     * Inicializa helpers para API, BD, Email, etc.
     */
    private void initializeHelpers() {
        this.apiHelper = new ApiHelper(getBaseUrl());
        this.databaseHelper = new DatabaseHelper(
            getProperty("db.url"),
            getProperty("db.username"),
            getProperty("db.password")
        );
        this.emailService = new EmailService();
        this.fileHelper = new FileHelper();
    }
    
    /**
     * Inicializa el WebDriver (se llama en @Before).
     */
    public void initializeDriver() {
        if (driver == null) {
            WebDriverManager.chromedriver().setup();
            
            ChromeOptions options = new ChromeOptions();
            options.addArguments("--start-maximized");
            options.addArguments("--disable-notifications");
            
            // Headless mode en CI/CD
            if (Boolean.parseBoolean(getProperty("headless"))) {
                options.addArguments("--headless=new");
                options.addArguments("--disable-gpu");
            }
            
            driver = new ChromeDriver(options);
            driver.manage().timeouts().implicitlyWait(Duration.ofSeconds(10));
            driver.manage().timeouts().pageLoadTimeout(Duration.ofSeconds(30));
        }
    }
    
    /**
     * Cierra el WebDriver (se llama en @After).
     */
    public void quitDriver() {
        if (driver != null) {
            driver.quit();
            driver = null;
        }
    }
    
    /**
     * Obtiene el WebDriver actual.
     */
    public WebDriver getDriver() {
        return driver;
    }
    
    /**
     * Obtiene una propiedad de configuración.
     */
    public String getProperty(String key) {
        return properties.getProperty(key);
    }
    
    /**
     * Obtiene la URL base de la aplicación.
     */
    public String getBaseUrl() {
        return getProperty("base.url");
    }
    
    /**
     * Guarda un valor en el contexto del escenario.
     * Permite compartir datos entre steps del mismo escenario.
     */
    public void setScenarioContext(String key, Object value) {
        scenarioContext.put(key, value);
    }
    
    /**
     * Obtiene un valor del contexto del escenario.
     */
    public Object getScenarioContext(String key) {
        return scenarioContext.get(key);
    }
    
    /**
     * Limpia el contexto del escenario.
     * Se llama al inicio de cada escenario para evitar contaminación de datos.
     */
    public void clearScenarioContext() {
        scenarioContext.clear();
    }
    
    // ═══════════════════════════════════════════════════════
    // GETTERS DE HELPERS
    // ═══════════════════════════════════════════════════════
    
    public ApiHelper getApiHelper() {
        return apiHelper;
    }
    
    public DatabaseHelper getDatabaseHelper() {
        return databaseHelper;
    }
    
    public EmailService getEmailService() {
        return emailService;
    }
    
    public FileHelper getFileHelper() {
        return fileHelper;
    }
}
```

---

**Continúa en Parte 3:** Administrador Features, Reports, CI/CD, Best Practices

---

*Generado el 3 de Diciembre de 2025*  
*Cucumber 7.15.0 + Selenium WebDriver 4.16.1*
