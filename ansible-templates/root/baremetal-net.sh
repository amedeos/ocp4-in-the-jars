#!/usr/bin/env bash
#
nmcli con down "System eth1"
nmcli con delete "System eth1"
nmcli connection down baremetal
nmcli connection delete baremetal
nmcli connection down bridge-slave-eth1
nmcli connection delete bridge-slave-eth1
nmcli connection add ifname baremetal type bridge con-name baremetal
nmcli con add type bridge-slave ifname eth1 master baremetal
nmcli connection modify baremetal ipv4.addresses {{ bastion_nodes[0].baremetal_ip }}/{{ baremetal_net.prefix }}
nmcli connection modify baremetal ipv4.gateway {{ baremetal_net.gateway }}
nmcli connection modify baremetal ipv4.method manual
nmcli connection modify baremetal ipv6.method ignore
nmcli connection modify baremetal bridge.stp no
nmcli connection up baremetal
