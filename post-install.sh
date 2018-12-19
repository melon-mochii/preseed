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
# disable terminal mail thing
sudo sed -i -e 's/session    optional   pam_mail.so standard/#session    optional   pam_mail.so standard/g' /etc/pam.d/login
sudo sed -i -e 's/session    optional     pam_mail.so standard noenv/#session    optional     pam_mail.so standard noenv/g' /etc/pam.d/sshd# add 32 bit architecture for wine
sudo dpkg --add-architecture i386
cat > "/home/a/launch_this" <<EOF
#!/bin/sh
echo "doing stuff"
# clone my dotfiles into /tmp
git clone https://github.com/melon-mochii/dotfiles /tmp/dotfiles && cd /tmp/dotfiles
# install system font
sudo cp micross.ttf /usr/share/fonts/truetype/
# overwrite default i3 config with my config
cp config /home/a/.config/i3
# copy my i3status config to the correct location
cp i3status.conf /home/a/.i3status.conf
# overwrite default .Xresources with my .Xresources
cp .Xresources /home/a/.Xresources
# make pictures folder
mkdir /home/a/Pictures
# make documents folder 
mkdir /home/a/Documents
# make music folder 
mkdir /home/a/Music
# make wallpaper folder
mkdir /home/a/Pictures/wallpapers
# copy wallpapers to wallpaper folder
cp wallpaper4:3.png /home/a/Pictures/wallpapers
# clone vim source 
cd /usr && sudo git clone https://github.com/vim/vim.git && cd vim  
# compile vim with python support
sudo ./configure --with-features=huge --enable-multibyte --enable-pythoninterp=yes --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/ --enable-python3interp=yes --with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu --enable-gui=gtk2 --enable-cscope --prefix=/usr/local/
# install it
cd /usr/vim && sudo make install
# set vim as default editor
sudo update-alternatives --install /usr/bin/editor editor /usr/local/bin/vim 1
sudo update-alternatives --set editor /usr/local/bin/vim
sudo update-alternatives --install /usr/bin/vi vi /usr/local/bin/vim 1
sudo update-alternatives --set vi /usr/local/bin/vim
sudo make VIMRUNTIMEDIR=/usr/local/share/vim/vim81 
# install plugin manager for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
# download fish source code
curl -fLo /tmp/fish.tar.gz --create-dirs https://github.com/fish-shell/fish-shell/releases/download/2.7.1/fish-2.7.1.tar.gz
# extract it
tar xzf fish.tar.gz
# cd into it
cd fish-2.7.1
# configure, compile, and install
./configure; make; sudo make install
# set default shell as fish
chsh -s /usr/bin/fish
rm "/home/a/launch_this"
echo "done doing stuff"
EOF
chmod +x "/home/a/launch_this"
chown a:a "/home/a/launch_this"

cat > "/home/a/.vimrc" <<EOF
set number
set tabstop=4
set shiftwidth=4
set expandtab
set backspace=indent,eol,start

call plug#begin('~/.vim/plugged')

Plug 'anned20/vimsence'

call plug#end()
EOF

#exec true
