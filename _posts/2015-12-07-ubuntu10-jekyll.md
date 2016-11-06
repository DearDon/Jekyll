---
layout: post
title:  搭建jekyll写github page
date: 2015-12-07
categories: 折腾折腾 
tags:  jekyll github ubuntu10.04 Tofinish
---
#### <strong>History:</strong>
* <em>2015-12-06</em>: 快速将内容记录了下来<br>
* <em>2015-12-27</em>: 对格式和段落进行分划
* <em>2016-09-25</em>: add easy install in ubuntu16.04

#### <strong>Backgound:</strong>
内容参考的github官方的[说明](https://help.github.com/articles/using-jekyll-with-pages/)，比较可靠。<br> 
本人在ubuntu10.04下搭建的，其它平台未尝试。


#### <strong>Content:</strong>
<strong>在ubuntu10.04下搭建的</strong>

由于jekyll基于ruby，所以主要分为3步，安装ruby,bundler和jekyll。ruby是jekyll的语言环境，自不用多说，而bundler是为了以后的更新安装方便用的，严格来说，不装也是可以的，但是为了安装包的管理更新方便，强烈建议安装，这样才能方便地保证github后台的jekyll更新时能及时在本地跟上，使本地编写的与github上看到的页面效果一致（更新可是很频繁的喔）。<br>
其实安装流程都是很明确的，主要问题在于版本，现在Ubuntu14.XX都早出来了，自己还守旧地用着停止更新支持的10.04。导致apt-get安装的程序都是很旧或是根本找不到软件包的，比如ruby就安装到1.8，而github里明确要求至少2.0。于是自己在apt-add了一个reposity，安装了2.0的ruby。而后就是bundler，用gem安装bundler时，发现国内不能连到默认的https://rubygems.org服务器，而替换为了可访问的https://ruby.tao.org。最后用bundler安装Jekyll也要设置该国内可访问的资源地址。
另外，在执行命令时可能出现没有javascript的runtime环境问题，可参考<https://github.com/rails/execjs>上网下载相应的环境，注意如果是用gem命令下的，只能在gem命令里使用该runtime环境，用bundle命令时仍然会报错，所以要用bundle安装该环境，方法就和安装jekyll差不多，在Gemfile里加上gem 'therubyracer'，还有后面加参数的形式，但是运行可能报错，不加参数实践证明也是OK的。至此环境安装成功。其中可能还会有些小问题，比如里面有个no什么什么的库一直报问题，注意要先下载了个c的dev环境库，具体可以直接搜那个缺少的包名的官方网站，上面有明确说明，而且说了在ubuntu,debian下不要用本地的那个包，要在线构建（网上就用说用这个本地构建的，也不说清楚系统状况，真是坑）。

不早了，今天写到这，把主要问题和内容都写了，下次再细细整理内容和排版吧。

<strong>在ubuntu16.04下搭建的</strong>

    #check version need new than 2.0
    ruby --version 

    #if ruby not install, install it
    sudo apt-get install ruby 

    #install jekyll
    $ gem install jekyll 

    #create a new site 
    $ jekyll new Blog
    #or clone a existed site from github, we name it Blog
    $ git clone  https://github.com/DearDon/DearDon.github.io.git Blog

    #start jekyll
    $ cd Blog
    $ jekyll serve
    # => Now browse to http://localhost:4000
