#! /usr/bin/env bash

DEVICE="88:D0:39:C6:85:40"

STATUS=$(bluetoothctl info $device_address | grep "Connected:" | awk '{print $2}')
S=""

if [ "$STATUS" == "yes" ]; then
  status="connected"
else
  status="disconnected"
fi

if [ "$STATUS" == "yes" ]; then
  echo "Disconnecting from $DEVICE..."
  S="disconnected"
  bluetoothctl << EOF
  disconnect $device_address
EOF
else
  
  echo "Connecting to $DEVICE..."
  S="connected"
  bluetoothctl << EOF
  connect $DEVICE
EOF
fi

echo "Device $DEVICE is now $S"


