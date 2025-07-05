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

variable "nginx-server" {
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
      vm_name       = "nginx-server"
      cpu           = 2
      ram           = 2
      disk          = 1
      core_fraction = 5
      nat           = true
    }
  ]
  description = "There's list if dict's with VM resources"
}

variable "backends" {
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
      vm_name       = "backend-1"
      cpu           = 2
      ram           = 4
      disk          = 2
      core_fraction = 5
      nat           = true

    },
    {
      vm_name       = "backend-2"
      cpu           = 2
      ram           = 4
      disk          = 2
      core_fraction = 5
      nat           = true

    },
  ]
  description = "There's list if dict's with VM resources"
}