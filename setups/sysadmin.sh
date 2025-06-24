sudo pacman -S tlp htop nnn tmux tree --noconfirm
cp config/dotfiles/tmux.conf ~/.tmux.conf
cp config/pacman.conf /etc
cp config/unikeyboard config/us /usr/share/X11/xkb/symbols
cp config/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf

