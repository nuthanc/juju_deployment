n20_status=$(juju status|grep noden20)
n29_status=$(juju status|grep noden29)
i34_status=$(juju status|grep nodei34)

while [[ ${n20_status} != *"Deployed"* ]] || [[ ${n29_status} != *"Deployed"* ]] || [[ ${i34_status} != *"Deployed"* ]]; do
	echo "Deploying"
	n20_status=$(juju status|grep noden20)
	n29_status=$(juju status|grep noden29)
	i34_status=$(juju status|grep nodei34)
	echo $n20_status
	echo $n29_status
	echo $i34_status
	sleep 5
done
