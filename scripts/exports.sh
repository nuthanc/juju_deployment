juju_n20_ip=`juju status|grep noden20|awk '{print $3}'`
juju_n19_ip=`juju status|grep noden19|awk '{print $3}'`

export n20=$juju_n20_ip
export n19=$juju_n19_ip

export n20_local="127.0.1.1 noden20.maas noden20"
export n19_local="127.0.1.1 noden19.maas noden19"
export n20_dns="${n20} noden20.maas noden20"
export n19_dns="${n19} noden19.maas noden19"

echo 'ssh ubuntu@${n20} sudo sed -i "/$n20_local/i $n20_dns/" /etc/hosts' 
echo 'ssh ubuntu@${n19} sudo sed -i "/$n19_dns/i $n19_dns/" /etc/hosts' 

echo
echo "${n20} noden20.maas noden20"
echo "${n19} noden19.maas noden19"

echo "Rembember this needs to be sourced"
