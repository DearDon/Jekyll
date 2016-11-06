---
layout: post
title: hadoop分布式集群搭建
date: 2016-09-17
categories: 折腾折腾
tags: Hadoop Tofinish
---
#### <strong>History:</strong>
* <em>2016-09-17</em>:简单记录Hadoop的安装流程及遇到的问题<br>
* <em>2016-09-20</em>:修正ip设置错误和部分描述<br>

#### <strong>Background:</strong>
Hadoop已经火了很久了，自己也对它也有好奇心挺久了，记得因为它自己才正式接触学习的java(mapreduce框架是基于Java的)。<br>
看了一些资料后，为了更直观地体验一下hadoop的集群能力，决定在自己的pc上安装试一下。为了模拟真实的分布式环境，用VirtualBox装了３个ubuntu10.04的32位系统，并在该环境下装了hadoop-2.5.2。由于hadoop要求相对较新的java环境，因此安装了jdk1.7.0_79。<br>
下面安装过程基于自己的实际经历，亲测有效，但其它环境无法保证。

#### <strong>Content:</strong>
对分布式hadoop具体的安装可以从系统搭建，ssh,java,hadoop几方面分为４步：

<strong>一.搭建用于安装hadoop的系统环境</strong><br>

<strong>1.利用虚拟机建立三个节点:</strong><br>
由于要实现真分布式的hadoop安装(集群中结点不止一个)，需要先搭建好集群环境。当然真实的集群肯定是不同的物理机，同时利用各结点的计算能力，才是分布式的作用。这里因为只是为了体验，就直接在自己pc上配合虚拟机来搭环境了。

利用VirtualBox在同一台pc上安装了三个ubuntu10.04的虚拟机系统，具体怎么装就不多说了，可以自己去找VirtualBox的资料。用一台来作master节点，另两台作为slave。设置主机名分别为master-desktop，slave1-desktop, slave2-desktop(合理的主机名可以更直观地区分各节点，且之后ssh时用主机名也比ip更方便，且避免配置出现hardcode)。三台机器的用户名要设置为相同(原因除了通用各节点文件权限，还有ssh免密登陆，总之hadoop有此要求)，如都为hadoop。

<strong>2.实现虚拟机互连:</strong><br>
由于是虚拟系统，有个问题要解决——各节点间的通信。刚装好时默认情况各节点是不互连的，我们可以通过将virtualbox的网卡设置为桥接方式来使其互通。如果虚拟机已经设置了NAT用来连外网，为了不影响上外网功能，可以新增虚拟网卡(VirtualBox的网络设置时自带最多4个虚拟网卡)。设置桥接方式的虚拟网卡时将网卡设置为有线的，并自行随意设置一个mac地址(如080027039F60)，Ipv4的地址设置为自动获取。但要注意mac和IPV4地址不能相同冲突。<br>
<strong>注意:</strong>要在系统的网络连接时确保上桥接网卡能成功连上，有时候自动分配IP不成功，就可以尝试手动分配IP。手动设置IP为合法的内网段地址，但要注意各机器的IP在同一网段(如10.133.24.235, 10.133.24.236...)，且不相同，掩码按通常的设就行(255.255.255.0)，网关设置无所谓(可设为10.133.24.1)，因为我们不需要通过它连外网。再尝试连接，一定要保证我们设置的桥接网卡能连接，各节点间能用桥接网卡的ip地址相互ping通。不然不能互相访问节点，分布式也就无从谈起了。

为了之后描述方便，假设三个节点的IP对应如下：

    Hostname        IP
    master-desktop  10.133.24.235	
    slave1-desktop  10.133.24.228	
    slave2-desktop  10.133.24.229	


<strong>二.安装ssh,并设置免密登陆</strong><br>
有了能实现相互ping通的三个节点机后，接下来要利用ssh来实现互连远程控制(这也是master控制slave的实现方式)。由于ssh默认是要输入帐户密码的，为了满足hadoop的频繁ssh操作。hadoop要求各节点间能免密直接ssh。

<strong>1.安装ssh:</strong><br>
大部分的Linux系统应该都是有预装ssh的。若没有，在ubuntu下直接 sudo apt-get install openssh-server（也可install ssh)即可。可用sudo ps -e|grep ssh看是否有sshd服务启动，如无，用sudo service ssh start启动

