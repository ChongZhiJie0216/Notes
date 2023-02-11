# 备份和恢复 GPG 密钥
___
[Gnu Privacy Guard](https://gnupg.org/)，也称为 GnuPG 和 GPG，是一个用于管理[OpenPGP](https://www.openpgp.org/)密钥的便捷工具。虽然不像许多人那样使用 PGP 密钥加密电子邮件，但我在使用[Git](https://git-scm.com/)时确实使用 PGP 密钥来签署我的工作。PGP 密钥可能比 SSH 密钥更难替换，因此进行备份对于减少未来的麻烦至关重要。

## 教程
___
以下步骤将向您展示如何使用 GnuPG（确切地说是 2.2.20 版）备份和恢复 PGP 密钥。备份是电子的，而不是物理的，例如使用[PaperKey](https://www.jabberwocky.com/software/paperkey/)创建的备份。我还建议使用 PaperKey 在纸上创建一个备份密钥，并将其保存在安全的地方以增加一层冗余。预计您已经熟悉从命令行使用 GnuPG，并且已经安装了 GPG，并带有可用于备份的密钥对。

# 备份

### 1. 首先，确定要备份的密钥。
     指令`gpg --list-secret-keys --keyid-format LONG`
```
➜ gpg --list-secret-keys --keyid-format LONG
/home/pstibbons/.gnupg/pubring.kbx
-------------------------------
sec   rsa4096/C8DE632E9A8A0BDD 2020-11-13 [SC]
      F38915B041F5F1024AF95C30C8DE632E9A8A0BDD
uid                 [ultimate] Ponder Stibbons <ponder.stibbons@unseen.edu>
ssb   rsa4096/DBCD8B98F2F9188C 2020-11-13 [E]
```
这里只有一个 Ponder Stibbons 的私钥。

### 2.导出 GPG 私钥。
`gpg -o private.gpg --export-options backup --export-secret-keys ponder.stibbons@unseen.edu`

此调用将密钥放置在private.gpg当前目录的文件中。导出选项backup导出 GnuPG 恢复密钥所需的所有数据。

### 3.在【导出密码提示】中输入私钥密码即可导出密钥。
![avatar](/Export%20Passphrase%20Prompt.png)
导出密码提示

### 4.现在将此备份放在安全的地方。理想情况下，仅将其存储在离线媒体上。

# **恢复**

### 1.导入私钥
指令：`gpg --import-options restore --import private.gpg`
```
➜ gpg --import-options restore --import private.gpg
gpg: key C8DE632E9A8A0BDD: public key "Ponder Stibbons <ponder.stibbons@unseen.edu>" imported
gpg: key C8DE632E9A8A0BDD: secret key imported
gpg: Total number processed: 1
gpg:               imported: 1
gpg:       secret keys read: 1
gpg:   secret keys imported: 1
```
```private.gpg```此调用从当前目录中的文件导入密钥。导入选项```restore```导入 GnuPG 完全恢复密钥所需的所有数据。导入选项```keep-ownertrust```保持所有者对密钥的信任，而不是清除它的信任值。这样可以避免以后手动设置密钥的信任值。

### 2.在【导入密码提示】中输入私钥的密码，导入密钥。
![avatar](/Import%20Passphrase%20Prompt.png)
导入密码提示

### 3.现在，编辑新导入的密钥。
指令:`gpg --edit-key ponder.stibbons@unseen.edu`
```
➜ gpg --edit-key ponder.stibbons@unseen.edu
gpg (GnuPG) 2.2.20; Copyright (C) 2020 Free Software Foundation, Inc.
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

Secret key is available.

sec  rsa4096/C8DE632E9A8A0BDD
     created: 2020-11-13  expires: never       usage: SC
     trust: unknown       validity: unknown
ssb  rsa4096/DBCD8B98F2F9188C
     created: 2020-11-13  expires: never       usage: E
[ unknown] (1). Ponder Stibbons <ponder.stibbons@unseen.edu>
```
### 4.输入trust修改密钥的信任值。
指令:`gpg> trust`
```
gpg> trust
sec  rsa4096/C8DE632E9A8A0BDD
     created: 2020-11-13  expires: never       usage: SC
     trust: unknown       validity: unknown
ssb  rsa4096/DBCD8B98F2F9188C
     created: 2020-11-13  expires: never       usage: E
[ unknown] (1). Ponder Stibbons <ponder.stibbons@unseen.edu>
```

### 5.输入 kbd:[5] 以完全信任您的密钥。
```
Please decide how far you trust this user to correctly verify other users' keys
(by looking at passports, checking fingerprints from different sources, etc.)

  1 = I don't know or won't say
  2 = I do NOT trust
  3 = I trust marginally
  4 = I trust fully
  5 = I trust ultimately
  m = back to the main menu

Your decision? 5
```
### 6.通过输入 kbd:[Y] 确认您的选择。
```
Do you really want to set this key to ultimate trust? (y/N) y

sec  rsa4096/C8DE632E9A8A0BDD
     created: 2020-11-13  expires: never       usage: SC
     trust: ultimate      validity: unknown
ssb  rsa4096/DBCD8B98F2F9188C
     created: 2020-11-13  expires: never       usage: E
[ unknown] (1). Ponder Stibbons <ponder.stibbons@unseen.edu>
Please note that the shown key validity is not necessarily correct
unless you restart the program.
```

### 7.使用命令quit退出。
`gpg> quit`

# **结论**
您现在应该能够备份和恢复您的 GPG 私钥。


