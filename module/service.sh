#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/common.sh"
# Bounded, non-blocking late-start wait for Android services.
COUNT=0
while [ "$(/system/bin/getprop sys.boot_completed)" != 1 ]; do
  [ "$COUNT" -ge 120 ] && exit 1
  sleep 2
  COUNT=$((COUNT + 1))
done
[ -f "$MODDIR/disable" ] && exit 0
[ -f "$MODDIR/remove" ] && exit 0
VALUE=$(cat "$MODDIR/choice" 2>/dev/null)
apply_value "$VALUE" > "$MODDIR/boot.log" 2>&1
RESULT=$?
echo "Requested: $VALUE; result: $RESULT" >> "$MODDIR/boot.log"
exit "$RESULT"
