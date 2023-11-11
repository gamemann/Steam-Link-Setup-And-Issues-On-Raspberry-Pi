This repository will be documenting my adventure to setting up [Steam Link](https://store.steampowered.com/app/353380/Steam_Link/) on my [Raspberry Pi 4 Model B](https://www.amazon.com/Raspberry-Model-2019-Quad-Bluetooth/dp/B07TC2BK1X) devices.

My goal is to stream games from my desktop (*Host A* below) to my projector at **1920x1080**@**120Hz** (FPS). I'm *currently* running into issues which is why I'll be listing everything here and posting online for help if I can't find a solution.

## My Setup
My general setup may be found [here](https://github.com/gamemann/Home-Lab).

### Host A Setup (Desktop)
* Windows 11 (22H2)
* RTX 3090 TI
* AMD Ryzen 9 5900X (12c/24t)
* 64 GBs DDR4 RAM
* 2 x 2 TBs NVMe (Samsung 970 EVO and Samsung 980 PRO)
* 1 gbps on-board NIC (wired)

### Host B Setup (Laptop)
* Linux (Ubuntu 23.04 with kernel `6.2.0-20-generic`)
* GTX 1660 TI
* AMD Ryzen 7 4800H (8c/16t)
* 16 GBs DDR4 RAM
* 1 TB NVMe
* 5GHz WiFi (not used with Steam Link)
* 1 gbps on-board NIC (used with Steam Link)

**This deviced is only used for testing to make sure there aren't any issues with Host A. There has been no difference between host A and B when testing and issues have remained the same.**

### Steam Link Device #1
* Raspberry Pi 4 Model B
* Runs Raspberry OS Buster (10) LITE (no desktop GUI) with kernel 5.1
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
* Runs Raspberry OS Bullseye (11) LITE (no desktop GUI) with kernel 6.1.46
* 128 GBs MicroSD card
* Wired Ethernet for Steam Link (1 gbps)

### Installing Steam Link
Installing Steam Link on Raspberry OS Bullseye (11) was a little more complicated. I used [this](https://raw.githubusercontent.com/icolwell/install_scripts/master/steamlink_install.bash) install script.

```bash
# Upgrade packages.
sudo apt update && sudo apt upgrade -y

# Reboot
sudo reboot

# Retrieve install script by Icolwell
wget https://raw.githubusercontent.com/icolwell/install_scripts/master/steamlink_install.bash

# Run the script to install Steam Link
./steamlink_install.bash
```

### Steam Link Settings
*To Do...*

### Projector
[BenQ TH685P](https://www.amazon.com/dp/B09V22YRMJ) running at 1920x1080p@120Hz (FPS)

### Controllers
* [Xbox Core Wireless Controller - Carbon Black](https://www.amazon.com/gp/product/B08DF248LD) via BlueTooth (primarily) or USB (for testing).
* [Forty4 Wireless Gaming Controller](https://www.amazon.com/gp/product/B0894RCSV4) via USB dongle. Recognized as Xbox 360 Controller.

#### XPadNeo
I've installed [xpadneo](https://github.com/atar-axis/xpadneo) on all Steam Link devices for controller support with Xbox 360 and Xbox Series S.

```bash
# Install Raspberry Pi kernel headers + DKMS
sudo apt install -y dkms raspberrypi-kernel-headers

# Clone xpadneo
git clone https://github.com/atar-axis/xpadneo.git

# Change directory
cd xpadneo

# Install
sudo ./install.sh

# Reboot
sudo reboot
```

I've had a lot of issues with pairing my Xbox Core Wireless Controller through BlueTooth in the past. However, I found this time around that stock installs of Buster (10) and Bullseye (11) with the `xpadneo` driver works *without* any other steps such as disabling ERTM or SAP. To pair my controllers through BlueTooth, I normally execute the following commands.

```bash
sudo bluetoothctl

# Will go into BlueTooth CLI...

# Set default agent (probably not needed, but I like doing it just in case)
default-agent

# Start scanning for devices
scan on

# Start pairing Xbox controller and find/copy MAC address of controller...

# Pair/connect to controller
connect <mac address>

# Wait until it connects, it should vibrate and have a steady light...

# Trust controller so I don't have to repair
trust <mac address>

# To remove, unpair, and untrust device, just execute the following
remove <mac address>

# To leave, use exit command
exit
```

### Systemd Service
I used a simple systemd service to automatically start Steam Link on boot and also to reopen it if Steam Link closes (I would at times accidently close Steam Link with my controller).

`nano /etc/systemd/system/steamlink.service` and paste the following.

```bash
[Unit]
Description=Steam Link

[Service]
Type=simple
User=pi
ExecStart=/usr/bin/steamlink
Restart=always

[Install]
WantedBy=multi-user.target
```

Afterwards, I enable the service and reboot with the following commands.

```bash
# Enable service on boot (systemctl daemon-reload shouldn't be needed if it's a new file)
sudo systemctl enable steamlink

# Reboot
sudo reboot
```

**Note A** - If you have a different user other than `pi`, make sure to change the `User=pi` line to whatever user you want Steam Link starting with (e.g. `User=christian`).
**Note B** - I would also recommend having OpenSSH enabled on the Steam Link device if `Restart=always` is present in the `systemd` file since it will keep restarting Steam Link after exiting through the main TTY (until it reaches fail count). You can enable the OpenSSN service by executing `sudo raspi-config` and then navigating to Interfaces -> SSH (on Buster and Bullseye).

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

**Display Latency** - 30 - 50ms (with spikes up to 60ms  
**Frame Loss Percentage** - Up to 30% (no packet loss)

## Issues
### Controllers Causing High Latency (#1)
**Resolved** - No  
**Impacts** - All Devices

Currently, when I use any controllers listed under setup through USB, bluetooth, or dongle, I start receiving very high display latency making everything unplayable through the game stream. This impacts all Steam Link devices regardless of OS release, kernel, and Steam Link version (public/beta).

*More information with screenshots + video coming soon...*


