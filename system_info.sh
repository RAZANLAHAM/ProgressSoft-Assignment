#!/bin/bash
echo "============================================"
echo "           system Information               "
echo "==========================================="
echo "Excuted By :  $(whoami)"
echo "Hostname : $(hostname)"
echo "server IP: $(hostname -I | awk '{print $1}')"
echo "public IP : $(curl -s https://api.ipify.org)"
echo "os type :$(cat /etc/os-release)"
echo "Kernel Version: $(uname -r)"
echo "Architecture:$(uname -m)"
echo "Virtualization:"
systemd-detect-virt

echo "Server Time:"
date

echo "Timezone:"
timedatectl

echo "Uptime:"
uptime 
echo "      Resources           "
 
echo "Total and Used Memory:"
free -h

echo "CPU Cores:"
nproc

echo "Disk Usage:"
df -h
echo "disk usages :"
df -h

