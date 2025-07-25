output "backends" {
  value = [
    for vm in yandex_compute_instance.backend :
    {
      address = "ssh dkuvshinov@${vm.network_interface.0.nat_ip_address}"
      vmname  = vm.name
    }
  ]
  description = "nat address"
}
output "db" {
  value = [
    for vm in yandex_compute_instance.db :
    {
      address = "ssh dkuvshinov@${vm.network_interface.0.nat_ip_address}"
      vmname  = vm.name
    }
  ]
  description = "nat address"
}

output "iscsi" {
  value = [
    for vm in yandex_compute_instance.iscsi :
    {
      address = "ssh dkuvshinov@${vm.network_interface.0.nat_ip_address}"
      vmname  = vm.name
    }
  ]
  description = "nat address"
}

output "frontend" {
  value = [
    for vm in yandex_compute_instance.frontend :
    {
      ssh    = "ssh dkuvshinov@${vm.network_interface.0.nat_ip_address}"
      url    = "curl -sI http://${vm.network_interface.0.nat_ip_address}"
      vmname = vm.name

    }
  ]
  description = "nat address"
}