#!/bin/bash
set -ex

# Variables
INSTALL_PKGS="wget unzip git python3 python3-pip pipx"
ANSIBLE_DATA_DIR="/home/onp-provisioner/ansible"
GIT_REPO_NAME="myhome"
GITLAB_REPO_URL="https://gitlab.mrmasaya.com/SoaB1/$${GIT_REPO_NAME}.git"
# REQUIREMENTS_PATH="$${ANSIBLE_DATA_DIR}/$${GIT_REPO_NAME}/provision/ansible/master-node"

USERS=(
  "msyadmin"
  "onp-provisioner"
)

# Function to send notifications
send_notification() {
    local message="$1"
    curl -X POST -H "Content-Type: application/json" -d "{\"content\": \"<@&1339068066893529118>\n$${message}\"}" "${webhook_url}"
}

## Main
# Set hostname
hostnamectl set-hostname "${server_name}"

# Update system
apt update && apt upgrade -y

# Install necessary packages
add-apt-repository ppa:git-core/ppa
apt update && apt install -y "$${INSTALL_PKGS}"

# Create new users
for user in "$${USERS[@]}"; do
    if id "$${user}" >/dev/null 2>&1; then
        echo "User $${user} already exists. Skipping creation."
    else
        useradd -m -d "/home/$${user}" -s /bin/bash "$${user}"
        su - "$${user}" -c "mkdir -p ~/.ssh && chmod 700 ~/.ssh"
        su - "$${user}" -c "curl -sS https://github.com/SoaB1.keys >> ~/.ssh/authorized_keys"
        su - "$${user}" -c "chmod 600 ~/.ssh/authorized_keys"
        echo "$${user} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers.d/"$${user}"
        chmod 440 /etc/sudoers.d/"$${user}"
        echo "User $${user} created."
    fi
done

# Install tailscale
curl -fsSL https://tailscale.com/install.sh > /tmp/tailscale-install.sh
chmod +x /tmp/tailscale-install.sh
/tmp/tailscale-install.sh

if ! which tailscale > /dev/null; then
    echo "Tailscale installation failed. Exiting."
    send_notification "Tailscale installation failed on the Ansible server."
    exit 1
fi
# Join Tailscale network
if [ -z "${tailnet_key}" ]; then
    echo "tailnet_key is not set. Skipping Tailscale join."
    send_notification "Tailscale key is not set for the Ansible server. Please check the configuration."
    exit 2
else
    echo "Joining Tailscale network with key: ${tailnet_key}"
    tailscale up --auth-key="${tailnet_key}"
    tailscale set --advertise-routes="${subnet_cidr}"
fi

# Install pipx
su - onp-provisioner -c "python3 -m pipx ensurepath"

# Install Ansible
su - onp-provisioner -c "pipx install --include-deps ansible"

# Download setup Playbook
su - onp-provisioner -c "mkdir -p $${ANSIBLE_DATA_DIR}"
ln -s "$${ANSIBLE_DATA_DIR}" /ansible

su - onp-provisioner -c "cd $${ANSIBLE_DATA_DIR} && git clone $${GITLAB_REPO_URL} $${GIT_REPO_NAME}"

# # Install Ansible collections
# cd "$${ANSIBLE_DATA_DIR}/$${GIT_REPO_NAME}" || exit 4
# git checkout main
# git fetch && git pull

# ansible-galaxy collection install -r "$${REQUIREMENTS_PATH}/requirements.yml"

# # Run Ansible Playbook

# set +e
# export ANSIBLE_CONFIG=$${REQUIREMENTS_PATH}/ansible.cfg"
# ansible-playbook -i "$${REQUIREMENTS_PATH}/inventory/hosts.yaml" "$${REQUIREMENTS_PATH}/site.yaml" > /tmp/ansible_setup.log 2>&1

# set +e

send_notification "Ansible server setup completed successfully. Please check the logs for details."