<strong>2.配置主机名代替IP:</strong><br>
标准的ssh方式是`$ ssh $username@$hostaddress`，然后根据提示输入密码。<br>
由于前面我们已经设置了各节点的用户名均相同(hadoop),因此我们之后的ssh都不用指定远程登陆的用户名(hadoop)，程序会默认用本地的用户名(hadoop)，我们只要给定节点地址$hostaddress就行了,命令简化为`$ ssh $hostaddress`。<br>
由于ip地址可能不同开关机后会变，这样配置文件里都会需要更改，不利于维护。我们设置主机名代替IP作为连接时的$hostaddress。对三个节点，分别修改/etc/hosts文件，添加如下内容:

    10.133.24.235	master-desktop
    10.133.24.228	slave1-desktop
    10.133.24.229	slave2-desktop

并在/etc/hostname内容修改为对应节点的主机名,如节点master-desktop将hostname文件内容改为master-desktop，其它节点同理修改。现在ssh命令进一步简化为了`$ ssh $hostname`，但仍然要输入密码。

<strong>3.配置用公私钥代替密码登陆:</strong><br>
利用公私钥对，可实现数字签名，身份验证等功能，以下我们设置用其做免密登陆。<br>
a.先生成公密钥对，在机器A的~/.ssh目录下输入`ssh-keygen -t rsa`，即可生成私钥文件d_rsa和公钥文件id_rsa.pub，其中-t 后表示加密算法，除rsa外，dsa也是常用的算法。

b.然后将id_rsa.pub的内容(内容较长，小心复制)追加到机器B的~/.ssh目录下authorized_keys的文件中(要求用户名相同，若该文件不存在可新建)。则从机器A上ssh到该机器B时，A会用秘钥加密验证信息，B则用authorized_keys中的每个公钥一一测试能否解密，解密成功，则说明A是被授权的免密登陆机器，可直接免密登陆B。这里的A和B可以是同一机器，并通过ssh localhost尝试免密登陆本机来验证ssh配置正确否。

c.hadoop要求的ssh流程不仅包括master->slave，还有master->master(但没有slave->master或slave->slave)。因此要求master上生成rsa的公私钥后，将id_rsa.pub内容不仅要添加到到slave1,slave2的authorized_keys里，还要加到master自己的authorized_keys中。


至此，为装hadoop而做的免密ssh就设置完了，命令变成了只要输入`$ ssh $hostname`，无需密码即可快速登陆远程机。

<strong>三.安装并设置Java环境</strong><br>
该安装对三个节点完全相同，为了保险起见，最好集郡里各主机上的hadoop,java安装路径完全一致。。Java的安装比较简单，有可能系统还自带了。若没有，直接上网下载对应系统的编译后tar包，版本最后不要太旧。在此只简单说明(不会的直接上网找，一大把)。将jdk的tar.gz包解压到安装目录(假设为/usr/local/jdk1.7.0_79)，设定PATH，JAVA_HOME,JRE_HOME,CLASSPATH环境变量即可，具体为在.bashrc中加入以下内容:

    export JAVA_HOME=/usr/local/jdk1.7.0_79
    export JRE_HOME=$JAVA_HOME/jre
    export CLASSPATH=.:$JAVA_HOME/lib:$JRE_HOME/lib:$CLASSPATH
    export PATH=$PATH:$JAVA_HOME/bin:$JRE_HOME/bin

可用java --version检验是否装成功

<strong>四.安装hadoop及配置</strong><br>
<strong>1.下载安装hadoop</strong><br>
该安装对三个节点完全相同。可直接搜索下载对应系统编译后tar包，这样不用重编译。安装很简单，直接将tar.gz解压到安装目录(假设/home/hadoop/hadoop-2.5.2)，然后.bashrc里设定如下环境变量。

    export HADOOP_HOME=~/hadoop-2.5.2
    export PATH=$PATH:$HADOOP_HOME/bin:$HADOOP_HOME/sbin
    export HADOOP_CONF_DIR=$HADOOP_HOME/etc/hadoop

