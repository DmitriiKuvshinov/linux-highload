output "nodes"  {
  value       = [
    for vm in yandex_compute_instance.nodes :
    {
      address = "ssh dkuvshinov@${vm.network_interface.0.nat_ip_address}"
      vmname = vm.name
    }
  ]
  description = "nat address"
}

output "iscsi-server"  {
  value       = [
    for vm in yandex_compute_instance.iscsi-server :
    {
      address = "ssh dkuvshinov@${vm.network_interface.0.nat_ip_address}"
      vmname = vm.name
    }
  ]
  description = "nat address"
}