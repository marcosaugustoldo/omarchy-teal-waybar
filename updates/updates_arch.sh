#!/bin/bash

CACHE_FILE="$HOME/.cache/omarchy_updates_arch.json"
CACHE_AGE=604800 # 7 dias

mkdir -p "$HOME/.cache"

if [ -f "$CACHE_FILE" ]; then
    LAST_MOD=$(stat -c %Y "$CACHE_FILE")
    NOW=$(date +%s)
    
    # Verifica quando o banco do pacman foi modificado pela última vez
    LAST_PACMAN_MOD=$(stat -c %Y /var/lib/pacman/local 2>/dev/null || echo 0)
    
    # Usa o cache APENAS se estiver no prazo E o pacman não tiver sido atualizado depois do cache
    if [ $((NOW - LAST_MOD)) -lt $CACHE_AGE ] && [ "$LAST_PACMAN_MOD" -lt "$LAST_MOD" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# ==========================================
# Início do processamento real
# ==========================================
updates_arch=$(checkupdates 2>/dev/null | wc -l)
updates_aur=$(yay -Qu 2>/dev/null | wc -l)
total=$((updates_arch + updates_aur))

if [ "$total" -gt 0 ]; then
    OUTPUT="{\"text\": \"󰣇 $total\", \"tooltip\": \"Arch: $updates_arch\nAUR: $updates_aur\", \"class\": \"pending\"}"
else
    OUTPUT="{\"text\": \"\", \"tooltip\": \"\", \"class\": \"updated\"}"
fi

echo "$OUTPUT" > "$CACHE_FILE"
echo "$OUTPUT"