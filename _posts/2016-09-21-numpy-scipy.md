---
layout: post
title: ubuntu16.04为python安装numpy,scipy模块
date: 2016-09-21
categories: python
tags: programming 
---
#### <strong>Abstract:</strong>
numpy和scipy是python的第三方模块，但是数学计算(ML)中很有用。
由于不是内置的，使用前需要先安装，在16.04下装这些python模块简直不要太简单。<br>

之前一直坚持使用的ubuntu10.04，由于更新库确实不能再用了，一咬牙直接更新到了16.04(目前最新版)。<br>
使用新版的好处就是源多，而且都是基本最新的，在16.04下装这些python模块简直不要太简单。

#### <strong>Content:</strong>
由于各模块依赖关系复杂，最好用专用的工具安装管理。<br>
毕竟各版本的依赖关系会变，手动维护很麻烦，钻这个手动安装也不是我们学习的目标。

先安装pip来管理python模块安装

    $ sudo apt-get install python-pip

然后

    $ pip install --upgrade numpy
    $ sudo pip install --upgrade scipy

上面加`--upgrade`作用是在未安装时装最新版，已安装时升级到新版。<br>
其它的模块也可以类似安装，pip会自动分析依赖并管理版本升级的问题。<br>
把精力安心放到程序的学习上去吧!

#### <strong>History:</strong>
* <em>2016-09-15</em>:将内容记录下来<br>

