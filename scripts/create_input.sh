n20_ip_in_file=`grep -o "CONFIG_API_VIP: .*" contrail_test_input.yaml | awk '{print $2}'`
juju_n20_ip=`juju status|grep noden20|awk '{print $3}'`
kstone_ip_in_file=`grep -o "KEYSTONE_AUTH_HOST: .*" contrail_test_input.yaml | awk '{print $2}'`
juju_kstone_ip=`juju status|grep keystone/|awk '{print $5}'`
n19_ip_in_file=`grep noden19 contrail_test_input.yaml -A 1|grep "ip: .*" -o|awk '{print $2}'`
juju_n19_ip=`juju status|grep noden19|awk '{print $3}'`

# Replace all n20,n19,keystone ips
sed -i -e "s/${n20_ip_in_file}/${juju_n20_ip}/g" \
-e "s/${n19_ip_in_file}/${juju_n19_ip}/g" \
-e "s/${kstone_ip_in_file}/${juju_kstone_ip}/g" contrail_test_input.yaml
