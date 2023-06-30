SHELL := /bin/bash
mNOW		:= $(shell date '+%Y-%m-%d_%H-%M-%S')
mCMD 		:= cd $(ROOT_DIR) ; sudo docker-compose
mDocker 	:= cd $(ROOT_DIR) ; sudo docker

mPacker  := /usr/bin/packer-1.5
mPacker17  := /usr/bin/packer-1.7


.SILENT: Configure
.PHONY: help

help:
	@fgrep -h "##" $(MAKEFILE_LIST) | fgrep -v fgrep | sed -e 's/\\$$//' | sed -e 's/##//'

vars:
	@printf "\033[36mUsing variables $$VARYML \033[0m\n"
	@echo ""
	@echo "***************************************"
	@echo "**"
	@echo "** RUSER:		$(RUSER)"
	@echo "** RCONN:		$(RCONN)"
	@echo "** VARYML:		$(VARYML)"
	@echo "** ROOT_PASSWORD:		$(ROOT_PASSWORD)"
	@echo "** INVENTORY:		$(INVENTORY)"
	@echo "** ABIN_PYTHON_DIR:	$(ABIN_PYTHON_DIR)"
	@echo "** LOCAL_SERVER:	$(LOCAL_SERVER)"
	@echo "**"
	@echo "***************************************"
	@echo ""

##
##---------------------------------------------------------------------------
##install00			| local machine setup
##---------------------------------------------------------------------------
install00: vars	
	wget -nc -P /tmp https://releases.hashicorp.com/packer/1.5.6/packer_1.5.6_linux_amd64.zip	
	cd /tmp && unzip /tmp/packer_1.5.6_linux_amd64.zip
	sudo mv /tmp/packer /usr/bin/packer-1.5

	wget -nc -P /tmp https://releases.hashicorp.com/packer/1.7.10/packer_1.7.10_linux_amd64.zip	
	cd /tmp && unzip /tmp/packer_1.7.10_linux_amd64.zip
	sudo mv /tmp/packer /usr/bin/packer-1.7	

##
##---------------------------------------------------------------------------
##install-fw			| Configure Local Firewall
##---------------------------------------------------------------------------
install-fw: vars	
	sudo firewall-cmd --state
	sudo firewall-cmd --add-port=8000-8050/tcp --permanent
	sudo firewall-cmd --reload

##
##---------------------------------------------------------------------------
##GenEnvFromGit			| Build Local Env Variables
##---------------------------------------------------------------------------
GenEnvFromGit: vars
	./abin/ansible-launch ./ansible/GenEnvFromGit.yml	

##
##---------------------------------------------------------------------------
##CreateIACForgeFiles		| Build Local Env Variables
##---------------------------------------------------------------------------
CreateIACForgeFiles: vars
	./abin/ansible-launch ./ansible/CreateIACForgeFiles.yml --vault-password-file=~/.vault_cloud_pass

##
##---------------------------------------------------------------------------
##Debian    			| DEBIAN| Build All Debian Images
##---------------------------------------------------------------------------
Debian: Debian-10 Debian-10-CustomPartMan Debian-11

##Debian-10			| Images| Build and Deploy Debian 10 Image
Debian-10: check-env-VSPHERE_PASSWORD
	$(mPacker) build -force -var-file ./resources/variables.json ./images/Debian-10/Debian-10.json 

##Debian-10-CustomPartMan		| Images| Build and Deploy Debian 10 Image With custom partman layout
Debian-10-CustomPartMan: check-env-VSPHERE_PASSWORD
	$(mPacker) build -force -var-file ./resources/variables.json ./images/Debian-10-CustomPartMan/Debian-10-CustomPartMan.json 

##Debian-10-InternalRep		| Images| Build and Deploy Debian 10 with Internal Image
Debian-10-InternalRepository: check-env-VSPHERE_PASSWORD
	$(mPacker) build -force -var-file ./resources/variables.json ./images/Debian-10-InternalRep/Debian-10-InternalRep.json 

##Debian-11			| Images| Build and Deploy Debian 11 Image
Debian-11: check-env-VSPHERE_PASSWORD
	$(mPacker) build -force -var-file ./resources/variables.json ./images/Debian-11/Debian-11.json 
##---------------------------------------------------------------------------


##
##---------------------------------------------------------------------------
##RHEL-7-RHSM-EN			| RHEL| Build All RHEL 8 Images
##---------------------------------------------------------------------------
RHEL-7-RHSM-EN: RHEL-7.9-RHSM-EN

##RHEL-7.9-RHSM-EN		| Images| Build and Deploy RHEL 7.9 With Internet registration
RHEL-7.9-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	cp resources/definitions.pkr.hcl images/RHEL-7-RHSM-EN/
	cd images/RHEL-7-RHSM-EN/ && $(mPacker17) init . && $(mPacker17) build -force -var-file="../../resources/rhel-7.9.pkrvars.hcl" -var-file="../../resources/common.pkrvars.hcl" --var-file="./variables.auto.pkrvars.hcl" . && echo ""
	rm -f images/RHEL-7-RHSM-EN/definitions.pkr.hcl images/RHEL-7-RHSM-EN/manifest.txt
