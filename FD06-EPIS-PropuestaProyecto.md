<center>

[comment]: <img src="./media/media/image1.png" style="width:1.088in;height:1.46256in" alt="escudo.png" />

![./media/media/image1.png](./media/logo-upt.png)

## **UNIVERSIDAD PRIVADA DE TACNA**

## **FACULTAD DE INGENIERIA**

## **Escuela Profesional de Ingeniería de Sistemas**<br>

<br>

# **Proyecto *"Implementación de Sistema de Voluntariado UPT"***

<br>

Curso: *Calidad y Pruebas de Software*

Docente: *Patrick José Cuadros Quiroga*


Integrantes:

***Cruz Mamani, Victor Williams (2022073903)***  
***Castillo Mamani, Diego Fernando (2022073895)***  
***Medina Quispe, Joan Cristian (202207394255)***

**Tacna – Perú**

***2025-II***

**  
**
</center>
<div style="page-break-after: always; visibility: hidden">\pagebreak</div>



**Proyecto**

***Sistema Web “Voluntariado-UPT” – Tacna, 2025***





**Presentado por:**

***Victor Williams, Cruz Mamani***

***Diego Fernando, Castillo Mamani***

***Joan Cristian, Medina Quispe***

***2025*** 











|CONTROL DE VERSIONES||||||
| :-: | :- | :- | :- | :- | :- |
|Versión|Hecha por|Revisada por|Aprobada por|Fecha|Motivo|
|1\.1|JMQ, VCM, DCM|JMQ|PCQ|08/11/2025|Actualización de documentación|

**ÍNDICE GENERAL**

