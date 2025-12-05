# Configuración de Secrets para GitHub Actions

## Secrets Requeridos

Para que los workflows de análisis estático funcionen correctamente, necesitas configurar los siguientes secrets en tu repositorio de GitHub:

### 1. SonarQube/SonarCloud

#### Opción A: SonarCloud (Recomendado para proyectos públicos)

1. Ve a [SonarCloud](https://sonarcloud.io/)
2. Inicia sesión con tu cuenta de GitHub
3. Crea una nueva organización o usa una existente: `upt-epis`
4. Crea un nuevo proyecto con la key: `voluntariado-upt`
5. Ve a **My Account** > **Security** > **Generate Token**
6. Copia el token generado

**Secrets a configurar:**
```
SONAR_TOKEN: <tu_token_de_sonarcloud>
SONAR_HOST_URL: https://sonarcloud.io
```

#### Opción B: SonarQube Server (Auto-hospedado)

Si tienes tu propio servidor SonarQube:

**Secrets a configurar:**
```
SONAR_TOKEN: <tu_token_de_sonarqube>
SONAR_HOST_URL: <url_de_tu_servidor_sonarqube>  # Ej: https://sonarqube.ejemplo.com
```

### 2. Snyk

1. Ve a [Snyk](https://snyk.io/)
2. Crea una cuenta gratuita
3. Ve a **Account Settings** > **General** > **API Token**
4. Copia tu token

**Secret a configurar:**
```
SNYK_TOKEN: <tu_token_de_snyk>
```

### 3. Codecov (Opcional - para reportes de cobertura)

1. Ve a [Codecov](https://codecov.io/)
2. Inicia sesión con GitHub
3. Añade tu repositorio
4. Copia el token

**Secret a configurar:**
```
CODECOV_TOKEN: <tu_token_de_codecov>
```

## Cómo Agregar Secrets en GitHub

1. Ve a tu repositorio en GitHub
2. Click en **Settings** (Configuración)
3. En el menú lateral, click en **Secrets and variables** > **Actions**
4. Click en **New repository secret**
5. Ingresa el **Name** (nombre del secret) y el **Value** (valor)
6. Click en **Add secret**

## Verificación

Después de agregar los secrets:

1. Ve a la pestaña **Actions** en tu repositorio
2. Ejecuta manualmente el workflow "Complete Test Suite"
3. Verifica que los análisis se ejecuten correctamente

## Notas Importantes

- Los secrets son **cifrados** y no se pueden ver después de crearlos
- Si necesitas actualizar un secret, debes crear uno nuevo con el mismo nombre
- Los secrets están disponibles para todos los workflows del repositorio
- **NUNCA** commits tokens o secrets directamente en el código

## Troubleshooting

### Error: "SONAR_TOKEN is empty"
- Verifica que hayas creado el secret con el nombre exacto `SONAR_TOKEN`
- Asegúrate de que el token sea válido y no haya expirado

### Error: "Unauthorized" en SonarQube
- Verifica que el token tenga los permisos correctos
- Verifica que la URL del host sea correcta (con o sin `/` al final)
- Para SonarCloud, asegúrate de usar `https://sonarcloud.io`

### Error: "Organization not found"
- Verifica que la organización `upt-epis` exista en SonarCloud
- Asegúrate de tener permisos en la organización
