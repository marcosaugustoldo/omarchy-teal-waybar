#!/bin/bash

# Recebe a classe como primeiro argumento e o comando como o restante
APP_CLASS=$1
shift
APP_CMD="$@"

# 1. Busca a janela pela classe informada
CLIENT_INFO=$(hyprctl clients -j | jq -r --arg class "$APP_CLASS" '
    .[] | select(.class == $class) | "\(.address)|\(.workspace.name)"' | head -n 1)

# 2. Se não encontrou, o app está fechado: ABRE
if [ -z "$CLIENT_INFO" ]; then
    eval "$APP_CMD" > /dev/null 2>&1 & disown
    exit 0
fi

# 3. Se encontrou, extrai os dados
ADDRESS=$(echo "$CLIENT_INFO" | cut -d'|' -f1)
WORKSPACE=$(echo "$CLIENT_INFO" | cut -d'|' -f2)

# 4. Lógica de Restauração / Foco
if [ "$WORKSPACE" == "special:minimized" ]; then
    # Tira do limbo e traz para o workspace ativo (e+0)
    hyprctl dispatch movetoworkspace e+0,address:$ADDRESS
    hyprctl dispatch focuswindow address:$ADDRESS
    
    # Avisa o módulo do contador (Signal 11) para atualizar o número na barra!
    pkill -RTMIN+11 waybar
else
    # Já está visível em algum workspace, apenas pula para ela
    hyprctl dispatch focuswindow address:$ADDRESS
fi
