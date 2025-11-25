variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа ОС"
}


variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Имя ВМ"
}

variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "тип платофрмы"
}


variable "vm_db_cores" {
  type        = number
  default     = 2
  description = "Количество ядер"
}

variable "vm_db_memory" {
  type        = number
  default     = 2
  description = "Количество ОЗУ"
}

variable "vm_db_cores_fraction" {
  type        = number
  default     = 20
  description = "Доля ядра"
}

variable "vm_db_preemptible" {
  type    = bool
  default = true
  description = "Прерываемую ВМ (preemptible)"
}

variable "vm_db_nat" {
  type    = bool
  default = true
  description = "Состояние вкл/выкл NAT"
}

variable "vm_db_default_zone" {
  type        = string
  default     = "ru-central1-b"
  description = "Зона ВМ"
}

variable "vm_db_vpc_name" {
  type        = string
  default     = "db"
  description = "VPC network & subnet name"
}

variable "vm_db_default_cidr" {
  type        = list(string)
  default     = ["10.0.2.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

resource "yandex_vpc_network" "db" {
  name = var.vm_db_vpc_name
}
resource "yandex_vpc_subnet" "db" {
  name           = var.vm_db_vpc_name
  zone           = var.vm_db_default_zone
  network_id     = yandex_vpc_network.db.id
  v4_cidr_blocks = var.vm_db_default_cidr
}

resource "yandex_compute_instance" "platformdb" {
  name        = local.namedb
  platform_id = var.vm_db_platform_id
  #zone        = var.vm_db_default_zone
  resources {
    cores         = var.vms_resources["db"].cores
    memory        = var.vms_resources["db"].memory
    core_fraction = var.vms_resources["db"].core_fraction
  }
boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible = var.vm_db_preemptible
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = var.vm_db_nat
  }

  metadata = {
    serial-port-enable = var.vm_metadata.serial-port-enable
    ssh-keys           = var.vm_metadata.ssh-keys
  }
  
}