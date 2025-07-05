data "yandex_compute_image" "ubuntu2404" {
  family = "ubuntu-2404-lts"
}

resource "yandex_compute_instance" "nginx-server" {
  # определим имена и ресурсы
  platform_id = "standard-v1"
  for_each = {
    for index, vm in var.nginx-server :
    vm.vm_name => vm
  }

  #  for_each   =  toset(var.vm_resources_list)
  name = each.value.vm_name
  hostname = each.value.vm_name

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu2404.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.homework.id
    nat       = each.value.nat
  }

  metadata = {
    user-data = "${file("../cloud-init/ubuntu")}"
  }
}

resource "yandex_compute_instance" "backends" {
  # определим имена и ресурсы
  depends_on  = [yandex_compute_instance.nginx-server]
  platform_id = "standard-v1"
  for_each = {
    for index, vm in var.backends :
    vm.vm_name => vm
  }

  #  for_each   =  toset(var.vm_resources_list)
  name     = each.value.vm_name
  hostname = each.value.vm_name

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction

  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu2404.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.homework.id
    nat       = each.value.nat
  }

  metadata = {
    user-data = "${file("../cloud-init/ubuntu")}"
  }
}

resource "yandex_vpc_network" "homework" {
  name = "homework3"
}

resource "yandex_vpc_subnet" "homework" {
  v4_cidr_blocks = ["10.2.0.0/28"]
  zone           = var.default_zone
  network_id     = yandex_vpc_network.homework.id
}
