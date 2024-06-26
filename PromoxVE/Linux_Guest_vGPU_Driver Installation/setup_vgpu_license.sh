#!/bin/bash

# This script automates the licensing of the vGPU guest driver
# on Unraid boot. Set the Schedule to: "At Startup of Array".
# 
# Relies on FastAPI-DLS for the licensing.
# It assumes FeatureType=1 (vGPU), change it as you see fit in line <>
# 
# Requires `eflutils` to be installed in the system for `nvidia-gridd` to run
# To Install it:
# 1) You might find it here: https://packages.slackware.com/ (choose the 64bit version of Slackware)
# 2) Download the package and put it in /boot/extra to be installed on boot
# 3) a. Reboot to install it, OR
#    b. Run `upgradepkg --install-new /boot/extra/elfutils*`
# [i]: Make sure to have only one version of elfutils, otherwise you might run into issues

# Sources and docs:
# https://docs.nvidia.com/grid/15.0/grid-vgpu-user-guide/index.html#configuring-nls-licensed-client-on-linux
# https://gitlab.scarletlabs.io/sl/virtualized-unraid-vgpu-grid-driver-setup

################################################
# MAKE SURE YOU CHANGE THESE VARIABLES         #
################################################

###### CHANGE ME! 
# IP and PORT of FastAPI-DLS 
DLS_IP=
#DLS_IP=dls.jiecloud.net
DLS_PORT=443
# Token folder, must be on a filesystem that supports
# linux filesystem permissions (eg: ext4,xfs,btrfs...)
TOKEN_PATH=/mnt/disk1/system/nvidia/ ###### Create a folder under /mnt/user/somwhere/nvidia/ (e.g. /mnt/user/system/nvidia)
PING=$(which ping)

# Check if the License is applied
if [[ "$(nvidia-smi -q | grep "Expiry")" == *Expiry* ]]; then
    echo " [i] Your vGPU Guest drivers are already licensed."
    echo " [i] $(nvidia-smi -q | grep "Expiry")"
    echo " [<] Exiting..."
    exit 0
fi

# Check if the FastAPI-DLS server is reachable
until ${PING} -c1 ${DLS_IP} > /dev/null 2>&1
do
	sleep 5
	echo " [*] DLS online, proceeding..."
done

# Check if the token folder exists
if [ -d "${TOKEN_PATH}" ]; then
	echo " [*] Token Folder exists. Proceeding..."
else
	echo " [!] Token Folder does not exists or not ready yet. Exiting."
	echo " [!] Token Folder Specified: ${TOKEN_PATH}"
	exit 1
fi

# Check if elfutils are installed, otherwise nvidia-gridd service
# wont start
if [ "$(grep -R "elfutils" /var/log/packages/* | wc -l)" != 0 ]; then
        echo " [*] Elfutils is installed, proceeding..."
else
        echo " [!] Elfutils is not installed, downloading and installing..."
        echo " [!] Downloading elfutils to /boot/extra"
        echo " [i] This script will download elfutils from slackware64-15.0 repository."
        echo " [i] If you have a different version of Unraid (6.11.5), you might want to"
        echo " [i] download and install a suitable version manually from the slackware"
        echo " [i] repository, and put it in /boot/extra to be install on boot."
        echo " [i] You may also install it by running: "
        echo " [i] upgradepkg --install-new /path/to/elfutils-*.txz"
        echo ""
        echo " [>] Downloading elfutils from slackware64-15.0 repository:"
        wget -q -nc --show-progress --progress=bar:force:noscroll -P /boot/extra https://slackware.uk/slackware/slackware64-15.0/slackware64/l/elfutils-0.186-x86_64-1.txz 2>/dev/null \
        || { echo " [!] Error while downloading elfutils, please download it and install it manually."; exit 1; }
	    echo ""
        if upgradepkg --install-new /boot/extra/elfutils-0.186-x86_64-1.txz 
        then
                echo " [*] Elfutils installed and will be installed automatically on boot"
        else
                echo " [!] Error while installing, check logs..."
                exit 1
        fi
