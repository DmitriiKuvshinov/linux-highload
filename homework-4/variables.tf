variable "username" {
  type = string
  default = "dkuvshinov"
}
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

variable "backend" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk          = number
    core_fraction = number
    nat           = bool
    ip_address    = string
  }))
  default = [
    {
      vm_name       = "back-1"
      cpu           = 2
      ram           = 2
      disk          = 1
      core_fraction = 5
      nat           = true
      ip_address    = "10.2.0.10"
    },
    {
      vm_name       = "back-2"
      cpu           = 2
      ram           = 2
      disk          = 1
      core_fraction = 5
      nat           = true
      ip_address    = "10.2.0.3"
    }
  ]
  description = "There's list if dict's with VM resources"
}

variable "nginx" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk          = number
    core_fraction = number
    nat           = bool
    ip_address    = string
  }))
  default = [
    {
      vm_name       = "front-1"
      cpu           = 2
      ram           = 4
      disk          = 2
      core_fraction = 5
      nat           = true
      ip_address    = "10.2.0.4"

    },
    {
      vm_name       = "front-2"
      cpu           = 2
      ram           = 4
      disk          = 2
      core_fraction = 5
      nat           = true
      ip_address    = "10.2.0.5"
    },
  ]
  description = "There's list if dict's with VM resources"
}

variable "db" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk          = number
    core_fraction = number
    nat           = bool
    ip_address    = string
  }))
  default = [
    {
      vm_name       = "db-1"
      cpu           = 2
      ram           = 4
      disk          = 2
      core_fraction = 5
      nat           = true
      ip_address    = "10.2.0.6"
    },
  ]
  description = "There's list if dict's with VM resources"
}

variable "iscsi" {
  type = list(object({
    vm_name       = string
    cpu           = number
    ram           = number
    disk          = number
    core_fraction = number
    nat           = bool
    ip_address    = string
  }))
  default = [
    {
      vm_name       = "iscsi-1"
      cpu           = 2
      ram           = 4
      disk          = 2
      core_fraction = 5
      nat           = true
      ip_address    = "10.2.0.7"
    },
  ]
  description = "There's list if dict's with VM resources"
}
