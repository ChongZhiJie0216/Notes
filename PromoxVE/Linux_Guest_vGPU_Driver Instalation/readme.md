# Linux_Guest_vGPU_Driver Instalation

## On Debian and Ubuntu
### 1.Similar to installing the driver on the host, disable nouveau and install the necessary packages
```bash
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
apt install build-essential gcc-multilib dkms mdevctl
update-initramfs -k all -u
reboot
```

### 2.After the restart is complete, install the Guest driver
```bash
chmod +x NVIDIA-Linux-x86_64-535.54.03-grid.run
./NVIDIA-Linux-x86_64-535.54.03-grid.run
```

### 3.Verify installation was successful
```bash
dkms status
nvidia-smi
nvidia-smi -q | grep License
```

> [!NOTE]
> View authorization, Unlicensed (Unrestricted) means not authorized

### 4.FastAPI-DLS Authorization
```bash
curl --insecure -L -X GET https://<IP_ADDR>/-/client-token -o /etc/nvidia/ClientConfigToken/client_configuration_token_$(date '+%d-%m-%Y-%H-%M-%S').tok
 
service nvidia-gridd restart
nvidia-smi -q | grep License 
```

> [!WARNING]
> FastAPI-DLS must be online as it performs authorization during system boot.

# On Unriad
  1.  Make sure you create a folder in a linux filesystem (BTRFS/XFS/EXT4...), 
  I recommend /mnt/user/system/nvidia (this is where docker and libvirt preferences are saved, so it's a good place to have that)

  2.  Edit the script to put your DLS_IP, DLS_PORT and TOKEN_PATH, properly
  3.  Install User Scripts plugin from Community Apps (the Apps page, or google User Scripts Unraid if you're not using CA)
  4.  Go to Settings > Users Scripts > Add New Script
  5.  Give it a name  (the name must not contain spaces preferably)
  6.  Click on the gear icon to the left of the script name then edit script
  7.  Paste the **[script]()** and save
  8.  Set schedule to At First Array Start Only
  9.  Click on Apply
