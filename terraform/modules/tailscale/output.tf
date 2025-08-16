output "tailnet_key" {
  description = "Tailnet key for the Ansible server"
  value       = tailscale_tailnet_key.tailnet_key.key
}

output "vpn_server_ip" {
  description = "VPN server IP address"
  value       = data.tailscale_device.vpn_server.addresses[0]
}
