variable "vm_list" {
  default = [
    { name = "vm1", memory = 2048, vcpu = 2, disk_size = 20 },
  ]
}

resource "random_string" "vm-name" {
  count  = length(var.vm_list)
  length = 8
  upper  = false
  lower  = true
  special = false
}

resource "libvirt_volume" "vm_disk" {
  count  = length(var.vm_list)
  name   = "disk-${random_string.vm-name[count.index].result}.qcow2"
  pool   = "default"
  source = "debian-12-genericcloud-amd64.qcow2"
  format = "qcow2"
}

data "template_file" "user_data" {
  template = file("${path.module}/cloud_init.cfg")
}

resource "libvirt_cloudinit_disk" "commoninit" {
  count    = length(var.vm_list)
  name     = "cloudinit-${random_string.vm-name[count.index].result}"
  user_data = data.template_file.user_data.rendered
}

resource "libvirt_domain" "debian12" {
  count   = length(var.vm_list)
  name    = "${var.vm_list[count.index].name}-${random_string.vm-name[count.index].result}"
  memory  = var.vm_list[count.index].memory
  vcpu    = var.vm_list[count.index].vcpu
  cloudinit = libvirt_cloudinit_disk.commoninit[count.index].id

  network_interface {
    network_name = "default"
    wait_for_lease = true
  }

  disk {
    volume_id = libvirt_volume.vm_disk[count.index].id
  }

  console {
    type        = "pty"
    target_type = "serial"
    target_port = "0"
  }

  graphics {
    type        = "spice"
    listen_type = "address"
    autoport    = true
  }
}

output "vm_ips" {
  value = [for vm in libvirt_domain.debian12 : vm.network_interface.0.addresses.0]
}
