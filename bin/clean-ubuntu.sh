#!/bin/bash

# Colores para los mensajes
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# 1. Verificar permisos de root
if [ "$EUID" -ne 0 ]; then
    echo -e "${RED}Por favor, ejecuta este script como root (sudo).${NC}"
    exit
fi

echo -e "${YELLOW}--- INICIANDO LIMPIEZA DE ESPACIO EN ROOT (/) ---${NC}"

# Medir espacio antes
SPACE_BEFORE=$(df / | tail -1 | awk '{print $4}')
echo -e "Espacio libre actual: ${RED}$(numfmt --to=iec --from-unit=1K $SPACE_BEFORE)${NC}"
echo ""

# ---------------------------------------------------------
# 2. LIMPIEZA DE APT (Paquetes)
# ---------------------------------------------------------
echo -e "${GREEN}[1/5] Limpiando caché de APT y dependencias huérfanas...${NC}"
apt-get clean
apt-get autoremove -y --purge
echo "APT limpio."
echo ""

# ---------------------------------------------------------
# 3. LIMPIEZA DE SNAP (Versiones antiguas)
# ---------------------------------------------------------
echo -e "${GREEN}[2/5] Eliminando versiones antiguas de SNAP (disabled)...${NC}"
# Script para detectar y borrar revisiones viejas
snap list --all | awk '/disabled/{print $1, $3}' |
    while read snapname revision; do
        echo "Borrando $snapname revisión $revision..."
        snap remove "$snapname" --revision="$revision"
    done
echo "Snaps antiguos eliminados."
echo ""

# ---------------------------------------------------------
# 4. LIMPIEZA DE JOURNALD (Logs del sistema)
# ---------------------------------------------------------
echo -e "${GREEN}[3/5] Reduciendo logs del sistema a 2 días...${NC}"
journalctl --vacuum-time=2d
echo "Logs limpiados."
echo ""

# ---------------------------------------------------------
# 5. LIMPIEZA DE CACHÉ DE ROOT
# ---------------------------------------------------------
echo -e "${GREEN}[4/5] Limpiando caché de thumbnails del usuario root...${NC}"
rm -rf /root/.cache/thumbnails/*
echo "Caché de root limpia."
echo ""

# ---------------------------------------------------------
# 6. LIMPIEZA DE DOCKER (Opcional)
# ---------------------------------------------------------
echo -e "${GREEN}[5/5] Limpieza de Docker${NC}"
echo -e "${YELLOW}ATENCIÓN: Esto eliminará:${NC}"
echo "  - Contenedores parados"
echo "  - Redes no usadas"
echo "  - Imágenes 'colgando' (dangling) - (Safe)"
echo "  - Caché de compilación"
echo -e "${RED}¿Quieres ejecutar 'docker system prune'? (s/N)${NC}"
read -r response

if [[ "$response" =~ ^([sS][iI]|[sS])$ ]]; then
    docker system prune -f
    echo "Docker limpiado."
else
    echo "Saltando limpieza de Docker."
fi
echo ""

# ---------------------------------------------------------
# RESUMEN FINAL
# ---------------------------------------------------------
echo -e "${YELLOW}--- RESUMEN ---${NC}"
SPACE_AFTER=$(df / | tail -1 | awk '{print $4}')
FREED=$((SPACE_AFTER - SPACE_BEFORE))

echo -e "Espacio libre ANTES:  $(numfmt --to=iec --from-unit=1K $SPACE_BEFORE)"
echo -e "Espacio libre AHORA:  ${GREEN}$(numfmt --to=iec --from-unit=1K $SPACE_AFTER)${NC}"

if [ $FREED -gt 0 ]; then
    echo -e "Has recuperado:       ${GREEN}$(numfmt --to=iec --from-unit=1K $FREED)${NC} de espacio."
else
    echo "No se pudo recuperar más espacio o el disco estaba casi optimizado."
fi

# Alerta si sigue crítico (menos de 1GB)
if [ $SPACE_AFTER -lt 1048576 ]; then
    echo -e "${RED}¡ADVERTENCIA! Todavía tienes menos de 1GB libre en /. Revisa /var manualmente.${NC}"
fi
