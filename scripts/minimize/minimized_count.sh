#!/bin/bash

# Extrai a contagem de janelas no limbo
count=$(hyprctl clients -j | jq '[.[] | select(.workspace.name == "special:minimized")] | length')

# Se zero, não exibe nada para manter a barra limpa
if [ "$count" -eq 0 ]; then
    echo ""
else
    # Retorna JSON para suporte a ícone + tooltip na Waybar
    echo "{\"text\": \"󱂬 $count\", \"tooltip\": \"$count minimized windows\"}"
fi