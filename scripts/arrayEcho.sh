nodes=(noden19 noden20 nodei34 nodec9 nodec61)
ctrl_ips=(192.168.40.19 192.168.40.20 192.168.40.34 192.168.40.9 192.168.40.61)
mgmt_ips=(192.168.30.19 192.168.30.20 192.168.30.34 192.168.30.9 192.168.30.61)

for (( i=0; i<${#nodes[@]}; i++ ))
do
  locals[$i]="127.0.1.1 ${nodes[$i]}.maas ${nodes[$i]}"
  host_specific[$i]="${ctrl_ips[$i]} ${nodes[$i]}.maas ${nodes[$i]}"
  echo ${locals[$i]}
  echo ${host_specific[$i]}
done


