---
layout: post
title: Python copy file or folder
date: 2016-12-11
categories: python
tags: shutil copy
---
#### <strong>History:</strong>
* <em>2016-12-11</em>:create the page<br>

#### <strong>Background:</strong>
To copy a file or dir is useful, python provide it by shutil, there are functions copyfile, copy, copymode, copy2, copytree. 

This pages note the differences between them.

#### <strong>Content:</strong>
    
copyfile, it cp file to file, the dst must also be a file(not folder)<br>
If there already a file with same name in dst, it will be coverd.<br>
available command: shutil.copyfile file file

copy, it cp file to file/folder, the mode/createtime will be new.<br>
If there already a file with same name in dst, it will be coverd.<br>
available command: shutil.copy file file|folder
    
copy2, similar to copy, but it also cp the mode/createtime from src.<br>
available command: shutil.copy2 file file|folder

copymode, it only copy mode, exclude file content.<br>
the dst file/folder must exist.<br>
available command: shutil.copy2 file|folder file|folder

copytree, it can cp folder to folder<br>
the dst file/folder must not exist.<br>
available command: shutil.copytree folder folder

    import shutil

    def main():
        srcfolder='./folder/SRC'
        src='./folder/SRC/a'
        dst='./folder/DST/a'
        dstfolder='./folder/DST/'
        # shutil.copy(src, dstfolder)
        # shutil.copy2(src, dst)
        # shutil.copyfile(src, dst)
        shutil.copytree(srcfolder, dstfolder)
        # shutil.copymode(srcfolder, dstfolder)

    if __name__ == '__main__':
        main()
