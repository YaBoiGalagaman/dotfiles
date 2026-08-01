#!/bin/bash
# VRAM usage script for Waybar (NVIDIA)
used=$(nvidia-smi --query-gpu=memory.used --format=csv,noheader,nounits | head -n1)
total=$(nvidia-smi --query-gpu=memory.total --format=csv,noheader,nounits | head -n1)
if [[ -z "$used" || -z "$total" ]]; then
  usage=0
else
  usage=$(( 100 * used / total ))
fi
echo "{\"text\":\"󰘚 $usage%\",\"tooltip\":\"VRAM Usage: $used MiB / $total MiB\",\"class\":\"vram\"}"
