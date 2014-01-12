#!/bin/sh
# This script installs a debug build of ClipShot on the device defined in the
# environment, in either $DEVICE, $THEOS_DEVICE_IP, or the first argument
# passed to this script.
# The debug build number is incremented every time this command is run.

set -e
cd "$(dirname $0)"

DEVICE="${DEVICE:=$1}"
DEVICE="${DEVICE:=$THEOS_DEVICE_IP}"
if [ -z "$DEVICE" ]; then
	echo "usage: $0 device-name"
	exit 1
fi

THEOS_DEVICE_IP=$DEVICE make DEBUG=1 package install
ssh root@$DEVICE sbreload
