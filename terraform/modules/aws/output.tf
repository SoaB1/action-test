output "ansible_server_public_ip" {
  description = "Public IP address of the Ansible server"
  value       = aws_instance.ansible_server.public_ip
}

output "is_running" {
  value = aws_instance.ansible_server.instance_state == "running"
}
