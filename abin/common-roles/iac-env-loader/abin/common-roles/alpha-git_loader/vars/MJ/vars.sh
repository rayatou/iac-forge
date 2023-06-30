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

  export CA_ROOT_CRT_URL="http://www.adlere.priv/dc3.adlere.priv.crt"

  export ABIN_ANSIBLE_VERSION=2.13
  export ABIN_MOLECULE_VERSION=3.6
  export ABIN_PYTHON_DIR=~/abin-ansible-${ABIN_ANSIBLE_VERSION}-molecule-${ABIN_MOLECULE_VERSION}

  export GIT_REPO_SHELL_CI_UTILS=git@gitlab.adlere.fr:adlereps/adlere-ansible/shell-ci-utils.git


  export GIT_REPO_SHELL_CI_UTILS=git@gitlab.adlere.fr:adlereps/adlere-ansible/shell-ci-utils.git
#  export IAC_ENV="INT"
  export IAC_ENV="INT"
  export IAC_GIT_BRANCH="IaC"
  export IAC_GIT_EMAIL="support@adlere.fr"
  export IAC_GIT_MESSAGE="IaC Integration"
  export IAC_GIT_USERNAME=qmontalan

#   export VAULT_ADDR="http://192.168.9.209:32000"
#   export VAULT_USER="k8s-service"
#   export VAULT_PASS="superk8spassword"
#   export VAULT_PATH="kv/data/kubeconfig"
fi