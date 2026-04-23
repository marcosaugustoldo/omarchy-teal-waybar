#!/bin/bash

STATE_FILE="/tmp/pomodoro_state"
TIMER_FILE="/tmp/pomodoro_timer"
ROUNDS_FILE="/tmp/pomodoro_rounds"

# Inicializa arquivos se não existirem
[ ! -f "$STATE_FILE" ] && echo "stopped" > "$STATE_FILE"
[ ! -f "$TIMER_FILE" ] && echo "1500" > "$TIMER_FILE"
[ ! -f "$ROUNDS_FILE" ] && echo "0" > "$ROUNDS_FILE"

STATE=$(cat "$STATE_FILE")
SECONDS=$(cat "$TIMER_FILE")
ROUNDS=$(cat "$ROUNDS_FILE")

# Formata MM:SS
TIME_FORMATED=$(printf "%02d:%02d" $((SECONDS%3600/60)) $((SECONDS%60)))

# Desenha os círculos de progresso na Tooltip
DOTS=""
for i in {1..4}; do
    if [ "$i" -le "$ROUNDS" ]; then
        DOTS+="●"
    else
        DOTS+="○"
    fi
done

# Retorna JSON para a Waybar com textos traduzidos
if [ "$STATE" == "focus" ]; then
    echo "{\"text\": \"󰞌 $TIME_FORMATED\", \"tooltip\": \"Foco ativo! ($DOTS)\\nClique para pausar.\", \"class\": \"focus\"}"
elif [[ "$STATE" == *"break" ]]; then
    echo "{\"text\": \"󰅶 $TIME_FORMATED\", \"tooltip\": \"Descansando... ($DOTS)\\nClique para pausar.\", \"class\": \"break\"}"
elif [[ "$STATE" == paused_* ]]; then
    echo "{\"text\": \"󰞌 $TIME_FORMATED\", \"tooltip\": \"Pausado. ($DOTS)\\nClique para continuar.\", \"class\": \"paused\"}"
else
    echo "{\"text\": \"󰞌 25:00\", \"tooltip\": \"Pronto para focar. ($DOTS)\\nClique para iniciar.\", \"class\": \"stopped\"}"
fi