# Mounting SMB and NFS in FSTAB

##  1. Install
First, ensure that you have installed the cifs-utils package, which includes tools for mounting SMB shared folders. If you haven't installed this package yet, you can do so using the following command.
```bash
sudo apt-get install cifs-utils
```

## 2. Make DIR for Cliet Storge From Host
Next, you need to create a local directory for mounting SMB/NFS shared folders. For example, you can create a directory named smb_share:
```bash
sudo mkdir /mnt/smb_share
```

##  3.Edit fstab file
```bash
sudo nano /etc/fstab
```

## 4. Save and Reload
Finally, save the /etc/fstab file and exit the editor. Use the following command to reload the fstab file to ensure that your changes take effect:
```bash
sudo mount -a
#or
systemctl daemon-reload
```

### Example of fstab
```bash
#SMB
//<HOST_IP>/<HOST_LOCATION> /<CLIENT_PATH> cifs username=<ID>,password=<PASSWORD>,comment=systemd.automount,nofail,rw,uid=1000,gid=1000
//<HOST_IP>/<HOST_LOCATION> /<CLIENT_PATH> cifs username=<ID>,password=<PASSWORD>,comment=systemd.automount,nofail,rw,uid=33,gid=33,file_mode=0770,dir_mode=0770 0 0
#NFS
<HOST_IP>:/<HOST_LOCATION> /<CLIENT_PATH> nfs username=<ID>,password=<PASSWORD>,comment=systemd.automount,nofail,rw,uid=33,gid=33
```

| Parameter     | Description                                                    |
| --------------| -------------------------------------------------------------- |
| comment       | systemd.automount: Automatically mounts during system boot.    |
| nofail        | Automatically remounts in case of failure.                     |
| rw            | Grants both read and write permissions.                        |
| uid           | Sets the user ID (UID) for Linux user group permissions.       |
| gid           | Sets the group ID (GID) for Linux user group permissions.      |
| file_mode     | Sets the file mode to 0770, providing read permissions.        |
| dir_mode      | Sets the directory mode to 0770, providing write permissions.  |
| 0 0	          | General permissions.                                           |
