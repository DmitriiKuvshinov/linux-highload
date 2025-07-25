resource "local_file" "hosts" {
  filename   = "inventory"
  depends_on = [yandex_compute_instance.iscsi]
  content = templatefile("${path.module}/hosts.tftpl", {
    frontend  = yandex_compute_instance.frontend
    backend   = yandex_compute_instance.backend
    db        = yandex_compute_instance.db
    iscsi     = yandex_compute_instance.iscsi
  })
}

resource "null_resource" "ansible_provisioning" {
  depends_on = [yandex_compute_instance.db]
  provisioner "local-exec" {
    command = "ansible-playbook ../homework4.yml -e init_cluster=true -e init_gfs2=true"

    working_dir = path.module
    interpreter = ["bash", "-c"]
  }
}
