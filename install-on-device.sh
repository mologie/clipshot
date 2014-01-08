#!/bin/sh
set -e
DEVICE=$1
if [ -z "$DEVICE" ]; then
	echo "usage: $0 device-name"
	exit 1
fi
make DEBUG=1
#scp -r layout/Library/* root@$DEVICE:/Library
scp ClipShot.plist .theos/obj/debug/ClipShot.dylib root@$DEVICE:/Library/MobileSubstrate/DynamicLibraries/
ssh root@$DEVICE sbreload
