#!/bin/bash

updates_flatpak=$(flatpak remote-ls --updates 2>/dev/null | wc -l)

if [ "$updates_flatpak" -gt 0 ]; then
    # Retorna o ícone e o número se houver atualizações
    echo "{\"text\": \"󰏔 $updates_flatpak\", \"tooltip\": \"$updates_flatpak atualizações Flatpak\", \"class\": \"pending\"}"
else
    # Retorna vazio para ocultar o módulo
    echo "{\"text\": \"\", \"tooltip\": \"\", \"class\": \"updated\"}"
fi