#!/bin/bash

rgbDevices=$(openrgb --list-devices)




keyboard=$(echo "$rgbDevices" | grep "Mountain Everest" | grep -v "Description" | cut -d: -f1)

memory=$(echo "$rgbDevices" | grep "ENE DRAM" | cut -d: -f1)

# Writing to an array
mapfile -t memory_ids <<<"$memory"

case_lights=$(echo "$rgbDevices" | grep "NZXT Smart Device V1" | cut -d: -f1)

aio=$(echo "$rgbDevices" | grep "Corsair Hydro H150i Pro XT" | cut -d: -f1)

graphics_card=$(echo "$rgbDevices" | grep "NVIDIA GeForce RTX 3080 FE" | cut -d: -f1)





/usr/bin/openrgb \
  --device "$keyboard" --zone 0 --color 0032FF \
  --device "$keyboard" --zone 1 --color 0032FF \
  --device "$keyboard" --zone 2 --color 0032FF \
  --device "$keyboard" --zone 3 --color 0032FF \
  --device "$case_lights" --zone 0 --color 3296FF \
  --device "${memory_ids[0]}" --mode 'Static' --zone 0 --color 0082FF \
  --device "${memory_ids[1]}" --mode 'Static' --zone 0 --color 0082FF \
  --device "${memory_ids[2]}" --mode 'Static' --zone 0 --color 0082FF \
  --device "${memory_ids[3]}" --mode 'Static' --zone 0 --color 0082FF \
  --device "$aio" --zone 0 --color 0032FF \
  --device "$graphics_card" --zone 0 --color 000000 \
  --device "$graphics_card" --mode 'Direct' --zone 1 --color FFFFFF --brightness 50
  
