# Домашнее задание 2 
## Подготовка окружения:
- Убедитесь, что VirtualBox установлен на вашей локальной машине.
- Проверьте, что Terraform уже установлен. Если у вас возникли проблемы с установкой, обратитесь к инструкциям из предыдущего задания.
- Установите Ansible для настройки виртуальных машин.
- Настройте сеть между виртуальными машинами, используя сетевой адаптер Internal Network или другой подходящий тип сети.
## Создание инфраструктуры с Terraform:
- Создайте Terraform манифесты для развертывания следующей конфигурации:
- - Одна виртуальная машина с iSCSI для предоставления общего диска.
- - Три виртуальные машины, которые будут использовать общую файловую систему GFS2.
- - Настройте дополнительные виртуальные диски для каждой виртуальной машины, которые будут использоваться для GFS2.
- Настройте сеть для взаимодействия всех виртуальных машин.
## Создание Ansible роли для GFS2:
- Создайте Ansible роль, которая выполнит настройку GFS2 на виртуальных машинах. Ваша роль должна:
- - Установить необходимые пакеты (gfs2-utils, lvm2).
- - Создать тома LVM на выделенном диске от iSCSI.
- - Инициализировать и смонтировать GFS2.
- Включите команды для создания файла и проверьте, что файл доступен с обеих виртуальных машин.
## Тестирование GFS2:
- Подключитесь к виртуальным машинам и убедитесь, что общая файловая система корректно монтируется и доступна для записи.
- Выполните тестовый сценарий записи данных на диск с обеих машин для проверки совместного доступа, используя команды для проверки статуса (mount, df -h).

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
cd homework-2
terraform init
terraform validate
terraform plan
terrafrom apply
```
Описание переменных расположено в variables.tf
При выполнении terraform манифестов - будет выполнен ansible-playbook
Создание пользователея и импорт ssh-ключа происходит средствами cloud-init
Роли:
- iscsi - установит и настроит iscsi сервер
- pacemaker - установит пакеты, подключит и разметит диск в GFS2 файловую систему, настроит кластер pacemaker
# Результат

## node-1
```
[root@node-1 iscsi]# mount
...
/dev/mapper/vg_iscsi-lv_iscsi on /data/iscsi type gfs2 (rw,noatime,seclabel,rgrplvb)
[root@node-1 iscsi]# df -h
Filesystem                     Size  Used Avail Use% Mounted on
devtmpfs                       4.0M     0  4.0M   0% /dev
tmpfs                          1.8G   63M  1.8G   4% /dev/shm
tmpfs                          732M  680K  732M   1% /run
/dev/vda2                       10G  2.0G  8.0G  20% /
tmpfs                          366M     0  366M   0% /run/user/1000
/dev/mapper/vg_iscsi-lv_iscsi  5.0G   67M  5.0G   2% /data/iscsi
[root@node-1 iscsi]# touch ${HOSTNAME} /data/iscsi/
[root@node-1 iscsi]# ls -la
total 12
drwxr-xr-x. 2 root root 3864 Jul  1 06:57 .
drwxr-xr-x. 3 root root   19 Jun 30 18:34 ..
-rw-r--r--. 1 root root    0 Jul  1 06:57 node-1.ru-central1.internal
```
## node-2
```
[root@node-2 iscsi]# mount
...
/dev/mapper/vg_iscsi-lv_iscsi on /data/iscsi type gfs2 (rw,noatime,seclabel,rgrplvb)
[root@node-2 iscsi]# df -h
Filesystem                     Size  Used Avail Use% Mounted on
devtmpfs                       4.0M     0  4.0M   0% /dev
tmpfs                          1.8G   45M  1.8G   3% /dev/shm
tmpfs                          732M  680K  732M   1% /run
/dev/vda2                       10G  2.0G  8.0G  20% /
tmpfs                          366M     0  366M   0% /run/user/1000
/dev/mapper/vg_iscsi-lv_iscsi  5.0G   67M  5.0G   2% /data/iscsi
[root@node-2 iscsi]# ls -la /data/iscsi/
total 12
drwxr-xr-x. 2 root root 3864 Jul  1 06:57 .
drwxr-xr-x. 3 root root   19 Jun 30 18:34 ..
-rw-r--r--. 1 root root    0 Jul  1 06:57 node-1.ru-central1.internal
```
## Pacemaker
```bash
[root@node-2 iscsi]# pcs status
Cluster name: otus
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: node-1 (version 2.1.9-1.2.el9_6-49aab9983) - partition with quorum
  * Last updated: Tue Jul  1 06:58:38 2025 on node-2
  * Last change:  Tue Jul  1 06:49:39 2025 by root via root on node-1
  * 2 nodes configured
  * 6 resource instances configured

Node List:
  * Online: [ node-1 node-2 ]

Full List of Resources:
  * Clone Set: dlm-clone [dlm]:
    * Started: [ node-1 node-2 ]
  * Clone Set: lvmlockd-clone [lvmlockd]:
    * Started: [ node-1 node-2 ]
  * Clone Set: clusterfs-clone [clusterfs]:
    * Started: [ node-1 node-2 ]

Daemon Status:
  corosync: active/enabled
  pacemaker: active/enabled
  pcsd: active/enabled
```
После выполнения всех работ прибиваю все ресурсы
```bash
terraform destroy
```