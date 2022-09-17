#!/usr/bin/env bash
#
#
VIRSH=$(which virsh)

${VIRSH} pool-define --file /root/default_pool.xml
${VIRSH} pool-autostart --pool default
STATUS=$?
if [ $STATUS -gt 0 ];then
    ${VIRSH} pool-destroy default
    ${VIRSH} pool-undefine default
    ${VIRSH} pool-define --file /root/default_pool.xml
    ${VIRSH} pool-autostart --pool default
fi
