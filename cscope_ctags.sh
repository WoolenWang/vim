#!/bin/bash
#========================================================================
# Author: Woolen.Wang
# Email: just_woolen＠qq.com
# File Name: /usr/sbin/cscope_ctags.sh
# Description: 
#    添加CSCOPE和ctags的标签
# Edit History: 
#   2014-01-11    File created.
#========================================================================
find `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.cc" -o -name "*.rb" -o -name "*.erb" > cscope.files 
cscope -bkq -i cscope.files 
ctags -R 
