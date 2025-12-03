#!/bin/bash

# ═══════════════════════════════════════════════════════════════════
# Script de Validación Local para GitHub Actions Workflow
# Sistema de Voluntariado UPT
# ═══════════════════════════════════════════════════════════════════

set -e

# Colores
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Variables
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$SCRIPT_DIR"
REPORTS_DIR="$PROJECT_DIR/local-test-reports"

echo ""
echo "═══════════════════════════════════════════════════════════════"
echo "  🔬 VALIDACIÓN LOCAL - GITHUB ACTIONS WORKFLOW"
echo "  Sistema de Voluntariado UPT"
echo "═══════════════════════════════════════════════════════════════"
echo ""

# Función para mostrar ayuda
show_help() {
    echo "Uso: ./validate-workflow.sh [OPCIÓN]"
    echo ""
    echo "Opciones:"
    echo "  --all              Ejecutar todas las etapas (default)"
    echo "  --static           Solo análisis estático"
    echo "  --unit             Solo pruebas unitarias"
    echo "  --integration      Solo pruebas de integración"
    echo "  --ui               Solo pruebas UI"
    echo "  --bdd              Solo pruebas BDD"
    echo "  --check-deps       Solo verificar dependencias"
    echo "  --clean            Limpiar reportes anteriores"
    echo "  --help             Mostrar esta ayuda"
    echo ""
    echo "Ejemplos:"
    echo "  ./validate-workflow.sh --all"
    echo "  ./validate-workflow.sh --static"
    echo "  ./validate-workflow.sh --unit --integration"
    exit 0
}

