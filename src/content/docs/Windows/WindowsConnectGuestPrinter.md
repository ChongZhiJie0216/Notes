---
title: "Windows 10 共享打印机（SMB / spoolss）完整教程"
---

> 适用场景：
>
> - 打印机 **USB 直连 Windows 10**
> - 通过 **SMB（spoolss）** 方式共享打印机
> - **仅 Windows 客户端**（Windows 10 / 11）
> - 工作组环境（非 AD 域）

---

## 一、整体架构说明

```text
Windows Client
      │
      │ SMB (spoolss)
      ▼
Windows 10 打印服务器（Activity7）
      │ USB
      ▼
Canon G2730
```

> ⚠️ 关键说明：
>
> - **WORKGROUP 只影响网络浏览，不影响打印功能**
> - 实际打印完全依赖：
>   - SMB（spoolss）
>   - Windows Print Spooler 服务
>   - 本机 Canon 驱动是否稳定

---

## 二、Windows 10（打印服务器）完整设置

### 1️⃣ 确认本机打印 100% 正常（必须）

在 **Activity7（连接打印机的那台）**：

```
控制面板 → 设备和打印机 → CAN-G2730
右键 → 打印测试页
```

✅ 要求：

- 多次测试打印成功
- 不延迟、不假打印

> ❗ 如果 **本机打印不稳定**，共享一定失败

---

### 2️⃣ 启用打印机共享

```
设备和打印机 → CAN-G2730 → 打印机属性
```

#### Sharing 选项卡

- ✔ Share this printer
- Share name：

```text
CAN-G2730
```

#### Security 选项卡（非常重要）

- 添加 **Everyone**
- 权限：
  - ✔ Print

---

### 3️⃣ 网络共享基础设置

```
控制面板 → 网络和共享中心 → 高级共享设置
```

#### 当前配置文件（Private / All Networks）

- ✔ Turn on network discovery
- ✔ Turn on file and printer sharing

#### All Networks

- ✔ Turn off password protected sharing

> 用于 **Guest / 无账号访问 SMB 打印机**

---

### 4️⃣ 允许 Guest 使用 Windows 打印服务（核心）

Windows 10 默认 **拒绝 Guest 访问 spoolss**，必须手动放行。

以 **管理员 CMD** 执行：

```bat
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Print" /v RpcAuthnLevelPrivacyEnabled /t REG_DWORD /d 0 /f
```

重启打印服务：

```bat
net stop spooler
net start spooler
```

> ❗ 没有这一步，客户端常见错误：
>
> - 无法访问共享打印机
> - 提示组织安全策略阻止 Guest

---

### 5️⃣ 本地安全策略（可选但推荐）

#### Windows 10 Pro / Enterprise

```
Win + R → gpedit.msc
```

路径：

```
Computer Configuration
→ Administrative Templates
→ Network
→ Lanman Workstation
```

设置：

- **Enable insecure guest logons** → ✅ Enabled

---

### 6️⃣ Canon 打印机高级设置（极其关键）

```
CAN-G2730 → 打印机属性
```

#### Ports

- ✔ USB00x（真实 USB 端口）
- ❌ 不使用 WSD

#### Advanced

- ❌ Enable advanced printing features
- ✔ Start printing after last page is spooled

#### Device Settings

- ❌ Enable bidirectional support

👉 Apply → OK

> 这是解决：
>
> - 队列正常但不出纸
> - 假打印
> - 客户端 Completed 但无输出 的关键

---

## 三、Windows 客户端连接共享打印机

### 方法 A：运行方式（最稳）

```
Win + R
\\Activity7\CAN-G2730
```

或直接使用 IP（强烈推荐）：

```
\\192.168.1.10\CAN-G2730
```

按照提示安装驱动即可。

---

### 方法 B：控制面板手动添加

```
控制面板 → 设备和打印机 → 添加打印机
```

若未自动发现：

- 选择 **The printer that I want isn’t listed**
- 选择 **Select a shared printer by name**
- 输入：

```text
\\192.168.1.10\CAN-G2730
```

---

## 四、常见问题排查

### ❌ 无法访问共享打印机（组织安全策略）

原因：

- Windows 默认阻止 Guest SMB

解决：

- 已设置 `RpcAuthnLevelPrivacyEnabled=0`
- 或改用 **有账号访问**（Registered User）

---

### ❌ 客户端显示打印成功但不出纸

原因（90%）：

- Canon 驱动问题
- 使用了 WSD
- 双向通信开启

解决：

- 使用 USB 端口
- 关闭双向支持
- 关闭高级打印功能

---

### ❌ 网络中看不到打印机

说明：

- 与打印功能无关
- WORKGROUP 只影响浏览

解决：

- 直接使用 `\\IP\共享名`

---

## 五、重要结论（必读）

- ❌ WORKGROUP **不是核心问题**
- ❌ 驱动重装 ≠ 解决共享
- ✅ 成功关键在于：
  - 本机是否能稳定打印
  - Print Spooler 是否正常
  - Guest / SMB 权限是否正确
  - Canon 驱动高级设置

---

## 六、推荐实践

- 小型办公室 / 教室：
  - **SMB + Registered User（最稳、最安全）**

- 多系统 / 新设备环境：
  - 建议迁移到 **IPP（HTTP 打印）**

---

> 文档版本：v1.1
> 适用系统：Windows 10 / Windows 11
