variable "token" {
  type = string
}
variable "cloud_id" {
  type = string
}
variable "folder_id" {
  type = string
}
variable "default_zone" {
  type    = string
  default = "ru-central1-a"
}

variable "iscsi-server" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk          = number
    core_fraction = number
    nat           = bool
  }))
  default = [
    {
      vm_name       = "iscsi-server"
      cpu           = 2
      ram           = 2
      disk          = 1
      core_fraction = 5
      nat           = true
    }
  ]
  description = "There's list if dict's with VM resources"
}

variable "nodes" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk          = number
    core_fraction = number
    nat           = bool
  }))
  default = [
    {
      vm_name       = "node-1"
      cpu           = 2
      ram           = 4
      disk          = 2
      core_fraction = 5
      nat           = true

    },
    {
      vm_name       = "node-2"
      cpu           = 2
      ram           = 4
      disk          = 2
      core_fraction = 5
      nat           = true

    },
  ]
  description = "There's list if dict's with VM resources"
}