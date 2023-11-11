This repository will be documenting my adventure to setting up [Steam Link](https://store.steampowered.com/app/353380/Steam_Link/) on my [Raspberry Pi 4 Model B](https://www.amazon.com/Raspberry-Model-2019-Quad-Bluetooth/dp/B07TC2BK1X) devices. My goal is to stream games from my desktop (*Host A* below) to my projector at **1920x1080**@**120Hz** (FPS). I'm *currently* running into issues which is why I'll be listing everything here and posting online for help if I can't find anything.

## Setup
### Host A Setup (Desktop)
* RTX 3090 TI
* AMD Ryzen 9 5900X (12c/24t)
* 64 GBs DDR4 RAM
* 2 x 2 TBs NVMe (Samsung 970 EVO and Samsung 980 PRO)
* 1 gbps on-board NIC (wired)

### Host B Setup (Laptop)
* GTX 1660 TI
* AMD Ryzen 7 4800H (8c/16t)
* 16 GBs DDR4 RAM
* 5GHz WiFi (not used with Steam Link)
* 1 gbps on-board NIC (used with Steam Link)

**This deviced is only used for testing to make sure there aren't any issues with Host A**

### Steam Link Device #1
* Raspberry Pi 4 Model B
* Runs Raspberry OS Buster (10) LITE with kernel 5.1
* 16 GBs MicroSD card
* Wired Ethernet for Steam Link (1 gbps)

### Installing Steam Link
Installing Steam Link on Raspberry OS Buster (10) was the easiest for me. All I ran was the following after setting up the OS.

```bash
# Upgrade packages.
sudo apt update && sudo apt upgrade -y

# Reboot
sudo reboot

# Install Steam Link
sudo apt install -y steamlink
```

### Steam Link Settings
*To Do...*

### Steam Link Device #2
* Raspberry Pi 4 Model B
* Runs Raspberry OS Bullseye (11) with kernel 6.1.46
* 128 GBs MicroSD card
* Wired Ethernet for Steam Link (1 gbps)

### Installing Steam Link
Installing Steam Link on Raspberry OS Bullseye (11) was a little more complicated. I used [this](https://raw.githubusercontent.com/icolwell/install_scripts/master/steamlink_install.bash) install script.

```bash
# Retrieve install script by Icolwell
wget https://raw.githubusercontent.com/icolwell/install_scripts/master/steamlink_install.bash

# Run the script
./steamlink_install.bash
```

### Steam Link Settings
*To Do...*

### Projector
[BenQ TH685P](https://www.amazon.com/dp/B09V22YRMJ) running at 1920x1080p@120Hz (FPS)

### Monitor For Testing
When not using the projector (e.g. I'm at my desk), I use an [Acer KC242Y](https://www.amazon.com/dp/B0BS9T3FNB) monitor (100 Hz) with [this](https://www.amazon.com/dp/B0C6GF5S14) KVM switch for testing the Steam Link devices.

## Current Status
### Steam Link Device #1
Running Steam Link on this device has the lowest latency and lowest frame loss percentage. It seems Buster (10) is the most stable OS for Steam Link with the Raspberry Pi with the testing I've concluded so far.

Unfortunately, issue #1 (below) impacts this device regardless of public/beta Steam Link builds. However, using a keyboard/mouse results in mostly smooth gameplay.

**Display Latency** - Around 20 - 30ms
**Frame Loss Percentage** - Up to 7 - 8% (no packet loss)

### Steam Link Device #2
Running Steam Link on this device has the highest latency and highest frame loss percentage. While it is still somewhat playable with a keyboard/mouse, I would definitely prefer running Raspberry OS Buster (10) since that is the most stable.

Unfortunately, issue #1 (below) also impacts this device regardless of public/beta Steam Link builds. Using the keyboard/mouse doesn't have issues, but the latency/frame loss is still noticeably higher compared to device #1.

**Display Latency** - 30 - 50ms (with spikes up to 60ms0
**Frame Loss Percentage** - Up to 30% (no packet loss)

## Issues
### Controllers Causing High Latency (#1)
**Resolved** - No  
**Impacts** - All Devices


