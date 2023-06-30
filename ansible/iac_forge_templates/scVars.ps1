
########################################################
## SYSTEM VARS
########################################################
$WIN64_ADMIN_DEFAULT_PASS='Kernet10$'

$WSUS_IS_INTERNAL             = ${{ CloudVMForge.windows.wsus_internal | default('False') }}
$WSUS_INTERNAL_WUServer       = "{{ CloudVMForge.windows.wu_server | default('') }}"
$WSUS_INTERNAL_WUStatusServer = "{{ CloudVMForge.windows.wu_status_server | default('') }}"
########################################################
########################################################


########################################################
## CLOUD INIT VARS 
########################################################
# $WIN64_CLOUDINIT_MSI ="{{ CloudVMForge.windows.cloudinit_msi_url }}"
$WIN64_CLOUDINIT_MSI ="https://www.cloudbase.it/downloads/CloudbaseInitSetup_Stable_x64.msi"
$WIN64_CLOUDINIT_DIR = "C:\Program Files\Cloudbase Solutions\Cloudbase-Init"
########################################################
