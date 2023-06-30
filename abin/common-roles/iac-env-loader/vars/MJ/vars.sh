if [ -z $REPO_DOCKER_PASSWORD ]; 
then 
  export LOCAL_VARSH_VERSION=23

  export CI_PROJECT_NAME=${PWD##*/}
  export CI_TENANT_DIR="$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )/.."
  export CI_SETENV=TRUE
  export abinDir="$CI_TENANT_DIR/../abin"
  export CI_ENV=LOCAL # Set this to GITLAB_CI in your Gitlab
  export CA_ROOT_CRT_URL="http://www.adlere.priv/dc3.adlere.priv.crt"
  export GIT_REPO_SHELL_CI_UTILS=git@gitlab.adlere.fr:adlereps/adlere-ansible/shell-ci-utils.git

  # With GITLAB RUNNER THESE ARE SENT DIRECTLY BY ENV VARS
  export VAULT_ENV_TYPE=ANSIBLE
  export VAULT_ENV_PASSFILE="~/.vault_pass"
  export VAULT_ENV_FILE="$abinDir/../vars/${CI_TENANT}/vault.cyml"
  export VAULT_ENV_PASSWORD=`cat ~/.vault_pass`

  # -------------------------------------------------------- #
  # Caching VAULT Content - Otherwise it slows down unit testing
  if [ -z $mVAULT_CONTENT ];
  then 
    echo "  [INFO][mShellLib] *** Create Cache ***"  1>&2
    export mVAULT_CONTENT=`ansible-vault view ${VAULT_ENV_FILE} --vault-id=${VAULT_ENV_PASSFILE}`
  fi
  # -------------------------------------------------------- #

  export ADMIN_PASSWORD=`$abinDir/vault-getsecret CA_CERT_PASSWORD`
  export WINRM_PORT=5985

  export REPO_DOCKER_BUILDAH_IMAGE=repo3.adlere.local:5000/adlere-releases/adlere-docker-cicd-buildah:v1.3
  export REPO_DOCKER_CA_ROOT_CRT_URL=$CA_ROOT_CRT_URL
  export REPO_DOCKER_HOST="repo3.adlere.local:5000"
  export REPO_DOCKER_USER="cicd-proto1"
  export REPO_DOCKER_PASSWORD=`$abinDir/vault-getsecret REPO_DOCKER_PASSWORD`
  export REPO_DOCKER_REGISTRY_RELEASE="adlere-releases"
  export REPO_DOCKER_REGISTRY_SNAPSHOT="adlere-snapshots"

  # Name Of the Tenant for Ansible. Should Be the Same as CI_TENANT
  export ROLE_NAME=$CI_PROJECT_NAME
  export ANSIBLE_TENANT=$CI_TENANT
  export ANSIBLE_REPO=$CI_PROJECT_NAME
  export ANSIBLE_REPO_TYPE=NEXUS3
  export ANSIBLE_REPO_HOST=https://repo3.adlere.local
  export ANSIBLE_REPO_USER=cicd-proto1
  export ANSIBLE_REPO_PASS=`$abinDir/vault-getsecret ANSIBLE_REPO_PASS`
  export ANSIBLE_REPO_SNAPSHOT=adlere-ansible-snapshot/mj-alpha/
  export ANSIBLE_REPO_RELEASE=adlere-ansible-release/mj-alpha/

  export RHN_USER="cicd01@adlere.fr"
  export RHN_PASS=`$abinDir/vault-getsecret RHN_PASS`
  export RHN_TOKEN=`$abinDir/vault-getsecret RHN_TOKEN`
  export RHN_POOL="2c9417b7828946750182b5d7fa2a3593"

  export CA_ROOT_CRT_URL="http://www.adlere.priv/dc3.adlere.priv.crt"
  export CA_CERT_PASSWORD=`$abinDir/vault-getsecret CA_CERT_PASSWORD`

  export ABIN_ANSIBLE_VERSION=2.13
  export ABIN_MOLECULE_VERSION=3.6
  export ABIN_PYTHON_DIR=~/abin-ansible-${ABIN_ANSIBLE_VERSION}-molecule-${ABIN_MOLECULE_VERSION}

  export GIT_REPO_SHELL_CI_UTILS=git@gitlab.adlere.fr:adlereps/adlere-ansible/shell-ci-utils.git

  export IPAM_APP_ID="cloudv1"
  export IPAM_ENDPOINT="https://ipam.adlere.priv/api/"
  export IPAM_PASSWORD=`$abinDir/vault-getsecret IPAM_PASSWORD`
  export IPAM_USERNAME="api-ipam-rw"
  export IPAM_INSECURE=true

  export ADMIN_PASSWORD=`$abinDir/vault-getsecret CA_CERT_PASSWORD`

  export GIT_REPO_SHELL_CI_UTILS=git@gitlab.adlere.fr:adlereps/adlere-ansible/shell-ci-utils.git
#  export IAC_ENV="INT"
  export IAC_ENV="INT"
  export IAC_GIT_BRANCH="IaC"
  export IAC_GIT_EMAIL="support@adlere.fr"
  export IAC_GIT_MESSAGE="IaC Integration"
  export IAC_GIT_USERNAME=qmontalan
  export IAC_GIT_TOKEN=`$abinDir/vault-getsecret IAC_GIT_TOKEN`

  export IAC_CLOUDADMIN_PASSWORD=""

# VSPHERE DC3 & DC5

  export VSPHERE_DC3_CLUSTER="Adlere-WORKER"
  export VSPHERE_DC3_DATACENTER="Adlere"
  export VSPHERE_DC3_DATASTORE="vsanDatastore-WORKER"
  export VSPHERE_DC3_FOLDER="/Adlere/vm/vProto3"
  export VSPHERE_DC3_HOST="vcenter.ext.adlere.priv"
  export VSPHERE_DC3_USER="cicd-proto3@adlere.priv"
  export VSPHERE_DC3_PASSWORD=`$abinDir/vault-getsecret VSPHERE3_PASSWORD`
  export VSPHERE_DC3_CHECK_CERT=false
  export VSPHERE_DC3_NIC_DEFAULT_NETWORK="dVLAN_PROTO2_v92"

  export VSPHERE_DC5_CLUSTER="Adlere7"
  export VSPHERE_DC5_DATACENTER="DC-Adlere7"
  export VSPHERE_DC5_DATASTORE="vsanDatastore"
  export VSPHERE_DC5_FOLDER="/DC-Adlere7/vm/Templates-ASC-VM"
  export VSPHERE_DC5_HOST="vcenter7.adlere.priv"
  export VSPHERE_DC5_USER="asanchez@adlere.priv"
  export VSPHERE_DC5_PASSWORD=`$abinDir/vault-getsecret VSPHERE5_PASSWORD`
  export VSPHERE_DC5_CHECK_CERT=false
  export VSPHERE_DC5_NIC_DEFAULT_NETWORK="VLAN_10_Dev"


# TEMP VAULT

  export VAULT_DATA_TOKEN=`$abinDir/vault-getsecret VAULT_DATA_TOKEN`
  export VAULT_ADDR="http://192.168.9.209:32000"
  export VAULT_USER="gitlab"
  export VAULT_PASS=`$abinDir/vault-getsecret VAULT_PASS`

# CERT X509 

  export CERT_OUTPUT_FIR="~/data"
  export CERT_AUTHORITY="dc3.adlere.priv"
  export CERT_CHAIN_URL="https://repo3.adlere.local/repository/bin/AdlerePKI/dc3.adlere.priv.crt"
  export CERT_ADMIN_USER="qmontalan"
  export CERT_ADMIN_PASS=`$abinDir/vault-getsecret CA_CERT_PASSWORD`
  export SSL_CERT_EMAIL="support@adlere.fr"
  export SSL_CERT_ORG="Adlere"
  export SSL_CERT_UNIT="SII"
  export SSL_CERT_CN="Adlere"
  export SSL_CERT_DOMAIN="adlere.priv"
  
# FORGE

  export CLOUD_FORGE_REPO_URL="https://repo2.adlere.fr/repository/bin/vmware/vra8/images"
  export CLOUD_WSUS_SERVER="http://sv01561:8530"
  export CLOUD_WIN_ADMIN_USER="Administrateur"
  export CLOUD_WIN_ADMIN_PASSWORD=`$abinDir/vault-getsecret WIN_PASSWORD`
  export CLOUD_SSH_USERNAME=cloudadmin
  export CLOUD_SSH_PASSWORD=`$abinDir/vault-getsecret WIN_PASSWORD`
  export CLOUD_SSH_PRIVATE_KEY=`$abinDir/vault-getsecret SSH_PRIVATE_KEY`
  export CLOUD_SSH_PUBLIC_KEY=`$abinDir/vault-getsecret SSH_PUBLIC_KEY`
  export IAC_CLOUDADMIN_TEMP_PASSWORD=`$abinDir/vault-getsecret CLOUD_SSH_PASS`

# SATELLITE

  export CLOUD_SATELLITE_ORG=ADLERE
  export CLOUD_SATELLITE_RHEL_POOL_ID="4028949f84aa44f50184addf2d993967"
  export CLOUD_SATELLITE_RHEL8_A_KEY="ADLERE_AKEY_RHEL8_LIBRARY"
  export CLOUD_SATELLITE_RHEL9_A_KEY=""
  export CLOUD_SATELLITE_RPM="http://satellite.adlere.priv/pub/katello-ca-consumer-latest.noarch.rpm"
  export CLOUD_SATELLITE_EPEL_SUB=true
  export CLOUD_SATELLITE_EPEL_REPO_NAME="EPEL-8"
  export CLOUD_SATELLITE_EPEL_POOL_ID="4028949f84aa44f50184b3979f013aba"
  export CLOUD_SATELLITE_SYS_UPGRADE=false
  export CLOUD_SATELLITE_DIS_REPOS=true
  export CLOUD_SATELLITE_ENA_REPOS=true

# USER PROFILE

  export CLOUD_USER_WINRM_USER="Administrateur"
  export CLOUD_USER_WINRM_PASSWORD=`$abinDir/vault-getsecret CLOUD_SSH_PASS`
  export CLOUD_USER_SSH_USER="cloudadmin"
  export CLOUD_USER_WINRM_PORT=5985
  export CLOUD_USER_WINRM_TRANSPORT=basic
  export CLOUD_USER_WINRM_SCHEME=http
  export CLOUD_USER_WINRM_TO=15
  export CLOUD_USER_WINRM_TO_OP=30

# WINDOWS ENV

  export CLOUD_WINDOWS_ENVIRONMENT_DOMAIN_JOIN=true
  export CLOUD_WINDOWS_ENVIRONMENT_DOMAIN_NAME="adlere.priv"
  export CLOUD_WINDOWS_ENVIRONMENT_DOMAIN_ADMINGROUP="Administrateurs"
  export CLOUD_WINDOWS_ENVIRONMENT_DOMAIN_USER="ADLERE\svcVRA"
  export CLOUD_WINDOWS_ENVIRONMENT_DOMAIN_PASSWORD=`$abinDir/vault-getsecret CL_WIN_ENV_DOMAIN_PASS`
  export CLOUD_WINDOWS_ENVIRONMENT_DOMAIN_JOIN_OU="OU=proto,DC=proto,DC=adlere,DC=priv"
  export CLOUD_WINDOWS_ENVIRONMENT_DOMAIN_SECURITY_SCAN="AC-Security/Outpost"
  export CLOUD_WINDOWS_ENVIRONMENT_NET_IPV6=true
  export CLOUD_WINDOWS_ENVIRONMENT_NET_DIS_TCPIP_NETBIOS=true
  export CLOUD_WINDOWS_ENVIRONMENT_SYS_UPGRADE=false
  export CLOUD_WINDOWS_ENVIRONMENT_TS_GROUP_NAME="Utilisateurs du Bureau à distance"

# WINDOWS ENV

  export CLOUD_WINDOWS_SQL_CREATE_WITH_LOCAL_ADMIN=true
  export CLOUD_WINDOWS_SQL_CREATE_WITH_LOCAL_USER=true
  export CLOUD_WINDOWS_SQL_ACTION="install"
  export CLOUD_WINDOWS_SQL_SERVER_SERIAL=`$abinDir/vault-getsecret SQLServerSerial`
  export CLOUD_WINDOWS_SQL_FEATURES=SQL,Tools
  export CLOUD_WINDOWS_SQL_INSTANCE_NAME="MSSQLSERVER"
  export CLOUD_WINDOWS_SQL_SYSADMIN_ACCOUNTS='""Administrateurs"" ""Administrateur"" ""svcSQLServer""'
  export CLOUD_WINDOWS_SQL_SVC_ACCOUNT=svcSQLServer
  export CLOUD_WINDOWS_SQL_SVC_PASSWORD=`$abinDir/vault-getsecret SQLSVCPASSWORD`
  export CLOUD_WINDOWS_SQL_AGENT_ACCOUNT=svcSQLServer
  export CLOUD_WINDOWS_SQL_AGENT_PASSWORD=`$abinDir/vault-getsecret AGTSVCPASSWORD`
  export CLOUD_WINDOWS_SQL_CREATE_SAMPLE_DB=true
  export CLOUD_WINDOWS_SQL_SERVER_DATADIR='D:\MSSQL\DATA'
  export CLOUD_WINDOWS_SQL_SERVER_SCRIPTDIR='D:\MSSQL\Scripts'
  export CLOUD_WINDOWS_SQL_SERVER_CMD='C:\Program Files\Microsoft SQL Server\Client SDK\ODBC\170\Tools\Binn\sqlcmd.exe'

fi