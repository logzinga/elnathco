#!/bin/bash

echo "Are you connected to the internet? [ y / n ]"
read INTERNETCONNECTION

if [ $INTERNETCONNECTION = n ]
    then
        echo "You must be connected to the internet to continue" # This asks the user if they are connected to the internet, important for installation
        sleep 2
        clear 
        exit
fi

clear

timedatectl set-ntp true
# These two commands make sure the time is set correctly
hwclock -w

clear

echo "Partitioning..."
sleep 1
parted /dev/sda mklabel gpt
parted /dev/sda mkpart "EFI" fat32 1MiB 301MiB # These set of commands help create the hard drive and makes it easy to use.
parted /dev/sda set 1 esp on

parted /dev/sda mkpart "swap" linux-swap 301MiB 8GiB # Creates SWAP

parted /dev/sda mkpart "root" ext4 8GiB 100% # Creates usable Hard Drive space

mkfs.ext4 /dev/sda3
mkswap /dev/sda2   # Formats Drives
mkfs.fat -F 32 /dev/sda1

mount /dev/sda3 /mnt 
mount --mkdir /dev/sda1 /mnt/boot # Mounts all of the drives
swapon /dev/sda2

clear
echo "Installing Packages..."
sleep 1
pacman -Sy archlinux-keyring --noconfirm # Makes sure the archlinux-keyring is up to date
clear
pacstrap /mnt base linux linux-firmware nano dkms plasma sddm networkmanager git grub efibootmgr intel-ucode amd-ucode sudo pulseaudio firefox dolphin flatpak packagekit-qt5 fwupd wine winetricks telepathy-accounts-signon telepathy-farstream telepathy-gabble telepathy-glib telepathy-haze telepathy-idle telepathy-kde-accounts-kcm telepathy-kde-approver telepathy-kde-auth-handler telepathy-kde-call-ui telepathy-kde-common-internals telepathy-kde-contact-list telepathy-kde-contact-runner telepathy-kde-desktop-applets telepathy-kde-filetransfer-handler telepathy-kde-integration-module telepathy-kde-meta telepathy-kde-send-file telepathy-kde-text-ui telepathy-mission-control telepathy-morse telepathy-qt telepathy-salut libreoffice # Installs linux and plasma

clear 
echo "Finishing up..."
sleep 1
genfstab -U /mnt >> /mnt/etc/fstab # Generates FSTAB, for remembering what drives are used for what thing
cp setup2.sh /mnt/usr/bin/setup # moves setup file so you can type setup to start 2nd part

clear

echo "When you are ready to proceed with setup, type 'setup'"
arch-chroot /mnt # Arch is installed to the bare minimum
