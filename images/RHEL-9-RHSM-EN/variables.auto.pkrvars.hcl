# OS Meta Data
vm_os_family           = "Linux"
vm_os_version          = "RHEL9"

# VM Hardware Settings
vm_firmware         = "efi-secure"
vm_cpu_sockets      = 1
vm_cpu_cores        = 1
vm_mem_size         = 2048
vm_nic_type         = "vmxnet3"
vm_disk_controller  = ["pvscsi"]
vm_disk_size        = 16384
vm_disk_thin        = true
vm_cdrom_type       = "sata"

# VM OS Settings
vm_guestos_type     = "rhel8_64Guest"

# Provisioner Settings
script_files        = [ "./scripts/rhel9-config.sh" ]
inline_cmds         = []

# Packer Settings
http_directory      = "config"
http_file           = "ks.cfg"
