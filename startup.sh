#!/bin/bash

#main programm install
sudo pacman -S git firefox kitty discord spotify-launcher steam htop curl wget powerline-fonts rofi vim neovim polybar python-pywal networkmanager nerd-fonts fantasque-sans-mono noto-fonts-extra ttf-droid terminus-font ranger plank

#yay install
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

#yay main programm install
yay -S github-desktop-bin prismlauncher jetbrains-toolbox spicetify-cli discord-screenaudio ttf-icomoon-feather material-icons-git siji-ttf siji-git pamac

#spicetify(spotify custom install)
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R


