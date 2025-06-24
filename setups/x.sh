sudo pacman -S xorg-server xorg-xinit xorg-xauth xorg-xmessage xorg-xrdb xorg-xprop xf86-input-libinput xorg-xrandr libx11 libxft libxinerama ttf-dejavu ttf-liberation noto-fonts mesa mesa-utils --noconfirm

sudo usermod -aG video,input $USER
newgrp video
newgrp input
