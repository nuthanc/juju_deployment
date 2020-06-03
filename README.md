# Juju MAAS deployment

### Topology

![alt text](./topology.png)

* In this example, 3 baremetal machines are used:
  * 1 Orchestrator
  * 1 Controller
  * 1 Compute
* Also 2 interfaces are used:
  * MAAS-mgmt for MAAS to communicate with the servers
  * Control data for post-deployment traffic within the cluster

### Setup MAAS and Juju

```bash
sudo apt-get install software-properties-common 
sudo add-apt-repository --yes --no-update ppa:maas/2.6 
sudo apt update 
sudo export DEBIAN_FRONTEND=noninteractive
# The above is for preventing prompt that asks to restart services
sudo apt install maas -y
dpkg-reconfigure maas-region-controller 
ssh-keygen 
maas createadmin 
maas-region apikey --username=admin > maas.admin.key 
maas login admin http://localhost:5240/MAAS/api/2.0 - < maas.admin.key
 
apt install bridge-utils -y 
apt install snapd -y 
snap install juju --classic
# Install juju again if you get hook error
# Close existing terminal and open new terminal if juju is not added in PATH 

```

### Bridge on MAAS node

* Define a bridge on the MAAS node. Add the private management port and bridge configurations. Typical contents of /etc/netplan/*.yaml are shown below; modify this accordingly.

```bash
network:
  version: 2
  renderer: networkd

  ethernets:
    eno1:
      dhcp4: no
      addresses: [10.204.216.194/24]
      gateway4: 10.204.216.254
      nameservers:
        addresses: [10.204.217.158, 8.8.8.8]
    eno2:
      dhcp4: no
      dhcp6: no
    enp94s0f0:
      dhcp4: no
      dhcp6: no

  bridges:
    br1:
      interfaces: [eno2]
      addresses: [192.168.30.18/24]
      gateway4: 192.168.30.254
      nameservers:
        addresses: [10.204.217.158, 8.8.8.8]
      parameters:
        stp: false
        forward-delay: 0
      dhcp4: no
      dhcp6: no
    br2:
      interfaces: [enp94s0f0]
      addresses: [192.168.40.18/24]
      gateway4: 192.168.40.254
      nameservers:
        addresses: [10.204.217.158, 8.8.8.8]
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
  * Gateway: 192.168.30.18
* For the 192.168.40.0/24 subnet, give 192.168.40.254 as Gateway
* For netronome deployment, give compute tag the following options
```sh
maas admin tags create name='compute' comment='kernel options' kernel_opts='intel_iommu=on iommu=pt default_hugepagesz=2M hugepagesz=2M hugepages=8192'
```

### Virsh configuration

* Add juju and neutron VMs by following the instructions given below
* Libvirt creates a default DHCP enabled network for guests upon installation with you can see by running sudo virsh net-list
```bash
sudo apt install bridge-utils qemu-kvm libvirt-bin
```
* Since we don’t need it, let’s delete it by running:
```bash
sudo virsh net-destroy default  
sudo virsh net-undefine default
```
* Instead, we will be using bridged networking with our existing bridge (br1) created during the previous step, along with the necessary minimal configuration.
* Create a net-default.xml file with the following content:
```bash
<network>  
    <name>default</name>  
    <forward mode="bridge" />  
    <bridge name="br1" />  
</network>
```
* Add it to virsh:
```bash
virsh net-define net-default.xml
virsh net-autostart default  
virsh net-start default
```
* Next, create a storage pool for the VMs. By default, none are defined, so let’s confirm and configure a directory-based pool:
```bash
virsh pool-define-as default dir - - - - "/var/lib/libvirt/images"  
virsh pool-autostart default  
virsh pool-start default
```
* Routing configurations:
  * We will enable NATing and routing on our MAAS pod only, and all the other pods will be using MAAS as a gateway. Here eno1 is the lab mgmt interface
  ```bash
  /sbin/iptables -t nat -A POSTROUTING -o eno1 -j MASQUERADE
  /sbin/iptables -A FORWARD -i eno1 -o br1 -m state --state RELATED,ESTABLISHED -j ACCEPT
  /sbin/iptables -A FORWARD -i br1 -o eno1 -j ACCEPT
  sudo sysctl -w net.ipv4.ip_forward=1
  ```
* Pod configuration:
  * For MAAS to query and manage machines as pods, both remotely and the local host, we will be using secure communication for libvirt over SSH.
  ```bash
  sudo mkdir -p ~maas
  sudo chown maas:maas ~maas
  sudo chsh -s /bin/bash maas
  sudo -u maas ssh-keygen
  sudo -u maas -i ssh-copy-id root@192.168.30.18
  sudo -u maas virsh -c qemu+ssh://root@192.168.30.18/system list --all
  ```
* Go back to the MAAS UI to add the local machine as a pod:
  * Select the “Pod” tab, and click “Add Pod” on the top right corner. Provide the requested info: - Name: MAAS Pod - Pod type: Virsh (virtual systems) - Virsh address: qemu+ssh://ubuntu@192.168.30.18/system
* Compose 2 VMs under Pod created in the above step, select default pool and Tag them juju and neutron VM 
* Add machines in MAAS webUI and tag them appropriately
  * While adding give BMC IP and MAC for Power configuration
  * Configure the control data interface(192.168.40.0/24) in controller, compute and neutron to auto-assign or static assign ip

### Bootstrap the JUJU controller

juju add-cloud MYMAAS --local\
Cloud Types \
  *maas \
  manual \
  openstack \
  oracle \
  vsphere \
API endpoint: \
http://10.204.216.194:5240/MAAS

juju add-credential mymaas \
Enter credential name: creds \
region: default \
aouth: (From ui under maas username) 

juju bootstrap --debug --no-gui --bootstrap-constraints tags=juju mymaas myjujucontroller --bootstrap-series=bionic

juju deploy ./bundle_multi.yml

### Possible failures and how to debug them:

* If you encounter hook error during installation of juju
  * Install juju again 
* If juju is not added in path during installation
  * Try closing the current session and open a new session
  * If the above doesn't work, then manually add PATH in ~/.bashrc
* If you get instance deployed but not started, try giving timeout
  * juju bootstrap --debug --no-gui --bootstrap-constraints tags=juju mymaas myjujucontroller --bootstrap-series=bionic --config bootstrap-timeout=1300
* If in case MAAS UI is inaccessible
  * sudo apt install maas --reinstall
* API server connection down with Keystone issue
  * Add controller and compute's ip in /etc/hosts in all the nodes
  * Restart the config api
* Failed to query node's BMC
  * Replace localhost with Juju jumphost ip in /etc/maas/rackd.conf
  * Note: Juju jumphost is node on which MAAS and juju are installed
* Hash Mismatch Issue
```
sudo rm -rf /var/lib/apt/lists/*
sudo apt-get update -o Acquire::CompressionTypes::Order::=gz
sudo apt-get update && sudo apt-get upgrade
```
* Cannot edit physical interface in gui 
  * Workaround mentioned in this link: https://bugs.launchpad.net/maas/+bug/1864241