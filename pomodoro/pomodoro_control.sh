#!/bin/bash

ACTION=$1
STATE_FILE="/tmp/pomodoro_state"
TIMER_FILE="/tmp/pomodoro_timer"
ROUNDS_FILE="/tmp/pomodoro_rounds"
PID_FILE="/tmp/pomodoro_loop.pid"
SIGNAL=13

VAULT_DIR="$HOME/Obsidian Vaults/Marcos Augusto"
LOG_FILE="$VAULT_DIR/Pomodoro (Hypr)/Tracker de Foco.md"

SOUND_FILE="/usr/share/sounds/freedesktop/stereo/complete.oga"

[ ! -f "$ROUNDS_FILE" ] && echo "0" > "$ROUNDS_FILE"

log_to_obsidian() {
    mkdir -p "$(dirname "$LOG_FILE")"
    DATA=$(date +"%Y-%m-%d (%A)")
    HORA=$(date +"%H:%M")
    if ! grep -q "## $DATA" "$LOG_FILE" 2>/dev/null; then
        echo -e "\n## $DATA\n" >> "$LOG_FILE"
    fi
    echo "- 25 minutos de foco concluídos às $HORA" >> "$LOG_FILE"
}

run_timer_loop() {
    while true; do
        STATE=$(cat "$STATE_FILE" 2>/dev/null)
        
        if [[ "$STATE" == "focus" || "$STATE" == "short_break" || "$STATE" == "long_break" ]]; then
            TIME=$(cat "$TIMER_FILE" 2>/dev/null)
            
            if [ "$TIME" -le 0 ]; then
                ROUNDS=$(cat "$ROUNDS_FILE" 2>/dev/null)
                
                if [ "$STATE" == "focus" ]; then
                    log_to_obsidian
                    ROUNDS=$((ROUNDS + 1))
                    
                    if [ "$ROUNDS" -ge 4 ]; then
                        echo "0" > "$ROUNDS_FILE"
                        echo "paused_long_break" > "$STATE_FILE"
                        echo "900" > "$TIMER_FILE"
                        # Aspas corrigidas abaixo:
                        notify-send -a "Pomodoro" -u critical "Ciclo completo!" "4 focos concluídos. Intervalo de 15 minutos permitido."
                        paplay "$SOUND_FILE" & disown
                    else
                        echo "$ROUNDS" > "$ROUNDS_FILE"
                        echo "paused_short_break" > "$STATE_FILE"
                        echo "300" > "$TIMER_FILE"
                        notify-send -a "Pomodoro" -u critical "Concentração concluída!" "É permitida uma breve pausa de 5 minutos."
                        paplay "$SOUND_FILE" & disown
                    fi
                else
                    echo "stopped" > "$STATE_FILE"
                    echo "1500" > "$TIMER_FILE"
                    notify-send -a "Pomodoro" -u critical "Fim do intervalo" "Hora de voltar ao trabalho!"
                    paplay "$SOUND_FILE" & disown
                fi
                
                pkill -RTMIN+$SIGNAL waybar
                exit
            fi
            
            TIME=$((TIME - 1))
            echo "$TIME" > "$TIMER_FILE"
            pkill -RTMIN+$SIGNAL waybar
        else
            exit
        fi
        sleep 1
    done
}

case $ACTION in
    "toggle")
        STATE=$(cat "$STATE_FILE" 2>/dev/null || echo "stopped")
        
        if [[ "$STATE" == "focus" || "$STATE" == "short_break" || "$STATE" == "long_break" ]]; then
            echo "paused_$STATE" > "$STATE_FILE"
            notify-send -a "Pomodoro" -t 1500 "Pomodoro" "Pausado"
        else
            if [ "$STATE" == "paused_short_break" ]; then
                echo "short_break" > "$STATE_FILE"
                notify-send -a "Pomodoro" -t 1500 "Pomodoro" "Intervalo curto iniciado"
            elif [ "$STATE" == "paused_long_break" ]; then
                echo "long_break" > "$STATE_FILE"
                notify-send -a "Pomodoro" -t 1500 "Pomodoro" "Começou o intervalo longo"
            else
                echo "focus" > "$STATE_FILE"
                notify-send -a "Pomodoro" -t 1500 "Pomodoro" "Foco de 25m iniciado"
            fi
            
            # Controle rígido de processos para não sobrepor loops no background
            if [ ! -f "$PID_FILE" ] || ! kill -0 $(cat "$PID_FILE") 2>/dev/null; then
                run_timer_loop &
                echo $! > "$PID_FILE"
                disown
            fi
        fi
        pkill -RTMIN+$SIGNAL waybar
        ;;
    "reset")
        echo "stopped" > "$STATE_FILE"
        echo "1500" > "$TIMER_FILE"
        # Tradução aplicada
        notify-send -a "Pomodoro" -t 2000 "Pomodoro" "Resetado para o tempo de foco (25m)."
        pkill -RTMIN+$SIGNAL waybar
        ;;
esac