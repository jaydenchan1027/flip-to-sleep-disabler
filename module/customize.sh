#!/system/bin/sh
ui_print "Flip to Sleep Disabler"
OLD=/data/adb/modules/flip_screen_toggle
if [ -f "$OLD/original" ]; then
  cp "$OLD/original" "$MODPATH/original" || abort "Cannot preserve original setting"
else
  ORIGINAL=$(/system/bin/device_config get attention_manager_service enable_flip_to_screen_off) || abort "Cannot read DeviceConfig"
  case "$ORIGINAL" in true|false|null) ;; *) abort "Unexpected DeviceConfig result: $ORIGINAL" ;; esac
  printf '%s\n' "$ORIGINAL" > "$MODPATH/original"
fi
if [ -f "$OLD/choice" ]; then
  cp "$OLD/choice" "$MODPATH/choice" || abort "Cannot preserve choice"
else
  printf 'false\n' > "$MODPATH/choice"
fi
set_perm_recursive "$MODPATH" 0 0 0755 0644
for SCRIPT in "$MODPATH"/*.sh; do
  set_perm "$SCRIPT" 0 0 0755
done
ui_print "Choose the setting to apply after reboot."
/system/bin/sh "$MODPATH/action.sh" --install || abort "Selection failed; installation cancelled."
SELECTED=$(cat "$MODPATH/choice")
case "$SELECTED" in true|false) ;; *) abort "Invalid saved choice" ;; esac
ui_print "SUCCESS: module configured with flip-to-screen-off = $SELECTED"
ui_print "Reboot to activate. You can change it later with Action."
ui_print "Finishing in 5 seconds..."
sleep 5
