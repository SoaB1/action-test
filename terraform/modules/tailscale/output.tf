output "tailnet_key" {
  description = "Tailnet key for the Ansible server"
  value       = tailscale_tailnet_key.tailnet_key.key
}
