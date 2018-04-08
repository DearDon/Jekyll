---
layout: post
title: Python copy file or folder
date: 2016-12-11
categories: python
tags: programming
---
### Abstract:
To copy a file or dir is useful, python provide it by shutil, there are functions copyfile, copy, copymode, copy2, copytree. 
This pages note the differences between them.<br>

### Content:

#### copy API in python:
* `copyfile`, it cp file to file, the dst must also be a file(not folder).
If there already a file with same name in dst, it will be coverd.
Available command: `shutil.copyfile file file`

* `copy`, it cp file to file/folder, the mode/createtime will be new.
If there already a file with same name in dst, it will be coverd.
Available command: `shutil.copy file file|folder`
    
* `copy2`, similar to copy, but it also cp the mode/createtime from src.
available command: `shutil.copy2 file file|folder`

* `copymode`, it only copy mode, exclude file content.
the dst file/folder must exist.
available command: `shutil.copy2 file|folder file|folder`

* `copytree`, it can cp folder to folder
the dst file/folder must not exist.
available command: `shutil.copytree folder folder`

#### code example:
<script src="https://gist.github.com/DearDon/02a2a88639a8659a8905e21cb6615a5e.js"></script>


### History:
* <em>2016-12-11</em>:create the page<br>

