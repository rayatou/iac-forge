# ----------------------------------------------------------------------------
# Name:         Win1809-Windows-2019-LTS-FR-HCL
# Description:  Build definition for Windows 2016
# Author:       Olivier De Pertat
# ----------------------------------------------------------------------------

packer {
    required_version = "1.7.10"
    required_plugins {
        vsphere = {
            version = "v1.0.6"
            source = "github.com/hashicorp/vsphere"
        }
        windows-update = {
            version = "0.14.1"
            source  = "github.com/rgl/windows-update"
        }
    }
}

variable "os_iso_path" {
    type        = string
    description = "Path to the iso file"
}
variable "vm_name" {
    type        = string
    description = "Name of the Template"
}

locals {
    build_version               = formatdate("YY.MM", timestamp())
    build_date                  = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
    vm_description              = "VER: ${ local.build_version }\nDATE: ${ local.build_date }"
    floppy_content         = {
                                    "autounattend.xml" = templatefile("./Files/autounattend.pkrtpl.hcl", {
                                        admin_password            = var.winrm_password
                                        admin_user                = var.winrm_username
                                        vm_guestos_language       = var.vm_guestos_language
                                        vm_guestos_systemlocale   = var.vm_guestos_systemlocale
                                        vm_guestos_keyboard       = var.vm_guestos_keyboard
                                        vm_guestos_timezone       = var.vm_guestos_timezone
                                        vm_windows_image          = "Windows Server 2019 SERVERSTANDARD"
                                    })
                                  }
}

source "vsphere-iso" "win2019iisfr" {
    # vCenter
    vcenter_server              = var.vcenter_server
    username                    = var.vcenter_username
    password                    = var.vcenter_password
    insecure_connection         = var.vcenter_insecure
    datacenter                  = var.vcenter_datacenter
    cluster                     = var.vcenter_cluster
    folder                      = var.vcenter_folder
    datastore                   = var.vcenter_datastore

    # Template Settings
    convert_to_template         = var.vcenter_convert_template

    # Virtual Machine
    guest_os_type               = var.vm_guestos_type
    vm_name                     = var.vm_name
    notes                       = local.vm_description
    firmware                    = var.vm_firmware_win
    CPUs                        = var.vm_cpu_sockets
    cpu_cores                   = var.vm_cpu_cores
    CPU_hot_plug                = var.vm_cpu_hotadd
    RAM                         = var.vm_mem_size
    RAM_hot_plug                = var.vm_mem_hotadd
    cdrom_type                  = var.vm_cdrom_type
    remove_cdrom                = var.vm_cdrom_remove
    disk_controller_type        = var.vm_disk_controller
    storage {
        disk_size               = var.vm_disk_size
        disk_thin_provisioned   = var.vm_disk_thin
    }
    network_adapters {
        network                 = var.vcenter_network
        network_card            = var.vm_nic_type
    }
    # Removeable Media
    iso_paths                   = [ "${ var.os_iso_path }", "[] /vmimages/tools-isoimages/windows.iso" ]
    floppy_files                = [ "Files/*", "scripts/*" ]
    floppy_content              = local.floppy_content

    # Boot and Provisioner
    boot_order                  = var.vm_boot_order
    ip_wait_timeout             = var.vm_ip_timeout
    communicator                = "winrm"
    winrm_username              = var.winrm_username
    winrm_password              = var.winrm_password
    shutdown_command            = "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Complete\""
}

build {
    # Build Sources
    sources                 = [ "source.vsphere-iso.win2019iisfr"]

    # Show Ip config
    provisioner "windows-shell" {
        inline              = [ "ipconfig" ]
    }

    provisioner "powershell" {
        scripts             = [ "scripts/10_CloudInit-Install.ps1", "scripts/11_CopyLocal-Scripts.ps1", "scripts/12_WindowsUpdate.ps1" ]
        environment_vars    = [ "SHELL_DIR=A:\\",
                                "AdminUser=${var.ansible_username}",
                                "AdminGroup=${var.win_admingroup}",
                                "CloudAdmin=${var.ansible_username}" ]
    }

}