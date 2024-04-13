#!/bin/bash

# Ensure script is run as root
if [ "$(id -u)" -ne 0 ]; then
    echo "Please run as root"
    exit 1
fi

# Partitioning with fdisk
echo "label: gpt
/dev/nvme0n1p1 : start=2048, size=2048000, type=EFI System
/dev/nvme0n1p2 : start=2048000, size=16777216, type=Linux swap
/dev/nvme0n1p3 : start=18825216, type=Linux filesystem" | fdisk /dev/nvme0n1

# Format partitions
mkfs.fat -F32 /dev/nvme0n1p1
mkswap /dev/nvme0n1p2
mkfs.ext4 /dev/nvme0n1p3

# Mount partitions
mount /dev/nvme0n1p3 /mnt
mkdir -p /mnt/boot/efi
mount /dev/nvme0n1p1 /mnt/boot/efi
swapon /dev/nvme0n1p2

# Install base system
pacstrap /mnt base linux linux-firmware sof-firmware base-devel \
  nano vim wget curl \
  man-db man-pages \
  openssh zsh git \
  bluez bluez-utils networkmanager

# Generate fstab
genfstab -U /mnt >> /mnt/etc/fstab

# Chroot into the new system
arch-chroot /mnt <<EOF
# Set timezone to Latvia
ln -sf /usr/share/zoneinfo/Europe/Riga /mnt/etc/localtime
arch-chroot /mnt ln -sf /usr/share/zoneinfo/Europe/Riga /etc/localtime
arch-chroot /mnt hwclock --systohc

# Localization for en_US.UTF-8
echo "en_US.UTF-8 UTF-8" > /mnt/etc/locale.gen
echo "lv_LV.UTF-8 UTF-8" >> /mnt/etc/locale.gen
locale-gen
echo "LANG=en_US.UTF-8" > /mnt/etc/locale.conf

# Set hostname
echo "lnovo" > /mnt/etc/hostname

# Set root password
echo "Enter root password:"
arch-chroot /mnt passwd

# Create a new user
echo "Creating new user..."
read -p "Enter username: " username
arch-chroot /mnt useradd -m -G wheel -s /bin/zsh $username
arch-chroot /mnt passwd $username
echo "User $username created."

# Install and configure sudo
arch-chroot /mnt pacman -S --noconfirm sudo
echo "%wheel ALL=(ALL) ALL" >> /mnt/etc/sudoers

# Install and configure bootloader
arch-chroot /mnt pacman -S --noconfirm grub efibootmgr
arch-chroot /mnt grub-install --target=x86_64-efi --efi-directory=/boot/efi --bootloader-id=grub
arch-chroot /mnt grub-mkconfig -o /boot/grub/grub.cfg

# Enable and start NetworkManager
arch-chroot /mnt systemctl enable NetworkManager

# Enable and start Bluetooth service
arch-chroot /mnt systemctl enable bluetooth

echo "All configurations completed."
EOF

# Unmount partitions
umount -R /mnt
swapoff -a

echo "Installation complete. You can reboot now."
