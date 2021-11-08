#!/usr/bin/env bash

change_bar_position() {
    # This function expects RIGHT, LEFT or BOTTOM as argument.
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position "$1"
}

change_theme() {
    gsettings set org.gnome.desktop.interface gtk-theme "Yaru-dark"
    gsettings set org.gnome.desktop.interface icon-theme "Yaru"
}

change_window_controls() {
    gsettings set org.gnome.desktop.wm.preferences button-layout 'close,minimize,maximize:'
}

change_taskbar () {
    gsettings set org.gnome.desktop.interface clock-show-weekday true
    gsettings set org.gnome.desktop.interface clock-show-date false
}