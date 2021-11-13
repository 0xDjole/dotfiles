# Welcome to my linux environment setup

## My stack consists of the most 5 important elements:

- Arch linux
- Nvim
- Alacritty
- Zsh
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
  timedatectl set-ntp true
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

  Create swap partition ( Good practice to have it double the size of RAM )

  ```
  n
  ```

  Partition number <code>2</code>
  Partition size <code>+30G</code>

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
  `pacstrap /mnt base linux linux-firmware`

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
  pacman -S neovim sudo grub efibootmgr dosfstools os-prober mtools networkmanager base-devel git xorg xorg-xinit nitrogen discord nemo flameshot alacritty i3-gaps i3blocks i3status rustup alsa-utils bc rofi wmctrl xdotool ripgrep wget noto-fonts neofetch net-tools rust-analyzer docker docker-compose redshift xclip
  ```
- Install zshrc
  ```
  sh -c "$(curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
  ```

- Copy <code>.zshrc</code> from repo to <code>**$HOME**/.zshrc</code> for ZSH Shell.

  ```
  nvim **$HOME**/.zshrc && source **$HOME**/.zshrc
  ```

  Install:

  ```
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  ```

  and

  ```
  git clone https://github.com/agkozak/zsh-z $ZSH_CUSTOM/plugins/zsh-z
  ```

  and

  ```
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
  ```

  and

  ```
  git clone https://github.com/zsh-users/zsh-autosuggestions ~/.zsh/zsh-autosuggestions
  ```
  
  and
  
  ```
  git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf && ~/.fzf/install
  ```

  To have the same configuration, you can also copy <code>.p10k.zsh</code> from repo into your <code>**$HOME**/.p10k.zsh</code>

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
       ::1 		        localhost
       127.0.1.1 		${hostname}.localdomain	${hostname}
  ```
- Set the root password

  ```
  passwd
  ```

- Add a user that you will use, since using **root** is not practical.

  ```
  useradd -m ${username}
  ```

  Then we set the password for our new user

  ```
  passwd {username}
  ```

  We also give him different permissions. Most important is **wheel**. Then we can assume **root** role essentially by running **sudo**.

  ```
  usermod -aG wheel,audio,video,optical,storage,input,docker {username}
  ```

  But we all want to uncomment **wheel all alll** line so **wheel** group acts as godlike group.

  ```
  EDITOR=nvim visudo
  ```

  As said, we uncomment **wheel all all** line, so wheel is any role.

- Create boot entry for first partition. Then install grub, so our system knows where to **boot** from.

  ```
  mkdir /boot/EFI
  ```

  ```
  mount /dev/{ First boot partition } /boot/EFI
  ```

  ```
  grub-install --target=x86_64-efi --bootloader-id=grub_uefi --recheck
  ```

  ```
  grub-mkconfig -o /boot/grub/grub.cfg
  ```

- Enable **NetowkrManager**, so we can have access to wifi next time we log in.

  ```
  systemctl enable NetworkManager.service
  ```

- Let's install **yay** helper, so we can easily install other dependencies not included in official pacman repo.
  `git clone https://aur.archlinux.org/yay-git.git && cd yay-git && makepkg -si && cd .. && rm -rf yay-git`
  Then we install:
  `yay -S google-chrome bumblebee-status libinput-gestures nerd-fonts-complete mongodb-compass postman-bin betterlockscreen` 
  We will also install nvm to manage our node versions.
  `git clone http://github.com/creationix/nvm.git .nvm`
  `source $HOME/.nvm/nvm.sh`

- Install npm global packages

        ```
	npm install -g typescript typescript-language-server diagnostic-languageserver jest mocha pyright svelte-language-server prettier npm eslint_d
	```
- Configure our neovim. Take nvim folder and replace it with your <code>**$HOME**/.config/nvim</code>.
	Then simply trigger:
	```
	nvim
	```
	```
	:PlugInstall
	```

- Configure sound with
	```
	alsa-mixer
	```

- We have to configure out touchpad as well. We take shared default one and put in <code>/etc</code>
	```
	cp /usr/share/X11/xorg.conf.d/40-libinput.conf /etc/X11/xorg.conf.d/40-libinput.conf
	```
	Then add to touchpad section:
	```
	Option "NaturalScrolling" "true"
	Option "Tapping" "true"
	```

- To run **startx** on login take .zlogin file from repo and put it in <code>**$HOME**/.zlogin</code>
	```
	vim $HOME/.zlogin
	```
- To configure alacritty take alacritty.yml file from repo and put it in <code>**$HOME**/.config/alacritty/</code>

- To suspend on lid switch change <code>/etc/systemd/logind.conf</code> and uncomment <code>HandleLidSwitch=suspend</code>

- To configure neofetch take neofetch folder from repo and put it in <code>**$HOME**/.config</code>

- To autologin
    ```
    cp /usr/lib/systemd/system/getty@.service /etc/systemd/system/autologin@.service
    ```
    Then 
    ```
    ln -s /etc/systemd/system/autologin@.service /etc/systemd/system/getty.target.wants/getty@tty1.service
    ```
    and most important change ExecStart line in autologin@.service file
    ```
    ExecStart=-/sbin/agetty -a USERNAME %I 38400
    ```


- Copy <code>i3</code> folder. Put it in <code>**$HOME**/.config</code>.
	Also download **arch.png** from repo if you want to use it as a background. I put my in <code>**$HOME**/Documents</code>, so be sure to tweak i3 config file if your image will be in a different path.
	Also note to change your monitor positions and everything regarding i3 for your own system.
	**I3 file contains sections specific for your system, so a bit work will be rquired.**

- Finally we unmount and that's it:
````

umount -I /mnt

```
All that is left is to <code>reboot</code> and enjoy.
```
