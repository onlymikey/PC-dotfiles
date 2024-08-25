install $HOME/.cache/wal/colors-spotify.ini ~/.config/spicetify/Themes/Comfy/color.ini
spicetify config current_theme Comfy
spicetify config inject_css 1 replace_colors 1 overwrite_assets 1 inject_theme_js 1
spicetify apply

# Ejecutar pgrep para buscar procesos con el nombre "spotify"
output=$(pgrep -x spotify)

# Verificar si se encontró algún proceso llamado "spotify"
if [ -n "$output" ]; then
    echo "Proceso 'spotify' encontrado. Abriendo Spotify..."
    spotify &
else
    echo "Proceso 'spotify' no encontrado."
fi
