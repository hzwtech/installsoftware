
yum -y update && yum upgrade
yum -y install  yum-axelget  wget kernel-devel kernel-headers gcc-c++
 
yum -y install   gcc-gfortran
echo -e "blacklist nouveau\noptions nouveau modeset=0" > /etc/modprobe.d/blacklist.conf
mv /boot/initramfs-$(uname -r).img /boot/initramfs-$(uname -r).img.bak
dracut /boot/initramfs-$(uname -r).img $(uname -r)
reboot

wget http://cn.download.nvidia.com/XFree86/Linux-x86_64/390.67/NVIDIA-Linux-x86_64-390.67.run

chmod +x NVIDIA-Linux-x86_64-390.67.run

 sh ./NVIDIA-Linux-x86_64-390.67.run  --kernel-source-path=/usr/src/kernels/3.10.0-862.3.2.el7.x86_64
 #install cuda
wget https://developer.nvidia.com/compute/cuda/9.2/Prod/local_installers/cuda_9.2.88_396.26_linux

chmod +x cuda_9.2.88_396.26_linux 
sh cuda_9.2.88_396.26_linux 
#install cuda update
wget https://developer.nvidia.com/compute/cuda/9.2/Prod/patches/1/cuda_9.2.88.1_linux
chmod +x cuda_9.2.88.1_linux 
sh cuda_9.2.88.1_linux 
echo 'export PATH=/usr/local/cuda-9.2/bin:$PATH
export LD_LIBRARY_PATH=/usr/local/cuda-9.2/lib64:$LD_LIBRARY_PATH' > cuda-9.2.source
#安装kde桌面
yum groupinstall -y "X Window System" 
yum groupinstall -y "KDE Plasma Workspaces"
 echo "exec startkde" >> ~/.xinitrc
systemctl set-default   graphical.target  
#禁用gdm,启用lightdm
systemctl disable gdm
systemctl enable lightdm
systemctl stop gdm ; systemctl start lightdm 
#reboot
 
 


