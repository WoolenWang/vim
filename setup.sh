#!/bin/bash
echo "安装将花费一定时间，请耐心等待直到安装完成^_^"
if which apt-get >/dev/null; then
	sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools ctags cscope python-twisted python-libxml2 rhino
else
	sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel ctags cscope python-twisted python-libxml2 rhino
fi
sudo easy_install -ZU autopep8 twisted
sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
mv ~/vim ~/vim_old -f
cd ~/ && git clone https://github.com/WoolenWang/vim.git
mv ~/.vim ~/.vim_old -f
mv ~/vim ~/.vim -f
mv ~/.vim/.vimrc ~/ -f
git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
echo "woolen正在努力为您安装bundle程序" > woolen
echo "安装完毕将自动退出" >> woolen
echo "请耐心等待" >> woolen
vim woolen -c "BundleInstall" -c "q" -c "q"
rm woolen
echo "安装完成"
