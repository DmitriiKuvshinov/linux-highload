# Домашнее задание 1. 
1. Подготовка окружения
2. Создание Terraform файла
3. Настройте ресурс для виртуальной машины .
4. Настройка инфраструктуры:
5. Добавьте секцию output, которая покажет IP-адрес созданной виртуальной машины после выполнения скрипта.
6. Инициализация и запуск
7. Запустите команду terraform init для инициализации проекта.
8. Проверьте корректность кода командой terraform plan.
9. Запустите terraform apply, чтобы создать виртуальную машину.
10. Проверка результата

# Выполнение
Настроен yandex cloud окружение
Для получение токенов выолняем команды
```bash
export YC_TOKEN=$(yc iam create-token)
export YC_CLOUD_ID=$(yc config get cloud-id)
export YC_FOLDER_ID=$(yc config get folder-id)
```
проверяем/применяем terraform манифесты
```bash
cd homework-1
terraform init
terraform validate
terraform plan
terrafrom apply
```
Описание переменных расположено в variables.tf
Создание пользователея и импорт ssh-ключа происходит средствами cloud-init
Написана небольшая роль, которая пингует хост, средствами ansible модуля, который вызывается через provisioner

# Результат

```
yandex_compute_instance.cloud-master (local-exec): PLAY [Serverbase deployment] ***************************************************
yandex_compute_instance.cloud-master: Still creating... [40s elapsed]
yandex_compute_instance.cloud-master: Still creating... [50s elapsed]
yandex_compute_instance.cloud-master: Still creating... [1m0s elapsed]
yandex_compute_instance.cloud-master: Still creating... [1m10s elapsed]
yandex_compute_instance.cloud-master: Still creating... [1m20s elapsed]
yandex_compute_instance.cloud-master: Still creating... [1m30s elapsed]
yandex_compute_instance.cloud-master (local-exec): [WARNING]: Platform linux on host 89.169.152.235 is using the discovered Python
yandex_compute_instance.cloud-master (local-exec): interpreter at /usr/bin/python3.12, but future installation of another Python
yandex_compute_instance.cloud-master (local-exec): interpreter could change the meaning of that path. See
yandex_compute_instance.cloud-master (local-exec): https://docs.ansible.com/ansible-
yandex_compute_instance.cloud-master (local-exec): core/2.18/reference_appendices/interpreter_discovery.html for more information.

yandex_compute_instance.cloud-master (local-exec): TASK [Gathering Facts] *********************************************************
yandex_compute_instance.cloud-master (local-exec): ok: [89.169.152.235]

yandex_compute_instance.cloud-master (local-exec): TASK [ping : Ping host] ********************************************************
yandex_compute_instance.cloud-master (local-exec): ok: [89.169.152.235] => changed=false
yandex_compute_instance.cloud-master (local-exec):   ping: pong

yandex_compute_instance.cloud-master (local-exec): PLAY RECAP *********************************************************************
yandex_compute_instance.cloud-master (local-exec): 89.169.152.235             : ok=2    changed=0    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0

yandex_compute_instance.cloud-master: Creation complete after 1m33s [id=fhmv6qlh8k9s18tpos6h]

Apply complete! Resources: 4 added, 0 changed, 0 destroyed.

Outputs:

nat-address = "89.169.152.235"
```

После выполнения всех работ прибиваю все ресурсы
```bash
terraform destroy
```