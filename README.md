#Arch Install Scripts
These are scripts I wrote to install a general setup of Arch with some common utilities I use.

For customization, look into the ArchPost.sh script which is the script you run after first installation.

Basic idea is to download the three files and then run the main ArchInstall.sh script.

Example:
```bash
wget https://raw.githubusercontent.com/GRMrGecko/Arch/master/ArchInstall.sh
wget https://raw.githubusercontent.com/GRMrGecko/Arch/master/ArchChroot.sh
wget https://raw.githubusercontent.com/GRMrGecko/Arch/master/ArchPost.sh
chmod +x ArchInstall.sh
./ArchInstall.sh
```

ArchInstall.sh will ask you for the drive to install to and it will also ask how large to make the swap partition. Usually the idea is to make the swap the same size as the amount of ram, but you can probably go with 4GB fine.

To find which drive is the one you want to use, smartctl -i on each device to get information on the drive. Example:
```bash
smartctl -i /dev/sda
```

Beware that Arch is not designed for people who are new to Linux.

After ArchInstall.sh script is done, reboot to the installation, login as root and run /ArchPost.sh to install the GUI and such.

#License
Public Domain, I see no reason to copyright or claim ownership of the scripts as it's just everything you'd do to install an OS.