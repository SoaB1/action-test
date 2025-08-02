data "aws_ami" "ubuntu_noble_24_04" {
  most_recent = true
  name_regex  = "^ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-.*"
  owners      = ["amazon"]
  filter {
    name   = "owner-alias"
    values = ["amazon"]
  }
}

data "template_file" "user_data" {
  template = file("./setup.sh")
  vars = {
    tailnet_key = tailscale_tailnet_key.tailnet_key.key
  }
}

resource "aws_network_interface" "ansible_server_nic01" {
  subnet_id       = aws_subnet.subnet_001.id
  private_ips     = [var.aws_ec2_server_private_ip]
  security_groups = [aws_security_group.mnsg_01.id]
}

resource "aws_instance" "ansible_server" {
  ami           = data.aws_ami.ubuntu_noble_24_04.id
  instance_type = var.aws_ec2_instance_type
  key_name      = "ec2"
  monitoring    = false
  tags = {
    Name = var.aws_ec2_server_name
  }
  tags_all = {
    Name = var.aws_ec2_server_name
  }
  maintenance_options {
    auto_recovery = "default"
  }
  root_block_device {
    encrypted   = false
    throughput  = 125
    volume_size = 30
    volume_type = "gp3"
  }

  network_interface {
    network_interface_id = aws_network_interface.ansible_server_nic01.id
    device_index         = 0
  }

  user_data                   = data.template_file.user_data.rendered
  user_data_replace_on_change = true
}
