# linux-environment-setup

Welcome!

You are looking into my linux environment which I use for local development.

My stack consists of the most 5 important elements:
  1. Arch linux
  2. Nvim
  3. Alacritty
  4. ZSH
  5. I3

Installation steps:

DISABLE ALL SECURE FEATURES BY ANY LAPTOP OVER OR DIE :)

Install arch linux ISO from:
http://mirror.pmf.kg.ac.rs/archlinux/iso/2021.06.01/

Make ISO bootable ( put ISO file to usb )

Open bios on start laptop ( usually F2, with plugged bootable USB )

Disable secure boot in bios.

Put usb order first in bios ( select device and put on top of boot order )

To setup the wifi:
iwctl
	device list
	station {device name} scan
	station {device name} get-networks
	station {device name} connect {SSID} ( Enter passphrase )
	exit
	
Verify wifi connection once you are connected:
ping google.com ( Confirm net )

Setup the time:
 timedatectl set-ntp

Verift the time:
timedatectl status

Find Hard Disk you wish to install linux on:
fdisk -l

Select Hard Disk you wish to install linux on:
fdisk /dev/${ Hardisk/SSD name }


	g
	n   ( Create boot partition, make it 550M )
		1
		Enter
		+550M
	n   ( Create swap partition, make it 2G )
        	2
        	Enter
        	+2G
	n   ( Create filesystem partition, let it take all space )
        	3
        	Enter
        	Enter
	t 
		1
		1
        t
		2
		19
	w
  
  
mkfs.fat -F32 /dev/{ Device name partition 1 }

mkswap /dev/{ Device name partition 2 }

swapon /dev/{ Device name partition 2 }

mkfs.ext4 /dev/{ Device name partition 3 }

mount /dev/{ Device name partition 3 } /mnt

pacstrap /mnt base linux linux-firmware

genfstab -U /mnt >> /mnt/etc/fstab

arch-chroot /mnt

ls /usr/share/zoneinfo

ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime

hwclock --systohc

pacman -S neovim sudo grub efibootmgr dosfstools os-prober mtools networkmanager base-devel git xorg xorg-xinit nitrogen discord nautilus code flameshot alacritty i3-gaps i3blocks i3lock i3status noto-fonts ttf-font-awesome ttf-dejavu ttf-liberation nodejs npm alsa-utils bc rofi wmctrl xdotool ripgrep zsh

vim ~/.bashrc && source ~/.bashrc ( check Djole .bashrc file ) 

vim /etc/locale.gen ( uncomment line 177 )

locale-gen

vim /etc/hostname ( Write in your hostname.., We choose "arch" )

vim /etc/hosts
     127.0.0.1 		localhost
     ::1 		localhost
     127.0.1.1 		{hostname}.localdomain	{hostname}


passwd

useradd -m {user name}

passwd {user name}

usermod -aG wheel,audio,video,optical,storage,input {username}

EDITOR=nvim visudo
Uncomment wheel all group


mkdir /boot/EFI

mount /dev/{ First boot partition } /boot/EFI

grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck

grub-mkconfig -o /boot/grub/grub.cfg

systemctl enable NetworkManager.service

git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si && cd ..  && rm -rf yay-git

yay -S google-chrome bumblebee-status libinput-gestures

git clone http://github.com/creationix/nvm.git .nvm

source ~/.nvm/nvm.sh

setup nvim ( Take nvim folder and replace it with your ~/.config/nvim )

alsa-mixer

cp /usr/share/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d/40-libinput.conf
Add to touchpad: 
	Option "NaturalScrolling" "true"
	Option "Tapping" "true"

vim ~/.zlogin, check djole setup

vim /bin/bright && chmod a+x /bin/bright
 
umount -I /mnt

