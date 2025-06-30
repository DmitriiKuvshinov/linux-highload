output "nodes"  {
  value       = [
    for vm in yandex_compute_instance.nodes :
    {
      address = vm.network_interface.0.nat_ip_address
    }
  ]
  description = "nat address"
}

output "iscsi-server"  {
  value       = [
    for vm in yandex_compute_instance.iscsi-server :
    {
      address = vm.network_interface.0.nat_ip_address
    }
  ]
  description = "nat address"
}