#   Step of Build VE-Anti-Detection

##  1.  Check KVM Verison
```bash
dpkg -l|grep kvm
```

##  2.  Install Env
```bash
apt update
apt install git curl wget -y
```

##  3.  Clone pve-qemu Source
```bash
git clone git://git.proxmox.com/git/pve-qemu.git
cd pve-qemu
```

##  4.  Update of Source Libuary from your KVM Version  (Step01)
```bash
git reset --hard (commit version)
```
### KVM Versions List
| Versions| Commit                                   |
| --------| ---------------------------------------- |
| **PVE 7.2** |
| 7.2.0-6 | 67cae45f41449517b7d7418e159f2519b55009ff |
| 7.2.0-7 | 09186f4b6e6c30bebc69930e0f66da7f8fbd0ece |
| 7.2.0-8 | 93d558c1eef8f3ec76983cbe6848b0dc606ea5f1 |
| **PVE 8.0** |
| 8.0.0-1 | bd3c1fa52561e4a307e5b5b37754788408fc75a6 |
| 8.0.2-1 | 0e9a7bfda2725804ab8d741d881b0454f2611d21 |
| 8.0.2-2 | 3aaa855e5cbc8346977b34d82336b11bc3778a43 |
| 8.0.2-3 | 409db0cd7bdc833e4a09d39492b319426029aa92 |
| 8.0.2-4 | d9cbfafeeb9a529184b7ab2a8564fd3a1489ce83 |
| 8.0.2-5 | 6cadf3677dfa02e11b68b374e6ddd4f99e97fd2f |
| 8.0.2-6 | 6c5563e30bea889ffc38a03d6ac86866c50e6484 |
| 8.0.2-7 | eca4daeeed268790e5d0cd7c5a98be24623724af |
| **PVE 8.1** |
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

##  5.  Build a Package
```bash
apt install  devscripts -y
mk-build-deps --install -y
wget "https://github.com/zhaodice/proxmox-ve-anti-detecion/raw/main/001-anti-detection.patch" -O qemu/001-anti-detection.patch
make
```