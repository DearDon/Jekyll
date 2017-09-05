---
layout: post
title:  vim 插件安装(Vundle)
date: 2016-09-11
categories:  trial&error
tags: vim
---
#### <strong>Abstract:</strong>
Vim非常强大，其中一个重要原因是丰富的插件。为了高效管理插件，Vundle(Vim bundle)是不错的选择，它也是一个vim的插件，但它可以管理其他插件，所以装好它其它插件都so easy.<br>

#### <strong>Content:</strong>
以下安装基于linux，参考自Vundle在github上的[项目说明](https://github.com/VundleVim/Vundle.vim)，原文写得很清楚，这里只是简单翻译。

1.建立Vundle:<br>

    $ git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

2.Vundle配置(.vimrc):<br>

    set nocompatible              " be iMproved, required
    filetype off                  " required

    " set the runtime path to include Vundle and initialize
    set rtp+=~/.vim/bundle/Vundle.vim
    call vundle#begin()
    " alternatively, pass a path where Vundle should install plugins
    "call vundle#begin('~/some/path/here')

    " let Vundle manage Vundle, required
    Plugin 'VundleVim/Vundle.vim'

    " All of your Plugins must be added before the following line
    call vundle#end()            " required
    filetype plugin indent on    " required
    " To ignore plugin indent changes, instead use:
    "filetype plugin on
    "
    " Bundle 'Valloric/YoucompleteMe'
    "
    " Brief help
    " :PluginList       - lists configured plugins
    " :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
    " :PluginSearch foo - searches for foo; append `!` to refresh local cache
    " :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
    "
    " see :h vundle for more details or wiki for FAQ
    " Put your non-Plugin stuff after this line

可以看到想安装插件只要在`call vundel#begin()`和`call vundle#end()`间加入相应的插件即可自动管理(格式如`Plugin 'VundleVim/Vundle.vim'`，该插件是必须的)。实践发现在`call vundle#end()`之后用`Bundle $PluginName`(格式如`Bundle 'Valloric/YoucompleteMe'`)也可以和上述`Plugin $PluginName`方式一样管理插件。

3.安装插件:<br>
记得先`source $vimrcfile`($vimrcfile为上面的vimrc)，让其生效。然后
打开vim输入

    :PluginInstall
或在终端输入

    $ vim +PluginInstall +qall

#### <strong>History:</strong>
* <em>2016-09-11</em>: 将内容记录下来<br>
* <em>2016-09-13</em>: 修改排版<br>

