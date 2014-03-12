#!/bin/bash
get_all_apps()
{
    if which apt-get >/dev/null; then
	    sudo apt-get install -y vim vim-gnome ctags xclip astyle python-setuptools ctags cscope python-twisted python-libxml2 rhino
    else
	    sudo yum install -y gcc vim git ctags xclip astyle python-setuptools python-devel ctags cscope python-twisted python-libxml2 rhino
    fi
    sudo easy_install -ZU autopep8 twisted
    sudo ln -s /usr/bin/ctags /usr/local/bin/ctags
}
copy_files_to_home()
{
    mv ~/vim ~/vim_old_$$ -f
    mv ~/.vim ~/.vim_old_$$ -f
    cd ~/ && git clone https://github.com/WoolenWang/vim.git -o vim
    mv ~/vim ~/.vim -f
    mv ~/.vim/_vimrc ~/.vimrc -f
    cp ~/.vim/cscope_ctags.sh /usr/sbin/mk_cscope_ctags
}
make_all_bundle_plugin()
{
    git clone http://github.com/gmarik/vundle.git ~/.vim/bundle/vundle
    echo "woolen正在努力为您安装bundle程序" > woolen
    echo "安装完毕将自动退出" >> woolen
    echo "请耐心等待" >> woolen
    vim woolen -c "BundleInstall" -c "q" -c "q"
    rm woolen
    local thisdir=`pwd`
    cd ~/.vim/bundle/Command-T/ruby/command-t;ruby extconf.rb && make;
    cd $thisdir
}
main()
{
    echo "安装将花费一定时间，请耐心等待直到安装完成^_^"
    get_all_apps
    echo "完成了安装的所有软件了，还差Vim的设置哈^_^"
    copy_files_to_home
    make_all_bundle_plugin
    echo "安装完成"
}
main
