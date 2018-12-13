#!/bin/sh

# remove password
passwd -d a
# remove motd, uname motd
rm /etc/motd /etc/update-motd.d/10-uname
# allow sudo group to use sudo without password
sed -i -e 's/%sudo.*ALL$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers
# auto login
sed -i -e 's/#autologin-user=/autologin-user=a/g' /etc/lightdm/lightdm.conf
# add user a to input group
usermod -aG input a
# grub quiet boot
sed -i -e 's/quiet_boot=\"0\"/quiet_boot=\"1\"/g' /etc/grub.d/10_linux
# edit grub for quiet and instant boot
sed -i -e 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet fastboot loglevel=3 vt.global_cursor_default=0"/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
# install stuff for the system
sudo apt install i3 nitrogen xbacklight alsa-utils pulseaudio
# clone my dotfiles into /tmp
git clone https://github.com/melon-mochii/dotfiles /tmp && cd /tmp/dotfiles
# overwrite default i3 config with my config
cat config > ~/.config/i3
# install system font
sudo cp micross.ttf /usr/share/fonts/truetype/
# delete i3status config (which is in the incorrect location)
sudo rm -rf /etc/i3status.conf
# copy my i3status config to the correct location
cp i3status.conf ~/.i3status.conf
# overwrite default .Xresources with my .Xresources
cp .Xresources ~/.Xresources
# make wallpaper folder
mkdir ~/Pictures/wallpapers
# copy wallpapers to wallpaper folder
cp wallpaper{4:3, 16:9} ~/Pictures/wallpapers
# disable exim4 because who cares
sudo systemctl disable exim4
sudo systemctl stop exim4
# disable terminal mail thing
sudo sed -i -e 's/session    optional   pam_mail.so standard/#session    optional   pam_mail.so standard/g' /etc/pam.d/login
sudo sed -i -e 's/session    optional     pam_mail.so standard noenv/#session    optional     pam_mail.so standard noenv/g' /etc/pam.d/sshd

#exec true
