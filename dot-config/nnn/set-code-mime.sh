#!/bin/bash
# Script para asociar archivos de código con VS Code Insiders

# Editor que usarás
EDITOR="code-insiders.desktop"

# Array de tipos MIME comunes de código
MIMES=(
  "text/x-python"
  "text/x-c"
  "text/x-c++"
  "text/x-java"
  "text/javascript"
  "text/x-shellscript"
  "text/x-ruby"
  "text/x-perl"
  "text/x-go"
  "text/x-haskell"
  "text/x-lua"
  "text/x-php"
  "text/x-rust"
)

# Asociar cada MIME con el editor
for mime in "${MIMES[@]}"; do
  xdg-mime default "$EDITOR" "$mime"
  echo "Asociado $mime -> $EDITOR"
done

echo "¡Listo! Ahora xdg-open y nnn abrirán los archivos de código en VS Code Insiders."
