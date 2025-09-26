#!/usr/bin/env bash
# Generar NNN_FCOLORS automáticamente a partir de wal / kitty
# Convierte colores a índices 0–F válidos para NNN

# Cargar colores de wal
. "$HOME/.cache/wal/colors.sh"

# Definir índice por defecto (0-F) según colores más destacados
# Puedes ajustar aquí si quieres otro mapeo
FG_INDEX=0      # foreground principal (texto)
ACC_INDEX=6     # acento (directorios / ejecutables)

# Crear NNN_FCOLORS: 16 posiciones
# Orden: blk chr dir exe reg hln symlink mis orph fifo sock other
NNN_FCOLORS="$FG_INDEX$FG_INDEX$ACC_INDEX$ACC_INDEX$FG_INDEX$FG_INDEX$ACC_INDEX$ACC_INDEX$FG_INDEX$FG_INDEX$FG_INDEX$FG_INDEX$FG_INDEX$FG_INDEX$FG_INDEX$FG_INDEX"

# Guardar export listo para source
mkdir -p "$HOME/.cache/wal"
echo "export NNN_FCOLORS=\"$NNN_FCOLORS\"" > "$HOME/.cache/wal/nnn_colors.sh"
