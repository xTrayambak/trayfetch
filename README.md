# trayfetch - a lightweight and customizable fetching tool for POSIX-compliant systems
That's it. Oh, and it's designed to be an almost 1:1 replacement for [maxfetch](https://github.com/jobcmax/maxfetch), apart from two stats that I'll add later.

# Docs
Trayfetch is really simple, you can store your configuration at `~/.config/trayfetch/config.toml`. As the filename implies, you can configure trayfetch using TOML.

To enable/disable modules, add/remove them from the `config.enabled` array as you wish.
The following modules are available and are enabled by default:

## user
Your username and user ID.

## host
Your hostname. (eg. nix, ubuntu, homepc, etc.)

## distro
Your software distribution's name

## kernel
Your kernel version. (eg. 6.1.54, 5.15.1, 6.4.1, etc.)

## DE/WM
The desktop environment or window manager you're using, along with the protocol it is using (X11/Wayland)

Eg. KDE Plasma (Wayland), GNOME (Wayland), Hyprland (Wayland), XFCE (X11), Qtile (Wayland), DWM (X11), etc.

## shell
The shell that was used to invoke trayfetch. (eg. zsh, bash, tsh, fish, sh, etc.)

Colors aren't configurable as of yet, but you can simply change them in `src/trayfetch.nim` for now.

You can change the bars that surround the stats, colors section and the end of the fetch using the `top_bar`, `colors_bar` and `bottom_bar` values respectively.

# License
All of trayfetch is licensed under the GNU General Public License v2.
