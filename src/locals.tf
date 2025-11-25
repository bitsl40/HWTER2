locals {
  namedb       = "${var.vm_db_name}-${var.vm_web_cores}"
  namedev      = "${var.vm_web_name}-${var.vm_web_cores}"
}