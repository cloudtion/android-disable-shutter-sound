#!/usr/bin/env bash

set -e

# Colors for status messages
RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
RESET=$(tput sgr0)

print_status() {
    local value="$1"
    if [[ "$value" == "0" ]]; then
        echo "${GREEN}Disabled${RESET}"
    elif [[ "$value" == "1" ]]; then
        echo "${RED}Enabled${RESET}"
    else
        echo "Unknown ($value)"
    fi
}

echo "[*] Checking if ADB is installed..."
if command -v adb &>/dev/null; then
    echo "[*] ADB is already installed."
else
    echo "[*] Installing ADB..."
    if [[ "$OSTYPE" == "linux-gnu"* ]]; then
        if command -v pacman &>/dev/null; then
            sudo pacman -Sy --needed android-tools
        elif command -v apt &>/dev/null; then
            sudo apt update && sudo apt install -y adb
        elif command -v dnf &>/dev/null; then
            sudo dnf install -y android-tools
        else
            echo "[!] Unsupported Linux package manager. Install adb manually."
            exit 1
        fi
    elif [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &>/dev/null; then
            brew install android-platform-tools
        else
            echo "[!] Homebrew not found. Install Homebrew first."
            exit 1
        fi
    else
        echo "[!] Unsupported OS. Install adb manually."
        exit 1
    fi
fi

echo "[*] Starting ADB server..."
adb start-server

# Spinner animation
spinner="/-\|"
echo -n "[*] Waiting for a connected & authorized device... "
while true; do
    DEVICE_COUNT=$(adb devices | grep -w "device" | grep -v "List" | wc -l)
    if [[ "$DEVICE_COUNT" -ge 1 ]]; then
        echo -e "\r[*] Device detected!                          "
        break
    fi
    for i in {0..3}; do
        printf "\r[*] Waiting for a connected & authorized device... ${spinner:$i:1}"
        sleep 0.2
    done
done

CURRENT_VAL=$(adb shell settings get system csc_pref_camera_forced_shuttersound_key 2>/dev/null || echo "notfound")
echo -n "[*] Current shutter sound setting: "
print_status "$CURRENT_VAL"

echo "[*] Disabling forced camera shutter sound..."
adb shell settings put system csc_pref_camera_forced_shuttersound_key 0

NEW_VAL=$(adb shell settings get system csc_pref_camera_forced_shuttersound_key 2>/dev/null || echo "notfound")
echo -n "[*] New shutter sound setting: "
print_status "$NEW_VAL"

echo "[*] Done! You may need to reboot or restart the camera app."
