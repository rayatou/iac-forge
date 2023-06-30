# ----------------------------------------------------------------------------
# Name:         common.pkrvars.hcl
# Description:  Common variables for Packer builds
# Author:       Olivier de PERTAT
# ----------------------------------------------------------------------------

# vCenter Settings
vcenter_username                = "{{ CloudVMProvider.vsphere_user }}"
vcenter_password                = "{{ CloudVMProvider.vsphere_password }}"

# vCenter Configuration
vcenter_server                  = "{{ CloudVMProvider.vsphere_host }}"
vcenter_datacenter              = "{{ CloudVMProvider.vsphere_datacenter }}"
vcenter_cluster                 = "{{ CloudVMProvider.vsphere_cluster }}"
vcenter_datastore               = "{{ CloudVMProvider.vsphere_datastore }}"
vcenter_network                 = "{{ CloudVMProvider.vsphere_network }}"
vcenter_insecure                = true
vcenter_folder                  = "{{ CloudVMProvider.vsphere_template_folder }}"

domain                          = "{{ CloudVMDefaultConfig.domain }}"

ansible_username                = "{{ CloudVMDefaultConfig.ansible_username }}"
ansible_password                = "{{ CloudVMDefaultConfig.ansible_password }}"
ansible_sshkey                  = "{{ CloudVMDefaultConfig.ansible_sshkey }}"

pki_certs                       = "{{ CloudVMDefaultConfig.pki }}"
vmware_guest_script             = "{{ CloudVMDefaultConfig.vmware_guest_script }}"

rhsm_user                       = "{{ CloudVMForge.redhat.rhn_user }}"
rhsm_pass                       = "{{ CloudVMForge.redhat.rhn_pass }}"

winrm_username                  = "{{ CloudVMForge.windows.FR.AdminUser }}"
winrm_password                  = "{{ CloudVMForge.windows.FR.AdminPassword }}"
win_admingroup                  = "{{ CloudVMForge.windows.FR.AdminGroup }}"