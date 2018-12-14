#!/bin/sh

# remove password
passwd -d a
# remove motd, uname motd
rm /etc/motd /etc/update-motd.d/10-uname
# allow sudo group to use sudo without password
sed -i -e 's/%sudo.*ALL$/%sudo ALL=(ALL:ALL) NOPASSWD:ALL/g' /etc/sudoers
# add user a to input group
usermod -aG input a
# grub quiet boot
sed -i -e 's/quiet_boot=\"0\"/quiet_boot=\"1\"/g' /etc/grub.d/10_linux
# edit grub for quiet and instant boot
sed -i -e 's/GRUB_TIMEOUT=5/GRUB_TIMEOUT=0/g' /etc/default/grub
sed -i -e 's/GRUB_CMDLINE_LINUX_DEFAULT="quiet"/GRUB_CMDLINE_LINUX_DEFAULT="quiet fastboot loglevel=3 vt.global_cursor_default=0"/g' /etc/default/grub
grub-mkconfig -o /boot/grub/grub.cfg
# auto login
sed -i -e 's/#autologin-user=/autologin-user=a/g' /etc/lightdm/lightdm.conf
# set i3 as default wm
sed -i 's/# user-session = Session to load for users/user-session = i3/g' /etc/lightdm/lightdm.conf
sed -i 's/# autologin-session = Session to load for automatic login (overrides user-session)/autologin-session = i3/g' /etc/lightdm/lightdm.conf
# automatically start lightdm on boot
systemctl enable lightdm
# install system font
sudo cp micross.ttf /usr/share/fonts/truetype/
# disable terminal mail thing
sudo sed -i -e 's/session    optional   pam_mail.so standard/#session    optional   pam_mail.so standard/g' /etc/pam.d/login
cat > "/home/a/launch_this" <<EOF
#!/bin/sh
echo "doing stuff"
# clone my dotfiles into /tmp
git clone https://github.com/melon-mochii/dotfiles /tmp/dotfiles && cd /tmp/dotfiles
# overwrite default i3 config with my config
cp config /home/a/.config/i3
# copy my i3status config to the correct location
cp i3status.conf /home/a/.i3status.conf
# overwrite default .Xresources with my .Xresources
cp .Xresources /home/a/.Xresources
# make wallpaper folder
mkdir /home/a/Pictures/wallpapers
# copy wallpapers to wallpaper folder
cp wallpaper4:3.png /home/a/Pictures/wallpapers
rm "/home/a/launch_this"
echo "done doing stuff"
EOF
chmod +x "/home/a/launch_this"
chown a:a "/home/launch_this"

#exec true
