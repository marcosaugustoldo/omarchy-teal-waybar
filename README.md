# Omarchy Teal Waybar & Hyprland Scripts

A highly customized, modular Waybar configuration designed for the Omarchy ecosystem. It features a floating island design and deep integration with custom Hyprland scripts for window minimization, Pomodoro tracking, and system updates.

![https://i.ibb.co/QLtRxxW/screenshot-2026-04-16-16-00-05.png](https://i.ibb.co/QLtRxxW/screenshot-2026-04-16-16-00-05.png)

## Features

- **Modular Island Design**: Clean separated sections for workspaces, system status, and hardware controls.
- **Window Minimization**: Custom logic to send windows to a `special:minimized` workspace and restore them via Walker, tracked directly on Waybar.
- **Pomodoro Timer**: Integrated focus timer with visual progress (●●○○), system notifications, audio cues, and automatic Markdown logging to Obsidian.
- **Update Indicators**: Custom modules for Arch Linux (pacman/AUR) and Flatpak updates with tooltip counts.
- **Floating UI**: Uses transparency and blur effects matching the Teal color palette.

## Layout Overview

| Section | Modules Included |
|:---:|---|
| **Left** | Hyprland Workspaces with custom icons. |
| **Center** | Clock, Pomodoro, Minimized Windows Count, Update Indicators (Arch/Flatpak), AI Status. |
| **Right** | Media Control (MPRIS), Expandable Tray, Network, Bluetooth, Audio, and Battery. |

## Prerequisites

This configuration depends on the following tools:
- `waybar-hyprland` (or `waybar`)
- `hyprctl` & `jq` (for window minimization logic)
- `walker` (for the window switcher UI)
- `checkupdates`, `yay`, `flatpak` (for updates)
- `playerctl` & `pamixer` (for media/audio)
- `JetBrainsMono Nerd Font`

## Installation

### Step 1: Clone and Install
The easiest way to install is using the provided script which handles file placement in both `~/.config/waybar` and `~/.config/hypr`, sets script permissions, and backs up your old bar automatically.

```bash
git clone https://github.com/marcosaugustoldo/omarchy-teal-waybar.git
cd /omarchy-teal-waybar
chmod +x install.sh
./install.sh
```

### Step 2: Hyprland Keybindings
To actually trigger the window minimization, you need to add a keybinding to your `~/.config/hypr/hyprland.conf`. Example:

```conf
# Minimize active window
bind = SUPER, M, exec, ~/.config/hypr/_scripts/minimize/minimize.sh
```

### Step 3: Configure Obsidian Vault (Pomodoro)
The Pomodoro script logs completed focus sessions to an Obsidian Markdown file. Edit `./scripts/pomodoro/pomodoro_control.sh` before or after installation to match your Vault path:
```bash
VAULT_DIR="$HOME/Obsidian Vaults/Marcos Augusto"
```

## Usage

- **Pomodoro**: Click the Waybar module to Start/Pause. Right-click to Reset. After 4 sessions, a 15-minute long break is triggered.
- **Minimized Windows**: Press `Super + M` (if configured) to minimize. Click the Waybar minimized counter module to open the Walker selector and restore the window.
- **Updates**: Click on Update Icons to open a floating terminal and perform system updates.
- **Clock**: Left Click to open calendar. Right Click to launch Notion Calendar webapp.

---
*Part of the Omarchy Teal Suite.*
