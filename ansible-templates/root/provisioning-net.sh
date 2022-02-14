#!/usr/bin/env bash
#
nmcli con down "System eth0"
nmcli con delete "System eth0"
nmcli connection down provisioning
nmcli connection delete provisioning
nmcli connection down bridge-slave-eth0
nmcli connection delete bridge-slave-eth0
nmcli connection add ifname provisioning type bridge con-name provisioning
nmcli con add type bridge-slave ifname eth0 master provisioning
nmcli connection modify provisioning ipv4.addresses {{ bastion_prov_ip }}/24
nmcli connection modify provisioning ipv4.dns {{ dns_ip_bastion }}
nmcli connection modify provisioning ipv4.method manual
nmcli connection modify provisioning ipv6.method ignore
nmcli connection modify provisioning bridge.stp no
nmcli connection up provisioning
