# Welcome to my linux environment setup

## My stack consists of the most 5 important elements:
  - Arch linux
  - Nvim
  - Alacritty
  - ZSH
  - I3

## Installation steps:

- Install arch linux ISO from [http://mirror.pmf.kg.ac.rs/archlinux/iso/2021.06.01/].
By the time you are watching this, there will be new versions. Choose the newest.

- Make ISO bootable and plug it in. For this step you are free to use any method you want.

- Open bios on start laptop ( usually F2, with plugged bootable USB ).

- Disable secure boot in bios.

- Change usb boot order ( select your USB device and move it to the top of boot order )    

- By this time you should get prompted with your Arch Linux installer which is just the terminal

- Let's get that wifi rolling!. <br />
	```
	iwctl
	```
	```
	device list
	station ${device name} scan
	station ${device name} get-networks
	station ${device name} connect ${SSID} ( Enter passphrase )
	exit
	```
	Verify wifi connection once you are connected:
	```
	ping google.com ( Confirm net )
	```

- Setup the time
	```
	timedatectl set-ntp
	```
	Verift the time:
	```
	timedatectl status
	```
	
- Next up we have to do the partitioning.
	Find Hard Disk you wish to install linux on.
	```
	fdisk -l
	```
	Select Hard Disk you wish to install linux on.
	```
	fdisk /dev/${Hardisk/SSD name}
	```
	This will lead us to **fdisk** environment. We have to create a partition table with 3 partitions. Bootable, swap and filesystem once.
	Filesystem is the one most important for us, because our Linux is actually gonna live on that partition.

	Let' create partition table.
	```
	g
	```
	Create boot partition. You will get prompted to fill parition number and size.
	```
	n 
	```
	
	Partition number <code>1</code>
		
	Partition size <code>+550M</code>
	
	Create swap partition
	```
	n 
	```
	
	Partition number <code>2</code>
		
	Partition size <code>+2G</code>
	
	Create filesystem partition
	```
	n 
	```
	
	Partition number <code>3</code>
		
	Partition size will be the rest of remaining memory. Just hit <code>Enter</code>
	
	Next we have to change type of boot partition.
	<code>t</code> 
	<code>1</code>
	<code>1</code>
        
	Next let's change swap
	<code>t</code>
	<code>2</code>
	<code>19</code>
	
	Last filesystem partition is already correct type becauase it is selected by default.
	
	Write out our partition table
	<code>w</code>
  
  
- Out first boot partition is going to be **FAT** type
```
mkfs.fat -F32 /dev/{ Device name partition 1 }
```

- Adding swap parition
```
mkswap /dev/{ Device name partition 2 }
```

- Turning the swap on
```
swapon /dev/{ Device name partition 2 }
```

- Filesystem partition is gonna be **EXT4**
```
mkfs.ext4 /dev/{ Device name partition 3 }
```

- Then we mount our filesystem partition to <code>/mnt</code> path
```
mount /dev/{ Device name partition 3 } /mnt
```

- Now we need install linux on our <code>/mnt</code> path.
To initilize our linux instalation on our partition that is mount
```
pacstrap /mnt base linux linux-firmware
```

- Genfstab our <code>/mnt</code>
```
genfstab -U /mnt >> /mnt/etc/fstab
```

- Finally let's enter our <code>/mnt</code> as arch installation.
```
arch-chroot /mnt
```

- Find your zone. It should be close to your location at least.
```
ls /usr/share/zoneinfo
```
- Then we set it up simply by:
```
ln -sf /usr/share/zoneinfo/Europe/Belgrade /etc/localtime
```

- Let's check is our clock is correct.
```
hwclock --systohc
```

- Install all of the required packages with pacman ( some might be missing from the list.
```
pacman -S neovim sudo grub efibootmgr dosfstools os-prober mtools networkmanager base-devel git xorg xorg-xinit nitrogen discord nautilus code flameshot alacritty i3-gaps i3blocks i3lock i3status noto-fonts ttf-font-awesome ttf-dejavu ttf-liberation nodejs npm alsa-utils bc rofi wmctrl xdotool ripgrep zsh
```

- Add <code>.zshrc</code>
```
nvim ~/.zshrc && source ~/.zshrc ( check out my .zshrc file ) 
```

- Now we uncomment <code>en-US</code> language so our Linux system displays all the text in that language.
```
vim /etc/locale.gen ( uncomment line 177 )
```
Then we reload:
```
locale-gen
```

- Set the hostname.
```
vim /etc/hostname
```
Then simply write wanted **hostname**. I recomment "arch".

- Set the hosts
```
vim /etc/hosts
```
```
     127.0.0.1 		localhost
     ::1 		localhost
     127.0.1.1 		${hostname}.localdomain	${hostname}
```

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

