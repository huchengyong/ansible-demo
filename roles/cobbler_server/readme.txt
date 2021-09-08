作者: liyajin
日期: 2017-05-29

准备环境:
    ansible-2.3.0.0以上版本   (重要)
    关闭selinux服务           (重要)
    关闭networkmanager服务    (重要)
    centos镜像的下载地址      (重要)

使用说明:
    请先配置./hosts文件中要执行安装的主机列表
    然后适当修改 roles/cobbler/vars/main.yml文件的配置，(一定要注意dhcp_start_ip与dhcp_stop_ip这个表示你要分配dhcp地址的范围!)
    修改roles/cobbler/tasks/main.yml文件，选择需要导入的镜像
    执行配置文件: ansible-playbook roles/cobbler_server/site.yml -e "hosts=host"
    example:
    1.  vim ./hosts
        [host]
        192.168.56.11

    2.  vim roles/cobbler/vars/main.yml
        取消注释，并配置相关的参数,需要注意配置centos镜像文件的下载地址
        example:
            vim roles/cobbler_server/vars/main.yml
            cobbler_image_ip_centos6_5: http://vault.centos.org/6.5/isos/x86_64/CentOS-6.5-x86_64-minimal.iso

    3.  vim roles/cobbler/tasks/main.yml
        install_config_cobbler_server.yml   (必选项)
        system_images_import_centos*.yml    (任选项)

    4.  ansible-playbook roles/cobbler_server/site.yml -e "hosts=host"

Web管理:
    你也可以通过打开浏览器输入对应的地址来进行web管理，功能也是很强大的！以下是登录的方式与默认的账户与密码
        https://IP/cobbler_web/
        Account: cobbler
        passwd: cobbler
    example:
        https://192.168.56.11/cobbler_web/

自动化安装系统:
    如果你想针对某个服务器进行定制化的安装系统的化，那么需要做如下配置
    1.首先你得知道对应服务器网卡的MAC地址
    2.然后只需将如下命令对应的参数配置好，执行回车即可
        cobbler system add --name=name --mac=mac --profile=CentOS-7.2-x86_64 --ip-address=ip--subnet=network--gateway=gateway --interface=network_interface_name --static=1 --hostname=hostname --name-servers="dns"
        example:
        cobbler system add --name=10-0-192-11 --mac=7c:a2:3e:e9:d7:30 --profile=CentOS-7.3-x86_64 --ip-address=10.0.192.11--subnet=255.255.255.0 --gateway=10.0.192.1 --interface=enp130s0f0 --static=1 --hostname=10-0-192-11
    3.最后不要忘记使用cobbler sync命令来使得你得设置生效
    cobbler sync
