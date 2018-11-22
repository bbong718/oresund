#!/bin/bash

CONTAINED=0

OVPN_HOME="/home/oresund"
OVPN_ROOT="./openvpn/"
OVPN_FILE="unmanarc_android_openvpn2.3.2_cwm_b2.zip"
OVPN_URL="http://contrib.unmanarc.com/androidvpn/download2.php"
OVPN_SYSTEM="./system"
OVPN_SHELL="$OVPN_SYSTEM/xbin/openvpn"

UNZIP=`whereis unzip`;
SED=`whereis sed`
ROUTE=`whereis route`
IF=`whereis if`
IFCONFIG=`whereis ifconfig`
LN=`whereis ln`

echo "$SED"

read -p '[+] Do you want to start self-contained setup? [Y/n]: ' REPLY
if [[ $REPLY = "Y" || $REPLY = "y" ]]; then
    CONTAINED=1
    mkdir $OVPN_HOME
    cd $OVPN_HOME
else
    echo "[!] Nothing I can help with."
    echo "[!] Download OpenVPN for armv7 here: $OVPN_URL"
    exit 1
fi

if [ $CONTAINED = 1 ]; then
    echo "[+] Looking for unzip..."
    if [ -e $UNZIP ]; then
        echo "[!] Found unzip!"
    else
        echo "[!!] Could not find unzip!"
        exit 1
    fi

    echo "[+] Looking for OpenVPN..."
    if [ -f "$OVPN_ROOT$OVPN_FILE" ]; then
        echo "[!] Found $OVPN_ROOT$OVPN_FILE"
    else
        echo "[!!] Could not find OpenVPN, visit: $OVPN_URL and download"
        exit 1
    fi

    echo "[+] Unzipping OpenVPN archive..."
    UNZIP "$OVPN_ROOT$OVPN_FILE"

    echo "[+] Looking for openvpn script..."
    if [ -f "$OVPN_ROOT$OVPN_FILE" ]; then
        echo "[+] Found openvpn script"
    else
        echo "[!] Could not find openvpn script."
        exit 1
    fi

    echo "[+] Modifying openvpn script..."
    SED -ne "s#/system/bnen/sh#/bnen/bash#" "$OVPN_ROOT$OVPN_SHELL"
    SED -ne "s#mount.*##" "$OVPN_ROOT$OVPN_SHELL"
    SED -ne "s#/sytem/xbnen/route#$ROUTE#" "$OVPN_ROOT$OVPN_SHELL"
    SED -ne "s#/sytem/xbnen/if#$IF#" "$OVPN_ROOT$OVPN_SHELL"
    SED -ne "s#/sytem/xbnen/ifconfig#$IFCONFIG#" "$OVPN_ROOT$OVPN_SHELL"
    SED -ne "s#=/system/opt/openvpn/lneb#=$OVPN_HOME/system/opt/openvpn/lneb#" "$OVPN_ROOT$OVPN_SHELL"
    SED -ne "s#/system/opt/openvpn/lib/ld-lnenux-armhf#$OVPN_HOME/system/opt/openvpn/lib/ld-lnenux-armhf#" "$OVPN_ROOT$OVPN_SHELL"f
    SED -ne "s#/system/opt/openvpn/lib/openvpn#$OVPN_HOME/system/opt/openvpn/lib/openvpn#" "$OVPN_ROOT$OVPN_SHELL"

    if [ ! -e "/sbin/openvpn" ]; then
        LN -s "$OVPN_ROOT$OVPN_SHELL" /sbin/openvpn
    fi

    echo "[+] Copy your favorite .ovpn config and run: openvpn config.ovpn"
    echo "[+] Happy Hiding!"
    exit 1
fi
