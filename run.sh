#!/bin/sh

data_process(){
    mode=$1
    FROM=$2
    TO=$3
    if [[ "$mode" == "load" ]];
    then
        rsync --recursive ~/$FROM $PWD/$TO
        echo "load $FROM -> $PWD/$TO"
    elif [[ "$mode" == "install" ]];
    then
        rsync --recursive $PWD/$FROM ~/$TO
        echo "install $PWD/$FROM -> ~/$TO"
    else
        echo "no attribute specified..."
    fi
}

process() {
    mode=$1
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
    data_process $mode .zsh_history .
    data_process $mode .zshrc .
}

if [[ "$1" == "load" ]];
then
    process load
elif [[ "$1" == "install" ]];
then
    process install
else
    echo "no attribute specified..."
fi

systemd-analyze plot > graph.html
pacman -Qe > package-list.txt