juju run-action contrail-controller/leader upgrade-ziu
juju config contrail-agent image-tag=master.1169 kernel-hugepages-2m=1024

juju config contrail-analytics image-tag=master.1169 
juju config contrail-analyticsdb image-tag=master.1169
juju config contrail-openstack image-tag=master.1169
juju config contrail-controller image-tag=master.1169

juju run-action contrail-agent/0 upgrade

# According to Alexey only the below command is sufficient
juju config contrail-agent image-tag=master.1169 kernel-hugepages-2m=1024
