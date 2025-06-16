data "yandex_compute_image" "ubuntu2204" {
  family = "ubuntu-2404-lts"
}

resource "yandex_compute_disk" "boot-disk" {
  name     = "homework-1"
  type     = "network-ssd"
  zone     = var.default_zone
  image_id = data.yandex_compute_image.ubuntu2204.image_id

  labels = {
    environment = "otus"
  }
}
resource "yandex_compute_instance" "cloud-master" {
  name = var.vms.master.vm_name
  zone = var.default_zone
  resources {
    cores         = var.vms.master.cpu_count
    memory        = var.vms.master.ram
    core_fraction = var.vms.master.core_fraction
  }
  boot_disk {
    disk_id = yandex_compute_disk.boot-disk.id
  }
  network_interface {
    index     = 1
    subnet_id = yandex_vpc_subnet.homework.id
    nat       = var.vms.master.nat
  }
  metadata = {
    user-data = "${file("./cloud-config")}"
  }
  provisioner "local-exec" {
    command = "ansible-playbook -i '${yandex_compute_instance.cloud-master.network_interface.0.nat_ip_address},' -e ansible_user=dkuvshinov ../serverbase.yml -v"
  }
}

resource "yandex_vpc_network" "homework" {
  name = "homework1"
}

resource "yandex_vpc_subnet" "homework" {
  v4_cidr_blocks = ["10.2.0.0/28"]
  zone           = var.default_zone
  network_id     = yandex_vpc_network.homework.id
}