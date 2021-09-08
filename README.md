# service

## ntp_server部署
1.配置hosts文件
```
[ntp_server]
192.168.56.14

[all:vars]
ansible_ssh_port=10000
ansible_ssh_user=root
ansible_become=yes
ansible_become_method=sudo
ansible_become_user=root
```
2.执行 ntp_server playbooks
```
[root@localhost service]# ansible-playbook playbooks/ntp_server.yml  
```
3.验证是否成功(必须使用ntpstat命令进行验证，出现同步公网地址后表示成功)
```
[root@linux-node14 ~]# ntpstat   
synchronised to NTP server (120.25.115.20) at stratum 3 
   time correct to within 962 ms
   polling server every 64 s
```
