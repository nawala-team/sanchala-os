#!/usr/bin/env bash
# shellcheck disable=SC2034
#
# SANCHALA OS - Archiso Profile Definition
# https://sanchala.id
#

iso_name="sanchala"
iso_label="SANCHALA_$(date +%Y%m)"
iso_publisher="Sanchala OS <https://sanchala.id>"
iso_application="Sanchala OS Live/Installer"
iso_version="$(date +%Y.%m.%d)"
install_dir="sanchala"
buildmodes=('iso')
bootmodes=('bios.syslinux.mbr' 'bios.syslinux.eltorito'
           'uefi-ia32.grub.esp' 'uefi-x64.grub.esp'
           'uefi-ia32.grub.eltorito' 'uefi-x64.grub.eltorito')
arch="x86_64"
pacman_conf="pacman.conf"
airootfs_image_type="squashfs"
airootfs_image_tool_options=('-comp' 'zstd' '-Xcompression-level' '15' '-b' '1M')
file_permissions=(
  ["/etc/shadow"]="0:0:400"
  ["/etc/gshadow"]="0:0:400"
  ["/etc/sudoers.d"]="0:0:750"
  ["/root"]="0:0:750"
  ["/root/.automated_script.sh"]="0:0:755"
  ["/root/.gnupg"]="0:0:700"
  ["/usr/local/bin/sanchala-install"]="0:0:755"
  ["/usr/local/bin/sanchala-welcome"]="0:0:755"
)
