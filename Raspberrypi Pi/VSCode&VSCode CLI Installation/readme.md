# VSCode-CLI 下载安装

# 1.更新资源包

```bash
sudo apt-get update
sudo apt update
sudo apt install curl wget git -y
```

# 2.下载 VSCode-CLI

```bash
wget https://code.visualstudio.com/sha/download?build=stable&os=cli-alpine-arm64
tar -xzvf vscode_cli_alpine_arm64_cli.tar.gz
sudo mv code /usr/bin/

```

# 3.下载 VSCode

```bash
wget https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-arm64
sudo apt install ./code_1.83.1-1696982739_arm64.deb
```
