                                              Centos/RHEl/Fedora源码安装指南
CMS管理端安装
首先你要在本站下载源码到你的机器
1、以root用户登录，安装socat（socat作用是在两个流之间建立双向的通道）：
yum install socat
提示：安装socat需要你导入一个第三方库epel，这个网上有很多教程，我在这里就不再说明了。
2、可以新建一个用户，例如opensource，以该用户登录，将下载的源码包移到该用户根目录下，并赋予opensource用户权限：
sudo chown -R opensource:opensource Centos-RHEL-Fedora
mv   Centos-RHEL-Fedora convirt
2、安装依赖关系
sudo ./convirt/install/cms/scripts/install_dependencies
提示：当需要mysql的root凭据时，输入‘convirt’（以后可以修改）
3、设置InnoDB缓冲和内存池
在Mysql配置文件/etc/my.cnf  [mysqld]下面。请添加跟随的两行：
   innodb_buffer_pool_size=1G
   innodb_additional_mem_pool_size=20M
然后重启mysql：
/etc/init.d/mysqld restart
4、设置TurboGears环境
./convirt/install/cms/scripts/setup_tg2
5、修改development.ini文件中mysql的root密码：
vi  src/convirt/web/convirt/development.ini
 
例如在url中, username = root, password = convirt, server=localhost, database port = 3306 
  和数据库名称是convirt
sqlalchemy.url=mysql://root:convirt@localhost:3306/convirt?charset=utf8
修改之后将文件保存。
6、设置convirt：
./convirt/install/cms/scripts/setup_convirt
7、验证convirt的安装
cd convirt
./convirt-ctl start
提示：开启convirt服务前，请确认你的8081端口是开着的
8、在浏览器导航栏输入http://ip:8081访问convirt控制台，默认登录帐号和密码都是admin
9、停止convirt服务：
cd convirt
./convirt-ctl stop
10、其他设置：
防火墙6900：6999端口你也应该打开（这是为VNC的端口），切换到root账户执行如下命令：
iptables -I INPUT -m state --state NEW -p tcp --dport 6900:6999 -j ACCEPT
节点安装
1、复制/convirt/install/managed_server/scripts到节点服务器
2、进入目录，执行下面两条命令：
./convirt-tool install_dependencies（安装依赖）
./convirt-tool setup（进行设置）
执行上面两条命令前你还可以通过下面命令查看你的平台：
./convirt-tool --detect_only setup
如果你的平台是Xen 4.0 /SLES 11/SLES 11 SP1，还需执行下面命令：
./convirt-tool --xen_ssl --all setup
为Xen，你还应该指定默认的内存：
./convirt-tool --dom0_mem 1024 setup
3、如果你开启了防火墙，还需要开放如下端口：
For Both: ssh port (usually 22)
For Xen : TCP port 8002 to allow migration, 8006 to allow ConVirt to talk to Xend Server.
Fox KVM : TCP ports 8002 to 8012 for migration.
4、现在你可以添加节点到CMS管理端了。
VNC设置
1. 登陆CMS服务器，生成公钥和密钥；
   ssh-keygen -t rsa -f ~/.ssh/cms_id_rsa（在这里可以输入秘密，也可以不用密码，如果输入了密码就将密码添加到代理上去）
   chmod 0600 ~/.ssh/cms_id_rsa*
2. 将公钥复制到被登陆的服务器上
   scp ~/.ssh/cms_id_rsa.pub root@被管理服务器的IP:/root/.ssh/vnc_proxy_id_rsa.pub
   ssh root@被管理服务器的IP  (需要输入登陆密码)
   cat ~/.ssh/vnc_proxy_id_rsa.pub >> ~/.ssh/authorized_keys
3. 将私钥添加到代理中去（CMS服务器）
   eval `ssh-agent -s`
   ssh-add ~/.ssh/cms_id_rsa（需要输入生成文件是输入的密码）
4. 启动convirt
   ./convirt-ctl start (不需先执行第3步，再执行第4步)


