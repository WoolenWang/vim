@echo off
echo "woolen正在努力为您安装bundle程序" > woolen
echo "安装完毕将自动退出" >> woolen
echo "请耐心等待" >> woolen
vim woolen -c "BundleInstall" -c "q" -c "q"
rm woolen