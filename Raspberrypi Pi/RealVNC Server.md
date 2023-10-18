# Tight VNC Server 安装

# 1.更新资源包

```bash
sudo apt-get update
sudo apt update
sudo apt install curl wget git -y
```

# 2.下载安装包

```bash
wget https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-6.11.0-Linux-ARM64.deb
sudo dpkg -i ./VNC-Server-6.11.0-Linux-ARM64.deb
cd /usr/lib/aarch64-linux-gnu/
sudo ln libvcos.so /usr/lib/libvcos.so.0
sudo ln libvchiq_arm.so /usr/lib/libvchiq_arm.so.0
sudo ln libbcm_host.so /usr/lib/libbcm_host.so.0
```

# 4.编辑 /etc/gdm3/custom.conf 文件

因为您正在使用非 LTS 版本，并取消注释 WaylandEnable=false。

```bash
sudo nano /etc/gdm3/custom.conf
```

# 5.输入激活码

```bash
sudo vnclicense -add XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```

# 6.设置密码

```bash
vncpasswd
```

# 7.设置开机自动启动

```bash
sudo systemctl enable vncserver-virtuald.service
sudo systemctl enable vncserver-x11-serviced.service
sudo systemctl start vncserver-virtuald.service
sudo systemctl start vncserver-x11-serviced.service
```
