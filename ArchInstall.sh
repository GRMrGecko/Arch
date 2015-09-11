#!/bin/bash
#
# Arch install script
#

#Define drive params
read -p "Enter driver location: " DRIVE
read -p "Enter swap amount: " DRIVESWAP

#Print all commands
set -x

#Partition drive
parted --script ${DRIVE} "mklabel gpt"
parted --script --align optimal ${DRIVE} "mkpart primary 0% 3MB mkpart primary ext4 3MB -$DRIVESWAP mkpart primary linux-swap -$DRIVESWAP 100%"
parted ${DRIVE} set 1 bios_grub on

#Format drive and mount
mkfs.ext4 ${DRIVE}2
mkswap ${DRIVE}3
mount ${DRIVE}2 /mnt

#Find best mirrors
cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
rankmirrors -n 6 /etc/pacman.d/mirrorlist.backup > /etc/pacman.d/mirrorlist

#Install base
pacstrap /mnt base

cp /etc/pacman.d/mirrorlist.backup /mnt/etc/pacman.d/

#Build the fs table
genfstab -U /mnt >> /mnt/etc/fstab

#Load chroot configuration script
cp ArchChroot.sh /mnt/
chmod +x /mnt/ArchChroot.sh
if [ -f ArchPost.sh ]; then
  cp ArchPost.sh /mnt/
  chmod +x /mnt/ArchPost.sh
else
  echo "ArchPost.sh does not exist."
fi
arch-chroot /mnt /ArchChroot.sh "$DRIVE"
rm /mnt/ArchChroot.sh
umount /mnt