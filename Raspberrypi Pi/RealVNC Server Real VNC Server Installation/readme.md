# Real VNC Server Installation

# 1.Update Package Resources
```bash
sudo apt-get update
sudo apt update
sudo apt install curl wget git -y
```

# 2.Download Installation Package
```bash
wget https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-6.11.0-Linux-ARM64.deb
sudo dpkg -i ./VNC-Server-6.11.0-Linux-ARM64.deb
cd /usr/lib/aarch64-linux-gnu/
sudo ln libvcos.so /usr/lib/libvcos.so.0
sudo ln libvchiq_arm.so /usr/lib/libvchiq_arm.so.0
sudo ln libbcm_host.so /usr/lib/libbcm_host.so.0
```

# 4.Edit the /etc/gdm3/custom.conf File
As you are using a non-LTS version, uncomment WaylandEnable=false.
```bash
sudo nano /etc/gdm3/custom.conf
```

# 5.Input Activation Code
```bash
sudo vnclicense -add XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```

# 6.Set Password
```bash
vncpasswd
```

# 7.Set Auto-start on Boot

```bash
sudo systemctl enable vncserver-virtuald.service
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl start vncserver-virtuald.service
sudo systemctl start vncserver-x11-serviced.service
```
