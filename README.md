# Flip to Sleep Disabler

A KernelSU module to disable Android's automatic face-down screen-off behavior.

## Download and install

[Download Flip-to-Sleep-Disabler-v1.zip](./Flip-to-Sleep-Disabler-v1.zip?raw=true)

1. Install the ZIP in KernelSU Manager under **Modules**.
2. During installation, press **Volume Up** to enable flip-to-screen-off (`true`),
   or **Volume Down** to disable it (`false`).
3. Reboot. Your selected setting is applied automatically.

Use the module's **Action** button to change the setting immediately later.
A successful action displays a success message and waits five seconds before
finishing. Installation also finishes with a success message and five-second pause.

The selection timeout is 30 seconds. During installation, no selection keeps the
previous preference on upgrades or uses `false` on a fresh install. During Action,
no selection leaves the setting unchanged.

## Compatibility

Compatible with **Android 12+ firmware that supports the
`enable_flip_to_screen_off` DeviceConfig flag**. Android version alone does not
guarantee support.

**Works on OnePlus 13T running ColorOS 16.0.10.500 with SukiSU Ultra** (user-reported confirmation
of the underlying setting). Module scripts passed syntax and simulated behavior
checks; the complete module has not been independently tested on hardware.


## How it works

The module sets `enable_flip_to_screen_off` in the
`attention_manager_service` DeviceConfig namespace and verifies the value.
It saves your choice and reapplies it after boot. It does not disable all sensors
or alter your regular screen timeout.


## Disable or uninstall

Disabling the module stops boot reapplication but leaves the current setting.
Uninstalling attempts to restore the override captured at first installation.
To remove the override manually, run in a root terminal:

```sh
/system/bin/device_config delete attention_manager_service enable_flip_to_screen_off
```

## Source and credits

Module source is in [`module/`](./module/). The module ID remains
`flip_screen_toggle` to allow upgrades from earlier development builds.

**ChatGPT** assisted with scripting, documentation, and
simulated validation.
