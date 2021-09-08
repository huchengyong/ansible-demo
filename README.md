# service

## yum_server部署
1.配置hosts文件
```
[yum_server]
192.168.56.13

[all:vars]
ansible_ssh_port=10000
ansible_ssh_user=root
ansible_become=yes
ansible_become_method=sudo
ansible_become_user=root
```
2.配置yum变量配置文件
```
[root@localhost service]# vim roles/yum_server/defaults/main.yml 
yum_server_iptables_accept_port:
  - 80
disk_data_name: /dev/sdb
disk_data_dir: /data
yum_data_dir: /data/repo/yum/
```
备注：这里记得检查一下yum-server远程主机是否有/dev/sdb磁盘
3.执行 yum_server playbooks
```
[root@localhost service]# ansible-playbook playbooks/yum_server.yml  
```
备注：执行之前需检查yum-server是否能curl通  124.236.120.248:50001/ctyun 如果不通则无法进行同步
```
[root@linux-node13 ~]# curl 124.236.120.248:50001/ctyun
<html>
<head><title>301 Moved Permanently</title></head>
<body bgcolor="white">
<center><h1>301 Moved Permanently</h1></center>
<hr><center>nginx/1.12.2</center>
</body>
</html>
```

4.验证部署是否成功
```
如果出现一下定时任务则表示成功
[root@linux-node13 ~]# crontab -l
#Ansible: Clean system mem
00 */1 * * * /bin/sh /etc/scripts/clean_mem.sh
#Ansible: Rsync yum ctyun os
10 */2 * * * flock -xn /var/run/pull_yum_rsync.lock -c "/bin/sh /script/pull_yum_rsync.sh &>/dev/null"
```
5.同步文件数据
```
/bin/sh /script/pull_yum_rsync.sh
```



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

## cobbler_server部署（离线包版本）
```
cobbler安装包下载公网地址
wget -c http://124.236.120.248:50001/ctyun/centos-iso/cobbler-offline-2.8.4_210707-1.x86_64.rpm
cobbler安装包下载私网地址(需提前同步YUM)
wget -c http://yum_server_ip/ctyun/centos-iso/cobbler-offline-2.8.4_210707-1.x86_64.rpm
```

## cobbler_server部署（YUM版本）



