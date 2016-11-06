---
layout: post
title: 升级旧版vim到7.4以上
date: 2016-09-11
categories: 折腾折腾
tags: Vim Upgrade apt-get
---
#### <strong>History:</strong>
* <em>2016-09-11</em>:将内容记录下来<br>

#### <strong>Background:</strong>
由于自己ubuntu10.04的自带vim版本低于7.3(可用`vim --version`查看)，而安装vim插件YouCompleteMe要求至少7.3以上。因此折腾升级vim版本，这里尽量不想重编译安装。尝试了几次，失败了。

#### <strong>Content:</strong>
对较新版ubuntu(13.0以上吧),可直接

    $ sudo apt-get update
    $ sudo apt-get install vim

可是自己是10.04,网上查了先加新的repository.

    $ sudo add-apt-repository ppa:fcwu-tw/ppa
    $ sudo apt-get update
    $ sudo apt-get install vim

结果fcwu-tw/ppa一直连不上，查了下要翻墙，找了代替的

    $ sudo add-apt-repository ppa:nmi/vim-snapshots
    $ sudo apt-get update
    $ sudo apt-get install vim

可install时还是提示已经最新，无语了。估计10.04上只能重编译了，有机会再弄吧，暂时用Pydiction代替YouCompleteMe使用了。
