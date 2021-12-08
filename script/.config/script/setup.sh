!#/bin/sh

pacman -Suy --noconfirm
echo Installing all the needed pacages from main artix/arch repo
pacman -S \
	xorg \
	lightdm \
	lightdm-gtk-greeter \
	lightdm-gtk-greeter-settings \
	xmonad \
	xmonad-contribs \
	pacman-contribs \
	code \
	xss-lock \
	fcitx5 \
	fcitx5-mozc \
	fcitx5-qt \
	fcitx5-gtk \
	font-manager \
	adobe-source-han-sans-jp-fonts \
	arandr \
	lxappearance \
	qt5ct \
	thunar \
	thunar-archive-plugin \
	thunar-volman \
	xfce4-settings \
	tumbler \
	raw-thumbnailer \
	gvfs \
	gvfs-mtp \
	networkmanager \
	networkmanager-openrc \
	network-manager-applet \
	nextcloud-client \
	polkit-gnome \
	nitrogen \
	htop \
	alacritty \
	rofi \
	base-devel \
	noto-fonts-emoji \
	siji \
	neofetch \
	neovim \
	--noconfirm \
echo Pleas provide a username
read name
useradd -m $name
passwd $name
echo adding user to some basic groups
usermod -a -G wheel $name
usermod -a -G video $name
usermod -a -G uucp $name
mv setup2.sh /home/$user/setup2.sh
chown $user:$user /home/$user/setup2.sh
chmod +x /home/$user/setup2.sh
read -p "pleas uncomment the wheel group to alow the user to use 'sudo':Press Enter to continu"
EDITOR=nvim visudo
read -p "The system needs to reboot for the user to be added to the groups. \n \
	after reboot log in as the new user \n \
	Then run setup2.sh found in your home directory \n \
	\n "
read -p "Press y to reboot or leave blanck to exit setup" confirm

if [ $confirm = 'y' ]
then
	reboot
else
	exit 0

