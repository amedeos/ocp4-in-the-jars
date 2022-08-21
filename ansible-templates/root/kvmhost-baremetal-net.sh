#!/usr/bin/env bash
#
# first check if bridge is present
ip link show type bridge {{ bridge_bm }} 2> /dev/null > /dev/null
STATUS=$?
if [ ${STATUS} -eq 0 ]; then
    echo "Bridge {{ bridge_bm }} is already present! Exit..."
    exit 0
else
    echo "Bridge {{ bridge_bm }} is not present. Creating it..."
fi

nmcli connection add ifname {{ bridge_bm }} type bridge con-name {{ bridge_bm }}
nmcli connection modify {{ bridge_bm }} ipv4.method disabled ipv6.method ignore
nmcli connection up {{ bridge_bm }}
nmcli connection add type vlan con-name {{ bridge_prov }}.{{ baremetal_net.vlan }} ifname {{ bridge_prov }}.{{ baremetal_net.vlan }} dev {{ bridge_prov }} id {{ baremetal_net.vlan }}
nmcli connection modify {{ bridge_prov }}.{{ baremetal_net.vlan }} master {{ bridge_bm }} slave-type bridge
nmcli connection modify {{ bridge_prov }}.{{ baremetal_net.vlan }} 802-3-ethernet.mtu {{ provision_net.mtu }}
nmcli connection modify {{ bridge_bm }} 802-3-ethernet.mtu {{ baremetal_net.mtu }}
nmcli connection up {{ bridge_prov }}.{{ baremetal_net.vlan }}

exit 0
