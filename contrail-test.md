# Contrail Test Instructions

### Configure root password if not configured on Controller and Compute
```bash
sudo su
passwd root
```

### To run a specific test case for the first time within contrail-test directory
```bash
docker run --entrypoint /bin/bash --network=host -it bng-artifactory.juniper.net/contrail-nightly/contrail-test-test:master.1152

PYTHONPATH=./scripts:./fixtures TEST_CONFIG_FILE=contrail_test_input.yaml python -m testtools.run scripts.vm_regression.test_vm_basic.TestBasicVMVN.test_ping_within_vn_two_vms_two_different_subnets
```

### Exports which may be required
```bash
export OS_IDENTITY_API_VERSION=3
export OS_AUTH_URL=http://192.168.7.100:5000/v3 
export OS_USER_DOMAIN_NAME=admin_domain
export OS_USERNAME=admin
export OS_PASSWORD=c0ntrail123
export OS_PROJECT_DOMAIN_NAME=admin_domain
export OS_PROJECT_NAME=admin
export OS_DOMAIN_NAME=admin_domain

# where 192.168.7.100 is keystone ip
```