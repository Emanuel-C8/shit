mkdir -p ~/suckless
cd ~/suckless
git clone https://git.suckless.org/dwm
git clone https://git.suckless.org/dmenu
git clone https://git.suckless.org/st

mkdir -p ~/.local/bin
for app in dwm dmenu st; do
	cd ~/suckless/$app
	make clean
	make 
	cp $app ~/.local/bin/
done
if ! echo "$PATH" | grep -q "$HOME/.local/bin"; then
	export PATH=$HOME/.local/bin:$PATH
fi
chmod +x ~/.xinitrc
cp config/unikeyboard config/us /usr/share/X11/xkb/symbols
cp config/00-keyboard.conf /etc/X11/xorg.conf.d/00-keyboard.conf
