# OS Meta Data
vm_os_family           = "Windows"
vm_os_type             = "Server"
vm_os_version          = "Server 2019"

# VM Hardware Settings
vm_firmware         = "boot"
vm_cpu_sockets      = 2
vm_cpu_cores        = 6
vm_mem_size         = 6144
vm_nic_type         = "vmxnet3"
vm_disk_controller  = ["lsilogic-sas"]
vm_disk_size        = 40960
vm_disk_thin        = true
vm_cdrom_type       = "sata"

# VM OS Settings
vm_guestos_type     = "windows9Server64Guest"
http_file           = ""
