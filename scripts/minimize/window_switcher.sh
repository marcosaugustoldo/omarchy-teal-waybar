#!/bin/bash

# 1. Coleta dados de todas as janelas
json_data=$(hyprctl clients -j)
[ "$(echo "$json_data" | jq 'length')" -eq 0 ] && exit 0

# 2. Gera lista para o Walker (Uniformidade visual com distinção de ícone)
menu_list=$(echo "$json_data" | jq -r '.[] | 
    (if .workspace.name == "special:minimized" then "" else "󱂬" end) as $icon |
    "\($icon)  \(.class) - \(.title)"')

# 3. Interface de Seleção
selected=$(echo -e "$menu_list" | walker --dmenu)
[ -z "$selected" ] && exit 0

# 4. Busca Reversa Blindada
window_info=$(echo "$json_data" | jq -r --arg sel "$selected" '
    .[] | 
    select(((if .workspace.name == "special:minimized" then "" else "󱂬" end) + "  " + .class + " - " + .title) == $sel) | 
    "\(.address)|\(.workspace.name)"' | head -n 1)

address=$(echo "$window_info" | cut -d'|' -f1)
workspace=$(echo "$window_info" | cut -d'|' -f2)

# 5. Execução de Foco/Restauração
if [ -n "$address" ]; then
    if [ "$workspace" == "special:minimized" ]; then
        # e+0 é a forma explícita de dizer "workspace ativo" no Hyprland
        hyprctl dispatch movetoworkspace e+0,address:$address
        pkill -RTMIN+11 waybar
    fi
    hyprctl dispatch focuswindow address:$address
fi