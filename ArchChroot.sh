#!/bin/bash
#
# Arch chroot install script
#

#Define drive params
DRIVE="$1"

#Print all commands
set -x

#Configure basic stuff
echo arch-server > /etc/hostname
ln -sf /usr/share/zoneinfo/America/Chicago /etc/localtime
echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /etc/locale.conf

#Configure network
pacman -S net-tools
MAC=`cat /sys/class/net/e*/address`
echo "SUBSYSTEM==\"net\", ACTION==\"add\", ATTR{address}==\"$MAC\", NAME=\"eth0\"" > /etc/udev/rules.d/10-network.rules

systemctl enable systemd-networkd
systemctl enable systemd-resolved
cat > /etc/systemd/network/dhcp.network <<EOL
[Match]
Name=eth0

[Network]
DHCP=ipv4
EOL

#Configure password
echo "Enter root password."
passwd

#Configure bootloader
pacman -S grub
grub-install --modules=part_gpt ${DRIVE}
grub-mkconfig -o /boot/grub/grub.cfg