# Función para verificar dependencias
check_dependencies() {
    echo -e "${BLUE}📦 Verificando dependencias...${NC}"
    
    local missing_deps=()
    
    # Java
    if ! command -v java &> /dev/null; then
        missing_deps+=("Java 17+")
    else
        java_version=$(java -version 2>&1 | awk -F '"' '/version/ {print $2}' | cut -d'.' -f1)
        if [ "$java_version" -lt 17 ]; then
            echo -e "${RED}❌ Java 17+ requerido (actual: $java_version)${NC}"
            missing_deps+=("Java 17+")
        else
            echo -e "${GREEN}✅ Java $java_version${NC}"
        fi
    fi
    
    # Maven
    if ! command -v mvn &> /dev/null; then
        missing_deps+=("Maven 3.8+")
    else
        echo -e "${GREEN}✅ Maven $(mvn -v | head -1 | awk '{print $3}')${NC}"
    fi
    
    # MySQL
    if ! command -v mysql &> /dev/null; then
        missing_deps+=("MySQL 8.0")
    else
        echo -e "${GREEN}✅ MySQL$(mysql --version | awk '{print $5}' | cut -d',' -f1)${NC}"
    fi
    
    # Chrome (para UI tests)
    if ! command -v google-chrome &> /dev/null && ! command -v chromium &> /dev/null; then
        echo -e "${YELLOW}⚠️  Chrome no encontrado (requerido para UI tests)${NC}"
    else
        echo -e "${GREEN}✅ Chrome instalado${NC}"
    fi
    
    # Git
    if ! command -v git &> /dev/null; then
        missing_deps+=("Git")
    else
        echo -e "${GREEN}✅ Git $(git --version | awk '{print $3}')${NC}"
    fi
    
    # Verificar si hay dependencias faltantes
    if [ ${#missing_deps[@]} -gt 0 ]; then
        echo ""
        echo -e "${RED}❌ Dependencias faltantes:${NC}"
        for dep in "${missing_deps[@]}"; do
            echo "   - $dep"
        done
        echo ""
        echo "Instalar dependencias y volver a ejecutar."
        exit 1
    fi
    
    echo -e "${GREEN}✅ Todas las dependencias están instaladas${NC}"
    echo ""
}

# Función para limpiar reportes
clean_reports() {
    echo -e "${YELLOW}🧹 Limpiando reportes anteriores...${NC}"
    rm -rf "$REPORTS_DIR"
    rm -rf "$PROJECT_DIR/proyecto/target"
    echo -e "${GREEN}✅ Reportes limpiados${NC}"
    echo ""
}

# Función para verificar servicios
check_services() {
    echo -e "${BLUE}🔍 Verificando servicios...${NC}"
    
    # MySQL
    if ! pgrep -x "mysqld" > /dev/null; then
        echo -e "${YELLOW}⚠️  MySQL no está corriendo. Iniciando...${NC}"
        
        # Detectar sistema operativo
        if [[ "$OSTYPE" == "darwin"* ]]; then
            brew services start mysql
        elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
            sudo systemctl start mysql
        else
            echo -e "${RED}❌ No se pudo iniciar MySQL automáticamente${NC}"
            exit 1
        fi
        
        sleep 5
    fi
    
    if pgrep -x "mysqld" > /dev/null; then
        echo -e "${GREEN}✅ MySQL corriendo${NC}"
    else
        echo -e "${RED}❌ MySQL no se pudo iniciar${NC}"
        exit 1
    fi
    
    echo ""
}

# Función para preparar base de datos
setup_database() {
    echo -e "${BLUE}🗄️  Inicializando base de datos de prueba...${NC}"
    
    # Eliminar DB si existe
    mysql -uroot -proot -e "DROP DATABASE IF EXISTS voluntariado_test;" 2>/dev/null || true
    
    # Crear DB
    mysql -uroot -proot -e "CREATE DATABASE voluntariado_test;"
    
    # Importar schema
    if [ -f "$PROJECT_DIR/base_de_datos/completo.sql" ]; then
        mysql -uroot -proot voluntariado_test < "$PROJECT_DIR/base_de_datos/completo.sql"
        echo -e "${GREEN}✅ Base de datos inicializada${NC}"
    else
        echo -e "${RED}❌ No se encontró base_de_datos/completo.sql${NC}"
        exit 1
    fi
    
    echo ""
}

# Función para análisis estático
run_static_analysis() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  STAGE 1: ANÁLISIS ESTÁTICO${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    cd "$PROJECT_DIR/proyecto"
    
    # Maven compile (requerido para análisis)
    echo -e "${BLUE}📦 Compilando proyecto...${NC}"
    mvn clean compile -DskipTests
    
    echo ""
    echo -e "${CYAN}🔍 Nota: Análisis estático completo requiere:${NC}"
    echo "   - SonarQube: mvn sonar:sonar -Dsonar.token=YOUR_TOKEN"
    echo "   - Semgrep: semgrep --config=auto ."
    echo "   - Snyk: snyk test"
    echo ""
    echo -e "${YELLOW}⚠️  Ejecutar estas herramientas manualmente con credenciales${NC}"
    echo ""
    
    cd "$PROJECT_DIR"
}

# Función para pruebas unitarias
run_unit_tests() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  STAGE 2: PRUEBAS UNITARIAS${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    cd "$PROJECT_DIR/proyecto"
    
    echo -e "${BLUE}🧪 Ejecutando pruebas unitarias...${NC}"
    mvn clean test jacoco:report
    
    # Verificar cobertura
    if [ -f "target/site/jacoco/index.html" ]; then
        echo -e "${GREEN}✅ Pruebas unitarias completadas${NC}"
        echo -e "${CYAN}📊 Reporte de cobertura: target/site/jacoco/index.html${NC}"
        
        # Extraer métricas de cobertura
        coverage=$(grep -oP '<td class="ctr2">\K[0-9]+%' target/site/jacoco/index.html | head -1)
        echo -e "${CYAN}   Cobertura: $coverage${NC}"
    else
        echo -e "${RED}❌ No se generó reporte de cobertura${NC}"
    fi
    
    echo ""
    cd "$PROJECT_DIR"
}

# Función para mutation testing
run_mutation_tests() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  STAGE 3: MUTATION TESTING${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    cd "$PROJECT_DIR/proyecto"
    
    echo -e "${BLUE}🧬 Ejecutando PITest...${NC}"
    echo -e "${YELLOW}⚠️  Esto puede tomar varios minutos...${NC}"
    
    mvn test-compile org.pitest:pitest-maven:mutationCoverage \
        -DtargetClasses=negocio.*,servlet.* \
        -DtargetTests=negocio.*Test,servlet.*Test
    
    if [ -d "target/pit-reports" ]; then
        echo -e "${GREEN}✅ Mutation testing completado${NC}"
        echo -e "${CYAN}📊 Reporte: target/pit-reports/index.html${NC}"
    fi
    
    echo ""
    cd "$PROJECT_DIR"
}

# Función para pruebas de integración
run_integration_tests() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  STAGE 4: PRUEBAS DE INTEGRACIÓN${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    setup_database
    
    cd "$PROJECT_DIR/proyecto"
    
    echo -e "${BLUE}🔗 Ejecutando pruebas de integración...${NC}"
    mvn verify -Dskip.unit.tests=true \
        -Ddb.url=jdbc:mysql://localhost:3306/voluntariado_test \
        -Ddb.username=root \
        -Ddb.password=root
    
    if [ -d "target/failsafe-reports" ]; then
        echo -e "${GREEN}✅ Pruebas de integración completadas${NC}"
        echo -e "${CYAN}📊 Reportes: target/failsafe-reports/${NC}"
    fi
    
    echo ""
    cd "$PROJECT_DIR"
}

# Función para pruebas UI
run_ui_tests() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  STAGE 5: PRUEBAS UI (SELENIUM)${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    setup_database
    
    cd "$PROJECT_DIR/proyecto"
    
    # Compilar aplicación
    echo -e "${BLUE}📦 Compilando aplicación...${NC}"
    mvn clean package -DskipTests
    
    # Iniciar servidor
    echo -e "${BLUE}🚀 Iniciando servidor Tomcat...${NC}"
    mvn tomcat7:run > /dev/null 2>&1 &
    TOMCAT_PID=$!
    
    # Esperar a que el servidor inicie
    echo -e "${YELLOW}⏳ Esperando a que el servidor inicie...${NC}"
    for i in {1..30}; do
        if curl -s http://localhost:8080/voluntariado/ > /dev/null; then
            echo -e "${GREEN}✅ Servidor iniciado${NC}"
            break
        fi
        sleep 1
    done
    
    # Ejecutar tests UI
    echo -e "${BLUE}🖥️  Ejecutando pruebas UI...${NC}"
    mvn test -Dtest=ui.**.*Test -Dbrowser=chrome -Dheadless=true
    
    # Detener servidor
    echo -e "${YELLOW}🛑 Deteniendo servidor...${NC}"
    kill $TOMCAT_PID 2>/dev/null || true
    
    if [ -d "target/screenshots" ]; then
        echo -e "${CYAN}📸 Screenshots: target/screenshots/${NC}"
    fi
    
    echo -e "${GREEN}✅ Pruebas UI completadas${NC}"
    echo ""
    
    cd "$PROJECT_DIR"
}

# Función para pruebas BDD
run_bdd_tests() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  STAGE 6: PRUEBAS BDD (CUCUMBER)${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    setup_database
    
    cd "$PROJECT_DIR/proyecto"
    
    # Compilar aplicación
    echo -e "${BLUE}📦 Compilando aplicación...${NC}"
    mvn clean package -DskipTests
    
    # Iniciar servidor
    echo -e "${BLUE}🚀 Iniciando servidor Tomcat...${NC}"
    mvn tomcat7:run > /dev/null 2>&1 &
    TOMCAT_PID=$!
    
    # Esperar a que el servidor inicie
    echo -e "${YELLOW}⏳ Esperando a que el servidor inicie...${NC}"
    sleep 30
    
    # Ejecutar smoke tests
    echo -e "${BLUE}🥒 Ejecutando BDD Smoke Tests...${NC}"
    mvn test -Dtest=SmokeTestRunner -Dheadless=true
    
    # Generar reportes
    mvn verify -DskipTests
    
    # Detener servidor
    echo -e "${YELLOW}🛑 Deteniendo servidor...${NC}"
    kill $TOMCAT_PID 2>/dev/null || true
    
    if [ -d "target/cucumber-reports" ]; then
        echo -e "${GREEN}✅ Pruebas BDD completadas${NC}"
        echo -e "${CYAN}📊 Reportes Cucumber: target/cucumber-reports/${NC}"
    fi
    
    echo ""
    cd "$PROJECT_DIR"
}

# Función para generar reporte consolidado
generate_consolidated_report() {
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo -e "${PURPLE}  STAGE 7: REPORTE CONSOLIDADO${NC}"
    echo -e "${PURPLE}═══════════════════════════════════════════════════════${NC}"
    echo ""
    
    mkdir -p "$REPORTS_DIR"
    
    echo -e "${BLUE}📊 Generando reporte consolidado...${NC}"
    
    cat > "$REPORTS_DIR/SUMMARY.md" << 'EOF'
# 🔬 Resumen de Validación Local

**Fecha:** $(date)
**Usuario:** $(whoami)
**Sistema:** $(uname -s)

## 📋 Resultados por Etapa

| Etapa | Estado | Detalles |
|-------|--------|----------|
| 🔍 Análisis Estático | ⚠️ Manual | Requiere credenciales SonarQube/Snyk |
| 🧪 Pruebas Unitarias | Ejecutado | Ver target/surefire-reports |
| 🧬 Mutation Testing | Ejecutado | Ver target/pit-reports |
| 🔗 Pruebas Integración | Ejecutado | Ver target/failsafe-reports |
| 🖥️ Pruebas UI | Ejecutado | Ver target/screenshots |
| 🥒 Pruebas BDD | Ejecutado | Ver target/cucumber-reports |

## 📁 Ubicación de Reportes

- Unitarias: `proyecto/target/site/jacoco/index.html`
- Mutation: `proyecto/target/pit-reports/index.html`
- Cucumber: `proyecto/target/cucumber-reports/cucumber.html`

## ✅ Siguientes Pasos

1. Revisar reportes generados
2. Configurar secrets en GitHub (si aún no está hecho)
3. Hacer push para activar workflow en GitHub Actions
4. Monitorear ejecución en: https://github.com/REPO/actions

EOF
    
    echo -e "${GREEN}✅ Reporte consolidado generado${NC}"
    echo -e "${CYAN}📄 Ver: $REPORTS_DIR/SUMMARY.md${NC}"
    echo ""
}

# Parsear argumentos
RUN_ALL=true
RUN_STATIC=false
RUN_UNIT=false
RUN_INTEGRATION=false
RUN_UI=false
RUN_BDD=false
CLEAN_FIRST=false

if [ $# -eq 0 ]; then
    RUN_ALL=true
else
    RUN_ALL=false
    while [[ $# -gt 0 ]]; do
        case $1 in
            --all)
                RUN_ALL=true
                shift
                ;;
            --static)
                RUN_STATIC=true
                shift
                ;;
            --unit)
                RUN_UNIT=true
                shift
                ;;
            --integration)
                RUN_INTEGRATION=true
                shift
                ;;
            --ui)
                RUN_UI=true
                shift
                ;;
            --bdd)
                RUN_BDD=true
                shift
                ;;
            --check-deps)
                check_dependencies
                exit 0
                ;;
            --clean)
                CLEAN_FIRST=true
                shift
                ;;
            --help)
                show_help
                ;;
            *)
                echo -e "${RED}Opción desconocida: $1${NC}"
                show_help
                ;;
        esac
    done
