---
title: OpenWrt 使用 OpenConnect 并共享给所有 LAN 设备
---

本教程演示如何在 OpenWrt 路由器上配置 OpenConnect VPN，并让 **局域网所有设备通过该 VPN 上网**。

适用于：

- GL.iNet / OpenWrt 路由器
- AnyConnect / OpenConnect VPN
- 公司 VPN / 自建 VPN
- 需要全局代理的家庭网络

---

## 1. 环境准备

示例环境：

| 项目           | 示例               |
| -------------- | ------------------ |
| OpenWrt LAN IP | 192.168.8.1        |
| LAN 网段       | 192.168.8.0/24     |
| VPN 协议       | AnyConnect         |
| VPN 服务器     | sslvpn.example.com |
| VPN 端口       | 8443               |

确保：

- 路由器已联网
- 可以 SSH 登录 OpenWrt

---

## 2. 安装 OpenConnect

更新软件源：

```bash
opkg update
```

安装 OpenConnect：

```bash
opkg install openconnect luci-proto-openconnect
```

安装完成后 LuCI 也会支持 OpenConnect。

---

## 3. 创建 OpenConnect 接口

编辑网络配置：

```bash
nano /etc/config/network
```

添加：

```bash
config interface 'ocvpn'
        option proto 'openconnect'
        option vpn_protocol 'anyconnect'
        option server 'sslvpn.example.com'
        option port '8443'
        option username 'YOUR_USERNAME'
        option password 'YOUR_PASSWORD'
        option authgroup 'Master Network'
        option useragent 'AnyConnect Linux'
        option os 'linux'
        option defaultroute '1'
        option peerdns '0'
```

参数说明：

| 参数         | 说明                  |
| ------------ | --------------------- |
| server       | VPN 服务器            |
| port         | VPN 端口              |
| username     | 用户名                |
| password     | 密码                  |
| authgroup    | 认证组（可选）        |
| defaultroute | 使用 VPN 作为默认路由 |

---

## 4. 重启网络

```bash
/etc/init.d/network restart
```

查看是否连接成功：

```bash
ifconfig
```

如果看到 `tun0`，说明 VPN 已连接。

---

## 5. 配置防火墙

为了让 LAN 设备可以通过 VPN 上网，需要配置防火墙。

编辑：

```bash
nano /etc/config/firewall
```

添加 VPN zone：

```bash
config zone
        option name 'ocvpn'
        option input 'ACCEPT'
        option output 'ACCEPT'
        option forward 'REJECT'
        option masq '1'
        option mtu_fix '1'
        option network 'ocvpn'
```

允许 LAN 转发到 VPN：

```bash
config forwarding
        option src 'lan'
        option dest 'ocvpn'
```

---

## 6. 重启防火墙

```bash
/etc/init.d/firewall restart
```

---

## 7. 测试 VPN

在 OpenWrt 上测试：

```bash
curl ifconfig.me
```

---

## 8. LAN 设备测试

在局域网设备访问：

```
https://ifconfig.me
```

如果 IP 与 VPN 相同，说明**所有设备已经通过 VPN 上网**。

---

## 9. 可选：强制所有设备必须走 VPN

如果希望**防止设备绕过 VPN**，编辑防火墙：

```bash
nano /etc/config/firewall
```

禁用 LAN → WAN：

```bash
config forwarding
        option src 'lan'
        option dest 'wan'
        option enabled '0'
```

重启防火墙：

```bash
/etc/init.d/firewall restart
```

这样 LAN 设备只能通过 VPN 上网。

---

## 10. 开机自动连接

OpenWrt 默认会自动启动 VPN 接口。

检查接口状态：

```bash
ifup ocvpn
```

手动连接：

```bash
ifup ocvpn
```

断开：

```bash
ifdown ocvpn
```

---

## 11. 查看 VPN 状态

查看日志：

```bash
logread -f
```

查看接口：

```bash
ifstatus ocvpn
```

---

## 12. 常见问题

### VPN 连接成功但设备不能上网

检查 NAT：

```bash
iptables -t nat -L
```

确认存在：

```
MASQUERADE  ocvpn
```

### DNS 不解析

手动设置 DNS，编辑 `/etc/config/network`，添加：

```bash
option dns '8.8.8.8'
```

---

## 13. 完成

现在你的 OpenWrt 已经：

- ✔ 连接 OpenConnect VPN
- ✔ 所有 LAN 设备共享 VPN
- ✔ 支持自动启动

### 参考命令

```bash
ifup ocvpn
ifdown ocvpn
logread -f
ifconfig
```

### 完整结构

```
OpenWrt
 ├── WAN
 ├── OpenConnect VPN
 │     └── ocvpn
 └── LAN
       ├── PC
       ├── Phone
       └── TV
```

所有设备流量：

```
LAN → OpenWrt → OpenConnect VPN → Internet
```
