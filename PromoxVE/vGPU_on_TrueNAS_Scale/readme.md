# TrueNAS_Scale_vGPU_Driver Instalation

### 1.Enable Developer Mode on TrueNAS-Scale

```bash
install-dev-tools
```

#### 1.2 Encountered Read-only file system problem, unable to create anything

```bash
zfs get readonly
zfs set readonly=off [dataset]
```

Example of [dataset]
`zfs set readonly=off boot-pool/ROOT/24.04-BETA.1`

### 2.Similar to installing the driver on the host, disable nouveau and install the necessary packages

```bash
echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf
apt install build-essential gcc-multilib dkms mdevctl
update-initramfs -k all -u
reboot
```

### 3.After the restart is complete, install the Guest driver

```bash
chmod +x NVIDIA-Linux-x86_64-535.54.03-grid.run
./NVIDIA-Linux-x86_64-535.54.03-grid.run
```

### 4.Verify installation was successful

```bash
dkms status
nvidia-smi
nvidia-smi -q | grep License
```

> [!NOTE]
> View authorization, Unlicensed (Unrestricted) means not authorized

### 5.FastAPI-DLS Authorization

```bash
curl --insecure -L -X GET https://<IP_ADDR>/-/client-token -o /etc/nvidia/ClientConfigToken/client_configuration_token_$(date '+%d-%m-%Y-%H-%M-%S').tok

service nvidia-gridd restart
nvidia-smi -q | grep License
```

> [!WARNING]
> FastAPI-DLS must be online as it performs authorization during system boot.