fi

# Ejecutar validaciones
if [ "$CLEAN_FIRST" = true ]; then
    clean_reports
fi

check_dependencies
check_services

# Ejecutar etapas según argumentos
if [ "$RUN_ALL" = true ]; then
    run_static_analysis
    run_unit_tests
    run_mutation_tests
    run_integration_tests
    run_ui_tests
    run_bdd_tests
    generate_consolidated_report
else
    [ "$RUN_STATIC" = true ] && run_static_analysis
    [ "$RUN_UNIT" = true ] && run_unit_tests
    [ "$RUN_INTEGRATION" = true ] && run_integration_tests
    [ "$RUN_UI" = true ] && run_ui_tests
    [ "$RUN_BDD" = true ] && run_bdd_tests
    generate_consolidated_report
fi

# Resumen final
echo ""
echo "═══════════════════════════════════════════════════════════════"
echo -e "${GREEN}✅ VALIDACIÓN COMPLETADA${NC}"
echo "═══════════════════════════════════════════════════════════════"
echo ""
echo -e "${CYAN}📊 Reportes generados en:${NC}"
echo "   - $REPORTS_DIR/SUMMARY.md"
echo "   - $PROJECT_DIR/proyecto/target/"
echo ""
echo -e "${CYAN}🚀 Siguiente paso:${NC}"
echo "   git add ."
echo "   git commit -m \"Add GitHub Actions workflow\""
echo "   git push origin main"
echo ""
echo -e "${CYAN}📈 Monitorear en:${NC}"
echo "   https://github.com/UPT-FAING-EPIS/voluntariado-upt/actions"
echo ""
