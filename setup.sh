#!/bin/bash

echo "Are you connected to the internet? [ y / n ]"
read INTERNETCONNECTION

if [ $INTERNETCONNECTION = n ]
    then
        echo "You must be connected to the internet to continue"
        sleep 2
        clear 
        exit
fi

clear

timedatectl set-ntp true
ntpd -qg
hwclock -w

clear

echo "Partitioning..."
sleep 1
parted /dev/sda mklabel gpt
parted /dev/sda mkpart "EFI" fat32 1MiB 301MiB
parted /dev/sda set 1 esp on

parted /dev/sda mkpart "swap" linux-swap 301MiB 8GiB

parted /dev/sda mkpart "root" ext4 8GiB 100%

mkfs.ext4 /dev/sda3
mkswap /dev/sda2
mkfs.fat -F 32 /dev/sda1

mount /dev/sda3 /mnt 
mount --mkdir /dev/sda1 /mnt/boot
swapon /dev/sda2

clear
echo "Installing Packages..."
sleep 1
pacman -Sy archlinux-keyring --noconfirm
clear
pacstrap /mnt base linux linux-firmware nano dkms plasma sddm networkmanager git grub efibootmgr intel-ucode amd-ucode sudo pulseaudio firefox dolphin flatpak packagekit-qt5 fwupd

clear 
echo "Finishing up..."
sleep 1
genfstab -U /mnt >> /mnt/etc/fstab
cp setup2.sh /mnt/usr/bin/setup

clear

echo "When you are ready to proceed with setup, type 'setup'"
arch-chroot /mnt 
