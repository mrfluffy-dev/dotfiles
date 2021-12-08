# Rofi menus

A variety of convenient menus made mainly using [rofi](https://github.com/davatorium/rofi) and its dmenu emulation.

A video showcasing the menus in action is available [here](https://old.reddit.com/r/unixporn/comments/cvqc6s/oc_handy_menus_made_with_rofi/).

[Here is a showcase](https://gitlab.com/vahnrr/rofi-menus/blob/master/colorschemes.md) of the current colorschemes.

![menus-gallery](screenshots/menus-gallery.png)

**List of menus:**
- **Apps:** call rofi in its drun mode to start desktop programmes
- **i3 keybindings:** quick way to list out all the keybindings you defined for [i3wm](https://github.com/i3/i3)
- **i3 layout:** change the current layout of [i3wm](https://github.com/i3/i3)
- **MPD:** control the song you play through [mpd (the Music Player Daemon)](https://github.com/MusicPlayerDaemon/)
- **Network:** Network Manager menu (a themed version of [this original script](https://github.com/firecat53/networkmanager-dmenu))
- **Network Manager VPN:** manage your active vpn connection in a few keystrokes
- **Power:** a classic power menu
- **Screenshot:** take screenshots using either [scrot](https://github.com/dreamer/scrot) or [maim](https://github.com/naelstrof/maim)
- **Prompt:** a simple customisable prompt to ask for confirmation before executing some given instruction

1. [Requirements](https://gitlab.com/vahnrr/rofi-menus#requirements)
    - [Fonts](https://gitlab.com/vahnrr/rofi-menus#fonts)
    - [Packages](https://gitlab.com/vahnrr/rofi-menus#packages)
2. [Installation](https://gitlab.com/vahnrr/rofi-menus#installation)
    - [Arch Linux](https://gitlab.com/vahnrr/rofi-menus#arch-linux)
    - [Manual installation](https://gitlab.com/vahnrr/rofi-menus#manual-installation)
3. [Troubleshooting](https://gitlab.com/vahnrr/rofi-menus#troubleshooting)
4. [Tweaks](https://gitlab.com/vahnrr/rofi-menus#tweaks)
    - [Simpler menu summoning](https://gitlab.com/vahnrr/rofi-menus#simpler-menu-summoning)
    - [Change the colorscheme](https://gitlab.com/vahnrr/rofi-menus#change-the-colorscheme)
    - [Monitor resolution](https://gitlab.com/vahnrr/rofi-menus#monitor-resolution)
    - [Use in i3](https://gitlab.com/vahnrr/rofi-menus#use-in-i3)
    - [Parsable keybindings in i3](https://gitlab.com/vahnrr/rofi-menus#parsable-keybindings-in-i3)
    - [Transparent theme](https://gitlab.com/vahnrr/rofi-menus#transparent-theme)
5. [Contributing](https://gitlab.com/vahnrr/rofi-menus#contributing)
    - [New resolutions](https://gitlab.com/vahnrr/rofi-menus#new-resolutions)
    - [New colorschemes](https://gitlab.com/vahnrr/rofi-menus#new-colorschemes)
    - [Things that could be improved](https://gitlab.com/vahnrr/rofi-menus#things-that-could-be-improved)

## Requirements

### Fonts

The menus uses 3 fonts:

- **Comfortaa** ([preview](https://www.dafont.com/comfortaa.font) and [source](https://www.deviantart.com/aajohan/art/Comfortaa-font-105395949)) used in appsmenu, mpdmenu, nmvpnmenu for the normal text
- **Hurmit Nerd Font Mono** ([preview](https://app.programmingfonts.org/#hermit) and [source](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/Hermit)) used in all the menus for the icons
- **RobotoMono Nerd Font** ([preview](https://app.programmingfonts.org/#roboto) and [source](https://github.com/ryanoasis/nerd-fonts/tree/master/patched-fonts/RobotoMono)) used in networkmenu for the monospace text

If you wish to change them dig in the resolution file you are using: `~/.config/rofi/themes/shared/resolutions/<your_resolution>.rasi`.

**Warning:** changing the `@icon-font` variable to another font has a high chance of messing most menus' layout.

### Packages

First of all make sure you have `rofi` installed:
``` bash
# Arch / Arch-based
pacman -S rofi
# Debian / Ubuntu
apt-get install rofi
# Fedora
dnf install rofi
```

These menus have been made on my machines (1366x768 and 1920x1080 resolutions) with rofi version **1.5.4**, they *might* not work on earlier version although it should be fine.

#### Dependencies for each menus

| Menu           | Package(s)                                                   | Note(s)                                                                                                                                                                                                                                                                 |
|----------------|--------------------------------------------------------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| Apps           | [Paper icon theme](https://github.com/snwh/paper-icon-theme) | Any icon theme would do the job, you can change this in *~/.config/rofi/config.rasi*                                                                                                                                                                                    |
| i3 keybindings | `i3` and `awk`                                               | `awk` is used to parse the i3 config file                                                                                                                                                                                                                               |
| i3 layout      | `i3`                                                         | -                                                                                                                                                                                                                                                                       |
| MPD            | `mpd` and `mpc`                                              | `mpc` is used to interact with `mpd`                                                                                                                                                                                                                                    |
| Network        | `python`                                                     | This script comes from [here](https://github.com/firecat53/networkmanager-dmenu), so if you encounter problems, check the issues there                                                                                                                                  |
| VPN            | `nmcli`, `grep`, `sed` and `bash` >= 4                       | The `mapfile` bash command is used, so `bash` >= 4 is necessary                                                                                                                                                                                                         |
| Power          | `systemctl`, `light-locker`, `mpc`                           | By default `systemctl` is used for most actions, `light-locker` is used for locking/sleeping, `i3-msg exit` is used to log out and `mpc`/`amixer` are used to pause and mute the music when going to sleep, you might want to change these commands to match your setup |
| Screenshot     | `scrot` or `maim` (+ `xdotool` and `xclip`)                  | -                                                                                                                                                                                                                                                                       |

## Installation

After installing please make sure you're using the right resolution, please see [this section](https://gitlab.com/vahnrr/rofi-menus#monitor-resolution).

### Arch Linux

The package is available in the Arch User Repository as [rofi-menus-git](https://aur.archlinux.org/packages/rofi-menus-git).

```
yay -S rofi-menus-git
```

You can then call the menus with these commands:

``` bash
rofi-appsmenu
rofi-i3layout
rofi-mpd
rofi-network
rofi-power
rofi-scrot
rofi-vpn
```

### Manual installation

``` bash
# 1. Go in rofi's config folder
cd ~/.config/rofi
# 2. Copy this repo
git clone https://gitlab.com/vahnrr/rofi-menus.git
# 3. Make sure the scripts are executables
cd rofi-menus && chmod +x scripts/*
# 4. Copy necessary files to the right location
cp -r scripts themes config.rasi ~/.config/rofi
cp -r networkmanager-dmenu ~/.config
# 5. Clean up rofi's config folder
cd .. && rm -r rofi-menus
# 6. Call the scripts (from the scripts folder)
cd scripts
./appsmenu.sh
# (or from anywhere)
. ~/.config/rofi/scripts/appsmenu.sh
```

**Note:** you might want to summon these menus simply by calling the `appsmenu` command, if so, please follow [these instructions](https://gitlab.com/vahnrr/rofi-menus#simpler-menu-summoning).

## Troubleshooting

**First,** check that you have everything (fonts and packages) you need for the menus you want to use in the [Requirements](https://gitlab.com/vahnrr/rofi-menus#requirements) section.
**Then** check your rofi version, I can confirm that it works well with rofi >= **1.5.4**, so make sure you have at least this version.

---

> Menus don't show or only show on part of the screen

Currently these menus only support the following resolutions:
- 1366x768
- 1920x1080

So make sure you're using the right resolution in *~/.config/rofi/themes/shared/settings.rasi*.
If you have a resolution that is not included in the above list, check [this section](https://gitlab.com/vahnrr/rofi-menus#New-resolutions).

---

Don't find any solution? If you checked all the above then consider opening an issue on this repository.

## Tweaks

### Simpler menu summoning

You can add your scripts folder to your `$PATH` variable so that entering `appsmenu` in the terminal (or executing this command) will summon the appsmenu.

The way I do it:
- I store a symlink to my scripts in *~/.local/bin*
- I then add this folder to my `$PATH` using the *~/.profile* file

``` bash
mkdir ~/.local/bin
# Creates the symlinks to the scripts
ln -s ~/.config/rofi/scripts/appsmenu.sh ~/.local/bin/appsmenu
ln -s ~/.config/rofi/scripts/i3keybindingsmenu.sh ~/.local/bin/i3keybindingsmenu
ln -s ~/.config/rofi/scripts/i3layoutmenu.sh ~/.local/bin/i3layoutmenu
ln -s ~/.config/rofi/scripts/maimmenu.sh ~/.local/bin/maimmenu
ln -s ~/.config/rofi/scripts/mpdmenu.sh ~/.local/bin/mpdmenu
ln -s ~/.config/rofi/scripts/networkmenu.py ~/.local/bin/networkmenu
ln -s ~/.config/rofi/scripts/nmvpnmenu.sh ~/.local/bin/nmvpnmenu
ln -s ~/.config/rofi/scripts/powermenu.sh ~/.local/bin/powermenu
ln -s ~/.config/rofi/scripts/promptmenu.sh ~/.local/bin/promptmenu
ln -s ~/.config/rofi/scripts/scrotmenu.sh ~/.local/bin/scrotmenu
# Add our folder to the $PATH variable
echo "PATH=$PATH:~/.local/bin" >> ~/.profile
```

**Note:** after doing this your `$PATH` variable won't be updated, so you will need to log out and then back in to be able to summon the menus this way.

By changing the second path given to `ls` you can change the command to type to summon the menu.

### Change the colorscheme

[Here is a showcase](https://gitlab.com/vahnrr/rofi-menus/blob/master/colorschemes.md) of the current colorschemes.
The files are stored in *~/.config/rofi/themes/shared/colorschemes*.
To change the active colorscheme simply change the import line in *~/.config/rofi/themes/shared/settings.rasi*.

If you wish to change the colorscheme for only one specific menu, you can add the line bellow to the *~/.config/rofi/themes/<menu-name>.rasi* file.

``` css
@import "shared/colorschemes/<colorscheme-name>.rasi"
```

**Note:** it needs to be added **after** the `@import "shared/settings.rasi"` otherwise it would not overwrite the theme from the settings file.

### Monitor resolution

**By default** the menus will use the 1920x1080 resolution.
The files are stored in *~/.config/rofi/themes/shared/resolutions*.
To change the active resolution simply change the import line in *~/.config/rofi/themes/shared/settings.rasi*.

If you don't find the resolution you are using, then please check [this section](https://gitlab.com/vahnrr/rofi-menus#new-resolutions).

### Use in i3

You can call the scripts by giving their fulls paths like *~/.config/rofi/scripts/<script-name>.sh* or follow [these instructions](https://gitlab.com/vahnrr/rofi-menus#simpler-menu-summoning) to call the menus in one word.

Then add these lines to your i3 config file:
```
set $mod Mod4
set $Alt Mod1
bindsym $mod+d exec --no-startup-id appsmenu
bindsym $mod+l exec --no-startup-id i3keybindingsmenu
bindsym $mod+l exec --no-startup-id i3layoutmenu
bindsym $mod+m exec --no-startup-id mpdmenu
bindsym $mod+n exec --no-startup-id networkmenu
bindsym $Alt+v exec --no-startup-id nmvpnmenu
bindsym $mod+p exec --no-startup-id powermenu
bindsym $mod+s exec --no-startup-id maimmenu
```

### Parsable keybindings in i3

The i3 keybindings menu parses your config file (the active one so you will need to restart i3 to get changes listed) using `awk`.
It has been designed to parse my config file, but you may write yours a different way, which might means the parser won't do a great job.

The parser looks for a comment (line starting with `# `).
Then sees if the line after is a keybinding by checking if it starts with `bindsym `.
If it does then it will create an entry in the list.

---

If there is one comment and several keybindings lines following it.
The parser will create an entry for every keybinding but they will have the same description (the comment).
However if your comment contains `$num`, this word will be replaced by the number found in the keybinding, e.g.:

```
# Focus workspace $num
bindsym $Mod+1                  workspace $ws1
bindsym $Mod+2                  workspace $ws2
bindsym $Mod+3                  workspace $ws3
```

Will create the following entries:
- **Mod+1** Focus workspace 1
- **Mod+2** Focus workspace 2
- **Mod+3** Focus workspace 3

**Note:** the \$ character is stripped from keybindings, so `$Mod` turns to **Mod**, `$Alt` to **Alt**, etc.

---

The parser also finds and lists i3's modes and their specific keybindings.
As long as your mode definition has this shape:

```
# Resize mode
bindsym $Mod+r mode "resize"
mode "resize" {
    # Shrink the focused window's width
    bindsym Left                resize shrink width 4
    # Grow the focused window's height
    bindsym Down                resize grow height 4
    # Shrink the focused window's height
    bindsym Up                  resize shrink height 4
    # Grow the focused window's width
    bindsym Right               resize grow width 4
    # Exit resize mode
    bindsym Escape              mode "default"
}
```

It will create the following entries:
- **Mod+r** Resize mode
- ` RESIZE ` **Left** Shrink the focused window's width
- ` RESIZE ` **Down** Grow the focused window's height
- ` RESIZE ` **Up** Shrink the focused window's height
- ` RESIZE ` **Right** Grow the focused window's width
- ` RESIZE ` **Escape** Exit the

### Transparent theme

Because the `background` variable in colorschemes is re-used in the `#horibox` and `#listview` you cannot achieve clean transparency without a few tweaks:
- In *~/.config/rofi/themes/shared/<chosen-colorscheme>.rasi* change the `background` variable to something like `#1c1c1caa`, the last 2 characters being the amount of transparency to use
- Then in *~/.config/rofi/themes/shared/option-menu.rasi* add `background-color: #00000000;` to the following entries: `#horibox` and `#listview`

## Contributing

### New resolutions

Copy one of the resolution file in *~/.config/rofi/themes/shared/resolutions* to the new one (i.e *1024x768.rasi*).

Then tweaks the values so that the menus display properly on your screen, the ones you'll most likely have to change are:
- `*-window-padding`: the whole canvas surounding the controls
- `*-element-padding`: the blank space around the icons/texts

### New colorschemes

These menus were initially published with 3 colorschemes, a fourth has been added after someone contributed his colorscheme file (*gruvbox.rasi*).
So if you have made your own and want to contribute, don't hesitate to open a merge request, including your *<colorscheme>.rasi* and screenshots (also added to *colorschemes.md*).

The colorschemes are located in the *~/.config/rofi/themes/shared/colorschemes* folder.

### Things that could be improved

**Universal resolution:** by using percentages instead of raw pixel values in the resolution files, it might be possible to create a universal resolution file.

---

Find a cleaner way to wait for the first `nmcli` command to be successful in *~/.config/rofi/scripts/nmvpnmenu.sh* as without the `sleep 1` it will throw an error.
But waiting 1 second is neither a safe nor a clean work around.

---

**Widget themes:** for now the menus are full screen, which does not suit everyone, there could be an option to call the scripts with (i.e `appsmenu --widget`).
This option would load an alternative resolution file (i.e *1920x1080-widget.rasi*) and would only display a little window for the menus.

