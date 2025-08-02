resource "tailscale_tailnet_key" "tailnet_key" {
  description   = "Ansible Server Tailnet Key"
  reusable      = true
  preauthorized = true
}
