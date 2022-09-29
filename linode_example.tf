terraform {
  required_providers {
    linode = {
      source  = "linode/linode"
    }
  }
}

variable "token" {}
variable "root_pass" {}
variable "ssh_key" {}

provider "linode" {
     token = var.token
}

resource "linode_instance" "my_linode" {
     label = "terraformvm1"
     image = "linode/rocky8"
     region = "ap-south"
     type = "g6-nanode-1"
     root_pass = var.root_pass
     authorized_keys = [var.ssh_key]

  connection {
      type     = "ssh"
      user     = "root"
      password = var.root_pass
      host     = self.ip_address
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo dnf installl -y python3",
      "sudo dnf install -y rsync lsof",
      "echo Done!",
    ]
  }
}

output "public_ip" {
  value = "${linode_instance.my_linode.ip_address}"
}

