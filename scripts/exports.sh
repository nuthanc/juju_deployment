juju_n20_ip=`juju status|grep noden20|awk '{print $3}'`
juju_n19_ip=`juju status|grep noden19|awk '{print $3}'`

export n20=juju_n20_ip
export n19=juju_n19_ip

echo "Rembember this needs to be sourced"