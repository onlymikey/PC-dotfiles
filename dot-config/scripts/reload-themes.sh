
wal -i $(swww query | grep -o -m 1 -E 'image: .+' | tail -c+8)
~/.config/mako/reload-theme.sh
~/.config/waybar/reload-theme.sh
~/.config/cava/reload-theme.sh
# 3. Generar NNN_FCOLORS dinámico usando tu script gen_fcolors.sh
#    Guardamos en un archivo listo para source
NNN_FILE="$HOME/.cache/wal/nnn_colors.sh"
"$HOME/.config/nnn/gen_fcolors.sh" > "$NNN_FILE"

# 4. Opcional: si quieres que la terminal actual ya lo cargue
if [ -n "$ZSH_VERSION" ] || [ -n "$BASH_VERSION" ]; then
    source "$NNN_FILE"
fi