# Домашнее задание 3
## Подготовка окружения:
- Развернуть 4 виртуальных машины терраформом в Яндекс.Облаке или на локальном стенде;
- 1 виртуалка - Nginx-балансировщик с публичным IP адресом. Показать конфигурацию для балансировки методами round-robin и hash (выбор переменных самостоятельный);
- 2 виртуалки - Nginx-фронтенд со статикой и бэкенд на выбор студента. В качестве бэкенда может использовать любой отладочный контейнер (образ vscoder/webdebugger) или заглушку;
## Создание инфраструктуры с Terraform:
- Создайте Terraform манифесты
- Настроить хосты с помощью cloud-init
- Настроить хосты с помощью ansible
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
cd homework-3
terraform init
terraform validate
terraform plan
terrafrom apply
```
Описание переменных расположено в variables.tf
При выполнении terraform манифестов - будет выполнен ansible-playbook
Создание пользователея и импорт ssh-ключа происходит средствами cloud-init
Роли:
- bacdrops - запустить CMS на удаленных бекендах
- docker - установит пакеты докера
- nginx - установит пакет nginx и настроит конфигурации веб-серверов
# Результат
На 80 порту слушается алгоритм Round-Robin
На 81 порту - hash
## Round-Robin
```
07/05/25-21:54:user ~ $ curl -sI http://89.169.134.159
HTTP/1.1 302 Found
Server: nginx/1.29.0
Date: Sat, 05 Jul 2025 18:54:52 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
X-Powered-By: PHP/8.3.23
Location: http://89.169.134.159/core/install.php
Cache-Control: no-cache
backend-2: backdrop-81
nginx-server: round-robin

07/05/25-21:54:user ~ $ curl -sI http://89.169.134.159
HTTP/1.1 302 Found
Server: nginx/1.29.0
Date: Sat, 05 Jul 2025 18:54:53 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
X-Powered-By: PHP/8.3.23
Location: http://89.169.134.159/core/install.php
Cache-Control: no-cache
backend-2: backdrop-82
nginx-server: round-robin

07/05/25-21:54:user ~ $ curl -sI http://89.169.134.159
HTTP/1.1 302 Found
Server: nginx/1.29.0
Date: Sat, 05 Jul 2025 18:54:53 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
X-Powered-By: PHP/8.3.23
Location: http://89.169.134.159/core/install.php
Cache-Control: no-cache
backend-2: backdrop-83
nginx-server: round-robin
```
## Hash
```
07/05/25-21:53:user ~ $ curl -sI http://89.169.134.159:81 
HTTP/1.1 302 Found
Server: nginx/1.29.0
Date: Sat, 05 Jul 2025 18:54:07 GMT
Content-Type: text/html; charset=UTF-8
Connection: keep-alive
X-Powered-By: PHP/8.3.23
Location: http://89.169.134.159/core/install.php
Cache-Control: no-cache
backend-2: backdrop-82
nginx-server: hash
```
Работу hash балансировки видно будет в браузере, потому что сохраняется сессия пользователя
Отследить бекенд можно по заголовкам ответов

После выполнения всех работ прибиваю все ресурсы
```bash
terraform destroy
```