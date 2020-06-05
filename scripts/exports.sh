juju_n20_ip=`juju status|grep noden20|awk '{print $3}'`
juju_n19_ip=`juju status|grep noden19|awk '{print $3}'`

export n20=$juju_n20_ip
export n19=$juju_n19_ip

export n20_local="127.0.1.1 noden20.maas noden20"
export n19_local="127.0.1.1 noden19.maas noden19"
export n20_dns="${n20} noden20.maas noden20"
export n19_dns="${n19} noden19.maas noden19"

echo "ssh ubuntu@${n20} \"sudo sed -i -e '/${n20_local}/i ${n20_dns}' -e '/${n20_local}/i ${n19_dns}' /etc/hosts\"" > 20remote.sh
echo "ssh ubuntu@${n19} \"sudo sed -i -e '/${n19_local}/i ${n19_dns}' -e '/${n19_local}/i ${n20_dns}' /etc/hosts\"" > 19remote.sh

bash 20remote.sh
bash 19remote.sh

# Create alias for this like alias e="source /root/juju_deployment/scripts/exports.sh"