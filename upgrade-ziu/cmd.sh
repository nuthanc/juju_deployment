juju run-action contrail-controller/leader upgrade-ziu
juju config contrail-agent image-tag=master-latest
juju config contrail-agent kernel-hugepages-2m=2
juju run-action contrail-agent/0 upgrade
# After 5 minutes
sudo reboot