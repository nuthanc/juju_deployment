#n20_status=$(juju status|grep noden20)
#n19_status=$(juju status|grep noden20)

while [[ ${n20_status} != *"Deployed"* ]] && [[ ${n19_status} != *"Deployed"* ]]; do
	echo "Deploying"
	n20_status=$(juju status|grep noden20)
	n19_status=$(juju status|grep noden20)
	sleep 5
done
