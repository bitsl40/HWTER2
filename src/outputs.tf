output "vms" {
  description = "Сведения о ВМ в Yandex Cloud: имя, внешний IP, FQDN "
  value = {
    instance_name_platform = yandex_compute_instance.platform.name
    external_ip_platform   = yandex_compute_instance.platform.network_interface[0].nat_ip_address
    instance_name_platformdb = yandex_compute_instance.platformdb.name
    external_ip_platformdb   = yandex_compute_instance.platformdb.network_interface[0].nat_ip_address
    
   
  }

}