juju upgrade-charm --force-units contrail-agent --path ./tf-charms/contrail-agent
juju config contrail-agent image-tag=master.1188 kernel-hugepages-2m=1024
juju run-action contrail-agent/0 --wait upgrade