##---------------------------------------------------------------------------

##
##---------------------------------------------------------------------------
##RHEL-8-RHSM-EN			| RHEL| Build All RHEL 8 Images
##---------------------------------------------------------------------------
RHEL-8-RHSM-EN: RHEL-8.1-RHSM-EN RHEL-8.2-RHSM-EN RHEL-8.3-RHSM-EN RHEL-8.4-RHSM-EN RHEL-8.6-RHSM-EN 

##RHEL-8.0-RHSM-EN		| Images| Build and Deploy RHEL 8.0 With Internet registration
RHEL-8.0-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel8 8.0

##RHEL-8.1-RHSM-EN		| Images| Build and Deploy RHEL 8.1 With Internet registration
RHEL-8.1-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel8 8.1

##RHEL-8.2-RHSM-EN		| Images| Build and Deploy RHEL 8.2 With Internet registration
RHEL-8.2-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel8 8.2

##RHEL-8.3-RHSM-EN		| Images| Build and Deploy RHEL 8.3 With Internet registration
RHEL-8.3-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel8 8.3

##RHEL-8.4-RHSM-EN		| Images| Build and Deploy RHEL 8.4 With Internet registration
RHEL-8.4-RHSM-EN:CreateIACForgeFiles check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel8 8.4

##RHEL-8.5-RHSM-EN		| Images| Build and Deploy RHEL 8.5 With Internet registration
RHEL-8.5-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel8 8.5

##RHEL-8.6-RHSM-EN		| Images| Build and Deploy RHEL 8.6 With Internet registration
RHEL-8.6-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel8 8.6

##RHEL-8.7-RHSM-EN		| Images| Build and Deploy RHEL 8.7 With Internet registration
RHEL-8.7-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel8 8.7
##---------------------------------------------------------------------------

##---------------------------------------------------------------------------
##RHEL-9-RHSM-EN                        | RHEL| Build All RHEL 9 Images
##---------------------------------------------------------------------------
RHEL-9-RHSM-EN: RHEL-9.1-RHSM-EN 
##RHEL-9.1-RHSM-EN              | Images| Build and Deploy RHEL 9.1 With Internet registration

RHEL-9.1-RHSM-EN: check-env-VSPHERE_PASSWORD check-env-RHSM_PASS
	./bin/run-rhel9 9.1
## 
##---------------------------------------------------------------------------


##Windows 2019 LTS - 1809 
##---------------------------------------------------------------------------

##Win1809-Windows-2019-LTS-FR	| Images| Build and Deploy Win1809-Windows-2019-LTS-FR Image
Win1809-Windows-2019-LTS-FR: check-env-VSPHERE_PASSWORD check-env-VSPHERE_USERNAME
	$(mPacker) build -force -var-file ./resources/variables.json ./images/Win1809-Windows-2019-LTS-FR/Win1809-Windows-2019-LTS-FR.json

##Win1809-Windows-2019-LTS-EN	| Images| Build and Deploy Win1809-Windows-2019-LTS-EN Image
Win1809-Windows-2019-LTS-EN: check-env-VSPHERE_PASSWORD check-env-VSPHERE_USERNAME
	$(mPacker) build -force -var-file ./resources/variables.json ./images/Win1809-Windows-2019-LTS-EN/Win1809-Windows-2019-LTS-EN.json

##Win1809-IIS-FR			| Images| Build and Deploy Win1809-IIS-FR Image
Win1809-IIS-FR: check-env-VSPHERE_PASSWORD check-env-VSPHERE_USERNAME
	$(mPacker) build -force -var-file ./resources/variables.json ./images/Win1809-IIS-FR/Win1809-IIS-FR.json

##Win1809-SQL-Server-2019-FR	| Images| Build and Deploy Win1809-SQL-Server-2019-FR Image
Win1809-SQL-Server-2019-FR: check-env-VSPHERE_PASSWORD check-env-VSPHERE_USERNAME
	$(mPacker) build -force -var-file ./resources/variables.json ./images/Win1809-SQL-Server-2019-FR/Win1809-SQL-Server-2019-FR.json

##Win1809-2019-LTS-FR(HCL)	| Images| Build and Deploy Win1809-2019-LTS-FR
Win1809-2019-LTS-FR:
	./bin/run-win1809 LTS-FR

##Win1809-2019-IIS-FR(HCL)	| Images| Build and Deploy Win1809-IIS-FR
Win1809-2019-IIS-FR:
	./bin/run-win1809 IIS-FR

clean:
	rm -rf tmp
	rm -rf resources/*
	rm -rf packer_cache
	

##---------------------------------------------------------------------------

check-env-VSPHERE_PASSWORD:
# ifndef VSPHERE_PASSWORD
# 	$(error VSPHERE_PASSWORD variable is undefined)
# endif

check-env-VSPHERE_USERNAME:
# ifndef VSPHERE_USERNAME
# 	$(error VSPHERE_USERNAME variable is undefined)
# endif

check-env-RHSM_PASS:
# ifndef RHSM_PASS
# 	$(error RHSM_PASS variable is undefined)
# endif
