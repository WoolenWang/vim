@echo on
move /y %USERPROFILE%\vim %USERPROFILE%\vim_old 
cd %USERPROFILE%
c:
git clone https://github.com/WoolenWang/vim.git
move /y %USERPROFILE%\.vim %USERPROFILE%\.vim_old 
move /y %USERPROFILE%\vim %USERPROFILE%\.vim 
move /y %USERPROFILE%\.vim\_vimrc %USERPROFILE%\ 
git clone http://github.com/gmarik/vundle.git %USERPROFILE%\.vim\bundle\vundle
echo "woolen����Ŭ��Ϊ����װbundle����" > woolen
echo "��װ��Ͻ��Զ��˳�" >> woolen
echo "�����ĵȴ�" >> woolen
vim woolen -c "BundleInstall" -c "q" -c "q"
rm woolen