import paramiko
import os

nodes = ("noden19", "noden20", "nodec9", "noden29", "nodei34")
mgmt_ips = ("192.168.30.19", "192.168.30.20", "192.168.30.9", "192.168.30.29", "192.168.30.34")

commands = [
  "sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/' -e 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config",
  "sudo systemctl restart sshd"
]

for ip in mgmt_ips:
    os.system(f'ssh-keygen -f "/root/.ssh/known_hosts" -R "{ip}"')


def execute_cmd_on_remote(i):
  client = paramiko.SSHClient()
  try:
    # k = paramiko.RSAKey.from_private_key_file('~/.ssh/id_rsa')
    client.load_system_host_keys()
    client.set_missing_host_key_policy(paramiko.AutoAddPolicy())
    client.connect(hostname=mgmt_ips[i], username='ubuntu')
  except:
    print("[!] Cannot connect to the SSH Server")
    exit()
  
  for command in commands:
    print("="*50, command, "="*50)
    stdin, stdout, stderr = client.exec_command(command)
    # import pdb;pdb.set_trace()
    print(stdout.read().decode())
    err = stderr.read().decode()
    if err:
        print(err)
  client.close()

def ssh_sed(machine='all'):
  if machine == 'all':
    for i in range(len(nodes)):
      execute_cmd_on_remote(i)
  else:
    execute_cmd_on_remote(machine)


# By default on all machines if no parameter is specified
ssh_sed(machine=1) 
# ssh_sed(machine=3) 
# ssh_sed(machine=4) 
