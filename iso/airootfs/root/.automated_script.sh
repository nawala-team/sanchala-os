#!/bin/bash
#
# SANCHALA OS - Live Environment Setup Script
# Runs on boot in live environment
#

# Create live user
useradd -m -G wheel,audio,video,optical,storage,network,power -s /bin/bash sanchala
echo "sanchala:sanchala" | chpasswd

# Passwordless sudo for live user
echo "sanchala ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/sanchala

# Set default shell
chsh -s /bin/bash sanchala

# Enable autologin to SDDM
mkdir -p /etc/sddm.conf.d
cat > /etc/sddm.conf.d/autologin.conf << EOF
[Autologin]
User=sanchala
Session=plasma
EOF

# Start welcome app on first login
mkdir -p /home/sanchala/.config/autostart
cat > /home/sanchala/.config/autostart/sanchala-welcome.desktop << EOF
[Desktop Entry]
Type=Application
Name=Sanchala Welcome
Exec=/usr/bin/sanchala-welcome
Icon=sanchala
Terminal=false
Categories=System;
X-GNOME-Autostart-enabled=true
EOF
chown -R sanchala:sanchala /home/sanchala/.config

# Set hostname
echo "sanchala-live" > /etc/hostname

# Enable essential services
systemctl enable NetworkManager
systemctl enable bluetooth
systemctl enable sddm
systemctl enable apparmor
systemctl enable fstrim.timer
systemctl enable systemd-timesyncd

# Disable root login
passwd -l root

echo "Sanchala OS Live environment setup complete!"
