# Домашнее задание 2 
## Подготовка окружения:
- Убедитесь, что VirtualBox установлен на вашей локальной машине.
- Проверьте, что Terraform уже установлен. Если у вас возникли проблемы с установкой, обратитесь к инструкциям из предыдущего задания.
- Установите Ansible для настройки виртуальных машин.
- Настройте сеть между виртуальными машинами, используя сетевой адаптер Internal Network или другой подходящий тип сети.
## Создание инфраструктуры с Terraform:
- Создайте Terraform манифесты для развертывания следующей конфигурации:
- - Одна виртуальная машина с iSCSI для предоставления общего диска.
- - 2 виртуальные машины, которые будут использовать общую файловую систему GFS2 для backend
- - 2 виртуальные машины, которые будут использовать keepalived для frontend
## Тестирование:
Задание считается выполненным, если с использованием кода из репозитория развёрнута отказоустойчивая система с фронт- и бэкенд серверами, а также СУБД.
Система должна продолжать работу при выключении одного любого сервера типа фронтенд или бэкенд.

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
cd homework-4
terraform init
terraform validate
terraform plan
terrafrom apply
```
Описание переменных расположено в variables.tf
При выполнении terraform манифестов - будет выполнен ansible-playbook
Создание пользователя и импорт ssh-ключа происходит средствами cloud-init
Роли:
- iscsi - установит и настроит iscsi сервер
- pacemaker - установит пакеты, подключит и разметит диск в GFS2 файловую систему, настроит кластер pacemaker
- nginx - установит пакет и настроит nginx
- docker - установит пакеты docker
- keepalived - установит/настроит keepalived
- backdrop/mysql - поднимут службы в контейненрах
# Результат

## Keepalived

```
root@front-1:/etc/nginx/conf.d# ifconfig  eth0:1
eth0:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.2.0.8  netmask 255.255.255.240  broadcast 0.0.0.0
        ether d0:0d:1e:4a:54:da  txqueuelen 1000  (Ethernet)

root@front-1:/etc/nginx/conf.d# systemctl stop nginx
root@front-1:/etc/nginx/conf.d# ifconfig  eth0:1
eth0:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether d0:0d:1e:4a:54:da  txqueuelen 1000  (Ethernet)
```
Послу выключения nginx адрес переехал на вторую ноду
```
root@front-2:/etc/keepalived# ifconfig eth0:1
eth0:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        inet 10.2.0.8  netmask 255.255.255.240  broadcast 0.0.0.0
        ether d0:0d:11:26:b5:8b  txqueuelen 1000  (Ethernet)

root@front-1:/etc/nginx/conf.d# systemctl start nginx

root@front-2:/etc/keepalived# ifconfig eth0:1
eth0:1: flags=4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500
        ether d0:0d:11:26:b5:8b  txqueuelen 1000  (Ethernet)

```
После включения nginx на первой - адрес вернулся на MASTER хост

## GFS2
```
[root@back-1 nginx]# pcs status
Cluster name: otus
Cluster Summary:
  * Stack: corosync (Pacemaker is running)
  * Current DC: back-1 (version 2.1.9-1.2.el9_6-49aab9983) - partition with quorum
  * Last updated: Fri Jul 25 13:53:11 2025 on back-1
  * Last change:  Fri Jul 25 10:52:30 2025 by root via root on back-1
  * 2 nodes configured
  * 6 resource instances configured

Node List:
  * Online: [ back-1 back-2 ]

Full List of Resources:
  * Clone Set: dlm-clone [dlm]:
    * Started: [ back-1 back-2 ]
  * Clone Set: lvmlockd-clone [lvmlockd]:
    * Started: [ back-1 back-2 ]
  * Clone Set: clusterfs-clone [clusterfs]:
    * Started: [ back-1 back-2 ]

Daemon Status:
  corosync: active/enabled
  pacemaker: active/enabled
  pcsd: active/enabled
```

После выполнения всех работ прибиваю все ресурсы
```bash
terraform destroy
```