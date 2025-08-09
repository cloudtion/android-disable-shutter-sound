# Android Disable Shutter Sound

Some Android devices — especially in regions like Japan and South Korea — ship with the **camera shutter sound force-enabled** due to local privacy laws.  
This means that even if you mute your phone, the camera will still make a sound when taking a picture.

This script uses `adb` (Android Debug Bridge) to disable the **forced** shutter sound setting on supported devices.  
It is known to work on many Samsung devices, including the Galaxy S23, by changing the `csc_pref_camera_forced_shuttersound_key` system setting.

> ⚠️ **Disclaimer:** This script may not work on all devices or Android versions.  
> Use at your own risk. In some regions, disabling the shutter sound may violate local laws.

---

## How It Works
The script:
1. Installs `adb` if not already installed.
2. Waits for your device to be connected and authorized.
3. Changes the forced camera shutter sound setting to **Disabled**.
4. Confirms the change with a before/after display.

---

## Requirements
- A computer running Linux or macOS  
- USB cable to connect your Android device  
- **Developer Options** and **USB Debugging** enabled on the device

---

## Usage
```bash
chmod +x disable_shutter.sh
./disable_shutter.sh
