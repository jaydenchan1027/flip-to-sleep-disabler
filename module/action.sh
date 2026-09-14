#!/system/bin/sh
MODDIR=${0%/*}
. "$MODDIR/common.sh"
INSTALL=false
[ "$1" = "--install" ] && INSTALL=true
umask 077
WORK=$(mktemp -d /data/local/tmp/flip-toggle.XXXXXX) || exit 1
PID=
cleanup() {
  if [ -n "$PID" ]; then
    kill "$PID" 2>/dev/null
    wait "$PID" 2>/dev/null
  fi
  rm -rf "$WORK"
}
trap cleanup EXIT
trap 'exit 1' HUP INT TERM
echo "Current flip-to-screen-off: $(get_value)"
# Start listening before showing the prompt.
/system/bin/getevent -l > "$WORK/events" 2> "$WORK/error" &
PID=$!
echo "Press and release a volume key within 30 seconds:"
echo "  Volume UP   = true (enable)"
echo "  Volume DOWN = false (disable)"
COUNT=0
VALUE=
while [ "$COUNT" -lt 30 ]; do
  VALUE=$(awk '/EV_KEY/ && /DOWN/ { if ($0 ~ /KEY_VOLUMEUP/) { print "true"; exit } if ($0 ~ /KEY_VOLUMEDOWN/) { print "false"; exit } }' "$WORK/events")
  [ -n "$VALUE" ] && break
  if ! kill -0 "$PID" 2>/dev/null; then
    echo "Cannot read volume keys. No setting changed."
    cat "$WORK/error"
    exit 1
  fi
  sleep 1
  COUNT=$((COUNT + 1))
done
if [ -z "$VALUE" ]; then
  echo "Timed out. Keeping the existing choice (false on a fresh install)."
  exit 0
fi
# Stop input capture before applying the choice or pausing.
kill "$PID" 2>/dev/null
wait "$PID" 2>/dev/null
PID=
if [ "$INSTALL" = true ] || apply_value "$VALUE"; then
  if printf '%s\n' "$VALUE" > "$MODDIR/choice.new" && mv "$MODDIR/choice.new" "$MODDIR/choice"; then
    if [ "$INSTALL" = true ]; then
      echo "Selection saved: flip-to-screen-off = $VALUE"
      echo "This setting will apply on the first reboot."
    else
      echo "SUCCESS: flip-to-screen-off = $VALUE"
      echo "Applied now and saved for future boots."
      echo "Finishing in 5 seconds..."
      sleep 5
    fi
  else
    echo "Failed to save boot preference. Check the current setting before retrying."
    exit 1
  fi
else
  echo "Failed to apply or verify setting. Boot preference unchanged."
  exit 1
fi
