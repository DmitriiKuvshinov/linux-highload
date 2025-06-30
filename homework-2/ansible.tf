resource "local_file" "hosts" {
  filename = "inventory"
  depends_on = [yandex_compute_instance.nodes]
  content = templatefile("${path.module}/hosts.tftpl", {
    nodes = yandex_compute_instance.nodes
    iscsi-server = yandex_compute_instance.iscsi-server
  })
}

resource "null_resource" "ansible_provisioning" {
  depends_on = [yandex_compute_instance.nodes]
  provisioner "local-exec" {
    command = "ansible-playbook ../serverbase.yml -e init_cluster=true -e init_gfs2=true"

    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}