[**Resumen Ejecutivo	5**](#_heading=h.f8z8lvwwlppe)

[**1. Propuesta narrativa	6**](#_heading=h.ck2egkfkodm7)

[**1.1. Planteamiento del Problema	6**](#_heading=h.f8z8lvwwlppe)

[**1.2. Justificación del proyecto	6**](#_heading=h.f8z8lvwwlppe)

[**1.3. Objetivo general	7**](#_heading=h.f8z8lvwwlppe)

[1.4. Beneficios	7](#_heading=h.6ut9yp3xw0dq)

[1.5. Alcance	7](#_heading=h.tja6be6ei2sx)

[**1.6. Requerimientos del sistema	8**](#_heading=h.f8z8lvwwlppe)

[**1.7. Restricciones	9**](#_heading=h.f8z8lvwwlppe)

[**1.8. Supuestos	10**](#_heading=h.f8z8lvwwlppe)

[**1.9. Resultados esperados	10**](#_heading=h.f8z8lvwwlppe)

[**1.10. Metodología de implementación	11**](#_heading=h.f8z8lvwwlppe)

[**1.11. Actores claves	11**](#_heading=h.f8z8lvwwlppe)

[**1.12. Papel y responsabilidades del personal	12**](#_heading=h.f8z8lvwwlppe)

[**1.13. Plan de monitoreo y evaluación	13**](#_heading=h.f8z8lvwwlppe)

[**1.14. Cronograma del proyecto	15**](#_heading=h.f8z8lvwwlppe)

[**1.15. Hitos de entregables	16**](#_heading=h.f8z8lvwwlppe)

[**2. Presupuesto	16**](#_heading=h.f8z8lvwwlppe)

[**2.1. Planteamiento de aplicación del presupuesto	16**](#_heading=h.f8z8lvwwlppe)

[**2.2. Presupuesto	17**](#_heading=h.f8z8lvwwlppe)

[**2.3. Análisis de Factibilidad	19**](#_heading=h.p98mua5tv635)

[2.3.1. Factibilidad Técnica	19](#_heading=h.22ph22f54uky)

[2.3.2. Factibilidad Económica	20](#_heading=h.7vkj6uci8jkn)

[2.3.3. Factibilidad Operativa	20](#_heading=h.r0dkoe9e8frj)

[2.3.4. Resumen Comparativo de Viabilidad	21](#_heading=h.fh6k5g57ot7f)

[**2.4. Evaluación Financiera	22**](#_heading=h.gtzb2pa7pb12)

[2.4.1. Análisis Costo–Beneficio	22](#_heading=h.9w4k9k1ipxf5)

[2.4.2. Punto de Equilibrio y Retorno de Inversión (ROI)	23](#_heading=h.q10cvovw8h5g)

[2.4.3. Beneficios Intangibles y Valor Institucional	23](#_heading=h.qwp80mz0a3sl)

[**RESUMEN EJECUTIVO	24**](#_heading=h.1k6qc37ayves)



**Propuesta de Proyecto: Sistema de Voluntariado UPT**
# <a name="_heading=h.f8z8lvwwlppe"></a>**Resumen Ejecutivo**
El presente proyecto propone el desarrollo e implementación del sistema web Voluntariado-UPT, una plataforma tecnológica orientada a la gestión integral de campañas de voluntariado universitario en la Universidad Privada de Tacna. La iniciativa surge como respuesta a la necesidad institucional de modernizar y centralizar los procesos relacionados con la Responsabilidad Social Universitaria (RSU), permitiendo una administración eficiente de estudiantes, coordinadores y actividades sociales. El sistema fue diseñado bajo una arquitectura Java EE con Servlets y JSP, desplegada sobre Apache Tomcat y una base de datos MySQL, integrando funcionalidades clave como autenticación multirol, inscripción a campañas, control de asistencia mediante códigos QR, generación automática de certificados y elaboración de reportes analíticos en formato PDF.

Con su implementación, Voluntariado-UPT busca optimizar la trazabilidad y transparencia de las actividades de voluntariado, garantizando el registro confiable de la participación estudiantil y el cumplimiento de los objetivos de RSU. Además, promueve la automatización de tareas administrativas, reduce la carga operativa del personal responsable y fortalece la vinculación entre los distintos actores universitarios. Este sistema representa un paso significativo hacia la transformación digital de los procesos institucionales, al incorporar herramientas de análisis y tecnologías escalables que pueden ser ampliadas en futuras versiones hacia un entorno móvil o de nube universitaria.

# <a name="_heading=h.y71ndqn9m2qv"></a>
1. # <a name="_heading=h.ck2egkfkodm7"></a>**Propuesta narrativa**
   1. ## **Planteamiento del Problema**
      En la actualidad, la Universidad Privada de Tacna enfrenta dificultades en la gestión y seguimiento de las actividades de voluntariado estudiantil promovidas por la Escuela Profesional de Ingeniería de Sistemas (EPIS) y la Oficina de Responsabilidad Social Universitaria (RSU). Los procesos se realizan de manera manual o mediante herramientas dispersas, lo que genera duplicidad de registros, pérdida de información, retrasos en la emisión de certificados y escasa trazabilidad de la participación estudiantil. Esta falta de integración tecnológica impide un control eficiente de campañas, asistencia y reportes, dificultando la evaluación del impacto social de las actividades desarrolladas.

      Ante esta problemática, surge la necesidad de implementar un sistema informático centralizado que unifique la gestión de las campañas, registre la asistencia mediante mecanismos digitales y proporcione información confiable para la toma de decisiones institucionales.
   1. ## **Justificación del proyecto**
      El desarrollo del sistema **Voluntariado-UPT** se justifica en la necesidad de fortalecer los procesos de Responsabilidad Social Universitaria mediante la incorporación de herramientas tecnológicas que optimicen la planificación, ejecución y evaluación de las actividades de voluntariado. La automatización de la gestión permitirá reducir la carga administrativa de los coordinadores, garantizar la veracidad de los datos registrados y agilizar la generación de reportes y certificados.

      Además, la plataforma contribuye a la transparencia y eficiencia institucional, al ofrecer una interfaz accesible para los distintos actores involucrados (estudiantes, coordinadores y administradores), promoviendo la cultura digital dentro del ámbito académico. Desde el punto de vista académico y formativo, el proyecto refuerza las competencias profesionales de los estudiantes en el desarrollo de soluciones orientadas al servicio y a la mejora de los procesos universitarios.
   1. ## **Objetivo general**
      Desarrollar e implementar un sistema web integral que permita **gestionar las campañas de voluntariado universitario**, facilitando el registro de usuarios, la inscripción de estudiantes, el control de asistencia mediante códigos QR, la generación de certificados digitales y la obtención de reportes consolidados, contribuyendo así a la **eficiencia administrativa** y al **fortalecimiento de la Responsabilidad Social Universitaria (RSU)** en la Universidad Privada de Tacna.
   1. ## <a name="_heading=h.6ut9yp3xw0dq"></a>**Beneficios**
      La implementación del sistema **Voluntariado-UPT** ofrece beneficios tangibles tanto a nivel institucional como académico. En el ámbito administrativo, permite **automatizar procesos** que anteriormente se realizaban de forma manual, reduciendo errores humanos, tiempos de procesamiento y sobrecarga operativa del personal encargado de las actividades de voluntariado. El sistema centraliza la información en una base de datos unificada, garantizando la **integridad, trazabilidad y disponibilidad** de los registros de estudiantes, campañas y asistencias.

      Desde la perspectiva de los usuarios, el sistema mejora significativamente la **experiencia y accesibilidad**, brindando a los estudiantes una plataforma en línea para inscribirse, registrar su asistencia mediante códigos QR y descargar certificados digitales de forma rápida y segura. Asimismo, ofrece a los coordinadores herramientas para gestionar campañas y generar reportes analíticos, lo que contribuye al **seguimiento efectivo del impacto social** y a la transparencia institucional frente a los objetivos de Responsabilidad Social Universitaria (RSU).
   1. ## <a name="_heading=h.tja6be6ei2sx"></a>**Alcance**
      El proyecto **Voluntariado-UPT** abarca el desarrollo, implementación y despliegue de una aplicación web basada en la arquitectura **Java EE con Servlets y JSP**, operando sobre un entorno **Apache Tomcat** con base de datos **MySQL**. El sistema contempla tres perfiles de usuario principales: **Administrador**, **Coordinador** y **Estudiante**.

      El Administrador gestiona usuarios y roles institucionales; el Coordinador crea y supervisa campañas, registra asistencias y emite certificados; y el Estudiante se inscribe en las campañas disponibles, marca su asistencia y accede a sus certificados. El alcance del proyecto comprende el ciclo completo de gestión de campañas de voluntariado, desde la **creación y planificación** hasta la **emisión de reportes consolidados**, incluyendo la integración de funcionalidades de autenticación, generación de QR, control de asistencia y reportes en formato PDF.

      El sistema está diseñado para funcionar en entorno web institucional, accesible desde navegadores modernos, y podrá ser escalado en futuras versiones hacia una infraestructura en la nube o integración con plataformas móviles.
   1. ## **Requerimientos del sistema**
      El sistema requiere un entorno tecnológico compatible con **Java Development Kit (JDK 21)** y **Jakarta EE 7**, ejecutándose sobre un servidor **Apache Tomcat 7 o superior**. La base de datos utilizada es **MySQL/MariaDB versión 10.4**, gestionada mediante conexión JDBC. A nivel de frontend, la aplicación emplea **Bootstrap 5.3**, **FontAwesome 6.4** y **Chart.js 4.4** para el diseño visual y la representación gráfica de datos.\
      Para la generación de certificados y reportes, se integran las librerías **iText 5.5.13** y **ZXing 3.5.3**, permitiendo la creación de documentos PDF y códigos QR respectivamente. El sistema puede implementarse en entornos locales (XAMPP o similares) y está preparado para su futura adaptación a entornos cloud mediante herramientas de **Terraform e Infracost**, tal como se detalla en los scripts de infraestructura.\
      En términos funcionales, los requerimientos mínimos incluyen:

- Un servidor con soporte para Java EE y conexión estable a base de datos.
- Navegadores actualizados (Google Chrome, Mozilla Firefox o equivalentes).
- Acceso controlado por roles y sesiones seguras para cada usuario autenticado.
  1. ## **Restricciones**
     El desarrollo e implementación del sistema **Voluntariado-UPT** presenta ciertas limitaciones técnicas y operativas que deben ser consideradas durante su ciclo de vida. En primer lugar, la infraestructura actual depende de un entorno **local de desarrollo (NetBeans + Tomcat + MySQL)**, lo cual restringe su despliegue inmediato en entornos de producción o nube sin ajustes de configuración adicionales. Asimismo, la ausencia de un mecanismo de autenticación avanzada (como OAuth2 o integración institucional) y la gestión manual de contraseñas reducen temporalmente el nivel de seguridad frente a sistemas de mayor madurez tecnológica.

     Adicionalmente, el uso de librerías con licencias restrictivas —como **iText (AGPL)**— limita su redistribución en entornos externos, lo que requiere evaluar alternativas open source o comerciales para versiones futuras. Finalmente, la infraestructura definida en Terraform contempla recursos en **Google Cloud Firestore**, los cuales aún no están integrados con la aplicación, generando una brecha entre la planificación y la implementación real del sistema.
|**Tipo de Restricción**|**Descripción**|**Impacto**|**Nivel**|
| - | - | - | - |
|**Tecnológica**|Dependencia de entorno local (Tomcat/MySQL)|Medio|Moderado|
|**Seguridad**|Ausencia de cifrado y autenticación federada|Alto|Crítico|
|**Licencia de software**|Uso de librerías AGPL (iText)|Medio|Moderado|
|**Infraestructura**|Desalineación con IaC (Firestore no implementado)|Medio|Moderado|
|**Operativa**|Falta de pruebas automatizadas y CI/CD completo|Alto|Crítico|

1. ## **Supuestos**
   Para la ejecución del proyecto se han establecido una serie de supuestos que sustentan el desarrollo y despliegue inicial del sistema. Se asume que la Universidad Privada de Tacna dispone de los recursos tecnológicos necesarios para mantener un servidor local o institucional con soporte para Java EE y MySQL, así como personal técnico con conocimientos básicos en administración de entornos Tomcat. Se considera, además, que los usuarios finales (administradores, coordinadores y estudiantes) cuentan con conectividad estable a Internet y dispositivos con navegadores actualizados.

   Otro supuesto relevante es que las **credenciales de acceso** serán gestionadas internamente por el administrador del sistema, garantizando la correcta asignación de roles y permisos. Finalmente, se presupone la **colaboración interdepartamental** entre la EPIS y la oficina de RSU para la validación de datos, el registro de campañas y la evaluación de resultados, asegurando la sostenibilidad operativa de la plataforma a largo plazo.
1. ## **Resultados esperados**
   Con la implementación del sistema **Voluntariado-UPT**, se espera lograr una **gestión integral, confiable y transparente** de todas las actividades de voluntariado universitario. Entre los principales resultados destacan la reducción del tiempo de registro y procesamiento de información, la eliminación de duplicidades y errores en las listas de asistencia, y la generación automática de certificados con validación por código.

   Asimismo, se prevé un incremento en la participación estudiantil al disponer de una interfaz web accesible y moderna, así como una mejora en la capacidad de seguimiento y evaluación de las campañas por parte de los coordinadores y del área de RSU. En términos institucionales, el sistema aportará a la **digitalización de los procesos académicos y sociales**, alineándose con los objetivos estratégicos de innovación tecnológica y responsabilidad universitaria promovidos por la Universidad Privada de Tacna.
1. ## **Metodología de implementación**
   La implementación del sistema **Voluntariado-UPT** se desarrolló siguiendo un enfoque **ágil e incremental**, basado en los principios de la metodología **Scrum**, adaptada al contexto académico. Este enfoque permitió realizar avances iterativos mediante entregas funcionales parciales, facilitando la retroalimentación continua entre los responsables del proyecto y los futuros usuarios.\
   ` `El proceso se dividió en tres etapas principales: la **fase de concepción**, en la cual se definieron los requerimientos funcionales y el diseño de la base de datos; la **fase de desarrollo**, donde se construyeron los módulos del sistema aplicando el patrón de diseño **Modelo-Vista-Controlador (MVC)**; y la **fase de transición**, enfocada en las pruebas, la documentación y la preparación para el despliegue institucional.

   Durante todo el proceso se aplicaron buenas prácticas de ingeniería de software, como la modularización del código, la reutilización de componentes, el control de versiones con GitHub y la documentación técnica estructurada bajo estándares IEEE e ISO/IEC. Este enfoque permitió garantizar la trazabilidad de los avances y la coherencia entre los entregables técnicos y académicos del proyecto.

1. ## **Actores claves**
   Los actores principales involucrados en el desarrollo e implementación del sistema **Voluntariado-UPT** son:

- **Estudiantes Voluntarios:** usuarios finales que se inscriben en las campañas, registran su asistencia y obtienen certificados digitales.
- **Coordinadores RSU:** encargados de crear y gestionar campañas, validar asistencias y generar reportes institucionales.
- **Administrador del Sistema:** responsable de la gestión de usuarios, control de roles y mantenimiento general de la plataforma.
- **Equipo de Desarrollo:** conformado por estudiantes de Ingeniería de Sistemas, quienes realizaron el análisis, diseño, codificación, pruebas y documentación del sistema.
- **Asesor Académico / Supervisor:** docente encargado de la supervisión técnica, evaluación de avances y validación metodológica del proyecto.
  1. ## **Papel y responsabilidades del personal**
     El personal involucrado en el proyecto desempeñó funciones específicas según su rol dentro del ciclo de desarrollo. A continuación, se presenta la matriz RACI (Responsible, Accountable, Consulted, Informed) que define las responsabilidades de cada actor:

|**Actividad / Fase**|**Descripción**|**Estudiantes Desarrolladores**|**Coordinador RSU**|**Administrador del Sistema**|**Asesor Académico**|
| - | - | - | - | - | - |
|**Análisis de requerimientos**|Identificación de necesidades funcionales y no funcionales|**R**|**C**|**I**|**A**|
|**Diseño del sistema**|Modelado de base de datos, diagramas UML y arquitectura MVC|**R**|**C**|**I**|**A**|
|**Desarrollo e integración**|Codificación de módulos y conexión a base de datos|**R**|**I**|**I**|**C**|
|**Pruebas y validación**|Verificación funcional de cada módulo|**R**|**C**|**I**|**A**|
|**Despliegue del sistema**|Instalación en servidor local o institucional|**R**|**I**|**A**|**C**|
|**Capacitación de usuarios**|Inducción al uso de la plataforma|**C**|**A**|**R**|**I**|
|**Mantenimiento y mejora continua**|Actualización y soporte técnico|**R**|**C**|**A**|**I**|

**Leyenda:**

R = Responsable (ejecuta la tarea)

A = Aprobador (valida y supervisa)

C = Consultado (brinda orientación o información)

I = Informado (recibe comunicación del avance)
1. ## **Plan de monitoreo y evaluación**
   El plan de monitoreo y evaluación del sistema **Voluntariado-UPT** tiene como propósito garantizar el cumplimiento de los objetivos propuestos, mediante un seguimiento sistemático de las actividades técnicas y académicas realizadas durante el desarrollo del proyecto. Este proceso se implementó a través de **revisiones periódicas de avance**, validaciones funcionales de cada módulo y retroalimentación continua por parte del asesor académico y los usuarios clave (coordinadores RSU y administradores).

   Para asegurar la calidad del producto final, se definieron indicadores de desempeño en torno a tres ejes: **eficiencia funcional**, **usabilidad del sistema** y **cumplimiento de plazos**. La evaluación incluyó pruebas de funcionalidad, revisiones de código fuente, análisis de rendimiento y verificación documental de cada fase. A nivel académico, los resultados se compararon con los entregables establecidos en el plan de trabajo y las rúbricas de evaluación del curso, asegurando la coherencia entre los objetivos pedagógicos y los resultados técnicos.

|**Dimensión Evaluada**|**Indicador**|**Método de Evaluación**|**Frecuencia**|**Responsable**|
| :- | :- | :- | :- | :- |
|**Funcionalidad del sistema**|Módulos implementados según requerimientos|Pruebas unitarias y revisión de código|Semanal|Equipo de desarrollo|
|**Usabilidad**|Facilidad de uso y navegabilidad|Prueba con usuarios finales|Al cierre de cada sprint|Coordinador RSU|
|**Cumplimiento de cronograma**|Actividades completadas dentro del plazo|Comparación plan vs. avance real|Quincenal|Asesor académico|
|**Calidad del código y documentación**|Estandarización y comentarios técnicos|Revisión de pares y docente|Mensual|Desarrolladores y asesor|
|**Satisfacción del usuario**|Nivel de aceptación del sistema|Encuesta posterior a la implementación|Final|RSU y usuarios finales|

1. ## **Cronograma del proyecto**
   El desarrollo del proyecto **Voluntariado-UPT** se estructuró en cuatro fases principales que abarcan desde la planificación hasta la implementación. Cada fase contempló entregables específicos y fue monitoreada mediante reuniones de control. El cronograma se planificó para ejecutarse en un periodo académico de **16 semanas**, equivalente a un semestre universitario.

|**Fase**|**Actividades Principales**|**Duración (Semanas)**|**Periodo**|**Responsable**|
| :- | :- | :- | :- | :- |
|**Fase I – Concepción**|Análisis del problema, levantamiento de requerimientos y diseño del modelo de datos|1 – 4|Agosto - Septiembre|Equipo de desarrollo y asesor|
|**Fase II – Elaboración**|Diseño de interfaz, arquitectura MVC y estructura de base de datos|5 – 7|Septiembre - Octubre|Desarrolladores|
|**Fase III – Construcción**|Implementación de módulos: login, gestión de campañas, QR y reportes|8 – 12|Octubre - Noviembre|Desarrolladores|
|**Fase IV – Transición**|Pruebas integrales, documentación técnica, ajustes y despliegue|13 – 16|Noviembre - Diciembre|Equipo de desarrollo y RSU|

1. ## **Hitos de entregables**
   Los hitos representan los momentos clave del proyecto en los que se concretan resultados medibles y verificables. Cada hito está asociado a una fase del ciclo de vida del sistema y cuenta con entregables técnicos y documentales que evidencian el cumplimiento de los objetivos planificados.

|**Hito**|**Entregable Principal**|**Descripción**|**Evidencia Asociada**|
| - | - | - | - |
|**H1**|Documento de Análisis y Diseño|Incluye diagramas C4, modelo ER y estructura MVC|Informe Técnico del Sistema|
|**H2**|Prototipo Funcional|Implementación de módulos de login e inscripción|Capturas y pruebas en entorno local|
|**H3**|Sistema Integrado|Versión funcional completa con QR, certificados y reportes|Archivo WAR desplegado en Tomcat|
|**H4**|Documentación Técnica Final|Informe SRS, SAD y manual de usuario|Archivos FD02–FD05|
|**H5**|Informe de Proyecto Final|Análisis de resultados, factibilidad y evaluación de impacto|Documento institucional consolidado|

1. # **Presupuesto**
   1. ## **Planteamiento de aplicación del presupuesto**
      El presupuesto asignado para el desarrollo del sistema **Voluntariado-UPT** se fundamenta en el aprovechamiento de **recursos humanos universitarios** y herramientas de **software libre**, con el propósito de minimizar costos y garantizar la sostenibilidad del proyecto. La aplicación de los recursos financieros se orienta principalmente a cubrir los requerimientos técnicos básicos, el mantenimiento de la infraestructura informática, y la adquisición de equipos o servicios complementarios que faciliten el despliegue y la operación del sistema.

      El proyecto fue desarrollado en un entorno académico, por lo cual las labores de análisis, diseño, codificación, pruebas y documentación fueron realizadas por **estudiantes de Ingeniería de Sistemas** bajo la supervisión de un docente asesor. Por tanto, no se contemplan costos laborales directos. No obstante, se estiman gastos asociados al consumo de energía eléctrica, mantenimiento de equipos, conexión a Internet y eventual migración a un servidor en la nube institucional. La gestión económica se plantea bajo un esquema de **presupuesto participativo y académico**, donde los recursos físicos y tecnológicos provienen de la infraestructura de la Universidad Privada de Tacna.

   1. ## **Presupuesto**
El presupuesto fue elaborado considerando recursos humanos, materiales y tecnológicos requeridos para el desarrollo del sistema. Se privilegió el uso de **software libre**, lo que redujo significativamente los costos operativos y de licenciamiento.
1. ### <a name="_heading=h.p566q7rvehd8"></a>**Detalle de Presupuesto**
   **Tabla 2.** Presupuesto estimado del Proyecto *Voluntariado-UPT* (elaboración propia, 2025).

![](./media/Aspose.Words.8cfa7fac-4171-4f36-83cd-dd91f4a9685b.004.png)

![ref1]

1. ## <a name="_heading=h.p98mua5tv635"></a>**Análisis de Factibilidad**
   El análisis de factibilidad tiene como propósito determinar la **viabilidad integral** del proyecto *Voluntariado-UPT* antes de su implementación definitiva, evaluando los recursos técnicos, financieros y humanos disponibles. Este estudio permite validar que el sistema puede desarrollarse, mantenerse y escalar dentro de las capacidades actuales de la Universidad Privada de Tacna, garantizando su sostenibilidad a largo plazo.

   El análisis de factibilidad permite evaluar la viabilidad del sistema desde múltiples dimensiones: técnica, económica, operativa, social, legal y ambiental (Pressman & Maxim, 2020).

   1. ### <a name="_heading=h.22ph22f54uky"></a>**Factibilidad Técnica**
La universidad cuenta con conectividad estable y servidores que pueden ser escalados en la nube mediante Terraform. El uso de esta herramienta permite automatizar el despliegue de máquinas virtuales, balanceadores de carga y almacenamiento en la nube. Los estudiantes y docentes cuentan con competencias básicas en desarrollo de software y administración de sistemas, lo que permite un soporte técnico adecuado.




hardware y software que posee la Universidad:

|Equipos Tecnológicos actualizados |disponibles 24/7|
| :- | :- |
|Programas instalados|apoyan al desarrollo del software|
|Internet|alta velocidad|

La factibilidad técnica evalúa los recursos, herramientas y tecnologías necesarias para implementar un sistema que permita optimizar el Voluntariado UPT.

Para ello, se presenta la siguiente propuesta para la viabilidad técnica:

1. **Infraestructura Tecnológica**\

   1. Servidores en la nube de Elastika(Linux) para alojar la Base de datos(MariaDB).
   1. Servidor Azure para desplegar el sistema.

1. **Recursos Humanos**\

   1. Equipo de desarrollo de software con experiencia en aplicaciones escritorio y web.
   1. Personal de soporte técnico encargado de mantenimiento preventivo y correctivo del sistema.
   1. Capacitación a los gestores para el uso de la aplicación Web
1. **Herramientas y Software**\


**GitHub Education Pack**

Como estudiante universitario, puedes acceder gratuitamente a beneficios como:

1. GitHub Copilot Pro
1. Dominios gratuitos (a través de partners)
1. Créditos en servicios cloud (Azure, AWS, Google Cloud)
1. Herramientas de desarrollo (JetBrains, DataCamp, etc.)
1. Acceso solo con verificar tu cuenta con tu correo institucional (@[upt.pe](http://upt.edu.pe) y @[virtual.upt.pe](http://virtual.upt.pe) ).
1. Dashboard administrativo web para registro y control de voluntariado UPT.
1. **Viabilidad de Implementación**\

   1. La Universidad ya cuenta con equipos tecnológicos(Computadoras) de última generación y la capacidad para implementar programas importantes que garantizan el desarrollo del sistema sin necesidad de grandes inversiones iniciales en hardware y software.
   1. La infraestructura requerida puede escalarse progresivamente según la demanda (ejemplo: aumentar la capacidad del servidor cuando crezcan la cantidad de voluntarios).
   1. La solución propuesta es compatible con la operación actual, permitiendo una transición gradual sin interrumpir el servicio.

      1. ### <a name="_heading=h.7vkj6uci8jkn"></a>**Factibilidad Económica**
El costo principal del proyecto se centra en:

- ***Servidores en la nube** (Elastika).*

  Se estima que los costos iniciales de infraestructura son menores en comparación con una implementación manual, ya que Terraform permite reutilizar plantillas y reducir tiempos de configuración.

  Definir los siguientes costos:

  1. Costos Generales 

|<p></p><p>***Concepto***</p>|<p></p><p>***Cantidad***</p>|***Costo Unitario (S/.)***|***Subtotal (S/.) x 3 meses***|
| :-: | :- | :- | :- |
|*Laptop/PC (uso del laboratorio)*|*3*|*0.00*|*0.00*|
|*Servidor Azure*|*1*|*0.00*|*0.00*|
|*Servidor Elástika*|*1*|*20.00*|*60.00*|
|***Total Costos Generales***|***60.00***|||

1. Costos operativos durante el desarrollo 

|***Concepto***|***Costo Unitario (S/.) por mes***|***costo por 3 estudiantes(S/.) por mes***|***Subtotal (S/.)***|
| :- | :- | :- | :- |
|*Energía eléctrica*|*0.00*|*0.00*|*0.00*|
|*Agua y servicios*|*0.00*|*0.00*|*0.00*|
|*Internet institucional*|*0.00* |*0.00*|*0.00*|
|***Total Operativo***|***0.00***|||

1. Costos del ambiente

|***Concepto***|***Cantidad***|***Costo Unitario (S/.)***|***Subtotal (S/.)***|
| :-: | :- | :- | :- |
|*Servidor en la nube (Azure)*|*1*|*0.00*|*0.00*|
|*Almacenamiento adicional (backup)*|*1*|*0.00*|*0.00*|
|*Certificado SSL (Let's Encrypt)*|*1*|*0.00*|*0.00*|
|***Total Ambiente***|***0.00***|||

1. Costos de personal

|***Cargo***|***Cantidad***|***Salario Mensual (S/.)***|***Subtotal (S/.) x 3 meses***|
| :-: | :- | :- | :- |
|*Líder de Proyecto*|*1*|*0.00*|*0.00*|
|*Desarrollador Backend*|*1*|*0.00*|*0.00*|
|*Desarrollador Frontend*|*1*|*0.00*|*0.00*|
|***Total Personal***|***0.00***|||






1. Costos totales del desarrollo del sistema 

|***Categoría***|***costo x mes***|***Costo Total (S/.) x 3 meses***|
| :-: | :-: | :- |
|*Costos Generales*|*20.00*|*60.00*|
|*Costos Operativos*|*0.00*|*0.00*|
|*Costos del Ambiente*|*0.00*|*0.00*|
|*Costos de Personal*|*0.00*|*0.00*|
|***Costo Total Final***|***20.00***|***60.00***|

*Nota: Los costos se mantienen bajos gracias al uso del tier gratuito de Azure (F1) para el despliegue web y la optimización de recursos en Elastika para la base de datos MariaDB.*

1. ### <a name="_heading=h.r0dkoe9e8frj"></a>**Factibilidad Operativa**
   La **factibilidad operativa** se sustenta en la facilidad de uso del sistema y la aceptación institucional de sus beneficios.\
   Durante las pruebas piloto, los usuarios reportaron una curva de aprendizaje mínima gracias a la interfaz intuitiva desarrollada con **Bootstrap 5.3** y la organización clara de menús.

   Asimismo, la Oficina de RSU manifestó su compromiso de incorporar el sistema en los procesos oficiales de registro y certificación, lo que garantiza su **adopción efectiva** (González & Figueroa, 2023).\
   La capacitación del personal fue realizada mediante sesiones breves de inducción y manuales digitales elaborados durante la fase de implementación.

   El sistema beneficiará a estudiantes, docentes y personal administrativo, quienes podrán gestionar campañas de manera más ágil. La EPIS cuenta con el personal y las capacidades necesarias para mantener la plataforma operativa a largo plazo. Además, la infraestructura tecnológica existente en la universidad como las computadoras actualizadas, el soporte TI y la conectividad estable permite el desarrollo confiable de la aplicación sin requerir inversiones adicionales.

   El equipo docente de la EPIS supervisará el proyecto como parte de las actividades de extensión universitaria y formación práctica, asegurando seguimiento académico y técnico.

   La simplicidad del diseño de la interfaz y la documentación técnica generada durante el desarrollo facilitarán la capacitación de nuevos mantenedores (estudiantes de últimos ciclos), garantizando la continuidad del sistema más allá de la generación actual de desarrolladores.

   Finalmente, este proyecto se alinea con las políticas institucionales de digitalización y responsabilidad social de la UPT, el sistema tiene un alto potencial de adopción formal por parte de las unidades operativas que gestionan voluntariado, lo que refuerza su utilidad real y su integración en los flujos de trabajo existentes.
1. #### <a name="_heading=h.o1vd5w2x9pm3"></a>**Factibilidad social**
   Desde el punto de vista **social**, el sistema fortalece la cultura de participación estudiantil y promueve la transparencia en la gestión de proyectos de responsabilidad social.\
   Según **Vallaeys (2018)**, la tecnología debe ser un medio para potenciar el compromiso ético de las universidades con la comunidad; en ese sentido, **Voluntariado-UPT** cumple un rol estratégico al visibilizar la labor solidaria de los estudiantes y docentes.

   Además, el sistema genera datos estadísticos que permiten medir el impacto social de las campañas, facilitando la elaboración de informes institucionales y contribuyendo al cumplimiento de los **Objetivos de Desarrollo Sostenible (ODS 4, 9 y 12)** relacionados con educación y alianzas para el desarrollo (ONU, 2022).
1. #### <a name="_heading=h.hgi9oepj621"></a>**Factibilidad legal**
Como menciona la Ley de Protección de Datos Personales del Perú (Ley N.º 29733) que protege el derecho de las personas a controlar su información personal, estableciendo que deben tener conocimiento de los datos que se recopilan sobre ellas, así como el derecho a corregirlos, eliminarlos y oponerse a su uso. También obliga a las entidades públicas y privadas a adoptar medidas técnicas, administrativas y físicas para proteger estos datos, y define las infracciones y sanciones en caso de incumplimiento. El sistema cumplirá con ello, asegurando la confidencialidad de la información de los estudiantes.

- **Ley N.º 30096 – Ley de Delitos Informáticos**, que regula las responsabilidades sobre uso indebido de información digital.
- **ISO/IEC 27001:2022**, norma internacional sobre sistemas de gestión de la seguridad de la información.
|*Alineamiento con las políticas internas de la Universidad Privada de Tacna (UPT)*|El sistema se desarrollará en concordancia con el Reglamento de Seguridad de la Información y las políticas de tratamiento de datos de la Universidad Privada de Tacna (UPT), garantizando que su uso esté autorizado y supervisado por la EPIS. |
| :- | - |
|*Tratamiento limitado y con finalidad específica*|Los datos personales recolectados (nombre, código universitario, correo institucional, etc.) Se utilizarán exclusivamente para fines de gestión de campañas de voluntariado, sin fines comerciales ni transferencia a terceros, en estricto cumplimiento del principio de finalidad establecido en el Artículo 4 de la Ley N.º 29733.|
|<p><h4>*Derechos ARCO (Acceso, Rectificación, Cancelación y Oposición)*</h4></p><p></p>|La plataforma incluirá funcionalidades que permitan a los titulares de los datos ejercer sus derechos ARCO, tales como consultar sus datos registrados, solicitar correcciones o solicitar la eliminación de su información al finalizar su participación en campañas.|
|<h4>*No Uso de Datos Sensibles(raza étnica, religión, partido político)*</h4>|El sistema no recolectará datos sensibles (como origen étnico, salud, creencias religiosas o filiación política), salvo que sea estrictamente necesario y con autorización expresa y documentada, evitando así riesgos legales innecesarios.|
|<h4><a name="_heading=h.pu0njpf5kdx"></a>*Marco de Responsabilidad*</h4>|Los Estudiantes encargados del proyecto en coordinación de la EPIS, en coordinación con la Oficina de Responsabilidad Social o la unidad organizadora del voluntariado, actuará como encargada del tratamiento de los datos, bajo la supervisión de la UPT como responsable del tratamiento, en los términos definidos por la normativa peruana.|

1. #### <a name="_heading=h.dmm8jwk87moc"></a>**Factibilidad ambiental**
   La implementación de **Voluntariado-UPT** tiene un **impacto ambiental positivo**, ya que reduce significativamente el consumo de papel y materiales impresos utilizados en formularios, reportes y certificados.\
   Conforme al enfoque de **ecoeficiencia institucional** promovido por el **MINAM (2023)**, la digitalización de procesos contribuye a una gestión ambientalmente responsable, minimizando la huella ecológica de las actividades administrativas.

   Además, el sistema promueve prácticas sostenibles entre los estudiantes al incentivar el uso de medios digitales y la reducción del desperdicio, en coherencia con el **ODS 12 (Producción y Consumo Responsables)** (ONU, 2022).

1. ### <a name="_heading=h.fh6k5g57ot7f"></a>**Resumen Comparativo de Viabilidad**

|**Dimensión**|**Criterios Evaluados**|**Nivel de Viabilidad**|**Evidencia Principal**|
| - | - | - | - |
|**Técnica**|Compatibilidad, mantenibilidad, disponibilidad de recursos y escalabilidad|**Alta**|Arquitectura Java EE, MySQL y entorno institucional|
|**Económica**|Costos, licencias, retorno de inversión y sostenibilidad|**Alta**|Software libre, bajo costo operativo y aprovechamiento institucional|
|**Operativa**|Aceptación de usuarios, capacitación, integración y gestión de roles|**Alta**|Interfaz web amigable y participación activa del personal universitario|

1. ## <a name="_heading=h.gtzb2pa7pb12"></a>**Evaluación Financiera**
   La evaluación financiera del proyecto **Voluntariado-UPT** tiene como objetivo determinar la **rentabilidad y sostenibilidad económica** del sistema a corto y mediano plazo. Dado que el proyecto fue desarrollado en un entorno académico y emplea **software libre**, los costos directos son mínimos y se concentran principalmente en la infraestructura tecnológica y el mantenimiento operativo. Sin embargo, el sistema genera beneficios económicos indirectos y medibles, asociados a la **reducción de tiempo administrativo**, la **disminución de costos de impresión y almacenamiento físico**, y la **optimización del registro de actividades de voluntariado**, lo que representa un ahorro institucional significativo.

*Beneficios* del Proyecto

***Tangibles:***

- *Reducción del uso de papel en un 70% (ahorro anual estimado de S/. 1,500).*\

- *Optimización en la gestión de campañas (ahorro de 20 horas/mes de trabajo administrativo ≈ S/. 600 mensuales).*\


***Intangibles:***\


- *Transparencia y confiabilidad en los certificados.*\

- *Mayor participación estudiantil en el voluntariado.*\

- *Posicionamiento institucional en el uso de tecnologías innovadoras.*

Criterios de Inversión

![](./media/Aspose.Words.8cfa7fac-4171-4f36-83cd-dd91f4a9685b.006.png)

![](./media/Aspose.Words.8cfa7fac-4171-4f36-83cd-dd91f4a9685b.007.png)

![](./media/Aspose.Words.8cfa7fac-4171-4f36-83cd-dd91f4a9685b.008.png)

![ref1]



*Relación Beneficio/Costo (B/C)*

*Beneficios proyectados ≈ S/. 3,835.82 anuales*

*Costos iniciales ≈ S/. 50.00*

*→ **B/C = 63.93 → Proyecto viable***

`                    `*Valor Actual Neto (VAN)*

*Con un horizonte de 3 años y tasa de descuento del 15%, el VAN proyectado es positivo  S/. 3,775.82*

*Tasa Interna de Retorno (TIR)*

El valor es muy superior al 15% de tasa de descuento siendo el valor en este caso del 2800%, lo que confirma que el rendimiento del proyecto es atractivo.

1. ### <a name="_heading=h.q10cvovw8h5g"></a>**Punto de Equilibrio y Retorno de Inversión (ROI)**
   El **punto de equilibrio** se alcanza cuando los beneficios acumulados igualan el costo total del proyecto. Dado el bajo nivel de inversión y el ahorro operativo estimado, se proyecta que el sistema **recupera su inversión en el primer año de funcionamiento**, considerando únicamente los beneficios directos.
|**Indicador**|**Fórmula**|**Resultado**|
| :- | :- | :- |
|**Inversión Inicial (I)**|Costo total del proyecto|S/ 60.00|
|**Beneficio Anual (B)**|Suma de beneficios directos estimados|S/ 3,775.82|
|**ROI (Retorno sobre la Inversión)**|((B – I) / I) × 100|**–3.4 % (equilibrio al primer año)**|
|**Periodo de Recuperación**|I / B|**≈ 1 año académico**|

1. ### <a name="_heading=h.qwp80mz0a3sl"></a>**Beneficios Intangibles y Valor Institucional**
   Además del ahorro económico, el proyecto genera **beneficios cualitativos** que fortalecen la gestión universitaria y el posicionamiento institucional:

- **Transparencia y trazabilidad** en la gestión del voluntariado.
- **Fortalecimiento de la cultura digital** y competencias tecnológicas de los estudiantes.
- **Reducción del impacto ambiental** al eliminar el uso de papel.
- **Optimización del tiempo docente y administrativo**, al automatizar reportes y certificados.
- **Alineación con los objetivos estratégicos de la RSU y la transformación digital de la UPT**.

Estos factores consolidan al sistema **Voluntariado-UPT** como una inversión estratégica sostenible, cuyo retorno no solo es financiero, sino también **académico, social y ambiental**, contribuyendo directamente a la eficiencia institucional y al cumplimiento de los compromisos de responsabilidad social.
## <a name="_heading=h.rc1ngre8vvwf"></a>**
## <a name="_heading=h.e61m7btyf8ai"></a>**Conclusiones**
El desarrollo del sistema web Voluntariado-UPT representa una iniciativa tecnológica alineada con los objetivos institucionales de innovación y transformación digital de la Universidad Privada de Tacna. La propuesta aborda de manera efectiva la problemática de la gestión dispersa y manual de las campañas de voluntariado, proporcionando una solución integral que optimiza los procesos de registro, control, seguimiento y certificación de la participación estudiantil.

La implementación del sistema demuestra ser técnica, económica y operativamente viable, sustentada en el uso de software libre, recursos institucionales existentes y una arquitectura modular basada en el modelo MVC (Modelo–Vista–Controlador). La automatización de los procesos ha permitido mejorar la eficiencia administrativa, reducir los tiempos de respuesta, fortalecer la trazabilidad de los datos y promover la transparencia en las actividades de Responsabilidad Social Universitaria (RSU).

Asimismo, la participación de estudiantes en su desarrollo refuerza el compromiso académico con la práctica profesional y la innovación social, integrando la formación técnica con la responsabilidad comunitaria. En consecuencia, el sistema Voluntariado-UPT no solo constituye una herramienta de apoyo a la gestión universitaria, sino también un modelo de desarrollo sostenible y replicable en otras instituciones educativas que busquen fortalecer su compromiso con la sociedad.
## <a name="_heading=h.1f8rwc7vgeka"></a>**
## <a name="_heading=h.pfu89ql6v0i1"></a>**Referencias Bibliográficas**
- Booch, G., Rumbaugh, J., & Jacobson, I. (2005). *El lenguaje unificado de modelado UML: Manual de referencia*. Pearson Educación.
- IEEE Computer Society. (2014). *IEEE Std 830-1998 – Recommended Practice for Software Requirements Specifications*. IEEE Standards Association.
- Pressman, R. S., & Maxim, B. R. (2020). *Ingeniería del software: Un enfoque práctico* (9.ª ed.). McGraw-Hill Education.
- Sommerville, I. (2011). *Ingeniería del software* (9.ª ed.). Pearson Educación.
- Visauta, B. (2017). *Metodología de la investigación científica y tecnológica*. UOC.
- Universidad Privada de Tacna. (2024). *Lineamientos de Responsabilidad Social Universitaria y Proyección Social de la UPT*. Oficina de RSU – UPT.
- Ministerio de Educación del Perú. (2023). *Guía de Gestión de Proyectos de Innovación Educativa*. Dirección General de Educación Superior Universitaria (DIGESU).
- Open Web Application Security Project (OWASP). (2023). *Top 10 Web Application Security Risks*.[ ](https://owasp.org/www-project-top-ten/)<https://owasp.org/www-project-top-ten/>
- Oracle. (2023). *Jakarta EE Platform Specification, Version 9.1*.[ ](https://jakarta.ee/specifications/)<https://jakarta.ee/specifications/>
- Apache Software Foundation. (2023). *Apache Tomcat Documentation*.[ ](https://tomcat.apache.org/)<https://tomcat.apache.org/>


#
# <a name="_heading=h.3xxb6y876bag"></a><a name="_heading=h.uby5pifecges"></a>
# <a name="_heading=h.1k6qc37ayves"></a>RESUMEN EJECUTIVO

|**Nombre del Proyecto propuesto**: ||
| - | :- |

|***Sistema Web “Voluntariado-UPT” – Tacna, 2025***|
| :-: |

|||
| - | :- |
|<p>**Propósito del Proyecto y Resultados esperados:** </p><p></p><p>*El propósito del proyecto es **diseñar e implementar un sistema web integral que modernice y optimice la gestión de campañas de voluntariado universitario**, fortaleciendo los procesos de Responsabilidad Social Universitaria (RSU) en la Universidad Privada de Tacna.*</p><p></p><p>Los resultados esperados son:</p><p>- *Un sistema funcional y accesible para la inscripción, control de asistencia mediante códigos QR y emisión de certificados digitales.*</p><p>- *Una base de datos centralizada que garantice la trazabilidad y fiabilidad de la información.*</p><p>- *Reportes automatizados que faciliten la toma de decisiones y la evaluación del impacto social de las campañas.*</p><p></p>||
|<p></p><p>**Población Objetivo:** </p><p>***Estudiantes voluntarios, coordinadores RSU y administradores** de la Universidad Privada de Tacna, beneficiando indirectamente a las comunidades atendidas por las campañas de voluntariado universitario.*</p><p></p>||
|<p>**Monto de Inversión (En Soles):**</p><p></p><p>***{  S/. 5,176.50}***</p><p></p>|<p>**Duración del Proyecto (En Meses):**</p><p></p><p>`     `***4 meses (16 semanas académicas)***</p><p></p>|



[ref1]: ./media/Aspose.Words.8cfa7fac-4171-4f36-83cd-dd91f4a9685b.005.png
