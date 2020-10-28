set -x
juju add-model default
juju model-config default-space=mgmt
# git pull in tf-charms
juju deploy ./bundle_multi_ha.yml && bash scripts/status.sh && python3 scripts/etc-hosts.py
