---
layout: post
title:  centos7搭建访问外网VPN
date: 2015-12-07
categories:  折腾折腾
tags: VPN CentOS7 阿里云 Tofinish
---
####<strong>History:</strong>
*<em>20151207v1</em>: 将内容尽量记录下来</br>
*<em>20160913v2</em>: 修改排版</br>

####<strong>Backgound:</strong>
首先说下在centos7上VPN服务器建立的背景，当时由于买了个阿里ECS，想着不能浪费了，就考虑该在上面折腾点啥，结果就想到了VPN，翻墙的厉器啊！</br>
几经折腾，终于能通过阿里云服务器上网了，可是便宜的服务器是青岛的，还是墙不出去...</br>
冷静之后转念一想，由于自己是移动的网（确实不稳定啊），想想没准用阿里来代理上国内网也能快点呢，当个游戏加速用。但发现自己还是天真了，连上阿里VPN后ping qq.com平均120ms以上、TTL＝50，不连VPN时只用平均70ms、TTL＝47。看来即使是强大的阿里做中转，绕远路还是比较慢啊。所以结果就是瞎折腾了！！ <br>
好了，废话说了一堆，下面说说具体的搭建吧。
申明本文方法是在阿里云ECS上64位centos7搭建可用于访问外网的VPN。

####<strong>Content:</strong>
搭建环节：首先自然是网上搜现成的案例过程，翻不了google，百度一搜还真是一大把，但是基本内容都是一样的（各种互转啊，要找到点新内容就像海里捞针似的）。这里我也就直接转转啦，不过是我实际成功搭建VPN时操作的，还算可靠。<br> 
VPN环境搭建流程同时参考了以下链接：<br>
<http://www.wanghailin.cn/centos-7-vpn/> <br>
<http://www.codeceo.com/article/centos7-vpn-server.html> <br>
<http://bbs.aliyun.com/read/162297.html>  <br>
<http://blog.csdn.net/johnnycode/article/details/45543157> <br>
为什么一个常规的搭建流程要参考这么多呢？因为里面没有一个，同时满足在阿里云ECS服务器，并且是64位centos7系统上用于代理上网的。而且由于是第一次搭建，难免很多不好把握，就多参考对比了。<br>
主要注意阿里是XEN架构的，所以iptables设置外网代理转发时要注意，而且外网网卡是eth1，此外要留意的是centos7与centos6明显的一个不同是默认的防火墙是firewalld，而不是iptables了，但是两者的管理命令都是iptable bla bla...的，然而有简单教程说明如何让centos7也使用iptables作为防火墙的，基本上解决这两点就可以连接VPN了。

####<strong>Questions:</strong>
以下为自己在VPN服务开启成功后遇到的两个问题。

<strong>问题1:服务开启后，客户端能ping通服务器，但是连接报错（好像是651错误，请原谅我记不清了）。</strong> </br>
确定不是密码输错等无语原因后，最大可能是服务器的防火墙把VPN端口挡住了。</br>这时可以先尝试关闭防火墙(假设用的是iptables,可用命令
```$ systemctl stop iptables.service```)，再连接，如果可以连，则说明是防火墙的问题。</br>
此时用命令 ``` $ iptables -A INPUT -p tcp --dport 1723 -j ACCEPT```
打开pptpd默认的1723端口接收客户端的数据，这样打开防火墙也能连接了。</br>
可能有人会问了，那直接不要开防火墙不就可以少折腾很多事了，反正自己服务器也没有什么需要特殊保护的。这个是不行的，因为我们需要VPN来进行上网转发数据，这里要借用iptables的转发功能，所以得开启！！

<strong>问题2:VPN终于正常连接了，但是连上后居然不能上网了。</strong> </br>
如果没连VPN之前网终正常，连了后不能上网。首先一个好消息是本地数据确实如愿通过VPN到了远程服务器，而没有走本地的网络上网，完成了我们代理上网的想法。</br>
但是网络上不了，说明数据到了VPN服务器后就中断了。这时候主要问题在于VPN服务器的配置，首先要参考以上网页说明设置iptables的数据转发规则，注意是XEN架构的，而且外网网卡是eth1。</br>
如果还是代理上不了外网，可是直接SSH到服务器是可以访问外网的，说明仍旧配置有问题。</br>
这里有一个很好的[帖子](http://bbs.aliyun.com/read/163732.html?spm=5176.bbsr163732.0.0.DU3Vqo)，里面总结了连网失败的解决办法。里面提到的iptables设置前要查看和清除旧规则很有用，因为规则是按顺序优先级检验的。
真正解决了我的问题的是设置mtu的问题，要把VPN连接的mtu设置为1500，然后奇迹般地可以代理上网了，不过网速比想像中慢就是了。
