#!/usr/bin/env bash

# make sure it's executable with:
# chmod +x ~/.config/sketchybar/plugins/aerospace.sh

source "$CONFIG_DIR/plugins/icon_map.sh"
source "$CONFIG_DIR/colors.sh"

# Get the currently focused workspace
FOCUSED=$(aerospace list-workspaces --focused)

# Update app icons for this workspace
# aerospace list-windows format: window_id | app_name | window_title
apps=$(aerospace list-windows --workspace $1 2>/dev/null | awk -F' \\| ' '{print $2}' | sort -u)

# Hide workspace if empty
if [ -z "$apps" ]; then
  sketchybar --set $NAME drawing=off
  exit 0
fi

# Show workspace if it has windows
sketchybar --set $NAME drawing=on

if [ "$1" = "$FOCUSED" ]; then
  sketchybar --set $NAME background.drawing=on \
    background.color=$ACCENT_TRANSPARENT \
    icon.color=$WHITE \
    label.color=$WHITE
else
  sketchybar --set $NAME background.drawing=off \
    icon.color=$BLACK \
    label.color=$BLACK
fi

icon_string=""
for app in $apps; do
  __icon_map "$app"
  if [ "$icon_result" != ":default:" ]; then
    icon_string+="$icon_result"
  fi
done

if [ -n "$icon_string" ]; then
  sketchybar --set $NAME label="$icon_string" label.drawing=on
else
  sketchybar --set $NAME label.drawing=off
fi
