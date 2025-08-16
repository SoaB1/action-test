data "tailscale_device" "vpn_server" {
  hostname = "dvmn-vpn-01"
}

resource "tailscale_tailnet_key" "tailnet_key" {
  description   = "Ansible Server Tailnet Key"
  reusable      = true
  preauthorized = true
}

resource "time_sleep" "wait_join_tailnet" {
  create_duration = "300s"

  depends_on = [var.aws_ec2_is_running]
}

data "tailscale_device" "ansible_server" {
  hostname = var.aws_ec2_server_name

  depends_on = [time_sleep.wait_join_tailnet]
}

resource "tailscale_device_key" "ansible_server_key" {
  device_id           = data.tailscale_device.ansible_server.id
  key_expiry_disabled = true

  depends_on = [time_sleep.wait_join_tailnet]
}
