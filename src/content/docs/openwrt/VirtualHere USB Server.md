---
title: OpenWrt 上部署 VirtualHere USB Server（离线环境）完整教程
---

> 适用场景：
>
> - OpenWrt（实体机 / 虚拟机 / iStore）
> - ARM64 架构
> - **无外网 / 离线环境**
> - VirtualHere USB Server
> - 系统完全启动后再运行服务
>
> ❗ 本教程 **不包含任何授权 / 许可 / 破解内容**

---

## 一、环境与前置条件

### 1️⃣ 系统要求

- OpenWrt（支持 `procd`）
- USB 子系统正常工作（`kmod-usb-core` 等已安装）
- 架构：**ARM64 (aarch64)**

### 2️⃣ 目录规划

本文统一使用以下目录结构：

```
/usr/VirtualHere/
├── vhusbdarm64      # VirtualHere Server 主程序
├── config.ini       # 配置文件（可选）
```

> 如果你的文件名或路径不同，请按实际情况替换

---

## 二、准备 VirtualHere 程序文件

### 1️⃣ 创建目录

```bash
mkdir -p /usr/VirtualHere
```

### 2️⃣ 放置程序文件

将 `vhusbdarm64` 上传或复制到：

```bash
/usr/VirtualHere/vhusbdarm64
```

### 3️⃣ 设置执行权限

```bash
chmod +x /usr/VirtualHere/vhusbdarm64
```

---

## 三、使用 OpenWrt 标准方式创建启动服务

OpenWrt 推荐使用 **`/etc/init.d/` + procd** 来管理长期服务。

本方式具备：

- 系统启动靠后
- 可控、可维护
- 崩溃自动重启

---

## 四、创建 VirtualHere 启动脚本

### 1️⃣ 新建 init.d 脚本

```bash
vi /etc/init.d/virtualhere
```

### 2️⃣ 写入以下完整内容

```sh
#!/bin/sh /etc/rc.common

START=99
STOP=10
USE_PROCD=1

VH_DIR="/usr/VirtualHere"
VH_BIN="$VH_DIR/vhusbdarm64"
VH_CONF="$VH_DIR/config.ini"

start_service() {
    logger -t virtualhere "Waiting for USB subsystem..."

    # 等待 USB 子系统加载完成（离线安全）
    while [ ! -d /sys/bus/usb/devices ]; do
        sleep 1
    done

    # 给 hotplug/udev 最后缓冲时间
    sleep 2

    logger -t virtualhere "Starting VirtualHere USB Server (arm64)"

    procd_open_instance
    procd_set_param command "$VH_BIN" -c "$VH_CONF"
    procd_set_param respawn
    procd_close_instance
}

stop_service() {
    logger -t virtualhere "Stopping VirtualHere USB Server"
}
```

### 3️⃣ 赋予脚本执行权限

```bash
chmod +x /etc/init.d/virtualhere
```

---

## 五、启用并测试开机自启

### 1️⃣ 启用服务

```bash
/etc/init.d/virtualhere enable
```

### 2️⃣ 手动启动测试

```bash
/etc/init.d/virtualhere start
```

### 3️⃣ 查看运行状态

```bash
ps | grep vhusbd
logread | grep virtualhere
```

正常情况下你会看到类似：

```
Waiting for USB subsystem...
Starting VirtualHere USB Server (arm64)
```

---

## 六、为什么这样做（设计说明）

### ✅ 为什么不用 rc.local

- rc.local 不受 procd 管理
- 服务崩溃不会自动重启
- 不利于长期维护

### ✅ 为什么 START=99

- 数值越大，启动越靠后
- 确保：
  - 系统初始化完成
  - USB / hotplug 已加载

### ✅ 为什么不等网络

- 本场景 **默认无外网 / 离线**
- VirtualHere Server 本身不依赖 WAN
- 避免因网络判断导致服务永不启动

---

## 七、USB 使用行为说明

- **USB 开机前已插入** → 服务启动后可直接识别
- **USB 开机后插入** → VirtualHere 自动接管
- 无需重启服务

---

## 八、常见排查

### 1️⃣ 程序无法启动

```bash
ls -l /usr/VirtualHere/vhusbdarm64
```

确认：

- 文件存在
- 有执行权限

### 2️⃣ USB 设备不显示

```bash
ls /sys/bus/usb/devices
```

若为空，请确认：

- USB 驱动是否安装
- 硬件 USB 控制器是否正常

---

## 九、总结

本方案特点：

- ✔ 完全离线可用
- ✔ ARM64 专用
- ✔ OpenWrt 官方标准启动方式
- ✔ 等系统与 USB 完全 ready
- ✔ 稳定、可维护、可扩展

非常适合：

- USB over IP
- 远程 USB 设备共享
- 打印机 / 声卡 / 加密狗 / 采集卡

---

> 本文未包含任何授权、许可或破解内容，仅涉及部署与系统服务管理。
