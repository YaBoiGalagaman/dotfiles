#!/bin/bash
IFACE="enp34s0"

# first read
read rx1 tx1 <<< $(awk -v iface="$IFACE" '$1 ~ iface":" {print $2, $10}' /proc/net/dev)
sleep 1
# second read
read rx2 tx2 <<< $(awk -v iface="$IFACE" '$1 ~ iface":" {print $2, $10}' /proc/net/dev)

# calculate bits per second
rx_rate=$(( (rx2 - rx1) * 8 ))
tx_rate=$(( (tx2 - tx1) * 8 ))

# clamp negatives
((rx_rate < 0)) && rx_rate=0
((tx_rate < 0)) && tx_rate=0

# human readable
rx_h=$(numfmt --to=iec --suffix=bps --round=nearest "$rx_rate")
tx_h=$(numfmt --to=iec --suffix=bps --round=nearest "$tx_rate")

# output for Waybar
echo "{\"text\":\"▲ $tx_h ▼ $rx_h\",\"tooltip\":\"$IFACE throughput\",\"class\":\"netrate\"}"
