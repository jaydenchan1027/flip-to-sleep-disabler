#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/common.sh"
touch "$MODDIR/stopping"
# Let any bounded framework call finish before restoring the original setting.
sleep 35
ORIGINAL=$(cat "$MODDIR/original" 2>/dev/null)
case "$ORIGINAL" in
  true|false) apply_value "$ORIGINAL" ;;
  null) /system/bin/device_config delete "$NS" "$KEY" ;;
  *) echo "No valid original setting; leaving DeviceConfig unchanged." ;;
esac
