#!/system/bin/sh
NS=attention_manager_service
KEY=enable_flip_to_screen_off
get_value() { /system/bin/device_config get "$NS" "$KEY"; }
apply_value() {
  case "$1" in true|false) ;; *) return 1 ;; esac
  /system/bin/device_config put "$NS" "$KEY" "$1" || return 1
  [ "$(get_value)" = "$1" ]
}
