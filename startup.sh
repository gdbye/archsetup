sudo pacman -Syu

#main programm install
sudo pacman -S git firefox kitty discord spotify steam htop curl wget powerline-fonts rofi nvim polybar pywal networkmanager_dmenu nerd-fonts fantasque-sans-mono noto-fonts-extra ttf-droid terminus-font ranger sddm openbox

#yay install
sudo pacman -S --needed git base-devel
git clone https://aur.archlinux.org/yay-bin.git
cd yay-bin
makepkg -si

#yay main programm install
yay -S github-desktop-bin prismlauncher jetbrains-toolbox spicetify-cli discord-screenaudio ttf-icomoon-feather material-icons-git siji-ttf siji-git

#spicetify(spotify custom install)
sudo chmod a+wr /opt/spotify
sudo chmod a+wr /opt/spotify/Apps -R

#zsh with plugins
pacman -S zsh
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#oh-my-zsh install
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

#nvchad
git clone https://github.com/NvChad/NvChad ~/.config/nvim --depth 1 && nvim

#custom polybar install
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git
cd polybar-themes
chmod +x setup.sh
./setup.sh

#custom rofi install
git clone --depth=1 https://github.com/adi1090x/rofi.git
cd rofi
chmod +x setup.sh
./setup.sh

#kitty terminal custimazer
cd $HOME
git clone https://github.com/adi1090x/kitty-cat
cd kitty-cat
./install

#openbox setup
mkdir -p ~/.config/openbox
cp /etc/xdg/openbox/* ~/.config/openbox/
echo "polybar --config=~/.config/polybar/config top &" > ~/.config/openbox/autostart
echo "rofi -show drun -display-drun \"Applications\" -sidebar-mode &" > ~/.config/openbox/autostart

chsh -s $(which zsh)

#sddm enable
sudo systemctl enable sddm
sudo systemctl restart sddm
