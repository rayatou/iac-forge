# ----------------------------------------------------------------------------
# Name:         rhel8.pkr.hcl
# Description:  Build definition for RedHat Enterprise Linux 8
# ----------------------------------------------------------------------------

# -------------------------------------------------------------------------- #
#                           Packer Configuration                             #
# -------------------------------------------------------------------------- #
packer {
    required_version = ">= 1.7.7"
    required_plugins {
        vsphere = {
            version = ">= v1.0.2"
            source  = "github.com/hashicorp/vsphere"
        }
    }
}

variable "RHEL_8_vm-name" {
    type        = string
    description = "RedHat VM Name"
    sensitive   = true
}

variable "RHEL_8_iso-path" {
    type        = string
    description = "RHEL 8 ISO Path"
    sensitive   = true
}

variable "rhsm_user" {
    type        = string
    description = "RedHat Subscription Manager username"
    sensitive   = true
}
variable "rhsm_pass" {
    type        = string
    description = "RedHat Subscription Manager password"
    sensitive   = true
}
variable "pki_certs" {
    type        = string
    description = "List of PKI Certificates that are meant to be installed"
    sensitive   = true
}



# Local Variables
locals { 
    build_version   = formatdate("YY.MM", timestamp())
    build_date      = formatdate("YYYY-MM-DD hh:mm ZZZ", timestamp())
}

# -------------------------------------------------------------------------- #
#                       Template Source Definitions                          #
# -------------------------------------------------------------------------- #
source "vsphere-iso" "rhel8" {
    # vCenter
    vcenter_server              = var.vcenter_server
    username                    = var.vcenter_username
    password                    = var.vcenter_password
    insecure_connection         = var.vcenter_insecure
    datacenter                  = var.vcenter_datacenter
    cluster                     = var.vcenter_cluster
    folder                      = "${ var.vcenter_folder }"
    datastore                   = var.vcenter_datastore
    remove_cdrom                = var.vm_cdrom_remove
    convert_to_template         = var.vm_convert_template

    # Virtual Machine
    guest_os_type               = var.vm_guestos_type
    vm_name                     = var.RHEL_8_vm-name
    notes                       = "VER: ${ local.build_version }\nDATE: ${ local.build_date }\nOS: RedHat Enterprise Linux 8 Server"
    firmware                    = var.vm_firmware
    CPUs                        = var.vm_cpu_sockets
    cpu_cores                   = var.vm_cpu_cores
    RAM                         = var.vm_mem_size
    cdrom_type                  = var.vm_cdrom_type
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
    iso_paths                   = [var.RHEL_8_iso-path]

    # Boot and Provisioner
    http_directory              = var.http_directory
    http_port_min               = var.http_port_min
    http_port_max               = var.http_port_max
    boot_order                  = var.vm_boot_order
    boot_wait                   = var.vm_boot_wait
    boot_command                = [ "up", "wait", "e", "<down><down><end><wait>",
                                    "<bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs><bs>",
                                    "quiet text inst.ks=http://{{ .HTTPIP }}:{{ .HTTPPort }}/${var.http_file}",
                                    "<enter><wait><leftCtrlOn>x<leftCtrlOff>" ]
    ip_wait_timeout             = var.vm_ip_timeout
    communicator                = "ssh"
    ssh_username                = var.build_username
    ssh_password                = var.build_password
    shutdown_command            = "sudo shutdown -P now"
    shutdown_timeout            = var.vm_shutdown_timeout
}

# -------------------------------------------------------------------------- #
#                             Build Management                               #
# -------------------------------------------------------------------------- #
build {
    # Build sources
    sources                 = [ "source.vsphere-iso.rhel8" ]
    
    # Shell Provisioner to execute scripts 
    provisioner "shell" {
        execute_command     = "echo '${var.build_password}' | {{.Vars}} sudo -E -S sh -eu '{{.Path}}'"
        environment_vars    = [ "CLOUDADMIN_NAME=${ var.ansible_username }", 
                                "CLOUDADMIN_SSHKEY=${ var.ansible_sshkey }",
                                "PKI_CERTS=${ var.pki_certs }",
                                "VMWARE_GUEST_SCRIPT=${ var.vmware_guest_script }",                                
                                "RHSM_USER=${ var.rhsm_user }",
                                "RHSM_PASS=${ var.rhsm_pass }" ]
        scripts             = var.script_files
    }

    post-processor "manifest" {
        output              = "manifest.txt"
        strip_path          = true
        custom_data         = {
                                vcenter_fqdn    = "${ var.vcenter_server }"
                                vcenter_folder  = "${ var.vcenter_folder }/${ var.vm_os_family }/${ var.vm_os_version }"
        }
    }
}