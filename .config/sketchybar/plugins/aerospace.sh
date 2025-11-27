#!/bin/bash

# Update workspace display when aerospace workspace changes
# This script is called for each workspace item

# Get all workspaces with windows
for sid in $(aerospace list-workspaces --all); do
  # Check if this workspace has windows
  apps=$(aerospace list-windows --workspace "$sid" | awk -F'|' '{gsub(/^ *| *$/, "", $2); print $2}')

  # Check if this workspace is focused
  is_focused=$(aerospace list-workspaces --focused)

  if [ "${apps}" != "" ]; then
    # Workspace has apps - build icon strip
    icon_strip=" "
    while read -r app; do
      icon_strip+=" $($CONFIG_DIR/plugins/icon_map_fn.sh "$app")"
    done <<<"${apps}"

    # Check if this is the focused workspace
    if [ "$sid" = "$is_focused" ]; then
      # Focused workspace - prominent styling with orange border and text
      sketchybar --set space.$sid \
        label="$icon_strip" \
        drawing=on \
        background.drawing=on \
        background.color=$ITEM_BG_COLOR \
        background.border_width=2 \
        background.border_color=0xffffa500 \
        icon.color=0xffffa500 \
        icon.shadow.drawing=on \
        label.shadow.drawing=on
    else
      # Non-focused workspace - subtle styling with white text
      sketchybar --set space.$sid \
        label="$icon_strip" \
        drawing=on \
        background.drawing=on \
        background.color=$ITEM_BG_COLOR \
        background.border_width=0 \
        icon.color=$WHITE \
        icon.shadow.drawing=off \
        label.shadow.drawing=off
    fi
  else
    # Workspace has no apps - hide it
    sketchybar --set space.$sid drawing=off
  fi
done
