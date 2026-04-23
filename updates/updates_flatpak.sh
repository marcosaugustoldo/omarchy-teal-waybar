#!/bin/bash

CACHE_FILE="$HOME/.cache/omarchy_updates_flatpak.json"
CACHE_AGE=604800

mkdir -p "$HOME/.cache"

if [ -f "$CACHE_FILE" ]; then
    LAST_MOD=$(stat -c %Y "$CACHE_FILE")
    NOW=$(date +%s)
    
    # Verifica diretórios do flatpak (sistema e usuário)
    SYS_MOD=$(stat -c %Y /var/lib/flatpak 2>/dev/null || echo 0)
    USR_MOD=$(stat -c %Y ~/.local/share/flatpak 2>/dev/null || echo 0)
    LAST_FLATPAK_MOD=$(( SYS_MOD > USR_MOD ? SYS_MOD : USR_MOD ))

    if [ $((NOW - LAST_MOD)) -lt $CACHE_AGE ] && [ "$LAST_FLATPAK_MOD" -lt "$LAST_MOD" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# ==========================================
# Início do processamento real
# ==========================================
updates_flatpak=$(flatpak remote-ls --updates 2>/dev/null | wc -l)

if [ "$updates_flatpak" -gt 0 ]; then
    OUTPUT="{\"text\": \"󰏔 $updates_flatpak\", \"tooltip\": \"$updates_flatpak atualizações Flatpak\", \"class\": \"pending\"}"
else
    OUTPUT="{\"text\": \"\", \"tooltip\": \"\", \"class\": \"updated\"}"
fi

echo "$OUTPUT" > "$CACHE_FILE"
echo "$OUTPUT"