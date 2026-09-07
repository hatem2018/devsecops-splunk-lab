variable "vm_name" {
  description = "Nom de la VM"
  type        = string
  default     = "devops-node"
}

variable "vm_cpu" {
  description = "Nombre de vCPU"
  type        = number
  default     = 2
}

variable "vm_memory" {
  description = "Mémoire RAM en MB"
  type        = number
  default     = 4096
}


variable "proxmox_password" {
  description = "Proxmox password"
  type        = string
  sensitive   = true
}