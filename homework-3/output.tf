output "backends"  {
  value       = [
    for vm in yandex_compute_instance.backends :
    {
      address = "ssh dkuvshinov@${vm.network_interface.0.nat_ip_address}"
      vmname = vm.name
    }
  ]
  description = "nat address"
}

output "nginx-server"  {
  value       = [
    for vm in yandex_compute_instance.nginx-server :
    {
      ssh = "ssh dkuvshinov@${vm.network_interface.0.nat_ip_address}"
      command_to_check_rr = "Round-Robin: curl -sI http://${vm.network_interface.0.nat_ip_address} | grep backend"
      command_to_check_hash = "Round-Robin: curl -sI http://${vm.network_interface.0.nat_ip_address}:81 | grep backend"
      vmname = vm.name

    }
  ]
  description = "nat address"
}