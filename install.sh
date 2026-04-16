#!/bin/bash

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Instalando Waybar Teal Suite (Configuração Centralizada)...${NC}"

WAYBAR_DIR="$HOME/.config/waybar"
SCRIPTS_ROOT="$WAYBAR_DIR/_scripts"
BACKUP_DIR="$HOME/.config/waybar.bak.$(date +%Y%m%d%H%M%S)"

# 1. Backup
if [ -d "$WAYBAR_DIR" ]; then
    echo "Fazendo backup em: $BACKUP_DIR"
    cp -r "$WAYBAR_DIR" "$BACKUP_DIR"
fi

# 2. Criação da Estrutura Centralizada
echo "Criando estrutura de diretórios em $SCRIPTS_ROOT..."
mkdir -p "$SCRIPTS_ROOT/updates"
mkdir -p "$SCRIPTS_ROOT/minimize"
mkdir -p "$SCRIPTS_ROOT/pomodoro"

# 3. Cópia de Configurações e Estilos
cp ./config.jsonc "$WAYBAR_DIR/config.jsonc"
cp ./style.css "$WAYBAR_DIR/style.css"

# 4. Instalação dos Scripts
echo "Copiando scripts para o diretório centralizado..."
cp ./scripts/updates/*.sh "$SCRIPTS_ROOT/updates/"
cp ./scripts/minimize/*.sh "$SCRIPTS_ROOT/minimize/"
cp ./scripts/pomodoro/*.sh "$SCRIPTS_ROOT/pomodoro/"

# 5. Permissões
chmod +x "$SCRIPTS_ROOT/updates/"*.sh
chmod +x "$SCRIPTS_ROOT/minimize/"*.sh
chmod +x "$SCRIPTS_ROOT/pomodoro/"*.sh

# 6. Reload
killall waybar
waybar > /dev/null 2>&1 & disown

echo -e "${GREEN}Sucesso! Tudo instalado em ~/.config/waybar/_scripts/${NC}"