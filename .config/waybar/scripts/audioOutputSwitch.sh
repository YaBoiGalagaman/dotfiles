#!/bin/bash

STATUS=$(wpctl status)

HEADPHONES_SINK=$(echo "$STATUS" \
  | sed -n '/Sinks:/,/Sources:/p' \
  | grep 'Arctis Pro Wireless Game' \
  | grep -Eo '[0-9]+' \
  | head -n1)

SPEAKERS_SINK=$(echo "$STATUS" \
  | sed -n '/Sinks:/,/Sources:/p' \
  | grep 'Starship/Matisse HD Audio Controller Analog Stereo' \
  | grep -Eo '[0-9]+' \
  | head -n1)

CURRENT=$(echo "$STATUS" \
  | sed -n '/Sinks:/,/Sources:/p' \
  | grep '*' \
  | grep -Eo '[0-9]+' \
  | head -n1)

if [[ "$CURRENT" == "$HEADPHONES_SINK" ]]; then
    wpctl set-default "$SPEAKERS_SINK"
else
    wpctl set-default "$HEADPHONES_SINK"
fi
