# By Default Role Name is Repository Name
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
  export VAULT_DATA_TOKEN=`$abinDir/vault-getsecret VAULT_DATA_TOKEN`

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
  export ANSIBLE_DOCKER_MOLECULE_IMAGE=repo3.adlere.local:5000/adlere-releases/ansible-molecule/ansible2.9-molecule2-podman:v2.5
  export ANSIBLE_DOCKER_RELEASE_ROLE_IMAGE=repo3.adlere.local:5000/adlere-releases/adlere-docker-cicd-releaserole:v1.6
  export ANSIBLE_REPO=$CI_PROJECT_NAME
  export ANSIBLE_REPO_TYPE=NEXUS3
  export ANSIBLE_REPO_HOST=https://repo3.adlere.local
  export ANSIBLE_REPO_USER=cicd-proto1
  export ANSIBLE_REPO_PASS=`$abinDir/vault-getsecret ANSIBLE_REPO_PASS`
  export ANSIBLE_REPO_SNAPSHOT=adlere-ansible-snapshot
  export ANSIBLE_REPO_RELEASE=adlere-ansible-release

  export CA_ROOT_CRT_URL="http://www.adlere.priv/dc3.adlere.priv.crt"

  export ABIN_ANSIBLE_VERSION=2.9
  export ABIN_MOLECULE_VERSION=2
  export ABIN_PYTHON_DIR=~/abin-ansible-${ABIN_ANSIBLE_VERSION}-molecule-${ABIN_MOLECULE_VERSION}

  export GIT_REPO_SHELL_CI_UTILS=git@gitlab.adlere.fr:adlereps/adlere-ansible/shell-ci-utils.git

  export SATELLITE_ORG="ADLERE"
  export SATELLITE_AKEY="ADLERE_AKEY_RHEL8_LIBRARY"
  export SATELLITE_POOL="4028949f84aa44f50184addf2d993967"
  export SATELLITE_RPM="http://satellite.adlere.priv/pub/katello-ca-consumer-latest.noarch.rpm"
  export SATELLITE_EPEL8="EPEL-8"
  export SATELLITE_EPEL8_POOL="4028949f84aa44f50184b3979f013aba"

  export RHN_USER="cicd01@adlere.fr"
  export RHN_PASS=`$abinDir/vault-getsecret RHN_PASS`
  export RHN_TOKEN=`$abinDir/vault-getsecret RHN_TOKEN`
  export RHN_POOL="2c9417b7828946750182b5d7fa2a3593"

  export GIT_REPO_SHELL_CI_UTILS=git@gitlab.adlere.fr:adlereps/adlere-ansible/shell-ci-utils.git
#  export IAC_ENV="INT"
  export IAC_ENV="DEV"
  export IAC_GIT_BRANCH="IaC"
  export IAC_GIT_EMAIL="support@adlere.fr"
  export IAC_GIT_MESSAGE="IaC Integration"
  export IAC_GIT_USERNAME=qmontalan
  export IAC_GIT_TOKEN=`$abinDir/vault-getsecret IAC_GIT_TOKEN`
  export IAC_GIT_ENV_REPO="gitlab.adlere.fr/adlereps/iac/iac-env-definitions.git"
  export IAC_GIT_MENU_REPO="gitlab.adlere.fr/adlereps/iac/iac-project-test/infra-test.git"
  export IAC_DOCKER_MENUBUILDER="repo3.adlere.local:5000/adlere-snapshots/iac-menu-builder:latest"
  export IAC_DOCKER_PROJECT7="repo3.adlere.local:5000/adlere-snapshots/iac-project7:latest"
  
  export VSPHERE_CLUSTER="Adlere-WORKER"
  export VSPHERE_DATACENTER="Adlere"
  export VSPHERE_DATASTORE="vsanDatastore-WORKER"
  export VSPHERE_FOLDER="/Adlere/vm/vProto3"
  export VSPHERE_HOST="vcenter.ext.adlere.priv"
  export VSPHERE_USER="cicd-proto3@adlere.priv"
  export VSPHERE_PASSWORD=`$abinDir/vault-getsecret VSPHERE_PASSWORD`
  export VSPHERE_NIC_DEFAULT_DOMAIN="adlere.local"
  export VSPHERE_NIC_DEFAULT_NETMASK="24"
  export VSPHERE_NIC_DEFAULT_NETWORK="dVLAN_PROTO3_v93"
  export VSPHERE_NIC_DEFAULT_TYPE="static"
  export VSPHERE_NIC_DEFAULT_IP="192.168.9.253"
  export VSPHERE_NIC_DEFAULT_GATEWAY="192.168.9.254"
  export VSPHERE_NIC_DEFAULT_DNS="192.168.9.254"

  export IPAM_APP_ID="cloudv1"
  export IPAM_ENDPOINT="https://ipam.adlere.priv/api/"
  export IPAM_PASSWORD=`$abinDir/vault-getsecret IPAM_PASSWORD`
  export IPAM_USERNAME="api-ipam-rw"
  export IPAM_INSECURE=true

  # To Get the Password to generate Certificates from Microsoft
  export CA_CERT_PASSWORD=`$abinDir/vault-getsecret CA_CERT_PASSWORD`

fi