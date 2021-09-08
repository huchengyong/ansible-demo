#!/bin/bash

systemctl stop postfix.service
systemctl disable postfix.service
systemctl stop firewalld
systemctl disable firewalld
sed -i '/UseDNS/d' /etc/ssh/sshd_config
echo "UseDNS no" >>/etc/ssh/sshd_config
sed -i '/#Port/d' /etc/ssh/sshd_config
echo "Port 10000" >>/etc/ssh/sshd_config
systemctl restart sshd
mkdir -p /root/.ssh/
chmod 700 /root/.ssh/
chown root.root /root/.ssh
touch /root/.ssh/authorized_keys
chown root.root /root/.ssh/authorized_keys
chmod 600 /root/.ssh/authorized_keys
echo "{{ root_public_key }}" > /root/.ssh/authorized_keys
useradd secure
mkdir -p /home/secure/.ssh
chown secure.secure /home/secure/.ssh
chmod 700 /home/secure/.ssh
touch /home/secure/.ssh/authorized_keys
chown secure.secure /home/secure/.ssh/authorized_keys
chmod 600 /home/secure/.ssh/authorized_keys
sed -i "100a secure  ALL=(ALL)       NOPASSWD:ALL" /etc/sudoers
echo "{{ root_public_key }}" > /home/secure/.ssh/authorized_keys
curl -o /opt/kernel-3.10.0-957.5.1.el7.x86_64.rpm http://{{ cobber_server_host }}/ks_config/7.6/kernel-3.10.0-957.5.1.el7.x86_64.rpm
rpm -ivh /opt/kernel-3.10.0-957.5.1.el7.x86_64.rpm
rm -f /opt/kernel-3.10.0-957.5.1.el7.x86_64.rpm
