#!/usr/bin/env bash
# opener.sh — opener para nnn
# Llama a este script desde nnn (NNN_OPENER).
# Si recibe un directorio, imprime la ruta (nnn puede cd a ella).
# Opciones rápidas (env vars):
#  - NNN_OPEN_IN = "same" | "tmux-split" | "kitty-new"  (default: same)
#  - NNN_KITTY_NEW_OPTS for extra kitty flags (optional)

set -euo pipefail

FILE="$1"
[ -e "$FILE" ] || exit 1

# Config (ajusta a tu gusto)
NNN_OPEN_IN="${NNN_OPEN_IN:-same}"   # same | tmux-split | kitty-new
NNN_KITTY_NEW_OPTS="${NNN_KITTY_NEW_OPTS:---detach}"

# Helpers
has_cmd() { command -v "$1" >/dev/null 2>&1; }

# Open in a new kitty window detached
kitty_new() {
    # use --detach to not block; pass through any extra opts
    if has_cmd kitty; then
        kitty $NNN_KITTY_NEW_OPTS -- "${@}"
    else
        "${@}" &
    fi
}

# Open in tmux split (if inside tmux)
tmux_split() {
    if [ -n "${TMUX-}" ] && has_cmd tmux; then
        # new horizontal split and run command in it
        tmux split-window -h "$*"
        tmux select-layout tiled >/dev/null 2>&1 || true
    else
        # fallback to same behavior
        eval "$*"
    fi
}

# If argument is a directory, print it — nnn will change directory
if [ -d "$FILE" ]; then
    printf '%s\n' "$FILE"
    exit 0
fi

# Get mime-type
MIME="$(file --mime-type -Lb -- "$FILE")" || MIME="application/octet-stream"

open_cmd_same() {
    # open in same terminal/pane (blocking)
    case "$1" in
        text/*|application/json|application/javascript|application/xml|application/x-shellscript|application/sql)
            # Prefer nvim in same pane (use EDITOR env var if present)
            ${EDITOR:-nvim} "$FILE"
            ;;
        image/*)
            # Display inline in Kitty if possible, otherwise fallback to sxiv
            if has_cmd kitty; then
                kitty +kitten icat --transfer-mode=file "$FILE"
                # keep process short (icat returns immediately)
                sleep 0.05
            elif has_cmd sxiv; then
                sxiv "$FILE"
            else
                xdg-open "$FILE" >/dev/null 2>&1 &
            fi
            ;;
        application/pdf)
            if has_cmd zathura; then
                zathura "$FILE" &
            else
                xdg-open "$FILE" >/dev/null 2>&1 &
            fi
            ;;
        audio/*)
            # play with mpv (no video) or enqueue to mpd (if used)
            if has_cmd mpv; then
                mpv --no-video "$FILE" &
            elif has_cmd ncmpcpp && has_cmd mpc; then
                mpc add "$FILE" && mpc play
            else
                xdg-open "$FILE" >/dev/null 2>&1 &
            fi
            ;;
        video/*)
            if has_cmd mpv; then
                mpv "$FILE" &
            else
                xdg-open "$FILE" >/dev/null 2>&1 &
            fi
            ;;
        application/*)
            # generic binaries or unknown application types
            if [ -x "$FILE" ]; then
                # executable script/binary: run in a new terminal (kitty) or same
                if [ "$NNN_OPEN_IN" = "kitty-new" ] && has_cmd kitty; then
                    kitty_new "$FILE"
                else
                    "$FILE"
                fi
            else
                xdg-open "$FILE" >/dev/null 2>&1 &
            fi
            ;;
        *)
            xdg-open "$FILE" >/dev/null 2>&1 &
            ;;
    esac
}

open_file() {
    case "$NNN_OPEN_IN" in
        same)
            open_cmd_same "$MIME"
            ;;
        tmux-split)
            # run the appropriate command in a tmux split
            if has_cmd tmux && [ -n "${TMUX-}" ]; then
                # Build a safe command string for the split
                case "$MIME" in
                    text/*|application/*(json|javascript|xml|x-shellscript|sql))
                        cmd="${EDITOR:-nvim} -- \"${FILE}\""
                        ;;
                    image/*)
                        if has_cmd kitty; then
                            cmd="kitty +kitten icat --transfer-mode=file \"${FILE}\""
                        elif has_cmd sxiv; then
                            cmd="sxiv \"${FILE}\""
                        else
                            cmd="xdg-open \"${FILE}\""
                        fi
                        ;;
                    application/pdf) cmd="zathura \"${FILE}\"" ;;
                    audio/*) cmd="mpv --no-video \"${FILE}\"" ;;
                    video/*) cmd="mpv \"${FILE}\"" ;;
                    *) cmd="xdg-open \"${FILE}\"" ;;
                esac
                tmux_split "$cmd"
            else
                open_cmd_same "$MIME"
            fi
            ;;
        kitty-new)
            # open in a new detached kitty window
            case "$MIME" in
                text/*|application/*(json|javascript|xml|x-shellscript|sql))
                    kitty_new ${EDITOR:-nvim} "$FILE"
                    ;;
                image/*)
                    # show inline in a new kitty window using icat or open externally
                    if has_cmd kitty; then
                        kitty_new kitty +kitten icat --transfer-mode=file "$FILE"
                    else
                        xdg-open "$FILE" >/dev/null 2>&1 &
                    fi
                    ;;
                application/pdf)
                    kitty_new zathura "$FILE"
                    ;;
                audio/*)
                    kitty_new mpv --no-video "$FILE"
                    ;;
                video/*)
                    kitty_new mpv "$FILE"
                    ;;
                *)
                    kitty_new xdg-open "$FILE"
                    ;;
            esac
            ;;
        *)
            # unknown mode: fallback to same
            open_cmd_same "$MIME"
            ;;
    esac
}

# Execute open
open_file

exit 0
