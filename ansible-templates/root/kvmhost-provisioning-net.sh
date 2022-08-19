#!/usr/bin/env bash
#
# first check if bridge is present
ip link show type bridge {{ bridge_prov }} 2> /dev/null > /dev/null
STATUS=$?
if [ ${STATUS} -eq 0 ]; then
    echo "Bridge {{ bridge_prov }} is already present! Exit..."
    exit 0
else
    echo "Bridge {{ bridge_prov }} is not present. Creating it..."
fi

# delete all active connection
for n in $(nmcli --get-values UUID connection show --active); do
    nmcli connection show ${n} | tee /root/backup-connection-${n}
    nmcli connection down ${n}
    nmcli connection delete ${n}
done

# create provisioning bridge {{ bridge_prov }}
nmcli connection add ifname {{ bridge_prov }} type bridge con-name {{ bridge_prov }}
nmcli con add type bridge-slave ifname {{ ansible_default_ipv4.interface }} master {{ bridge_prov }}
nmcli connection modify {{ bridge_prov }} ipv4.method manual
nmcli connection modify {{ bridge_prov }} ipv4.addresses {{ ansible_default_ipv4.address }}/{{ ansible_default_ipv4.prefix }}
nmcli connection modify {{ bridge_prov }} ipv4.gateway {{ ansible_default_ipv4.gateway }}
nmcli connection modify {{ bridge_prov }} ipv4.dns {{ ansible_dns.nameservers[0] }}
nmcli connection modify {{ bridge_prov }} ipv4.dns-search {{ ansible_dns.search[0] }}
nmcli connection modify {{ bridge_prov }} ipv6.method ignore
nmcli connection modify {{ bridge_prov }} ipv4.method manual
nmcli connection modify {{ bridge_prov }} ipv4.method manual
nmcli connection modify {{ bridge_prov }} ipv4.method manual
nmcli connection modify {{ bridge_prov }} bridge.stp no
nmcli connection modify bridge-slave-{{ ansible_default_ipv4.interface }} 802-3-ethernet.mtu {{ provision_net.mtu }}
nmcli connection modify {{ bridge_prov }} 802-3-ethernet.mtu {{ provision_net.mtu }}
nmcli connection down {{ bridge_prov }} ; nmcli connection up {{ bridge_prov }}
exit 0

