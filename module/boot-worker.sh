#!/system/bin/sh
MODDIR=${0%/*}
PATH=/system/bin:/system/xbin:$PATH
export PATH
umask 077
. "$MODDIR/common.sh"
LOG="$MODDIR/boot.log"
[ -f "$LOG" ] && mv -f "$LOG" "$MODDIR/boot.previous.log"
: > "$LOG"
log() {
  [ "$(wc -c < "$LOG")" -gt 32768 ] && mv -f "$LOG" "$MODDIR/boot.previous.log"
  echo "$(date '+%F %T') $*" >> "$LOG"
}
enabled() {
  [ -d "$MODDIR" ] && [ ! -f "$MODDIR/disable" ] && [ ! -f "$MODDIR/remove" ] && [ ! -f "$MODDIR/stopping" ]
}
log "Boot worker started; waiting for Android."
while enabled && [ "$(/system/bin/getprop sys.boot_completed)" != 1 ]; do
  sleep 5
done
enabled || exit 0
log "Android boot completed; enforcing saved choice."
COUNT=0
LAST=
while enabled; do
  # Action owns the setting while a user is selecting or applying a value.
  ACTION_PID=$(cat "$MODDIR/action.pid" 2>/dev/null)
  case "$ACTION_PID" in
    ''|*[!0-9]*) BUSY=false ;;
    *) if kill -0 "$ACTION_PID" 2>/dev/null; then BUSY=true; else BUSY=false; fi ;;
  esac
  if [ "$BUSY" = false ]; then
    VALUE=$(cat "$MODDIR/choice" 2>/dev/null)
    case "$VALUE" in true|false) ;; *) VALUE=false ;; esac
    CURRENT=$(get_value 2>> "$LOG")
    if [ "$CURRENT" != "$VALUE" ]; then
      enabled || break
      if apply_value "$VALUE" >> "$LOG" 2>&1; then
        log "Restored $CURRENT -> $VALUE; verified."
        LAST="$VALUE"
      else
        log "Write/verification failed for $VALUE; will retry."
      fi
    elif [ "$LAST" != "$VALUE" ]; then
      log "Verified saved choice: $VALUE"
      LAST="$VALUE"
    fi
  fi
  COUNT=$((COUNT + 1))
  # Fast retries during startup, then a low-frequency reset check.
  if [ "$COUNT" -lt 24 ]; then sleep 5; else sleep 60; fi
done
log "Module disabled or removed; worker stopped."
