output "ansible_server_public_ip" {
  description = "Public IP address of the Ansible server"
  value       = aws_instance.ansible_server.public_ip
}
