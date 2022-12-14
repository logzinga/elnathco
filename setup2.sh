#!/bin/bash 

# TODO:
# ARCH ISO SEAMLESS INSTALLER

systemctl enable NetworkManager # Enables Internet
systemctl enable sddm # Enables Login Screen

clear

echo "Setting Timezone to Australia/Sydney..."
sleep 1
ln -sf /usr/share/zoneinfo/Australia/Sydney /etc/localtime # Sets the timezone

clear

hwclock --systohc # Syncs the clock again

clear
cd tmp
git clone https://github.com/logzinga/elnathco
cd elnathco
rm /etc/locale.gen
cp files/locale.gen /etc/
cp files/locale.conf /etc/
rm /etc/pacman.conf
cp files/pacman.conf /etc/pacman.conf # Copies some important files to the install
rm /etc/sudoers
cp files/sudoers /etc/sudoers
cd /
clear

echo "What would you like to call your computer? (no spaces or special characters)"
read COMPUTERNAME
echo $COMPUTERNAME >> /etc/hostname # Sets computer name

clear
echo "Running mkinitcpio..." # Reruns mkinitcpio
mkinitcpio -P

clear
echo "Would you like a root account? (Administrator) [ y / n ]" # Asks if the user wants an Administrator Account
read ROOTACC
    if [ $ROOTACC = y ]
        then
            echo "Creating Root Account..."
            passwd
            sleep 2
            echo "Account Created!"
fi

clear
echo "Installing bootloader..."
grub-install --target=x86_64-efi --efi-directory=/boot --bootloader-id=grub # Creates the bootloader which allows Linux to boot
grub-mkconfig -o /boot/grub/grub.cfg

clear
echo "What is your user account name? (no spaces or special characters)" # Creates User
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

clear
echo "Finalizing Setup..." # Sets up Plasma Welcome and installs steam
cd /tmp
cd elnathco
cd files
mkdir /home/$USERACCNAME/.config
mkdir -p /home/$USERACCNAME/.config/autostart/
cp org.kde.plasma-welcome.desktop /home/$USERACCNAME/.config/autostart/ # Adds the welcome screen correcctly, i would remove it from the start up applications but shut up
cp plasma-welcome /usr/bin
chmod +x /home/$USERACCNAME/.config/autostart/org.kde.plasma-welcome.desktop
chmod +x /usr/bin/plasma-welcome

pacman -Syu steam --noconfirm

cd /tmp
git clone https://aur.archlinux.org/spotify.git
cd spotify
makepkg -csi  # Spotify 
cd ..
rm -R spotify

cd /tmp
git clone https://aur.archlinux.org/timeshift.git
cd timeshift
makepkg -csi # timeshift
cd ..
rm -R timeshift

cd /tmp
git clone https://aur.archlinux.org/ttf-ms-fonts.git
cd ttf-ms-fonts
makepkg -csi # microsoft fonts
cd ..
rm -R ttf-ms-fonts

echo "Cleaning Up..." # Deletes all useless items
cd /tmp
rm -R elnathco
rm /usr/bin/setup

echo "Installation Finished."
echo "To reboot, type 'reboot'" # Completes Setup
exit