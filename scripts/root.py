import subprocess
import sys
import os


def execute_cmd_on_remote():
  ssh = subprocess.Popen(["ssh", "ubuntu@192.168.30.19"],
                          shell=False,
                          stdout=subprocess.PIPE,
                          stderr=subprocess.PIPE)
  import pdb;pdb.set_trace()
  result = ssh.stdout.readlines()
  err = ssh.stderr.readlines()
  # print(result)
  print(err)


execute_cmd_on_remote()

