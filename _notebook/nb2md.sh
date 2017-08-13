#!/bin/bash
#########################################################################
# File Name: magange.sh
# Purpose:
#	This file is to manage convert notebook to markdown and deploy it
# History:
#	Created Time: 2017-08-05
# Author: Don E-mail: dpdeng@whu.edu.cn
#########################################################################
#set -x

#jekyll serve

BLOG_ROOT="/home/don/Blog"

ASSETS_PATH="${BLOG_ROOT}/assets"
POST_PATH="${BLOG_ROOT}/_posts"

NOTEBOOK_FILE=${1} 
BASE_NAME=`echo ${NOTEBOOK_FILE} | cut -d . -f 1`
jupyter nbconvert --to markdown ${NOTEBOOK_FILE} --config ${BLOG_ROOT}/_notebook/config/myconfig.py
if [ -d ${BASE_NAME}_files ]; then
    if [ -d ${ASSETS_PATH}/${BASE_NAME}_files ]; then
        echo [WARNING]: ${ASSETS_PATH}/${BASE_NAME}_files already exist, will be removed!
        echo rm -r ${ASSETS_PATH}/${BASE_NAME}_files 
        rm -r ${ASSETS_PATH}/${BASE_NAME}_files 
    fi
    echo mv ${BASE_NAME}_files  ${ASSETS_PATH}
    mv ${BASE_NAME}_files  ${ASSETS_PATH}
fi
if [ -e ${BASE_NAME}.md ]; then
    echo mv ${BASE_NAME}.md  ${POST_PATH}
    mv ${BASE_NAME}.md  ${POST_PATH}
fi
