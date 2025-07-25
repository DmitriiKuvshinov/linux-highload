data "yandex_compute_image" "ubuntu2404" {
  family = "ubuntu-2404-lts"
}

data "yandex_compute_image" "rocky-9" {
  family = "rocky-9-oslogin"
}

resource "yandex_compute_disk" "iscsi" {
  count = 1
  name  = "disk-target-1-${count.index}"
  type  = "network-hdd"
  size  = 10
  zone  = "ru-central1-a"
}

resource "yandex_compute_instance" "backend" {
  # определим имена и ресурсы
  platform_id = "standard-v1"
  depends_on  = [yandex_compute_disk.iscsi]
  for_each = {
    for index, vm in var.backend :
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
      image_id = data.yandex_compute_image.rocky-9.image_id
    }
  }

  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.homework.id
    nat        = each.value.nat
    ip_address = each.value.ip_address
  }

  metadata = {
    user-data = "${file("../cloud-init/ubuntu")}"
  }
}

resource "yandex_compute_instance" "frontend" {
  # определим имена и ресурсы
  depends_on  = [yandex_compute_instance.backend]
  platform_id = "standard-v1"
  for_each = {
    for index, vm in var.nginx :
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
    subnet_id  = yandex_vpc_subnet.homework.id
    nat        = each.value.nat
    ip_address = each.value.ip_address
  }

  metadata = {
    user-data = "${file("../cloud-init/ubuntu")}"
  }
}

resource "yandex_compute_instance" "db" {
  # определим имена и ресурсы
  depends_on  = [yandex_compute_instance.frontend]
  platform_id = "standard-v1"
  for_each = {
    for index, vm in var.db :
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
    subnet_id  = yandex_vpc_subnet.homework.id
    nat        = each.value.nat
    ip_address = each.value.ip_address
  }

  metadata = {
    user-data = "${file("../cloud-init/ubuntu")}"
  }
}

resource "yandex_compute_instance" "iscsi" {
  # определим имена и ресурсы
  depends_on  = [yandex_compute_instance.db]
  platform_id = "standard-v1"
  for_each = {
    for index, vm in var.iscsi :
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
  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.iscsi.*.id
    content {
      disk_id = secondary_disk.value

    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id  = yandex_vpc_subnet.homework.id
    nat        = each.value.nat
    ip_address = each.value.ip_address
  }

  metadata = {
    user-data = "${file("../cloud-init/ubuntu")}"
  }
}

resource "yandex_vpc_network" "homework" {
  name = "homework4"
}

resource "yandex_vpc_subnet" "homework" {
  v4_cidr_blocks = ["10.2.0.0/28"]
  zone           = var.default_zone
  network_id     = yandex_vpc_network.homework.id
}
