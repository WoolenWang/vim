@echo on
move /y %USERPROFILE%\vim %USERPROFILE%\vim_old 
cd %USERPROFILE%
c:
git clone https://github.com/WoolenWang/vim.git
move /y %USERPROFILE%\.vim %USERPROFILE%\.vim_old
move /y %USERPROFILE%\vim %USERPROFILE%\.vim
move /y %USERPROFILE%\.vim\_vimrc %USERPROFILE%\ 
git clone http://github.com/gmarik/vundle.git %USERPROFILE%\.vim\bundle\vundle
echo "woolen正在努力为您安装bundle程序" > woolen
echo "安装完毕将自动退出" >> woolen
echo "请耐心等待" >> woolen
vim woolen -c "BundleInstall" -c "q" -c "q"
rm woolen
echo "记得还要把 %USERPROFILE%\.vim\ 里面的文件中的其他目录都复制到VimRuntime目录下的vimfiles里面"
echo "记得还要把 %USERPROFILE%\.vim\dict 不能移走的哈"
pause