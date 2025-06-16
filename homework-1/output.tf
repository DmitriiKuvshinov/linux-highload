output "nat-address" {
  value = yandex_compute_instance.cloud-master.network_interface.0.nat_ip_address
}