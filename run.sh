#!/bin/sh

data_process() {
    mode=$1
    FROM=$2
    TO=$3
    if [[ "$mode" == "load" ]];
    then
        rsync --recursive $HOME/$FROM $PWD/$TO
        echo -e "load $HOME/$FROM -> $PWD/$FROM"
    elif [[ "$mode" == "install" ]];
    then
        rsync --recursive $PWD/$FROM $HOME/$TO
        echo -e "install $PWD/$FROM -> $HOME/$FROM"
    else
        echo "$1: wrong argument: must be [load|install]" >&2
        exit 2
    fi
}

process() {
    mode=$1

    data_process $mode .config/alacritty .config
    data_process $mode .config/dunst .config
    data_process $mode .config/gtk-3.0 .config
    data_process $mode .config/i3 .config
    data_process $mode .config/Kvantum .config
    data_process $mode .config/picom .config
    data_process $mode .config/polybar .config
    data_process $mode .config/rofi .config

    data_process $mode .icons/default .icons

    data_process $mode .gitconfig .
    data_process $mode .gtkrc-2.0 .
    data_process $mode .xinitrc .
    data_process $mode .zshrc .
}

if [[ "$#" -eq 1 ]];
then
    process $1

    systemd-analyze plot > graph.svf
    pacman -Qe > package-list.txt
else
    echo "Usage: $0 [load|install]" >&2
    exit 1
fi