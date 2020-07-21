ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.30.20"
ssh-keygen -f "/root/.ssh/known_hosts" -R "192.168.30.19"

juju_n20_ip=`juju status|grep noden20|awk '{print $3}'`
juju_n19_ip=`juju status|grep noden19|awk '{print $3}'`

export n20=$juju_n20_ip
export n19=$juju_n19_ip

export n20_local="127.0.1.1 noden20.maas noden20"
export n19_local="127.0.1.1 noden19.maas noden19"
export n20_dns="${n20} noden20.maas noden20"
export n19_dns="${n19} noden19.maas noden19"
export n20_dns_ctl="192.168.40.20 noden20.maas noden20"
export n19_dns_ctl="192.168.40.19 noden19.maas noden19"

echo "ssh ubuntu@${n20} \"sudo sed -i -e '/${n20_local}/i ${n20_dns}' -e '/${n20_local}/i ${n19_dns}' /etc/hosts\"" > 20remote.sh
echo "ssh ubuntu@${n20} \"sudo sed -i -e '/${n20_local}/i ${n20_dns_ctl}' -e '/${n20_local}/i ${n19_dns_ctl}' /etc/hosts\"" >> 20remote.sh
echo "ssh ubuntu@${n19} \"sudo sed -i -e '/${n19_local}/i ${n19_dns}' -e '/${n19_local}/i ${n20_dns}' /etc/hosts\"" > 19remote.sh
echo "ssh ubuntu@${n19} \"sudo sed -i -e '/${n19_local}/i ${n19_dns_ctl}' -e '/${n19_local}/i ${n20_dns_ctl}' /etc/hosts\"" >> 19remote.sh

bash 20remote.sh
bash 19remote.sh

# Create alias for this like alias e="source /root/juju_deployment/scripts/exports.sh"  

# Add below in ~/.ssh/config to avoid Host key checking
# Host *
#     StrictHostKeyChecking no
192.168.30.20 noden20.maas noden20
192.168.30.19 noden19.maas noden19
192.168.30.9 nodec9.maas nodec9
192.168.30.60 nodeg20.maas nodeg20
192.168.30.61 nodec61.maas nodec61
