#!/bin/bash
# Prepare RHEL 8 template for vSphere cloning
# @author Olivier de PERTAT
# @website https://www.linkedin.com/in/olivier-de-pertat-27985822/

## Set required environment variables
export RHSM_USER
export RHSM_PASS
export PKI_CERTS
export CLOUDADMIN_NAME
export CLOUDADMIN_SSHKEY
export VMWARE_GUEST_SCRIPT

set -x

## Disable IPv6
echo ' - Disabling IPv6 in grub ...'
sudo sed -i 's/quiet"/quiet ipv6.disable=1"/' /etc/default/grub
sudo grub2-mkconfig -o /boot/efi/EFI/redhat/grub.cfg &>/dev/null

## Register with RHSM
echo ' - Registering with RedHat Subscription Manager ...'
sudo subscription-manager register --username $RHSM_USER --password $RHSM_PASS --auto-attach &>/dev/null

## Apply updates
echo ' - Applying package updates ...'
#sudo yum update -y -q &>/dev/null

## Install core packages
echo ' - Installing additional packages ...'
sudo yum install -y -q ca-certificates &>/dev/null
sudo yum install -y -q cloud-init perl python3 python-pip openssl cloud-utils-growpart &>/dev/null

## Adding additional repositories
echo ' - Adding repositories ...'
#sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo &>/dev/null

## Cleanup yum
echo ' - Clearing yum cache ...'
sudo yum clean all &>/dev/null

## Configure SSH server
echo ' - Configuring SSH server daemon ...'
sudo sed -i '/^PermitRootLogin/s/yes/no/' /etc/ssh/sshd_config
sudo sed -i "s/.*PubkeyAuthentication.*/PubkeyAuthentication yes/g" /etc/ssh/sshd_config
sudo sed -i "s/PasswordAuthentication no/PasswordAuthentication yes/g" /etc/ssh/sshd_config

## Create Ansible user
echo ' - Creating local user for Ansible integration ...'
sudo groupadd ${CLOUDADMIN_NAME}
sudo useradd -g ${CLOUDADMIN_NAME} -G wheel -m -s /bin/bash ${CLOUDADMIN_NAME}
echo ${CLOUDADMIN_NAME}:$(openssl rand -base64 14) | sudo chpasswd
sudo mkdir /home/${CLOUDADMIN_NAME}/.ssh
echo ${CLOUDADMIN_SSHKEY} >> /home/${CLOUDADMIN_NAME}/.ssh/authorized_keys
sudo chown -R ${CLOUDADMIN_NAME}:${CLOUDADMIN_NAME} /home/${CLOUDADMIN_NAME}/.ssh
sudo chmod 700 /home/${CLOUDADMIN_NAME}/.ssh
sudo chmod 600 /home/${CLOUDADMIN_NAME}/.ssh/authorized_keys
echo "${CLOUDADMIN_NAME} ALL=(ALL:ALL) NOPASSWD: ALL" |  tee /etc/sudoers.d/${CLOUDADMIN_NAME}

## Install trusted SSL CA certificates
echo ' - Installing trusted SSL CA certificates ...'
cd /etc/pki/ca-trust/source/anchors
echo $PKI_CERTS
for cert in $PKI_CERTS
do
    echo "   -> Installig certificate: $cert"
    sudo wget --no-check-certificate $cert
    echo "   -> Certificate downloaded $cert"
done
echo "   -> update-ca-trust extract"
sudo update-ca-trust extract

## Configure cloud-init
echo ' - Installing cloud-init ...'
sudo touch /etc/cloud/cloud-init.disabled
sudo sed -i 's/^ssh_pwauth:   0/ssh_pwauth:   1/g' /etc/cloud/cloud.cfg
sudo sed -i -e 1,3d /etc/cloud/cloud.cfg
sudo sed -i "s/^disable_vmware_customization: false/disable_vmware_customization: true/" /etc/cloud/cloud.cfg
sudo sed -i "/disable_vmware_customization: true/a\\\nnetwork:\n  config: disabled" /etc/cloud/cloud.cfg
sudo sed -i "s@^[a-z] /tmp @# &@" /usr/lib/tmpfiles.d/tmp.conf
sudo sed -i "/^After=vgauthd.service/a After=dbus.service" /usr/lib/systemd/system/vmtoolsd.service
sudo sed -i '/^disable_vmware_customization: true/a\datasource_list: [OVF]' /etc/cloud/cloud.cfg
sudo cat << RUNONCE > /etc/cloud/runonce.sh
#!/bin/bash
# Runonce script for cloud-init on vSphere

## Enable cloud-init
sudo rm -f /etc/cloud/cloud-init.disabled
## Execute cloud-init
sudo cloud-init init
sleep 20
sudo cloud-init modules --mode config
sleep 20
sudo cloud-init modules --mode final
## Mark cloud-init as complete
sudo touch /etc/cloud/cloud-init.disabled
sudo touch /tmp/cloud-init.complete
sudo crontab -r
RUNONCE
sudo chmod +rx /etc/cloud/runonce.sh
echo "$(echo '@reboot ( sleep 30 ; sh /etc/cloud/runonce.sh )' ; crontab -l)" | sudo crontab -
echo ' - Installing cloud-init-vmware-guestinfo ...'
echo " foo: $VMWARE_GUEST_SCRIPT"
curl -o vmware-guest-script.sh $VMWARE_GUEST_SCRIPT -s
cat vmware-guest-script.sh | sudo sh - &>/dev/null
echo " foo2"

## Setup MoTD
echo ' - Setting login banner ...'
BUILDDATE=$(date +"%Y-%m-%d")
RELEASE=$(cat /etc/redhat-release)
sudo cat << ISSUE > /etc/issue
CloudEngine Template

$RELEASE (Built - $BUILDDATE)

ISSUE
rm -f /etc/motd
sudo ln -sf /etc/issue /etc/motd
sudo ln -sf /etc/issue /etc/issue.net

## Unregister from RHSM
echo ' - Unregistering from Red Hat Subscription Manager ...'
sudo subscription-manager unsubscribe --all &>/dev/null
sudo subscription-manager unregister &>/dev/null
sudo subscription-manager clean &>/dev/null

## Final cleanup actions
echo ' - Executing final cleanup tasks ...'
if [ -f /etc/udev/rules.d/70-persistent-net.rules ]; then
    sudo rm -f /etc/udev/rules.d/70-persistent-net.rules
fi
sudo rm -rf /tmp/*
sudo rm -rf /var/tmp/*
sudo truncate -s 0 /etc/machine-id
sudo rm -f /var/lib/dbus/machine-id
sudo ln -s /etc/machine-id /var/lib/dbus/machine-id
sudo cloud-init clean --logs --seed
sudo rm -f /etc/ssh/ssh_host_*
if [ -f /var/log/audit/audit.log ]; then
    sudo cat /dev/null > /var/log/audit/audit.log
fi
if [ -f /var/log/wtmp ]; then
    sudo cat /dev/null > /var/log/wtmp
fi
if [ -f /var/log/lastlog ]; then
    sudo cat /dev/null > /var/log/lastlog
fi

echo ' - Resetting Build User adlere'
echo adlere:$(openssl rand -base64 14) | sudo chpasswd

echo ' - Configuration complete'