import os

n20_ip = os.getenv('n20')
n19_ip = os.getenv('n19')

if n19_ip and n20_ip:
  print("Write to file sed command here")
else:
  print("Source the exports.sh file first")