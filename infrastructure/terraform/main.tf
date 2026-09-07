terraform {
  required_providers {
    proxmox = {
      source  = "Telmate/proxmox"
      version = "3.0.2-rc04"
    }
  }
}

provider "proxmox" {
  pm_api_url      = "https://10.0.0.100:8006/api2/json"
  pm_user         = "terraform@pve"
  pm_password = var.proxmox_password
  pm_tls_insecure = true

}

# ========================
# Variables générales
# ========================
variable "ssh_public_key" {
  default = "ssh-ed25519 REPLACE_WITH_YOUR_PUBLIC_KEY user@example.com"
}

locals {
  template_name = "ubuntu-22.04-cloudinit"
  node_name     = "proxmox"
}

resource "proxmox_vm_qemu" "k3s_master" {
  name        = "k3s-master"
  target_node = "proxmox"
  clone       = "ubuntu-22.04-cloudinit"
  full_clone  = true
  agent       = 1
  memory      = 32768
  os_type     = "cloud-init"
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "order=scsi0;ide2;net0"
  onboot      = true

  # ✅ Cloud-init configuration
  cicustom    = "user=local:snippets/cloudinit-userdata.yml"
  ipconfig0   = "ip=10.0.0.102/24,gw=10.0.0.1"
  nameserver  = "8.8.8.8"
  sshkeys     = var.ssh_public_key

  # ✅ Disques : disque principal + cloudinit
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "150G"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  # ✅ Réseau
  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
  }

  cpu {
    type    = "host"
    sockets = 1
    cores   = 8
  }

  tags = "k3s,terraform"
}


resource "proxmox_vm_qemu" "k3s_worker_A" {
  name        = "k3s-worker-A"
  target_node = "proxmox"
  clone       = "ubuntu-22.04-cloudinit"
  full_clone  = true
  agent       = 1
  memory      = 32768
  os_type     = "cloud-init"
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "order=scsi0;ide2;net0"
  onboot      = true

  # ✅ Cloud-init configuration
  cicustom    = "user=local:snippets/cloudinit-userdata.yml"
  ipconfig0   = "ip=10.0.0.104/24,gw=10.0.0.1"
  nameserver  = "8.8.8.8"
  sshkeys     = var.ssh_public_key

  # ✅ Disques : disque principal + cloudinit
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "150G"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  # ✅ Réseau
  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
  }

  cpu {
    type    = "host"
    sockets = 1
    cores   = 8
  }

  tags = "k3s,terraform"
}


resource "proxmox_vm_qemu" "k3s_worker_B" {
  name        = "k3s-worker-B"
  target_node = "proxmox"
  clone       = "ubuntu-22.04-cloudinit"
  full_clone  = true
  agent       = 1
  memory      = 32768
  os_type     = "cloud-init"
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "order=scsi0;ide2;net0"
  onboot      = true

  # ✅ Cloud-init configuration
  cicustom    = "user=local:snippets/cloudinit-userdata.yml"
  ipconfig0   = "ip=10.0.0.105/24,gw=10.0.0.1"
  nameserver  = "8.8.8.8"
  sshkeys     = var.ssh_public_key

  # ✅ Disques : disque principal + cloudinit
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "150G"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  # ✅ Réseau
  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
  }

  cpu {
    type    = "host"
    sockets = 1
    cores   = 8
  }

  tags = "k3s,terraform"
}


resource "proxmox_vm_qemu" "k3s_worker_C" {
  name        = "k3s-worker-C"
  target_node = "proxmox"
  clone       = "ubuntu-22.04-cloudinit"
  full_clone  = true
  agent       = 1
  memory      = 32768
  os_type     = "cloud-init"
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "order=scsi0;ide2;net0"
  onboot      = true

  # ✅ Cloud-init configuration
  cicustom    = "user=local:snippets/cloudinit-userdata.yml"
  ipconfig0   = "ip=10.0.0.106/24,gw=10.0.0.1"
  nameserver  = "8.8.8.8"
  sshkeys     = var.ssh_public_key

  # ✅ Disques : disque principal + cloudinit
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "150G"
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  # ✅ Réseau
  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
  }

  cpu {
    type    = "host"
    sockets = 1
    cores   = 8
  }

  tags = "k3s,terraform"
}



resource "proxmox_vm_qemu" "nexus_registry" {
  name        = "nexus-registry"
  target_node = local.node_name
  clone       = local.template_name
  full_clone  = true
  agent       = 1
  memory = 12288 # 12 GB for Nexus Repository
  os_type     = "cloud-init"
  scsihw      = "virtio-scsi-pci"
  bootdisk    = "scsi0"
  boot        = "order=scsi0;ide2;net0"
  onboot      = true

  # Cloud-init
  cicustom    = "user=local:snippets/cloudinit-userdata.yml"
  ipconfig0   = "ip=10.0.0.110/24,gw=10.0.0.1"
  nameserver  = "8.8.8.8"
  sshkeys     = var.ssh_public_key

  # Disques
  disks {
    scsi {
      scsi0 {
        disk {
          storage = "local-lvm"
          size    = "50G"      # Espace Docker registry
        }
      }
    }
    ide {
      ide2 {
        cloudinit {
          storage = "local-lvm"
        }
      }
    }
  }

  # Réseau
  network {
    id      = 0
    model   = "virtio"
    bridge  = "vmbr0"
  }

  # CPU
  cpu {
    type    = "host"
    sockets = 1
    cores   = 4
  }

  tags = "nexus,registry,terraform"
}
