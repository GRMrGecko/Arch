#!/bin/bash
#
# Arch post install script
#

#Print all commands
set -x

ln -sf /run/systemd/resolve/resolv.conf /etc/resolv.conf
pacman -S xorg-server gnome gnome-extra plank gnome-do firefox wget cronie libva-vdpau-driver mesa-vdpau vdpauinfo cpio bc imagemagick fuse gtkmm linux-headers argyllcms ntp
#Nvidia
#pacman -S xorg-server gnome gnome-extra plank firefox wget cronie nvidia nvidia-libgl libva-vdpau-driver mesa-vdpau vdpauinfo cpio bc imagemagick fuse gtkmm linux-headers argyllcms ntp
systemctl enable cronie
systemctl enable gdm
systemctl start ntpd
systemctl enable ntpd

#Setup sudo
pacman -S sudo
echo "%wheel ALL=(ALL) ALL" >> /etc/sudoers

#Add first user account
read -p "Enter username: " USERNAME
useradd -m -G wheel -s /bin/bash $USERNAME
echo "Enter password"
passwd $USERNAME

#Set startup applications.
mkdir -p /home/$USERNAME/.config/autostart
chown -R $USERNAME:$USERNAME /home/$USERNAME/.config/
cp /usr/share/applications/plank.desktop /home/$USERNAME/.config/autostart/plank.desktop
cat > /home/$USERNAME/.config/autostart/gnome-do.desktop <<EOL
[Desktop Entry]
Name=GNOME Do
Type=Application
Exec=gnome-do
Terminal=false
Icon=gnome-do
Comment=Do things as quickly as possible (but no quicker) with your files, bookmarks, applications, music, contacts, and more!
Categories=Utility;
Hidden=false
EOL

#Install ssh
pacman -S openssh
systemctl enable sshd

#Prepare for Development
pacman -S base-devel yasm intltool

mkdir -p /opt/src
chown -R $USERNAME:$USERNAME /opt

#AUR Package Manager
cd /home/$USERNAME
pacman -S diffutils gettext rsync yajl
sudo -u $USERNAME wget https://aur.archlinux.org/cgit/aur.git/snapshot/package-query.tar.gz
sudo -u $USERNAME tar -xzf package-query.tar.gz
cd package-query
sudo -u $USERNAME makepkg -sri
cd ..

sudo -u $USERNAME wget https://aur.archlinux.org/cgit/aur.git/snapshot/yaourt.tar.gz
sudo -u $USERNAME tar -xzf yaourt.tar.gz
cd yaourt
sudo -u $USERNAME makepkg -sri
cd ..

#Media Player
pacman -S smplayer youtube-dl rtmpdump atomicparsley mkvtoolnix-cli mkvtoolnix-gtk mediainfo mediainfo-gui
sudo -u $USERNAME gpg --keyserver pool.sks-keyservers.net --recv-keys 0xD67658D8
sudo -u $USERNAME yaourt -S opencl-headers12-svn
sudo -u $USERNAME yaourt -S mpv-git
sudo -u $USERNAME yaourt -S ffmpeg-full

#VirtualBox
pacman -S virtualbox vde2 virtualbox-guest-iso virtualbox-host-dkms
modprobe vboxdrv
modprobe vboxnetflt
echo vboxdrv > /etc/modules-load.d/virtualbox.conf
echo vboxnetflt >> /etc/modules-load.d/virtualbox.conf

#Random tools
pacman -S nmap filezilla gparted go p7zip exfat-utils fuse-exfat nload iftop iotop lsof

sudo -u $USERNAME yaourt -S sublime-text-dev

gsettings set org.gnome.desktop.wm.preferences button-layout 'close:appmenu'