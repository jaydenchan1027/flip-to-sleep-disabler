Flip to Sleep Disabler 1 — KernelSU

Install this ZIP in KernelSU Manager > Modules. During installation, press
Volume Up (true) or Volume Down (false), then reboot to apply the chosen setting.
Installation and successful Action show a success message and wait 5 seconds
before their script finishes. The Manager controls whether the screen closes.
Tap this module's Action button, then press a volume key:
Volume Up: enable flip-to-screen-off (true).
Volume Down: disable flip-to-screen-off (false).
No key within 30 seconds: no change.

If no key is pressed during installation within 30 seconds, a fresh install
uses false; an update keeps the previous choice. Installation only saves the
choice, which is applied after reboot. A successful Action applies immediately,
verifies the value, and saves it for subsequent boots. Updates preserve choice.
No system overlay, Zygisk, or SELinux policy modification is used.
Requires KernelSU Manager with Action support and root access to getevent.

Disabling the module stops boot reapplication but does not undo the stored
DeviceConfig value. Uninstall attempts to restore the value captured on first
installation (including any override set before installation).
To manually return to the ROM default in a root terminal:
/system/bin/device_config delete attention_manager_service enable_flip_to_screen_off

If Action reports inability to read volume keys, share its output; no broad
SELinux changes are included. The normal Android volume level may also change.
DeviceConfig changes by ColorOS later in a session are not continuously blocked.

Author: Jayden
Credits: Developed by Jayden in collaboration with ChatGPT.
ChatGPT assisted with scripting, documentation, and simulated validation.
Compatibility: Android 12+ firmware that honors the
attention_manager_service / enable_flip_to_screen_off DeviceConfig flag.
Support is not guaranteed on every Android device or firmware.
Works on OnePlus 13T running ColorOS 16.0.10.500 (user-reported).
The underlying setting was confirmed working by the user; module script paths
were checked with shell syntax validation and simulated tests.
KernelSU module format: https://kernelsu.org/guide/module.html
