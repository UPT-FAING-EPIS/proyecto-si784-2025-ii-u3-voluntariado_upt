# Instrucciones para habilitar descarga de Certificados en PDF

## Paso 1: Descargar la librería iText

Descarga los siguientes archivos JAR y colócalos en la carpeta `web/WEB-INF/lib/`:

### Opción A: Descargar manualmente
1. **iText 5.5.13.3** (Versión gratuita bajo licencia AGPL)
   - Descarga desde: https://github.com/itext/itextpdf/releases/tag/5.5.13.3
   - Archivo: `itextpdf-5.5.13.3.jar`

### Opción B: Usar Maven (si tu proyecto usa Maven)
Agrega al `pom.xml`:
```xml
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itextpdf</artifactId>
    <version>5.5.13.3</version>
</dependency>
```

### Opción C: Descargar directamente
Ejecuta este comando en PowerShell desde la raíz del proyecto:

```powershell
# Crear directorio si no existe
New-Item -ItemType Directory -Force -Path "web\WEB-INF\lib"

# Descargar iText
Invoke-WebRequest -Uri "https://repo1.maven.org/maven2/com/itextpdf/itextpdf/5.5.13.3/itextpdf-5.5.13.3.jar" -OutFile "web\WEB-INF\lib\itextpdf-5.5.13.3.jar"
```

## Paso 2: Limpiar y reconstruir el proyecto

1. En NetBeans, haz clic derecho en el proyecto
2. Selecciona "Clean and Build"
3. Espera a que termine la compilación

## Paso 3: Registrar el Servlet en web.xml

Agrega esta configuración en `web/WEB-INF/web.xml`:

```xml
<!-- Servlet de descarga de certificados -->
<servlet>
    <servlet-name>DescargarCertificadoServlet</servlet-name>
    <servlet-class>servlet.DescargarCertificadoServlet</servlet-class>
</servlet>
<servlet-mapping>
    <servlet-name>DescargarCertificadoServlet</servlet-name>
    <url-pattern>/DescargarCertificadoServlet</url-pattern>
</servlet-mapping>
```

## Paso 4: Reiniciar el servidor

1. Detén el servidor Tomcat
2. Inicia el servidor nuevamente
3. Prueba descargando un certificado

## Verificación de imágenes

Asegúrate de que las imágenes estén en la ubicación correcta:
- `web/img/upt.jpeg` - Logo de la universidad
- `web/img/coordinador.jpg` - Firma del coordinador
- `web/img/director.jpeg` - Firma del director

## Características del PDF generado

✅ Formato horizontal (A4 landscape)
✅ Logo de la UPT en el header
✅ Diseño profesional con colores institucionales
✅ Firmas digitales del coordinador y director
✅ Código de verificación incluido
✅ Información completa del estudiante y campaña
✅ Formato listo para imprimir

## Solución de problemas

### Error: "NoClassDefFoundError: com/itextpdf/text/Document"
- Asegúrate de que el archivo JAR esté en `web/WEB-INF/lib/`
- Reconstruye el proyecto (Clean and Build)

### Error: "FileNotFoundException" para imágenes
- Verifica que las imágenes existan en `web/img/`
- Verifica los nombres de archivo (upt.jpeg, coordinador.jpg, director.jpeg)

### El PDF se descarga vacío
- Revisa los logs de Tomcat para ver errores específicos
- Verifica que el certificado exista en la base de datos

## Alternativa sin librerías externas

Si no puedes instalar iText, puedo crear una versión alternativa que:
- Genere el certificado como HTML
- Use CSS para imprimir
- Permita guardar como PDF desde el navegador (Ctrl+P > Guardar como PDF)

¿Quieres que prepare la versión alternativa?
