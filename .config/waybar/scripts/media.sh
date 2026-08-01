#!/bin/bash
# Robust Waybar media script with safe JSON

STATE_FILE="/tmp/waybar_current_player"

escape() {
    printf '%s' "$1" | sed 's/\\/\\\\/g; s/"/\\"/g'
}

mapfile -t PLAYERS < <(playerctl -l 2>/dev/null)

# Remove kdeconnect ghosts
FILTERED=()
for p in "${PLAYERS[@]}"; do
    [[ "$p" == kdeconnect* ]] && continue
    FILTERED+=("$p")
done
PLAYERS=("${FILTERED[@]}")

if [ ${#PLAYERS[@]} -eq 0 ]; then
    echo '{"text":"No players","tooltip":"No MPRIS sources","class":"media"}'
    exit 0
fi

# Collapse firefox instances
LOGICAL_PLAYERS=()
HAS_FIREFOX=0
for p in "${PLAYERS[@]}"; do
    if [[ "$p" == firefox* ]]; then
        HAS_FIREFOX=1
    else
        LOGICAL_PLAYERS+=("$p")
    fi
done
[ $HAS_FIREFOX -eq 1 ] && LOGICAL_PLAYERS+=("firefox")

# Init state
[ ! -f "$STATE_FILE" ] && echo "${LOGICAL_PLAYERS[0]}" > "$STATE_FILE"
CURRENT=$(cat "$STATE_FILE")

# Validate current
FOUND=0
for p in "${LOGICAL_PLAYERS[@]}"; do
    [[ "$p" == "$CURRENT" ]] && FOUND=1
done
if [ $FOUND -eq 0 ]; then
    CURRENT="${LOGICAL_PLAYERS[0]}"
    echo "$CURRENT" > "$STATE_FILE"
fi

# Click handling
if [ "$1" = "next" ] || [ "$1" = "prev" ]; then
    for i in "${!LOGICAL_PLAYERS[@]}"; do
        if [[ "${LOGICAL_PLAYERS[$i]}" == "$CURRENT" ]]; then
            if [ "$1" = "next" ]; then
                NEW_INDEX=$(( (i + 1) % ${#LOGICAL_PLAYERS[@]} ))
            else
                NEW_INDEX=$(( (i - 1 + ${#LOGICAL_PLAYERS[@]}) % ${#LOGICAL_PLAYERS[@]} ))
            fi
            echo "${LOGICAL_PLAYERS[$NEW_INDEX]}" > "$STATE_FILE"
            exit 0
        fi
    done
fi

CURRENT=$(cat "$STATE_FILE")

# Resolve firefox instance
REAL="$CURRENT"
if [[ "$CURRENT" == firefox ]]; then
    for p in "${PLAYERS[@]}"; do
        [[ "$p" == firefox* ]] && REAL="$p" && break
    done
fi

# Display name
DISPLAY_NAME="$CURRENT"
[[ "$CURRENT" == firefox* ]] && DISPLAY_NAME="Firefox"
[[ "$CURRENT" == *spotify* ]] && DISPLAY_NAME="Spotify"
[[ "$CURRENT" == *vlc* ]] && DISPLAY_NAME="VLC"
[[ "$CURRENT" == *brave* ]] && DISPLAY_NAME="Brave"

metadata=$(playerctl -p "$REAL" metadata --format '{{artist}}|{{title}}|{{album}}' 2>/dev/null)
status=$(playerctl -p "$REAL" status 2>/dev/null)

if [ -z "$status" ]; then
    txt=$(escape "$DISPLAY_NAME: Idle")
    tip=$(escape "Player idle")
    echo "{\"text\":\"$txt\",\"tooltip\":\"$tip\",\"class\":\"media\"}"
    exit 0
fi

IFS="|" read -r artist title album <<< "$metadata"

icon="⏸"
[ "$status" = "Paused" ] && icon="▶"

text=$(escape "$DISPLAY_NAME $icon")
tooltip=$(escape "Player: $DISPLAY_NAME | $status | $artist — $title | $album")

echo "{\"text\":\"$text\",\"tooltip\":\"$tooltip\",\"class\":\"media\"}"
