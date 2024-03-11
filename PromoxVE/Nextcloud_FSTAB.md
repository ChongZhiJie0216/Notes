```smb
//<HOST_IP>/<HOST_LOCATION> /<CLIENT_PATH> cifs username=<ID>,password=<PASSWORD>,comment=systemd.automount,nofail,rw,uid=1000,gid=1000
//<HOST_IP>/<HOST_LOCATION> /<CLIENT_PATH> cifs username=<ID>,password=<PASSWORD>,comment=systemd.automount,nofail,rw,uid=33,gid=33,file_mode=0770,dir_mode=0770 0 0
```

```NFS
<HOST_IP>:/<HOST_LOCATION> /<CLIENT_PATH> nfs username=<ID>,password=<PASSWORD>,comment=systemd.automount,nofail,rw,uid=33,gid=33
```

| Parameter| Description                                   |
| --------------| -------------------------------------------------------------- |
| comment       | systemd.automount: Automatically mounts during system boot.    |
| nofail        | Automatically remounts in case of failure.                     |
| rw            | Grants both read and write permissions.                        |
| uid           | Sets the user ID (UID) for Linux user group permissions.       |
| gid           | Sets the group ID (GID) for Linux user group permissions.      |
| file_mode     | Sets the file mode to 0770, providing read permissions.        |
| dir_mode      | Sets the directory mode to 0770, providing write permissions.  |
| 0 0	          | General permissions.                                           |
