#!/bin/sh
# This shell script is responsible for pushing new packages to the Mologie
# Cydia Repository. It is not useful for the general public, but included for
# the sake of completeness.

set -e
cd "$(dirname $0)"

make clean package
LAST_PACKAGE=`cat .theos/last_package`

APTUSER=aptmanager
APTSERVER=sastarsimleykatemyu.servers.mologie.de
APTPATH=repos/cydia
APTDISTRO=stable

scp "$LAST_PACKAGE" $APTUSER@$APTSERVER:$APTPATH/incoming/$APTDISTRO/
ssh $APTUSER@$APTSERVER $APTPATH/scripts/import
