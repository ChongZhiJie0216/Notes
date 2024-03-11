#   Step of Build VE-Anti-Detection

## Source Reference comes from
  [pve7 pve8 kvmqemu反虚拟化检测显卡直通玩游戏教程小白直接安装+大神可以自己源码编译](https://www.bilibili.com/read/cv26245305/) by 李晓流

  [zhaodice/proxmox-ve-anti-detection](https://github.com/zhaodice/proxmox-ve-anti-detection)

## 1. Edit Source Lisr
### 1.1 Remove the old Source
```bash
mv /etc/apt/sources.list /etc/apt/sources.list.deleted
mv /etc/apt/sources.list.d/pve-enterprise.list /etc/apt/sources.list.d/pve-enterprise.list.deleted
```
### 1.2 Edit | /etc/apt/sources.list |
```bash
deb https://mirrors.ustc.edu.cn/debian/ bookworm main contrib non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian/ bookworm-updates main contrib non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian/ bookworm-backports main contrib non-free non-free non-free-firmware
deb https://mirrors.ustc.edu.cn/debian-security bookworm-security main contrib non-free non-free-firmware
#pve源
deb https://mirrors.ustc.edu.cn/proxmox/debian bookworm pve-no-subscription
#ceph源
deb https://mirrors.ustc.edu.cn/proxmox/debian/ceph-quincy bookworm main
#开发源，必须
deb https://mirrors.ustc.edu.cn/proxmox/debian/devel bookworm main
```

### 1.3 nano | /etc/apt/sources.list.d/ceph.list |
```bash
#deb https://enterprise.proxmox.com/debian/ceph-quincy bookworm enterprise
#deb http://download.proxmox.com/debian/ceph-quincy bookworm no-subscription
```

### 1.4 nano | /etc/apt/sources.list.d/pve-no-subscription.list |
```bash
deb https://mirrors.ustc.edu.cn/proxmox/debian/pve bookworm pve-no-subscription
```

### 1.5 update & upgrade your systtem
```bash
apt update -y && apt dist-upgrade -y
```

##  2.  Check KVM Verison
```bash
dpkg -l|grep kvm
```

##  3.  Install Env
```bash
apt update
apt install git curl wget -y
```

##  4.  Clone pve-qemu Source
```bash
git clone git://git.proxmox.com/git/pve-qemu.git
cd pve-qemu
```

###  4.1  Update of Source Libuary from your KVM Version  (Step01)
```bash
git reset --hard (commit version)
```
### KVM Versions List
| Versions| Commit                                   |
| --------| ---------------------------------------- |
| **PVE 7.2**                                        |
| 7.2.0-6 | 67cae45f41449517b7d7418e159f2519b55009ff |
| 7.2.0-7 | 09186f4b6e6c30bebc69930e0f66da7f8fbd0ece |
| 7.2.0-8 | 93d558c1eef8f3ec76983cbe6848b0dc606ea5f1 |
| **PVE 8.0**                                        |
| 8.0.0-1 | bd3c1fa52561e4a307e5b5b37754788408fc75a6 |
| 8.0.2-1 | 0e9a7bfda2725804ab8d741d881b0454f2611d21 |
| 8.0.2-2 | 3aaa855e5cbc8346977b34d82336b11bc3778a43 |
| 8.0.2-3 | 409db0cd7bdc833e4a09d39492b319426029aa92 |
| 8.0.2-4 | d9cbfafeeb9a529184b7ab2a8564fd3a1489ce83 |
| 8.0.2-5 | 6cadf3677dfa02e11b68b374e6ddd4f99e97fd2f |
| 8.0.2-6 | 6c5563e30bea889ffc38a03d6ac86866c50e6484 |
| 8.0.2-7 | eca4daeeed268790e5d0cd7c5a98be24623724af |
| **PVE 8.1**                                        |
| 8.1.2-1 | 1807330a6fa79c37bb5e6330cee5d49de05579c0 |
| 8.1.2-2 | 33b22c3fe03e5a6a8b32d7148c4ba774fd7c9937 |
| 8.1.2-3 | 38726d3473828b3e276dc13778d2ce5d43d33469 |
| 8.1.2-4 | 24d732ac0f4ab613ba6e6f77a34bea0742bdcf3b |
| 8.1.2-5 | c6eb05a79954fd490e2e09708c86aafb89554043 |
| 8.1.2-6 | f366bb97ae67910cb36a9f6e36d26e8d6070ad57 |
| 8.1.5-1 | 12b69ed9c5d919cbd0805fcf01a82ef094cf3a6c |
| 8.1.5-2 | 676adda3c697a2f6eeff512c985d82761ec78264 |
| 8.1.5-3 | 0d4462207ba23931c168a5d674ee356517e86ba6 |

`Last Update:   25.02.2024  `

Use this websitte to check your kvm commit versions
[Commit Version](https://git.proxmox.com/?p=pve-qemu.git;a=summary)

###  4.2  Build a Package
```bash
apt install  devscripts -y
mk-build-deps --install
```

## 5.Rebuild of Anti-VM Detection
### 5.1 Clear of last Build
```bash
make clean
```

### 5.2 Backup QEMU Folder
```bash
cp -r qemu qemu-bak
```

### 5.3 Create a SED File or Download from [Here](https://github.com/ChongZhiJie0216/Notes/blob/main/PromoxVE/Anti-Detection/sedPatch-pve-qemu-kvm7-8-anti-dection.sh)
```bash
cd qemu
nano sedPatch-pve-qemu-kvm7-8-anti-dection.sh
```

### 5.4 Paste this into |sedPatch-pve-qemu-kvm7-8-anti-dection.sh|
```bash
#!/bin/bash
#适用于给pve-qemu-kvm7 和pve-qemu-kvm8里面的qemu打补丁使用，最高从7.0支持到8.1(再高的8.2等没有测试)，直接放本脚本在qemu目录下，在make包之前在qemu目录运行一次本脚本就是，运行后你可以继续使用git工具生成qemu具体版本的patch文件
#参考开源项目 https://github.com/zhaodice/proxmox-ve-anti-detection 编写，处理重复劳作
#作者 李晓流
echo "开始sed工作"
sed -i 's/QEMU v" QEMU_VERSION/ASUS v" QEMU_VERSION/g' block/vhdx.c
sed -i 's/QEMU VVFAT", 10/ASUS VVFAT", 10/g' block/vvfat.c
sed -i 's/QEMU Microsoft Mouse/ASUS Microsoft Mouse/g' chardev/msmouse.c
sed -i 's/QEMU Wacom Pen Tablet/ASUS Wacom Pen Tablet/g' chardev/wctablet.c
sed -i 's/QEMU vhost-user-gpu/ASUS vhost-user-gpu/g' contrib/vhost-user-gpu/vhost-user-gpu.c
sed -i 's/desc->oem_id/ACPI_BUILD_APPNAME6/g' hw/acpi/aml-build.c
sed -i 's/desc->oem_table_id/ACPI_BUILD_APPNAME8/g' hw/acpi/aml-build.c
sed -i 's/array, ACPI_BUILD_APPNAME8/array, "PTL "/g' hw/acpi/aml-build.c

grep "do this once" hw/acpi/vmgenid.c >/dev/null
if [ $? -eq 0 ]; then
	echo "hw/acpi/vmgenid.c 文件只能处理一次！以前已经处理，本次不执行！"
else
	sed -i 's/    Aml \*ssdt/       \/\/FUCK YOU~~~\n       return;\/\/do this once\n    Aml \*ssdt/g' hw/acpi/vmgenid.c
	echo "hw/acpi/vmgenid.c 文件处理完成（第一次处理，只处理一次）"
fi

sed -i 's/QEMU N800/ASUS N800/g' hw/arm/nseries.c
sed -i 's/QEMU LCD panel/ASUS LCD panel/g' hw/arm/nseries.c
sed -i 's/strcpy((void *) w, "QEMU ")/strcpy((void *) w, "ASUS ")/g' hw/arm/nseries.c
sed -i 's/"1.1.10-qemu" : "1.1.6-qemu"/"1.1.10-asus" : "1.1.6-asus"/g' hw/arm/nseries.c
sed -i "s/QEMU 'SBSA Reference' ARM Virtual Machine/ASUS 'SBSA Reference' ARM Real Machine/g" hw/arm/sbsa-ref.c
sed -i 's/QEMU Sun Mouse/ASUS Sun Mouse/g' hw/char/escc.c
sed -i 's/info->vendor = "RHT"/info->vendor = "DEL"/g' hw/display/edid-generate.c
sed -i 's/QEMU Monitor/DEL Monitor/g' hw/display/edid-generate.c
sed -i 's/uint16_t model_nr = 0x1234;/uint16_t model_nr = 0xA05F;/g' hw/display/edid-generate.c

grep "do this once" hw/i386/acpi-build.c >/dev/null
if [ $? -eq 0 ]; then
	echo "hw/i386/acpi-build.c 文件只能处理一次！以前已经处理，本次不执行！"
else
	sed -i '/static void build_dbg_aml(Aml \*table)/,/ /s/{/{\n     return;\/\/do this once/g' hw/i386/acpi-build.c
	sed -i '/create fw_cfg node/,/}/s/}/}*\//g' hw/i386/acpi-build.c
	sed -i '/create fw_cfg node/,/}/s/{/\/*{/g' hw/i386/acpi-build.c
	echo "hw/i386/acpi-build.c 文件处理完成（第一次处理，只处理一次）"
fi

sed -i 's/"QEMU", "Standard PC (i440FX + PIIX, 1996)",/"ASUS", "M4A88TD-M",/g' hw/i386/pc_piix.c
sed -i 's/"QEMU", "Standard PC (Q35 + ICH9, 2009)",/"ASUS", "M4A88TD-M",/g' hw/i386/pc_q35.c
sed -i 's/mc->name, pcmc->smbios_legacy_mode,/"ASUS-PC", pcmc->smbios_legacy_mode,/g' hw/i386/pc_q35.c
sed -i 's/pcmc->smbios_uuid_encoded,/0x00,/g' hw/i386/pc_q35.c
sed -i 's/"QEMU/"ASUS/g' hw/ide/atapi.c
sed -i 's/"QEMU/"ASUS /g' hw/ide/core.c
sed -i 's/QM%05d/ASUS%05d/g' hw/ide/core.c
sed -i 's/"QEMU/"ASUS/g' hw/input/adb-kbd.c
sed -i 's/"QEMU/"ASUS/g' hw/input/adb-mouse.c
sed -i 's/"QEMU/"ASUS/g' hw/input/ads7846.c
sed -i 's/"QEMU/"ASUS/g' hw/input/hid.c
sed -i 's/"QEMU/"ASUS/g' hw/input/ps2.c
sed -i 's/"QEMU/"ASUS/g' hw/input/tsc2005.c
sed -i 's/"QEMU/"ASUS/g' hw/input/tsc210x.c
sed -i 's/"QEMU Virtio/"ASUS/g' hw/input/virtio-input-hid.c
sed -i 's/QEMU M68K Virtual Machine/ASUS M68K Real Machine/g' hw/m68k/virt.c
sed -i 's/"QEMU/"ASUS/g' hw/misc/pvpanic-isa.c
sed -i 's/"QEMU/"ASUS/g' hw/nvme/ctrl.c
sed -i 's/0x51454d5520434647ULL/0x4155535520434647ULL/g' hw/nvram/fw_cfg.c
sed -i 's/"QEMU/"ASUS/g' hw/pci-host/gpex.c
sed -i 's/"QEMU/"ASUS/g' hw/ppc/e500plat.c
sed -i 's/qemu-e500/asus-e500/g' hw/ppc/e500plat.c
sed -i 's/s16s8s16s16s16/s11s4s51s41s91/g' hw/scsi/mptconfig.c
sed -i 's/QEMU MPT Fusion/ASUS MPT Fusion/g' hw/scsi/mptconfig.c
sed -i 's/"QEMU"/"ASUS"/g' hw/scsi/mptconfig.c
sed -i 's/0000111122223333/1145141919810000/g' hw/scsi/mptconfig.c
sed -i 's/"QEMU/"ASUS/g' hw/scsi/scsi-bus.c
sed -i 's/"QEMU/"ASUS/g' hw/scsi/scsi-disk.c
sed -i 's/"QEMU/"ASUS/g' hw/scsi/spapr_vscsi.c
sed -i 's/extension_bytes[1] = 0x14/extension_bytes[1] = 0x08/g' hw/smbios/smbios.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-audio.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-hid.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-hub.c
sed -i 's/314159/114514/g' hw/usb/dev-hub.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-mtp.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-network.c
sed -i 's/"RNDIS\/QEMU/"RNDIS\/ASUS/g' hw/usb/dev-network.c
sed -i 's/400102030405/400114514405/g' hw/usb/dev-network.c
sed -i 's/s->vendorid = 0x1234/s->vendorid = 0x8086/g' hw/usb/dev-network.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-serial.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-smartcard-reader.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-storage.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-uas.c
sed -i 's/27842/33121/g' hw/usb/dev-uas.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/dev-wacom.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/u2f-emulated.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/u2f-passthru.c
sed -i 's/"QEMU/"ASUS/g' hw/usb/u2f.c
sed -i 's/"BOCHS/"INTEL/g' include/hw/acpi/aml-build.h
sed -i 's/"BXPC/"PC8086/g' include/hw/acpi/aml-build.h
sed -i 's/"QEMU0002/"ASUS0002/g' include/standard-headers/linux/qemu_fw_cfg.h
sed -i 's/0x51454d5520434647ULL/0x4155535520434647ULL/g' include/standard-headers/linux/qemu_fw_cfg.h
sed -i 's/"QEMU/"ASUS/g' migration/migration.c
sed -i 's/"QEMU/"ASUS/g' migration/rdma.c
sed -i 's/0x51454d5520434647ULL/0x4155535520434647ULL/g' pc-bios/optionrom/optionrom.h
sed -i 's/"QEMU/"ASUS/g' pc-bios/s390-ccw/virtio-scsi.h
sed -i 's/"QEMU/"ASUS/g' roms/seabios/src/fw/ssdt-misc.dsl
sed -i 's/"QEMU/"ASUS/g' roms/seabios-hppa/src/fw/ssdt-misc.dsl
#sed -i 's/KVMKVMKVM\\0\\0\\0/GenuineIntel/g' target/i386/kvm/kvm.c
sed -i 's/QEMUQEMUQEMUQEMU/ASUSASUSASUSASUS/g' target/s390x/tcg/misc_helper.c
sed -i 's/"QEMU/"ASUS/g' target/s390x/tcg/misc_helper.c
sed -i 's/"KVM/"ATX/g' target/s390x/tcg/misc_helper.c
echo "结束sed工作"
```
> [!NOTE]  
> |sed -i 's/KVMKVMKVM\\0\\0\\0/GenuineIntel/g' target/i386/kvm/kvm.c.|
> I Comment of this becuase I need vGPU Support ,if you need pelase unComment.

### 5.5 Give Permission of |sedPatch-pve-qemu-kvm7-8-anti-dection.sh|
```bash
chmod +x sedPatch-pve-qemu-kvm7-8-anti-dection.sh
```

### 5.6 Run it
```bash
bash sedPatch-pve-qemu-kvm7-8-anti-dection.sh
```

### 5.7 Return to |pve-qemu| dir and make
```bash
cd ..
make
```

##  6 Intall of Anti-Detection Package
```bash
dpkg -i
```

### 6.1 And Add This Parameter to your VM
```bash
qm set <VM_ID> --args "-cpu host,hypervisor=off,vmware-cpuid-freq=false,enforce=false,host-phys-bits=true, -smbios type=0,version=X9SRLF.B13 -smbios type=1,manufacturer=Supermicro,product=X9SRL-F,version=2017.01 -smbios type=2,manufacturer=Intel,version=2021.5,product='Intel E5-2697v2' -smbios type=3,manufacturer=XBZJ -smbios type=17,manufacturer=KINGSTON,loc_pfx=DDR3,speed=1600,serial=114514,part=FF63 -smbios type=4,manufacturer=Intel,max-speed=1600,current-speed=1600"
```