#!/bin/bash
if [ `id -u` -eq 0 ];then
  echo "Welcome to Debian (Mental Stability Edition)"
else
  echo "Please run with root permission. Debian demands bureaucracy."
  exit 1
fi

mv /etc/pacman.conf /etc/pacman.conf.bak
mv /etc/arch-release /etc/arch-release.bak
mv /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.bak

cat <<EOF >/etc/pacman.conf
[options]
SigLevel = Never
LocalFileSigLevel = Optional
HoldPkg = dpkg apt
Architecture = auto
Color
CheckSpace

[debian-stable-but-in-pacman-format]
Include = /etc/pacman.d/mirrorlist
EOF

[ -z "$SERVER" ] && SERVER='https://mirrors.tuna.tsinghua.edu.cn/debian/$repo/os/$arch'
cat <<EOF >/etc/pacman.d/mirrorlist
Server = $SERVER
EOF

pacman -Syyuu --noconfirm base-files apt dpkg sysvinit linux-image-amd64

pacman -Rdd   --noconfirm $(pacman -Qq | grep -E 'arch|hyprland|sway|neofetch|yay|paru|linux-zen')

sed -i '/^GRUB_THEME.*$/d' /etc/default/grub
echo "GRUB_TIMEOUT=30" >> /etc/default/grub 
grub-mkconfig -o /boot/grub/grub.cfg

echo "=========================================================="
echo "🎉 SUCCESS! 'I use Arch btw' has been successfully purged."
echo "Your system is now as stable as a brick. And just as useful."
echo "=========================================================="
exit 0
