#!/bin/bash

# Verifica pacman
updates_arch=$(checkupdates 2>/dev/null | wc -l)

# Verifica AUR (yay)
updates_aur=$(yay -Qu 2>/dev/null | wc -l)

total=$((updates_arch + updates_aur))

if [ "$total" -gt 0 ]; then
    # Retorna o ícone e o número se houver atualizações
    echo "{\"text\": \"󰣇 $total\", \"tooltip\": \"Arch: $updates_arch\nAUR: $updates_aur\", \"class\": \"pending\"}"
else
    # Retorna vazio para ocultar o módulo
    echo "{\"text\": \"\", \"tooltip\": \"\", \"class\": \"updated\"}"
fi