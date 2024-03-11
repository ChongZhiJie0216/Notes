# Tight VNC Server Installation
# 1.Install TightVNCServer
```bash
sudo apt-get update
sudo apt update
sudo apt-get install tightvncserver
```

# 2.Start VNCServer on Pi
```bash
vncserver
```

# 3. How to Start VNC Server on Boot?
Create a File or Download Script From **[Here]()**
```bash
sudo nano /etc/init.d/tightvncserver
```
# 4. Give Permission to Run it
```bash
sudo chmod 755 /etc/init.d/tightvncserver
sudo update-rc.d tightvncserver defaults
```

# VNC Configuration Parameters
If you want to configure the VNC server further, commonly used parameters include:
- Connection Port (:$NUM): For example, setting :1 will open port 5901, :2 will open port 5902, and so on. Default is :1.
- Resolution (geometry): For example, 640×480, 800×600, 1024×768, etc. Default is 1024×768.
- Pixel Depth (depth): For example, 8, 16, 24, etc., representing the number of bits per pixel. Default is 16.
- For instance, if we want to set up the VNC server to listen on port 5902 and open a 640×480 BGR233 display when a user connects to port 5902.
