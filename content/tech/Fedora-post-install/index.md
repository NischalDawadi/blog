+++
title = 'Post-install setup for Fedora Linux'
summary= "Small guide to post install setup for fedora."
date = 2025-11-05T17:20:58+05:45
tags= ["linux", "fedora"]
keywords= ["linux", "kde", "fedora"]
author= "Nischal Dawadi"
[cover]
  image = "/images/fedora.jpg"
+++

# Fedora Post-Install Setup Guide

A minimal setup reference for Fedora users to enable essential repositories, drivers, codecs, and performance tweaks.

## RPM Fusion & Terra

Fedora ships with several repositories disabled by default.  
To access free and non-free software like Steam, Discord, or certain codecs, enable them:

```
sudo dnf install \
https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

```

To enable **Terra**:

```
sudo dnf install --nogpgcheck --repofrompath 'terra,https://repos.fyralabs.com/terra$releasever' terra-release

```

Update appstream metadata:

```
sudo dnf group upgrade core
sudo dnf4 group install core

```



## Update System

Use the Software Center → Update  
or run:

```
sudo dnf -y update 

```

Then reboot your system.


## Firmware

If your device supports updates through LVFS, refresh and apply firmware updates:

```
sudo fwupdmgr refresh --force
sudo fwupdmgr get-devices
sudo fwupdmgr get-updates
sudo fwupdmgr update

```


## Flatpak

Enable full Flathub access (for non-free and third-party apps):

```
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
```

Allow Flatpak installs per-user (optional):

```
flatpak remote-add --user --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
```


## AppImage

For AppImage support:

```
sudo dnf install fuse
```

Optional AppImage manager:

```
flatpak install it.mijorus.gearlever
```


## NVIDIA Drivers

Only for systems with supported NVIDIA GPUs (GT/GTX 600 series or newer).

```
sudo dnf update
```

Reboot, then install drivers:

```
sudo dnf install akmod-nvidia
sudo dnf install xorg-x11-drv-nvidia-cuda  # for CUDA apps
```

Wait a few minutes for the kernel module to build:

```
modinfo -F version nvidia
```

Then reboot again.


## Media Codecs

Enable full multimedia playback support:

```
sudo dnf4 group install multimedia
sudo dnf swap 'ffmpeg-free' 'ffmpeg' --allowerasing
sudo dnf upgrade @multimedia --setopt="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf group install -y sound-and-video
```


## Hardware Video Acceleration

Improves playback and reduces CPU load.

```
sudo dnf install ffmpeg-libs libva libva-utils
```

### Intel

```
sudo dnf swap libva-intel-media-driver intel-media-driver --allowerasing
sudo dnf install libva-intel-driver
```

### AMD

Restore codec support:

```
sudo dnf swap mesa-va-drivers mesa-va-drivers-freeworld
sudo dnf swap mesa-vdpau-drivers mesa-vdpau-drivers-freeworld
sudo dnf swap mesa-va-drivers.i686 mesa-va-drivers-freeworld.i686
sudo dnf swap mesa-vdpau-drivers.i686 mesa-vdpau-drivers-freeworld.i686
```


### OpenH264 for Firefox

```
sudo dnf install -y openh264 gstreamer1-plugin-openh264 mozilla-openh264
sudo dnf config-manager setopt fedora-cisco-openh264.enabled=1
```

Then enable the OpenH264 plugin in Firefox settings.


## System Tweaks

### Set Hostname

```
hostnamectl set-hostname YOUR_HOSTNAME
```

### Restore Default Firefox Start Page

```
sudo rm -f /usr/lib64/firefox/browser/defaults/preferences/firefox-redhat-default-prefs.js
```


### Fix Dual-Boot Time Sync

```
sudo timedatectl set-local-rtc 0
```



## Performance & Optimization

### Enable NVIDIA Modeset

```
sudo grubby --update-kernel=ALL --args="nvidia-drm.modeset=1"
```

### Disable Boot Delay

Speeds up boot by disabling the wait service:

```
sudo systemctl disable NetworkManager-wait-online.service
```


## Recommended Apps

### Compression Support

```
sudo dnf install -y unzip p7zip p7zip-plugins unrar
```

### Useful Applications

```
Blender, Brave, Discord, Easyeffects, Flatseal, Foliate, GIMP
Krita, Obsidian, OnlyOffice, qBittorrent, VS Codium, yt-dlp

```

### Wallpaper

https://github.com/NischalDawadi/Wallpapers

---
  
**Credit**: https://github.com/devangshekhawat/Fedora-43-Post-Install-Guide