<strong>2.hadoop配置:</strong><br>
主要有三类文件要配置, 有的文件(如slaves)只需要在master上配置，slave节点中不需要。但是安全起见，建议全部配置，保持master和slave节点的hadoop安装配置完全一致。<br>
<strong>4个xml文件:core-site.xml,hdfs-site.xml,mapred-site.xml,yarn-site.xml</strong><br>
core-site.xml原文件改为

    <configuration>
        <property>   
        <name>hadoop.tmp.dir</name>   
        <value>/home/hadoop/tmp</value>   
        <description>Abase for other temporary directories.</description>   
        </property>   
        <property>   
        <name>fs.defaultFS</name>   
        <value>hdfs://master-desktop:9000</value>   
        </property>   
        <property>   
        <name>io.file.buffer.size</name>   
        <value>4096</value>   
        </property>   
    </configuration>

hdfs-site.xml原文件改为

    <configuration>
        <property>   
        <name>dfs.nameservices</name>   
        <value>hadoop-cluster1</value>   
        </property>   
        <property>   
        <name>dfs.namenode.secondary.http-address</name>
        <value>master-desktop:50090</value>
        </property>   
        <property>   
        <name>dfs.namenode.name.dir</name>   
        <value>file:///home/hadoop/dfs/name</value>   
        </property>   
        <property>   
        <name>dfs.datanode.data.dir</name>   
        <value>file:///home/hadoop/dfs/data</value>   
        </property>   
        <property>   
        <name>dfs.replication</name>
        <value>2</value>   
        </property>   
        <property>   
        <name>dfs.webhdfs.enabled</name>   
        <value>true</value>   
        </property>   
    </configuration>

mapred-site.xml原文件改为

    <configuration>
        <property>
            <name>mapreduce.framework.name</name>
            <value>yarn</value>
        </property>
        <property>
            <name>mapreduce.jobtracker.http.address</name>
            <value>master-desktop:50030</value>
        </property>
        <property>
            <name>mapreduce.jobhistory.address</name>
            <value>master-desktop:10020</value>
        </property>
        <property>
            <name>mapreduce.jobhistory.webapp.address</name>
            <value>master-desktop:19888</value>
        </property>
    </configuration>

yarn-site.xml原文件改为

    <configuration>
        <property>
            <name>yarn.nodemanager.aux-services</name>
            <value>mapreduce_shuffle</value>
        </property>
        <property>
            <name>yarn.resourcemanager.address</name>
            <value>master-desktop:8032</value>
        </property>
        <property>
            <name>yarn.resourcemanager.scheduler.address</name>
            <value>master-desktop:8030</value>
        </property>
        <property>
            <name>yarn.resourcemanager.resource-tracker.address</name>
            <value>master-desktop:8031</value>
        </property>
        <property>
            <name>yarn.resourcemanager.admin.address</name>
            <value>master-desktop:8033</value>
        </property>
        <property>
            <name>yarn.resourcemanager.webapp.address</name>
            <value>master-desktop:8088</value>
        </property>
    </configuration>

<strong>2个env.sh文件:hadoop-env.sh,yarn-env.sh</strong> <br>
两个文件的最后均添加一行

    export JAVA_HOME=/usr/local/jdk1.7.0_79

<strong>1个slaves文件:slaves</strong> <br>
slaves文件内容改为(若没有，则新建)

    slave1-desktop
    slave2-desktop

老版本还有master文件，2.5.2取消了。

<strong>五.hadoop启动和检验</strong><br>
设置完成后，就可以尝试启动了。正常情况下，所有hadoop操作均只需要在master上进行。

    $ hdfs namenode -format #仅第一次启动时要先格式化文件
    $ start-dfs.sh #启动dfs服务
    $ start-yarn.sh #启动yarn

启动成功后可查看进程`$ jps`
可浏览器访问服务`http://10.0.1.100:50070/`
若要关闭

    stop-dfs.sh
    stop-yarn.sh

#### <strong>Questions:</strong>
搭建过程中可能遇到的一些问题：

<strong>一.不匹配的库的warning</strong><br>
在.bashrc设置环境变量，这一步不是必须的，当有如下问题才需要。启动hadoop时可能出现提示

    Starting namenodes on [OpenJDK 64-Bit Server VM warning: You have loaded library /opt/lib/native/libhadoop.so which might have disabled stack guard. The VM will try to fix the stack guard now.
    It's highly recommended that you fix the library with 'execstack -c <libfile>', or link it with '-z noexecstack'.
    master-desktop]

