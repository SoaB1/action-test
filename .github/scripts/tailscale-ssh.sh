#!/bin/bash

SSH_KEY_PATH="$1"
ANSIBLE_USER="onp-provisioner"
ANSIBLE_HOST="dvmn-ans-01.taile4dba.ts.net"

if [ -z "$SSH_KEY_PATH" ]; then
  echo "SSH key path is required."
  exit 1
fi

function sshCommand() {
    local -r ssh_command="$1"

    ssh -o StrictHostKeyChecking=no \
        -i "${SSH_KEY_PATH}" \
        "${ANSIBLE_USER}@${ANSIBLE_HOST}" \
        "${ssh_command}"
}

sshCommand "whoami;uname -n;date" > /tmp/script-result.log
