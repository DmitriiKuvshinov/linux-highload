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

variable "vms" {
  type = map(object({
    vm_name       = string
    cpu_count     = string
    ram           = string
    disk          = string
    core_fraction = string
    platform_id   = string
    nat           = bool
  }))
  default = {
    "master" = {
      vm_name       = "master"
      cpu_count     = 2
      ram           = 1
      disk          = 1
      core_fraction = 5
      platform_id   = 1
      nat           = true
    }
  }
}