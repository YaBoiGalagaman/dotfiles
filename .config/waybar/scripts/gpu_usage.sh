#!/bin/bash
# GPU utilization script for Waybar (NVIDIA)
usage=$(nvidia-smi --query-gpu=utilization.gpu --format=csv,noheader,nounits | head -n1)
if [[ -z "$usage" ]]; then
  usage=0
fi
echo "{\"text\":\"󰢮 $usage%\",\"tooltip\":\"GPU Usage\",\"class\":\"gpu\"}"
