resource "local_file" "hosts" {
  filename = "inventory"
  depends_on = [yandex_compute_instance.backends]
  content = templatefile("${path.module}/hosts.tftpl", {
    backends = yandex_compute_instance.backends
    nginx-server = yandex_compute_instance.nginx-server
  })
}

resource "null_resource" "ansible_provisioning" {
  depends_on = [yandex_compute_instance.backends]
  provisioner "local-exec" {
    command = "ansible-playbook ../serverbase.yml"

    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}
