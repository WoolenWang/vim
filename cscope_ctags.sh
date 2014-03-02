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
find `pwd` -name "*.h" -o -name "*.c" -o -name "*.cpp" -o -name "*.php" -o -name "*.js" -o -name "*.sh" -o -name "*.cc" -o -name "*.rb" -o -name "*.erb" > cscope.files 
find /usr/include -name "*.h" -o -name "*.c" -o -name "*.cpp" >> cscope.files
cscope -bkq -i cscope.files 
ctags -R 
