# Android Disable Shutter Sound

Some Android devices — especially in regions like Japan and South Korea — ship with the **camera shutter sound force-enabled** due to local privacy laws.

This means that even if you mute your phone, the camera will still make a sound when taking a picture

This is a very silly law and feature for two reasons:

- The rule is not enforced for phones from overseas
- The rule does not apply to apps other than the default camera app

This script uses `adb` (Android Debug Bridge) to disable the **forced** shutter sound setting on supported devices.

It is known to work on many Samsung devices, including the Galaxy S23, by changing the `csc_pref_camera_forced_shuttersound_key` system setting.

⚠️ **Disclaimer:** This script may not work on all devices or Android versions.  
Use at your own risk. In some regions, disabling the shutter sound may violate local laws.

## How It Works

The script:

1. Installs `adb` if not already installed.
2. Waits for your device to be connected and authorized.
3. Changes the forced camera shutter sound setting to **Disabled**.
4. Confirms the change with a before/after display.

## Requirements

- A computer running Windows, Linux, or macOS
- USB cable to connect your Android device (or use [wireless debugging](https://developer.android.com/studio/debug/dev-options) if you don't have a USB cable)
- **Developer Options** and **USB Debugging** enabled on the device

## Enabling Developer Options

If you have not already enabled Developer Options:

1. On your phone, open **Settings**.
2. Scroll down and tap **About phone** (on some devices, go to **Settings → System → About phone**).
3. Tap **Build number** **seven times** quickly.
   - You may be asked to enter your PIN/password.
4. You should see a message saying **"You are now a developer!"**.
5. Go back to **Settings**, then **Developer options**.
6. Enable **USB debugging**.

## Usage

### Linux / macOS

```bash
chmod +x disable_shutter.sh
./disable_shutter.sh
```

### Windows

```cmd
disable_shutter.bat
```

**Note:** On Windows, ADB is not installed automatically. You can install it via:

- [Download Platform Tools](https://developer.android.com/studio/releases/platform-tools)
- `choco install adb`
- `winget install Google.PlatformTools`