这是提示有些库不匹配，64-bit java vs 32-bit hadoop and os。这只是一个java的warning,本来不影响hadoop使用，但是该warning输出信息却和之后的主机名重定向到了一起，破坏了合法的主机名(这其实应该算hadoop的bug，这种设计不合理)，因此之后可能报一堆ssh到主机不成功，或主机名异常的问题。在此我们可设置让该warning消息不输出(有人说下面的设置对64操作系统无效，自己是32bit，反正是有效，因此没有再深钻)，在.bashrc 里加上下面设置,千万注意，设置完后，要source一下，不然不会生效。

    export HADOOP_COMMON_LIB_NATIVE_DIR=$HADOOP_HOME/lib/native
    export HADOOP_OPTS="-Djava.library.path=$HADOOP_HOME/lib"

<strong>二.dfs.namenode等配置文件内容错误</strong><br>
当启动时出现类似下面的错误提示时，往往就是那几个配置文件出错了。两个sh文件都是只加入了java的安装路径，主要的配置在xml文件中，问题应该出在那。

    java.io.IOException: Incorrect configuration: namenode address dfs.namenode.servicerpc-address or dfs.namenode.rpc-address is not configured.
    at org.apache.hadoop.hdfs.DFSUtil.getNNServiceRpcAddresses(DFSUtil.java:840)
    at   org.apache.hadoop.hdfs.server.datanode.BlockPoolManager.refreshNamenodes(BlockPoolManager.java:151)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.startDataNode(DataNode.java:745)
    at org.apache.hadoop.hdfs.server.datanode.DataNode.<init>(DataNode.java:278)

该问题最最需要注意的是<xml>标签内的空格不会被忽略，尤其从网上copy时容易出现标签与内容间有多空格的情况:<tag>value</tag>变成<tag> value </tag>。这个问题很隐，要注意。

此外，dfs.namenode就是core-site.xml里的dfs.defaultFS，旧版本里xml是配置为dfs.defaultname，2.5.2已经改为dfs.defaultFS了。

<strong>三.ssh need to configure yes for first time</strong><br>
此外，由于第一次尝试免密登陆时要手动确认(yes)，这在hadoop启动时可能会导致不能自动ssh连接。

因此在启动hadoop前要确保每种要求的连接流程(master->all slaves, 以及尤其容易忘记的master->master)都经过先手动连一次(只要一次就行),并输入yes。

<strong>四.集群的用户名忘记设为一致了</strong><br>
有可能会事先没有设好各节点相同的用户名，这种情况，如果代价不大，安全起见，最好重新搭建。不想重新来，可参考以下方法为免密互联(ssh)创建同名用户——hadoop

1.原用户下sudo useradd hadoop,创建用户名,并用sudo passwd hadoop根据提示为其设置密码(不设置密码不能使用该用户)

2.原用户下在/home目录sudo mkdir hadoop，为该用户创建用户目录，再用sudo chown hadoop hadoop和sudo chgrp hadoop hadoop，将该用户目录所有者和所属用户组改为hadoop(其中hadoop的用户组是在useradd创建用户时默认创建同来的同名组)

3.给hadoop赋予sudo权限,原用户下sudo usermod -a -G admin hadoop(注意!!现在为此的3步均是在原用户下操作，并未用hadoop登陆),

4.为新用户拷贝配置文件.bashrc，由于要使其所有者为hadoop，因此我们改用hadoop登陆,登陆后，打开命令行，会发现命令行环境明显有问题，补全等功能都用不了，这个之后会解决，先将原用户的配置文件.bashrc拷到hadoop用户目录下(/home/hadoop/),并确认其所属者和组均为hadoop

5.继续留在hadoop用户环境下，并设置SHELL由默认的sh变为bash(不改会使tab补全，上下记录和命令提示符显示都有问题),可先用echo $SHELL看当前的SHELL值，然后使用sudo usermod -s /bin/bash hadoop改变其值，改完后，要注销用户并重登陆才能看到效果。

至此，新建的hadoop用户和原始的用户功能基本一样了，可以用于搭建hadoop系统用。
