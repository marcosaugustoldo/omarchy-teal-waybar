#!/bin/bash

# Move a janela ativa para o workspace especial SEM levar o foco junto
hyprctl dispatch movetoworkspacesilent special:minimized

# Atualiza APENAS o contador de minimizadas (Signal 11)
pkill -RTMIN+11 waybar