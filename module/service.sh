#!/system/bin/sh
MODDIR=${0%/*}
# Use Android's shell and command environment for framework calls.
exec /system/bin/sh "$MODDIR/boot-worker.sh"
