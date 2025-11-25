# Домашнее задание к занятию «Основы Terraform. Yandex Cloud»

[Сcылка на репазиторий с заданием  ](https://github.com/bitsl40/HWTER2/tree/main/src)
### Задание 1


>1. Изучите проект. В файле variables.tf объявлены переменные для Yandex provider.
>2. Создайте сервисный аккаунт и ключ. [service_account_key_file](https://terraform-provider.yandexcloud.net).
>4. Сгенерируйте новый или используйте свой текущий ssh-ключ. Запишите его открытую(public) часть в переменную >**vms_ssh_public_root_key**.
>5. Инициализируйте проект, выполните код. Исправьте намеренно допущенные синтаксические ошибки. Ищите внимательно, >посимвольно. Ответьте, в чём заключается их суть.
>6. Подключитесь к консоли ВМ через ssh и выполните команду ``` curl ifconfig.me```.
>Примечание: К OS ubuntu "out of a box, те из коробки" необходимо подключаться под пользователем ubuntu: ```"ssh >ubuntu@vm_ip_address"```. Предварительно убедитесь, что ваш ключ добавлен в ssh-агент: ```eval $(ssh-agent) && >ssh-add``` Вы познакомитесь с тем как при создании ВМ создать своего пользователя в блоке metadata в следующей >лекции.;
>8. Ответьте, как в процессе обучения могут пригодиться параметры ```preemptible = true``` и ```core_fraction=5``` в >параметрах ВМ.

>В качестве решения приложите:

>- скриншот ЛК Yandex Cloud с созданной ВМ, где видно внешний ip-адрес;
>- скриншот консоли, curl должен отобразить тот же внешний ip-адрес;
>- ответы на вопросы.
### Ответ
```
resource "yandex_compute_instance" "platform" {
  name        = "netology-develop-platform-web"
  platform_id = "standart-v4" # Опечатка в слове standarT, правильно  standarD и 4 версии нет. исправлено на cуществующую standard-v3
  resources {
    cores         = 1    #не подерживаемое платформой значение
    memory        = 1
    core_fraction = 5   # не подерживаемое платформой значение, указанная доля ядра недоступна на платформе "standard-v3"; разрешенные доли ядра: 20, 50, 100
  }
```
Параметры preemptible = true и core_fraction = 5 — это инструменты экономии и гибкого планирования ресурсов. 

Cкриншот ЛК Yandex Cloud :

![Изображение](https://github.com/bitsl40/HWTER2/blob/main/vmycscr.png)

Cкриншот консоли, curl :

![Изображение](https://github.com/bitsl40/HWTER2/blob/main/curl.png)

### Задание 2

>1. Замените все хардкод-**значения** для ресурсов **yandex_compute_image** и **yandex_compute_instance** на >**отдельные** переменные. К названиям переменных ВМ добавьте в начало префикс **vm_web_** .  Пример: >**vm_web_name**.
>2. Объявите нужные переменные в файле variables.tf, обязательно указывайте тип переменной. Заполните их **default** >прежними значениями из main.tf. 
>3. Проверьте terraform plan. Изменений быть не должно. 
### Ответ
 Вывод terraform plan:
 ```
 yura@yura-WORKBOOK:~/work/terraform/ter-homeworks/02/src$ terraform plan
data.yandex_compute_image.ubuntu: Reading...
yandex_vpc_network.develop: Refreshing state... [id=enpgg74p1g4sv72smgi8]
data.yandex_compute_image.ubuntu: Read complete after 1s [id=fd8jgooo35tigfr6kj9g]
yandex_vpc_subnet.develop: Refreshing state... [id=e9bn6njnvl79jsdu0jtl]
yandex_compute_instance.platform: Refreshing state... [id=fhmrhfc8ci529h0fqje7]

No changes. Your infrastructure matches the configuration.
Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.```

 ```


### Задание 3

>1. Создайте в корне проекта файл 'vms_platform.tf' . Перенесите в него все переменные первой ВМ.
>2. Скопируйте блок ресурса и создайте с его помощью вторую ВМ в файле main.tf: >**"netology-develop-platform-db"** ,  ```cores  = 2, memory = 2, core_fraction = 20```. Объявите её переменные с >префиксом **vm_db_** в том же файле ('vms_platform.tf').  ВМ должна работать в зоне "ru-central1-b"
>3. Примените изменения.


### Задание 4

>1. Объявите в файле outputs.tf **один** output , содержащий: instance_name, external_ip, fqdn для каждой из ВМ в >удобном лично для вас формате.(без хардкода!!!)
>2. Примените изменения.
>В качестве решения приложите вывод значений ip-адресов команды ```terraform output```.


### Ответ
 Вывод terraform output:
 ```
 yura@yura-WORKBOOK:~/work/terraform/ter-homeworks/02/src$ terraform output
vms = {
  "external_ip_platform" = "130.193.50.85"
  "external_ip_platformdb" = "178.154.202.100"
  "instance_name_platform" = "netology-develop-platform-web"
  "instance_name_platformdb" = "netology-develop-platform-db"
}
```
### Задание 5

>1. В файле locals.tf опишите в **одном** local-блоке имя каждой ВМ, используйте интерполяцию ${..} с НЕСКОЛЬКИМИ >переменными по примеру из лекции.
>2. Замените переменные внутри ресурса ВМ на созданные вами local-переменные.
>3. Примените изменения.

### Ответ
Лстинг locals.tf(мя вм формируется из 2 переменных var.vm_db_name + var.vm_web_cores ):
```
locals {
  namedb       = "${var.vm_db_name}-${var.vm_web_cores}"
  namedev      = "${var.vm_web_name}-${var.vm_web_cores}"
}
```
Листинг части кода  при объявлении ресурсов:
```
...
resource "yandex_compute_instance" "platform" {
  name        = local.namedev
  platform_id = var.vm_web_platform_id
  
...
...
resource "yandex_compute_instance" "platformdb" {
  name        = local.namedb
  platform_id = var.vm_db_platform_id
...

```
### Задание 6

>1. Вместо использования трёх переменных  ".._cores",".._memory",".._core_fraction" в блоке  resources {...}, >объедините их в единую map-переменную **vms_resources** и  внутри неё конфиги обеих ВМ в виде вложенного map>(object).  
   ```
   пример из terraform.tfvars:
   vms_resources = {
     web={
       cores=2
       memory=2
       core_fraction=5
       hdd_size=10
       hdd_type="network-hdd"
       ...
     },
     db= {
       cores=2
       memory=4
       core_fraction=20
       hdd_size=10
       hdd_type="network-ssd"
       ...
     }
   }
   ```
### Ответ 
в файле variables.tf  объявил переменную ms_resources, листинг кода:
```
variable "vms_resources" {
  type = map(object({
    cores          = number
    memory         = number
    core_fraction  = number
    
  }))
  description = "Ресурсы для ВМ: ядра, память, доля ядра"
  default = {
    web = {
      cores          = 2
      memory         = 1
      core_fraction  = 20
    
    }
    db = {
      cores          = 2
      memory         = 2
      core_fraction  = 20
      
    }
  }
```
Листинг части кода конфига обеих ВМ в виде вложенного map:
```
...
resource "yandex_compute_instance" "platform" {
  name        = local.namedev
  platform_id = var.vm_web_platform_id
  resources {
    cores         = var.vms_resources["web"].cores
    memory        = var.vms_resources["web"].memory
    core_fraction = var.vms_resources["web"].core_fraction
  }
...
...
esource "yandex_compute_instance" "platformdb" {
  name        = local.namedb
  platform_id = var.vm_db_platform_id
  #zone        = var.vm_db_default_zone
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
...

```


>3. Создайте и используйте отдельную map(object) переменную для блока metadata, она должна быть общая для всех ваших >ВМ.
>   ```
>   пример из terraform.tfvars:
>   metadata = {
>     serial-port-enable = 1
>     ssh-keys           = "ubuntu:ssh-ed25519 AAAAC..."
>   }
>   ```  
>  
>5. Найдите и закоментируйте все, более не используемые переменные проекта.
>6. Проверьте terraform plan. Изменений быть не должно.
>
>------

### Ответ 
в файле variables.tf  объявил переменную , листинг кода:
```
vvariable "vm_metadata" {
  type = object({
    serial-port-enable = number
    ssh-keys           = string
  })
  description = "Общие metadata для всех ВМ: включение serial‑порта и SSH‑ключи"
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINe5CQPAWspyy56JMMB5js6mo0aI2X6owapwEEd19Tjf <опциональный_комментарий>"
  }


  ....

 metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = var.vm_metadata.ssh-keys
  }

  ....

```

Terraform plan. Изменений  нет
