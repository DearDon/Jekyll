#########################################################################
# File Name: manage.sh
# Purpose:
#	This file is to manage blog
# History:
#	Created Time: 2017-08-06
# Author: Don E-mail: dpdeng@whu.edu.cn
#########################################################################


COMMANDS='notebook, nbconvert, jekyll, git, gem'
case ${1} in 
    'notebook')
        echo cd _notebook
        cd _notebook
        echo jupyter notebook
        jupyter notebook
        ;;
    'nbconvert')
        if [ $# != 2 ]; then
            echo "${1} need other inputs, eg: ./mange.sh ${1} '_notebook/2017-05-05-example.ipynb'"
            exit -1
        fi
        echo cd _notebook
        cd _notebook
        echo ./nb2md.sh `echo ${2} | cut -d / -f 2`
        ./nb2md.sh `echo ${2} | cut -d / -f 2`
        ;;
    'jekyll')
        echo bundle exec jekyll serve --watch --incremental
        bundle exec jekyll serve --watch
        ;;
    'gem')
        echo bundle update
        bundle update
        ;;
    'git')
        case ${2} in
            'commit')
                if [ $# != 3 ]; then
                    echo "${2} need other inputs for comment, eg: ./mange.sh ${1} ${2} 'submit for test'"
                    exit -1
                fi
                echo ${1} ${2} -m ${3}
                ${1} ${2} -m ${3}
                ;;
            'push')
                echo ${1} ${2}
                ${1} ${2}
                ;;
            'pull')
                echo ${1} ${2}
                ${1} ${2}
                ;;
            'addall')
                echo git add *
                git add *
                ;;
            'add')
                if [ $# != 3 ]; then
                    echo "${2} need other inputs for comment, eg: ./mange.sh ${1} ${2} filename "
                    exit -1
                fi
                echo ${1} ${2} ${3}
                ${1} ${2} ${3}
                ;;
            *)
                echo "${2} is not a valid for ${1}. Please choose command from commit/pull/push for ${1}"
                exit -1
                ;;
        esac
        ;;
    *)
        echo "${1} is not a valid command. Please choose command from ${COMMANDS}"
        exit -1
        ;;
esac
