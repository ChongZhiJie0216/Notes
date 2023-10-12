# Tight VNC Server 安装

# 1.更新资源包

```bash
sudo apt-get update
sudo apt update
sudo apt install curl wget git -y
```

# 2.下载安装包

```bash
wget https://downloads.realvnc.com/download/file/vnc.files/VNC-Server-7.6.1-Linux-ARM64.deb
sudo dpkg -i ./VNC-Server-7.6.1-Linux-ARM64.deb
```

# 3.输入激活码

```bash
sudo vnclicense -add XXXXX-XXXXX-XXXXX-XXXXX-XXXXX
```

# 4.设置密码

```bash
vncpasswd
```

# 5.设置开机自动启动

```bash
sudo nano /etc/systemd/system/realvnc.service
```

粘贴以下内容:

```bash
[Unit]
Description=RealVNC Server
After=network.target

[Service]
ExecStart=/usr/bin/vncserver-x11-serviced -run
Restart=on-failure
RestartSec=2
User=your_username
WorkingDirectory=/home/your_username

[Install]
WantedBy=multi-user.target

```

请确保将 your_username 替换为您的实际用户名。
使用 Ctrl+O，然后 Ctrl+X 退出 nano 编辑器

```bash
sudo systemctl enable realvnc.service
sudo systemctl start realvnc.service
sudo systemctl status realvnc.service
sudo systemctl enable realvnc.service #设置开机启动
sudo systemctl disable realvnc.service #关闭开机启动
```
