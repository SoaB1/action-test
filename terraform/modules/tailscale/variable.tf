# region Tailscale variables
variable "tailscale_api_key" {
  description = "API key for Tailscale"
  type        = string
  sensitive   = true
}

variable "tailscale_tailnet" {
  description = "Tailscale tailnet name"
  type        = string
}
# endregion

# region AWS variables
variable "aws_ec2_server_name" {
  description = "Name tag for the Ansible server"
  type        = string
  default     = "prmn-asm-01"
}

variable "aws_ec2_is_running" {
  description = "Whether the Ansible server is running"
  type        = bool
  default     = false
}
# endregion
