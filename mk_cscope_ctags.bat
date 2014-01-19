@echo off
dir /s /b *.c *.h *cpp *.hpp *.sh > cscope.files
cscope -bqk
ctags --c-kinds=+px --c++-kinds=+px --fields=+iafksS --extra=+qf -R
