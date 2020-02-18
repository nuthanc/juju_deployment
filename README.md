# Juju MAAS deployment

### Topology

![alt text](./juju_charms_setup.png)

### Setup MAAS and Juju

sudo apt-get install software-properties-common \
sudo add-apt-repository --yes --no-update ppa:maas/2.6 \
sudo apt update \
sudo apt install maas -y \
apt install bridge-utils -y \
apt install snapd -y \
snap install juju --classic \
dpkg-reconfigure maas-region-controller \
ssh-keygen \
maas createadmin \
maas-region apikey --username=admin > maas.admin.key \
maas login admin http://localhost:5240/MAAS/api/2.0 - < maas.admin.key

### Bridge on MAAS node

* Define a bridge on the MAAS node. Add the private management port and bridge configurations. Typical contents of /etc/netplan/*.yaml are shown below; modify this accordingly.
```bash
network:
  version: 2
  renderer: networkd

  ethernets:
    eno1:
      dhcp4: yes
    eno2:
      dhcp4: no
      dhcp6: no
    enp94s0f1:
      dhcp4: no
      dhcp6: no

  bridges:
    br1:
      interfaces: [eno2]
      addresses: [192.168.30.18/24]
      gateway4: 192.168.30.254
      nameservers:
        addresses: [8.8.8.8]
      parameters:
        stp: false
        forward-delay: 0
      dhcp4: no
      dhcp6: no
    br2:
      interfaces: [enp94s0f1]
      addresses: [192.168.40.18/24]
      gateway4: 192.168.40.254
      nameservers:
        addresses: [8.8.8.8]
      parameters:
        stp: false
        forward-delay: 0
      dhcp4: no
      dhcp6: no
```
netplan generate \
netplan apply

### MAAS WebUI

* Upload to the MAAS webUI under the “admin” tab (top right of MAAS webUI) -> ssh keys \
cat ~/.ssh/id_rsa.pub
* The subnet of the bridge created on the MAAS node will reflect in the MAAS webUI under the “subnets” tab. On the newly created subnet of the bridge (192.168.30.0/24); i.e. the management network:
  * Click on “untagged” and enable DHCP (take action drop down)
  * Define an appropriate subnet range
  * Give the subnet a DNS of 8.8.8.8
* Add juju and neutron VMs by following the instructions in this link:https://maas.io/tutorials/create-kvm-pods-with-maas#2-getting-started
* Tag the juju and neutron VM 
* Add machines in MAAS webUI and tag them appropriately
  * While adding give BMC IP and MAC for Power configuration

### Bootstrap the JUJU controller

juju add-cloud (name) --local\
Cloud Types \
  *maas \
  manual \
  openstack \
  oracle \
  vsphere \
API endpoint: http://(maas-ip-here):5240/MAAS 

juju add-credential  \
Enter credential name: (name) \
region: default \
aouth: (From ui under maas username) 

juju bootstrap --debug --no-gui --bootstrap-constraints tags=juju mymaas myjujucontroller --bootstrap-series=bionic 

juju deploy (give-bundle.yaml-here)