import subprocess
import os

nodes = ("noden19", "noden20", "nodec9", "noden29", "nodei34")
mgmt_ips = ("192.168.30.19", "192.168.30.20", "192.168.30.9", "192.168.30.29", "192.168.30.34")
hosts = []
commands = [
  "sudo su",
  "passwd root",
  "sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/' -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config"
]

for ip in mgmt_ips:
    os.system(f'ssh-keygen -f "/root/.ssh/known_hosts" -R "{ip}"')
    hosts.append(f"ubuntu@{ip}")

command = 

def execute_cmd_on_remote(i):
  ssh = subprocess.Popen(["ssh", "%s" % hosts[i], commands[i]],
                          shell=False,
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)
  result = ssh.stdout.readlines()
  err = ssh.stderr.readlines()
  # print(result)
  print(err)

def ssh_sed(machine='all'):
  if machine == 'all':
    for i in range(len(nodes)):
      execute_cmd_on_remote(i)
  else:
    execute_cmd_on_remote(machine)


host_mapping()
mach_specific_sed_cmd()
# By default on all machines if no parameter is specified
ssh_sed(machine=1) 
ssh_sed(machine=3) 
ssh_sed(machine=4) 
