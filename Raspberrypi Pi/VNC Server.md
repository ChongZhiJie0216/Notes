# Tight VNC Server 安装

# 1.安装 TightVNCServer

```bash
sudo apt-get update
sudo apt update
sudo apt-get install tightvncserver
```

# 2.在 Pi 上启动 VNCServer

```bash
vncserver
```

# 3.如何在开机时就启动 VNC 伺服器？

```bash
sudo vim /etc/init.d/tightvncserver
```

```bash
#!/bin/bash
### BEGIN INIT INFO
# Provides:          TightVNCServer
# Required-Start:    $syslog
# Required-Stop:     $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: vnc server
# Description:
### END INIT INFO
export USER='pi'
eval cd ~$USER
# Check the state of the command - this'll either be start or stop
case "$1" in
  start)
    # if it's start, then start vncserver using the details below
    su $USER -c '/usr/bin/vncserver :1 -geometry 1920x1080 -depth 16 -pixelformat rgb565'
    echo "Starting TightVNCServer for $USER"
    ;;
  stop)
    # if it's stop, then just kill the process
    pkill Xtightvnc
    echo "TightVNCServer stopped"
    ;;
  *)
    echo "Usage: /etc/init.d/tightvncserver {start|stop}"
    exit 1
    ;;
esac
exit 0
```

```bash
sudo chmod 755 /etc/init.d/tightvncserver
sudo update-rc.d tightvncserver defaults
```

# VNC 設定參數

如果要对 VNC 伺服器做更多设定，常用的参数有：

- 连线埠 (:$NUM)：例如设定 :1 开启的 port 为 5901，:2 开启的 port 为 5902，依此类推，预设为 :1。
- 解析度(geometry)：例如 640×480, 800×600, 1024×768 等，预设为 1024×768
- 像素深度(depth)：例如 8, 16, 24 等，这是指每个像素可显示的位元数，预设为 16。
  例如我们想设定 VNC 伺服器监听 5902 这个埠号，当有用户连线到 5902 后可开启一个 640×480 BGR233 的画面。
