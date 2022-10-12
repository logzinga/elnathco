#!/bin/bash 

systemctl enable NetworkManager
systemctl enable sddm

clear

echo "Setting Timezone to Australia/Sydney..."
sleep 1
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime

clear

hwclock --systohc

clear
cd tmp
git clone https://github.com/logzinga/elnathco
cd elnathco
rm /etc/locale.gen
cp files/locale.gen /etc/
cp files/locale.conf /etc/
rm /etc/pacman.conf
cp files/pacman.conf /etc/pacman.conf
cd /
rm -R elnathco
clear

echo "What would you like to call your computer? (no spaces or special characters)"
read COMPUTERNAME
echo $COMPUTERNAME >> /etc/hostname

clear
echo "Running mkinitcpio..."
mkinitcpio -P

clear
echo "Would you like a root account? (Administrator) [ y / n ]"
read ROOTACC
    if [ $ROOTACC = y]
        then
            echo "Creating Root Account..."
            passwd
            sleep 2
            echo "Account Created!"
fi

clear
echo "Installing bootloader..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub
grub-mkconfig -o /boot/grub/grub.cfg

clear
echo "What is your user account name? (no spaces or special characters)"
read USERACCNAME
echo "Would you like to be Administrator (superuser)? [ y / n ]"
read SUPERUSERACC
    if [ $SUPERUSERACC = y ]
        then
            clear
            useradd -m -G wheel $USERACCNAME
            passwd $USERACCNAME
        fi
    if [ $SUPERUSERACC = n ]
        then
            clear
            useradd -m $USERACCNAME
            passwd $USERACCNAME
        fi