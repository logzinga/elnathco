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
