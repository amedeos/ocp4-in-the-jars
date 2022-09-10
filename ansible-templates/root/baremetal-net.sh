#!/usr/bin/env bash
#
{% if redfish.enable == True  %}
INTERFACE="eth0"
{% else %}
INTERFACE="eth1"
{% endif %}
nmcli con down "System ${INTERFACE}"
nmcli con delete "System ${INTERFACE}"
nmcli connection down baremetal
nmcli connection delete baremetal
nmcli connection down bridge-slave-${INTERFACE}
nmcli connection delete bridge-slave-${INTERFACE}
nmcli connection add ifname baremetal type bridge con-name baremetal
nmcli con add type bridge-slave ifname ${INTERFACE} master baremetal
nmcli connection modify bridge-slave-${INTERFACE} 802-3-ethernet.mtu {{ baremetal_net.mtu }}
nmcli connection modify baremetal ipv4.addresses {{ bastion_nodes[0].baremetal_ip }}/{{ baremetal_net.prefix }}

{% if redfish.enable == True  %}
nmcli connection modify baremetal ipv4.dns {{ utility_nodes[0].baremetal_ip }}
{% endif %}

nmcli connection modify baremetal ipv4.gateway {{ baremetal_net.gateway }}
nmcli connection modify baremetal ipv4.method manual
nmcli connection modify baremetal ipv6.method ignore
nmcli connection modify baremetal bridge.stp no
nmcli connection up baremetal
