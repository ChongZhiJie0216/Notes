# 1.Remove Source List

```bash
echo "deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription" >> /etc/apt/sources.list
rm /etc/apt/sources.list.d/pve-enterprise.list
```

### Add Source PVE8.0
```
deb http://ftp.debian.org/debian bookworm main contrib
deb http://ftp.debian.org/debian bookworm-updates main contrib

# Proxmox VE pve-no-subscription repository provided by proxmox.com,
# NOT recommended for production use
deb http://download.proxmox.com/debian/pve bookworm pve-no-subscription

# security updates
deb http://security.debian.org/debian-security bookworm-security main contrib
```

### Install Update
```bash
apt update
apt dist-upgrade
apt install -y git build-essential dkms pve-headers mdevctl
```

# 2.Enable IOMMU 
```bash
nano /etc/default/grub
```

### Add This
```grub
iommu=on
```

The result should look like this (for intel systems):
```
GRUB_CMDLINE_LINUX_DEFAULT="quiet intel_iommu=on"
```

>[!Note]
> ```pci=realloc=off```
> This Varable of give for Serial Attached SCSI controller
> Broadcom / LSI SAS2008 PCI-Express Fusion-MPT SAS-2 [Falcon] (rev 03)


### Update Grub
```bash
update-grub
```

### Loading required kernel modules and blacklisting the open source nvidia driver
```
echo -e "vfio\nvfio_iommu_type1\nvfio_pci\nvfio_virqfd" >> /etc/modules
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
```

### Applying our kernel configuration
```bash
update-initramfs -u -k all
reboot
```

# 3.Download vGPU Driver From NVIDIA Enterprice
Download Driver Files From [NVIDIA Enterprice](https://nvid.nvidia.com/login) and Login to Download

# 4.Install vGPU Driver
```bash
chmod +x NVIDIA-Linux-x86_64-550.54.10-vgpu-kvm.run
./NVIDIA-Linux-x86_64-550.54.10-vgpu-kvm.run --dkms -m=kernel
reboot
```

# 5.Finishing touches
### Command of Vertify
```bash
nvidia-smi
```

### To verify if the vGPU unlock worked, type this command
```bash
mdevctl types
```

# Args of AntiDetect of PromoxVE
```
qm set <VM_ID> --args "-cpu host,hypervisor=off,vmware-cpuid-freq=false,enforce=false,host-phys-bits=true, -smbios type=0,version=X9SRLF.B13 -smbios type=1,manufacturer=Supermicro,product=X9SRL-F,version=2017.01 -smbios type=2,manufacturer=Intel,version=2021.5,product='Intel E5-2697v2' -smbios type=3,manufacturer=XBZJ -smbios type=17,manufacturer=KINGSTON,loc_pfx=DDR3,speed=1600,serial=114514,part=FF63 -smbios type=4,manufacturer=Intel,max-speed=1600,current-speed=1600"

```