fi

create_token () {
	echo " [>] Creating new token..."
	if ${PING} -c1 ${DLS_IP} > /dev/null 2>&1
	then
		# curl --insecure -L -X GET https://${DLS_IP}:${DLS_PORT}/-/client-token -o ${TOKEN_PATH}/client_configuration_token_"$(date '+%d-%m-%Y-%H-%M-%S')".tok || { echo " [!] Could not get the token, please check the server."; exit 1;}
		wget -q -nc -4c --no-check-certificate --show-progress --progress=bar:force:noscroll -O "${TOKEN_PATH}"/client_configuration_token_"$(date '+%d-%m-%Y-%H-%M-%S')".tok https://${DLS_IP}:${DLS_PORT}/-/client-token \
		|| { echo " [!] Could not get the token, please check the server."; exit 1;}
		chmod 744 "${TOKEN_PATH}"/*.tok || { echo " [!] Could not chmod the tokens."; exit 1; }
		echo ""
		echo " [*] Token downloaded and stored in ${TOKEN_PATH}."
	else
		echo " [!] Could not get token, DLS server unavailable ."
		exit 1
	fi
}

setup_run () {
        echo " [>] Setting up gridd.conf"
        cp /etc/nvidia/gridd.conf.template /etc/nvidia/gridd.conf || { echo " [!] Error configuring gridd.conf, did you install the drivers correctly?"; exit 1; }
        sed -i 's/FeatureType=0/FeatureType=1/g' /etc/nvidia/gridd.conf
        echo "ClientConfigTokenPath=${TOKEN_PATH}" >> /etc/nvidia/gridd.conf
        echo " [>] Creating /var/lib/nvidia folder structure"
        mkdir -p /var/lib/nvidia/GridLicensing
        echo " [>] Starting nvidia-gridd"
        if pidof nvidia-gridd >/dev/null 2>&1
        then
            echo " [!] nvidia-gridd service is running. Closing."
            sh /usr/lib/nvidia/sysv/nvidia-gridd stop
            # kill the service if does not close
            if pidof nvidia-gridd >/dev/null 2>&1; then
                kill -9 "$(pidof nvidia-gridd)" || { echo " [!] Error while closing nvidia-gridd service"; exit 1; }
            fi
            echo " [*] Restarting nvidia-gridd service."
            sh /usr/lib/nvidia/sysv/nvidia-gridd start
            if pidof nvidia-gridd >/dev/null 2>&1; then
                echo " [*] Servie started, PID: $(pidof nvidia-gridd)"
            else
                echo -e " [!] Error while starting nvidia-gridd service. Use strace -f nvidia-gridd to debug.\n [i] Check if elfutils is installed.\n [i] strace is not installed by default."
                exit 1
            fi
        else
            sh /usr/lib/nvidia/sysv/nvidia-gridd start
            if pidof nvidia-gridd >/dev/null 2>&1; then
                echo " [*] Servie started, PID: $(pidof nvidia-gridd)"
            else
                echo -e " [!] Error while starting nvidia-gridd service. Use strace -f nvidia-gridd to debug.\n [i] Check if elfutils is installed.\n [i] strace is not installed by default."
                exit 1
            fi
        fi
}

for token in "${TOKEN_PATH}"/*; do
    if [ "${token: -4}" == ".tok" ]
    then
        echo " [*] Tokens found..."
        setup_run
    else
        echo " [!] No Tokens found..."
        create_token
        setup_run
    fi
done

until nvidia-smi -q | grep "Expiry" >/dev/null 2>&1; do
    sleep 3
	echo " [>] vGPU getting Licensed... Checking again"
    echo " [i] $(nvidia-smi -q | grep "Expiry")"
done

echo " [>] Done..."
