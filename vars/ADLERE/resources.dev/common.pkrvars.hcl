# ----------------------------------------------------------------------------
# Name:         common.pkrvars.hcl
# Description:  Common variables for Packer builds
# Author:       Olivier de PERTAT
# ----------------------------------------------------------------------------

# vCenter Settings
vcenter_username                = "odepertat@adlere.priv"

# vCenter Configuration
vcenter_server                  = "vcenter7.adlere.priv"
vcenter_datacenter              = "DC-Adlere7"
vcenter_cluster                 = "Adlere7"
vcenter_datastore               = "vsanDatastore"
vcenter_network                 = "dVLAN_PROTO_v9"
vcenter_insecure                = true
vcenter_folder                  = "Templates"

domain                          = "adlere.local"

ansible_username                = "cloudadmin"
ansible_sshkey                  = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDAj5Kebslu6tpWHIToYRK5dKZVZ/tCS0L99ZJVDCkmKEZemGxgXU9T7aJY2j+UA0sxyx15y6qXCJT6FeJ8Glbo/De1Gkdwq/I6AIJMWiYKyn6xSxz3y4cLbjPvO1g48QCdbYDslK8Zc73LVLCeOusips4FIec/k0VdWlUklfsOxNoJcjTVH5WbjwN7ZDLCnAQLw7sLm8SiFlfHSJ+NBd2rvhwwC0PbwPYxV2XJN6PqiN1/5PKEArkMZ+OyHcJQ3asAu+on4jgD9IQIjl62RmZNrM7ZfDaNrmWh2wzzaI7L9zMjyLqHXp9KA2npCtlwfjCbBceoyqTh6T7sm6/Q9XnZ cloudadmin@cicd-rhel7-02"

pki_certs                       = "http://www.adlere.priv/dc3.adlere.priv.crt http://www.adlere.priv/adlere-DC2-CA.crt"
vmware_guest_script             = "https://raw.githubusercontent.com/vmware/cloud-init-vmware-guestinfo/master/install.sh"

rhsm_user                       = "odepertat@adlere.fr"


