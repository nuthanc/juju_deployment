ssh ubuntu@noden20 "sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config;sudo systemctl restart sshd"
