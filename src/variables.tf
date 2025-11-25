###cloud vars


variable "cloud_id" {
  type        = string
  default     = "b1gbq8rt47hsq5i7vnf0"
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  default     = "b1g1cc80vekm2u1stsgv" 
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}


###ssh vars

variable "vms_ssh_root_key" {
  type        = string
  default     = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINe5CQPAWspyy56JMMB5js6mo0aI2X6owapwEEd19Tjf <опциональный_комментарий>"
  description = "ssh-keygen -t ed25519"
}

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Семейство образа ОС"
}


variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Имя ВМ"
}

variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v3"
  description = "тип платофрмы"
}


variable "vm_web_cores" {
  type        = number
  default     = 2
  description = "Количество ядер"
}

variable "vm_web_memory" {
  type        = number
  default     = 1
  description = "Количество ОЗУ"
}

variable "vm_web_cores_fraction" {
  type        = number
  default     = 20
  description = "Доля ядра"
}

variable "vm_web_preemptible" {
  type    = bool
  default = true
  description = "Прерываемую ВМ (preemptible)"
}

variable "vm_web_nat" {
  type    = bool
  default = true
  description = "Состояние вкл/выкл NAT"
}


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
}

variable "vm_metadata" {
  type = object({
    serial-port-enable = number
    ssh-keys           = string
  })
  description = "Общие metadata для всех ВМ: включение serial‑порта и SSH‑ключи"
  default = {
    serial-port-enable = 1
    ssh-keys           = "ubuntu:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINe5CQPAWspyy56JMMB5js6mo0aI2X6owapwEEd19Tjf <опциональный_комментарий>"
  }
}