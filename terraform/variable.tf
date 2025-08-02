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
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "ap-northeast-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "vpc_subnet_cidr" {
  description = "CIDR block for the VPC subnet"
  type        = string
  default     = "10.0.1.0/24"
}

variable "ec2_instance_type" {
  description = "EC2 instance type for the Ansible server"
  type        = string
  default     = "t3.small"
}

variable "server_name" {
  description = "Name tag for the Ansible server"
  type        = string
  default     = "Ansibleサーバ#1"
}

variable "server_private_ip" {
  description = "Private IP address for the Ansible server"
  type        = string
  default     = "10.0.0.2"
}

variable "tailscale_tailnet_key" {
  description = "Tailscale tailnet key"
  type        = string
  sensitive   = true
}

# endregion
