
" =============================================================================
"        << 判断操作系统是 Windows 还是 Linux 和判断是终端还是 Gvim >>
" =============================================================================
if(has("win32") || has("win64") || has("win95") || has("win16"))
    let g:iswindows = 1
    let g:userHome = $USERPROFILE
else
    let g:iswindows = 0
    let g:userHome = $HOME
endif
if has("gui_running")
    let g:isGUI = 1
else
    let g:isGUI = 0
endif
" =============================================================================
"                          << 以下为软件默认配置 >>
" =============================================================================

" -----------------------------------------------------------------------------
"  < Windows Gvim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if (g:iswindows && g:isGUI)
    source $VIMRUNTIME/vimrc_example.vim
    source $VIMRUNTIME/mswin.vim
    behave mswin
    set diffexpr=MyDiff()
    set guifont=YaHei_Consolas_Hybrid:h12:cANSI   " 设置字体  YaHei_Consolas_Hybrid:h10 Courier_New:h10:cANSI

    function! MyDiff()
        let opt = '-a --binary '
        if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
        if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
        let arg1 = v:fname_in
        if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
        let arg2 = v:fname_new
        if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
        let arg3 = v:fname_out
        if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
        let eq = ''
        if $VIMRUNTIME =~ ' '
            if &sh =~ '\<cmd'
                let cmd = '""' . $VIMRUNTIME . '\diff"'
                let eq = '"'
            else
                let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
            endif
        else
            let cmd = $VIMRUNTIME . '\diff'
        endif
        silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
    endfunction
endif

" -----------------------------------------------------------------------------
"  < gvimfullscreen 工具配置 > 请确保已安装了工具
" -----------------------------------------------------------------------------
" 用于 Windows Gvim 全屏窗口，可用 F11 切换
" 全屏后再隐藏菜单栏、工具栏、滚动条效果更好
if (g:iswindows && g:isGUI)
    map <F11> <Esc>:call libcallnr("gvimfullscreen.dll", "ToggleFullScreen", 0)<CR>
endif

" -----------------------------------------------------------------------------
"  < Linux Gvim/Vim 默认配置> 做了一点修改
" -----------------------------------------------------------------------------
if !g:iswindows
    set hlsearch        "高亮搜索
    set incsearch       "在输入要搜索的文字时，实时匹配

    " Uncomment the following to have Vim jump to the last position when
    " reopening a file
    if has("autocmd")
        au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
    endif

    if g:isGUI
        " Source a global configuration file if available
        set guifont=WenQuanYi\ Micro\ Hei\ Mono\ 11
        if filereadable("/etc/vim/gvimrc.local")
            source /etc/vim/gvimrc.local
        endif
    else
        " This line should not be removed as it ensures that various options are
        " properly set to work with the Vim-related packages available in Debian.
        runtime! debian.vim

        " Vim5 and later versions support syntax highlighting. Uncommenting the next
        " line enables syntax highlighting by default.
        if has("syntax")
            syntax on
        endif

        set mouse=a                    " 在任何模式下启用鼠标
        set t_Co=256                   " 在终端启用256色
        set backspace=2                " 设置退格键可用

        " Source a global configuration file if available
        if filereadable("/etc/vim/vimrc.local")
            source /etc/vim/vimrc.local
        endif
    endif
endif


" 显示/隐藏菜单栏、工具栏、滚动条，可用 Ctrl + F11 切换
if g:isGUI
    set guioptions-=m
    set guioptions-=T
    set guioptions-=r
    set guioptions-=L
    map <silent> <c-F11> :if &guioptions =~# 'm' <Bar>
                \set guioptions-=m <Bar>
                \set guioptions-=T <Bar>
                \set guioptions-=r <Bar>
                \set guioptions-=L <Bar>
                \else <Bar>
                \set guioptions+=m <Bar>
                \set guioptions+=T <Bar>
                \set guioptions+=r <Bar>
                \set guioptions+=L <Bar>
                \endif<CR>
endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" 函数定义  
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""定义函数SetTitle，自动插入文件头 
func! SetTitle()
    "这里是添加文件头部自身信息标记
    if &filetype == 'sh' || &filetype == 'python' || &filetype == 'ruby'
        call setline(1, "\#========================================================================")
        call append(line("."), "\# Author: Woolen.Wang")
        call append(line(".")+1, "\# Email: just_woolen＠qq.com")
        call append(line(".")+2, "\# File Name: ".expand("%"))
        call append(line(".")+3, "\# Description: ")
        call append(line(".")+4, "\#   ")
        call append(line(".")+5, "\# Edit History: ")
        call append(line(".")+6, "\#   ".strftime("%Y-%m-%d")."    File created.")
        call append(line(".")+7, "\#========================================================================")
        call append(line(".")+8, "") 
    else
        call setline(1, "/**")
        call append(line("."), "=========================================================================")
        call append(line("."), "\# Author: Woolen.Wang")
        call append(line(".")+1, "\# Email: just_woolen＠qq.com")
        call append(line(".")+2, "\# File Name: ".expand("%"))
        call append(line(".")+4, " Description: ")
        call append(line(".")+5, "   ")
        call append(line(".")+6, " Edit History: ")
        call append(line(".")+7, "   ".strftime("%Y-%m-%d")."    File created.")
        call append(line(".")+8, "=========================================================================")
        call append(line(".")+9, "**/")
        call append(line(".")+10, "") 
    endif
    "这里是添加文件类型相关的头部信息
    if &filetype == 'php'
        call append(0, "<?php")
        call append(line("$"), "?>")
    endif
    if &filetype == 'sh'
        call append(0, "\#!/bin/bash")
    elseif &filetype == 'python'
        call append(0, "\#!/usr/bin/env python")
        call append(1, "\# -*- coding: utf-8 -*-")
    elseif &filetype == 'ruby'
        call append(0, "\#!/usr/bin/env ruby")
        call append(1, "\# -*- coding: utf-8 -*-")
    endif
endfunc

"定义函数打开关闭NerdTree(左目录树),默认是不开的
let g:isNerdTreeOpen=0
func! ShowHideNerdTree()
    if g:isNerdTreeOpen
        exec ":NERDTreeClose"
        let g:isNerdTreeOpen=0
    else
        exec ":NERDTree"
        let g:isNerdTreeOpen=1
    endif
endfunc

"编译并运行文件
func! CompileRun()
    exec "w"
    if &filetype == 'c'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'cpp'
        exec "!g++ % -o %<"
        exec "!time ./%<"
    elseif &filetype == 'java' 
        exec "!javac %" 
        exec "!time java %<"
    elseif &filetype == 'sh'
        :!time bash %
    elseif &filetype == 'python'
        exec "!time python2.7 %"
    elseif &filetype == 'html'
        exec "!firefox % &"
    elseif &filetype == 'go'
        "        exec "!go build %<"
        exec "!time go run %"
    elseif &filetype == 'mkd'
        exec "!". g:userHome . "/.vim/markdown.pl % > %.html &"
        exec "!firefox %.html &"
    elseif &filetype == 'php'
        exec "!php %"
    elseif &filetype == 'ruby'
        exec "!ruby %"
    endif
endfunc

"调试模式运行文件
func! Rungdb()
    exec "w"
    if &filetype == 'c'
        exec "!gcc % -g -o %<"
        exec "!gdb %<"
    elseif &filetype == 'cpp'
        exec "!g++ % -g -o %<"
        exec "!gdb %<"
    elseif &filetype == 'php'
        exec "!php %"
    elseif &filetype == 'sh'
        exec "!bash -x %"
    endif
endfunc


"定义FormatSrc(),格式化文件
func! FormatSrc()
    exec "w"
    if &filetype == 'c'
        exec "!astyle --style=ansi -a --suffix=none %"
    elseif &filetype == 'cpp' || &filetype == 'hpp'
        exec "r !astyle --style=ansi --one-line=keep-statements -a --suffix=none %> /dev/null 2>&1"
    elseif &filetype == 'perl'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'py'||&filetype == 'python'
        exec "r !autopep8 -i --aggressive %"
    elseif &filetype == 'java'
        exec "!astyle --style=java --suffix=none %"
    elseif &filetype == 'ruby'
        exec "!astyle --style=ruby --suffix=none %"
    elseif &filetype == 'jsp'
        exec "!astyle --style=gnu --suffix=none %"
    elseif &filetype == 'xml'
        exec "!astyle --style=gnu --suffix=none %"
    else
        exec "normal gg=G"
        return
    endif
    exec "e! %"
endfunc

"自动加载Cscope和Ctags数据文件,目录自动递归往上遍历
function! AutoLoadCTagsAndCScope()
    let max = 8
    let dir = './'
    let i = 0
    let break = 0
    while isdirectory(dir) && i < max
        if filereadable(dir . 'cscope.out') 
            execute 'cs add ' . dir . 'cscope.out'
            let break = 1
        endif
        if filereadable(dir . 'tags')
            execute 'set tags =' . dir . 'tags'
            let break = 1
        endif
        if break == 1
            execute 'lcd ' . dir
            break
        endif
        let dir = dir . '../'
        let i = i + 1
    endwhile
endf
" =============================================================================
"    << Vim系统整体设置 >>
" =============================================================================
syntax on
set cul                             "高亮光标所在行
set cuc
set shortmess=atI                   " 启动的时候不显示那个援助乌干达儿童的提示  
set go=                             " 不要图形按钮  
set background=dark                 " 黑色的背景
color solarized                        " 设置背景主题  
"color ron                          " 设置背景主题  
"color torte                        " 设置背景主题  
"autocmd InsertLeave * se nocul     " 用浅色高亮当前行  
autocmd InsertEnter * se cul        " 用浅色高亮当前行  
set ruler                           " 显示标尺  
set showcmd                         " 输入的命令显示出来，看的清楚些  
"set whichwrap+=<,>,h,l             " 允许backspace和光标键跨越行边界(不建议)  
set scrolloff=3                     " 光标移动到buffer的顶部和底部时保持3行距离  
set statusline=%F%m%r%h%w\ [FORMAT=%{&ff}]\ [TYPE=%Y]\ [POS=%l,%v][%p%%]\ %{strftime(\"%d/%m/%y\ -\ %H:%M\")}   "状态行显示的内容  
set laststatus=2                    " 启动显示状态行(1),总是显示状态行(2)  
set foldenable                      " 允许折叠  
"set foldmethod=indent               " 手动折叠  
set foldcolumn=0
set foldlevel=3 
set nocompatible                    "去掉讨厌的有关vi一致性模式，避免以前版本的一些bug和局限  
" 显示中文帮助
if version >= 603
    set helplang=cn
    set encoding=utf-8
endif
" 自动缩进
set autoindent
set cindent
set tabstop=4                       " Tab键的宽度
set softtabstop=4                   " 统一缩进为4
set shiftwidth=4
set expandtab                       " 不要用空格代替制表符
set smarttab                        " 在行和段开始处使用制表符
set smartindent                     "自动缩进
set number                          " 显示行号
set history=1000                    " 历史记录数
set hlsearch                        "搜索逐字符高亮
set incsearch
set cmdheight=2                     " 总是显示状态行
filetype on                         " 侦测文件类型
filetype plugin on                  " 载入文件类型插件
filetype indent on                  " 为特定文件类型载入相关缩进文件
set viminfo+=!                      " 保存全局变量
set iskeyword+=_,$,@,%,#,-          " 带有如下符号的单词不要被换行分割
autocmd! BufWritePost $MYVIMRC source % "自动加载vimrc,vimrc一修改就自动加载之
" 字符间插入的像素行数目

"文本语言编码检测
set fencs=ucs-bom,utf-8,gb18030,gbk,gb2312,big5,euc-jp,euc-kr,latin1,cp936,utf-16
set et
set lbr
set fo+=mB
set sm
set selection=inclusive
set wildmenu
set mousemodel=popup
let g:snippets_dir=g:userHome . "/.vim/snippets"
let g:tmp_dictionary=&dict
" 自动完成设置字典和相关完成提示的函数
autocmd FileType php let &dict= g:tmp_dictionary . g:userHome . "/.vim/dict/php_funclist.dict"
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType css let &dict= g:tmp_dictionary . g:userHome . "/.vim/dict/css.dict"
autocmd FileType css setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType c let &dict= g:tmp_dictionary . g:userHome . "/.vim/dict/c.dict"
autocmd FileType cpp let &dict= g:tmp_dictionary . g:userHome . "/.vim/dict/cpp.dict"
autocmd FileType scale let &dict= g:tmp_dictionary . g:userHome . "/.vim/dict/scale.dict"
autocmd FileType javascript let &dict= g:tmp_dictionary . g:userHome . "/.vim/dict/javascript.dict"
autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html let &dict= g:tmp_dictionary . g:userHome . "/.vim/dict/javascript.dict"
autocmd FileType html let &dict= g:tmp_dictionary . g:userHome . "/.vim/dict/css.dict"
autocmd FileType html,markdown setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType python setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType ruby setlocal omnifunc=rubycomplete#Complete
autocmd FileType haskell setlocal omnifunc=necoghc#omnifunc

"syntastic相关
let g:syntastic_python_checkers=['pylint']
let g:syntastic_php_checkers=['php', 'phpcs', 'phpmd']
"golang
"Processing... % (ctrl+c to stop)
let g:fencview_autodetect=0
set rtp+=$GOROOT/misc/vim
"markdown配置
autocmd BufRead,BufNewFile *.{md,mdown,mkd,mkdn,markdown,mdwn}   set filetype=mkd
autocmd BufRead,BufNewFile *.{go}   set filetype=go
autocmd BufRead,BufNewFile *.{js}   set filetype=javascript
autocmd BufRead,BufNewFile *.{c}   set filetype=c
autocmd BufRead,BufNewFile *.{cpp}   set filetype=cpp
autocmd BufRead,BufNewFile *.{h}   set filetype=cpp
autocmd BufRead,BufNewFile *.{rb}   set filetype=ruby
autocmd BufRead,BufNewFile *.{php}   set filetype=php
" 自动跳转到新打开文件的所在目录里
autocmd BufEnter * if bufname("") !~ "^\[A-Za-z0-9\]*://" | lcd %:p:h | endif
"rkdown to HTML  我都没用mardown,暂时不设置
"let g:markdownExe=g:userHome . "/.vim/markdown.pl"
"nmap md :exec "!". g:userHome . "/.vim/markdown.pl % > %.html " <CR><CR>
"nmap fi :!firefox %.html & <CR><CR>
"nmap \ \cc
"vmap \ \cc

"将tab替换为空格
nmap tt :%s/\t/    /g<CR>



"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"""""新文件标题
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"新建.c,.h,.sh,.java文件，自动插入文件头 
autocmd BufNewFile *.cpp,*.[ch],*.sh,*.java,*.py,*.rb exec ":call SetTitle()" 
autocmd BufNewFile * normal G


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"键盘命令
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
map! <C-Z> <Esc>zzi
map <C-A> ggVG$"+y
map <C-w> <C-w>w
imap <C-k> <C-y>,
imap <C-v> <Esc>"*pa
vmap <C-c> "+y
set mouse=v
"set clipboard=unnamed
"比较文件  
nnoremap <C-F4> :vert diffsplit 
"列出当前目录文件  
map <F3> :call ShowHideNerdTree()<CR>  
"F4打开关闭TagList
nmap <F4> <ESC>:Tlist<RETURN>
"源代码 按F5编译运行
map <F5> :call CompileRun()<CR>
"代码的调试
map <F6> :call Rungdb()<CR>
"代码格式优化化
map <F8> :call FormatSrc()<CR><CR>
"F7加载Cscope和Ctags文件
nmap <F7> :call AutoLoadCTagsAndCScope()<CR>
" 自动完成的热键，undo的？
inoremap <expr><C-g>     neocomplcache#undo_completion()
inoremap <expr><C-l>     neocomplcache#complete_common_string()
"==========================
"设置自定义的<leader>快捷键
let mapleader=","
let g:mapleader=","

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" CTags,Cscope的设定  
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_Sort_Type = "name"    " 按照名称排序  
let Tlist_Use_Right_Window = 1  " 在右侧显示窗口  
let Tlist_Compart_Format = 1    " 压缩方式  
let Tlist_Exist_OnlyWindow = 1  " 如果只有一个buffer，kill窗口也kill掉buffer  
let Tlist_File_Fold_Auto_Close = 1  " 当前不被编辑的文件方法列表自动折叠
""let Tlist_Enable_Fold_Column = 0    " 不要显示折叠树  
"let Tlist_Show_One_File=1            "不同时显示多个文件的tag，只显示当前文件的
"设置tags  
"set tags=tags  
set autochdir 


"设置Cscope
if (g:iswindows)
    let g:cscope_cmd=$VIMRUNTIME . "/cscope.exe"
else
    let g:cscope_cmd="cscope"
endif
set cscopequickfix=s-,c-,d-,i-,t-,e-
"cscope 的一些热键
nmap <C-\>s :cs find s <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>g :cs find g <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>c :cs find c <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>t :cs find t <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>e :cs find e <C-R>=expand("<cword>")<CR><CR>  
nmap <C-\>f :cs find f <C-R>=expand("<cfile>")<CR><CR>  
nmap <C-\>i :cs find i <C-R>=expand("<cfile>")<CR><CR>  
nmap <C-\>d :cs find d <C-R>=expand("<cword>")<CR><CR>  


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
""实用设置
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"当打开vim且没有文件时自动打开NERDTree
autocmd vimenter * if !argc() | NERDTree | endif
" 只剩 NERDTree时自动关闭
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" 根据文件类型来Map热键
"autocmd FileType c,cpp map <buffer> <leader><space> :w<cr>:make<cr>
set autoread                                " 设置当文件被改动时自动载入
set completeopt=preview,menu                "代码补全 
set clipboard+=unnamed                      "共享剪贴板  
set autowrite                               "自动保存
"set ruler                                  " 打开状态栏标尺
"set cursorline                             " 突出显示当前行
set magic                                   " 设置魔术
set nocompatible                            " 不要使用vi的键盘模式，而是vim自己的
set noeb                                    " 去掉输入错误的提示声音
set confirm                                 " 在处理未保存或只读文件的时候，弹出确认
set nobackup                                "禁止生成临时文件
set writebackup                             "关闭文件的时候自动备份一次
set noswapfile
set ignorecase                              "搜索忽略大小写
set linespace=0
set wildmenu                                " 增强模式中的命令行自动完成操作
set backspace=2                             " 使回格键（backspace）正常处理indent, eol, start等
set whichwrap+=<,>,h,l                      " 允许backspace和光标键跨越行边界
set mouse=a                                 " 可以在buffer的任何地方使用鼠标（类似office中在工作区双击鼠标定位）
set selection=exclusive
set selectmode=mouse,key
set report=0                                " 通过使用: commands命令，告诉我们文件的哪一行被改变过
set fillchars=vert:\ ,stl:\ ,stlnc:\        " 在被分割的窗口间显示空白，便于阅读
set showmatch                               " 高亮显示匹配的括号
set matchtime=1                             " 匹配括号高亮的时间（单位是十分之一秒）
set scrolloff=3                             " 光标移动到buffer的顶部和底部时保持3行距离
filetype plugin indent on 
set completeopt=longest,menu                "打开文件类型检测, 加了这句才可以用智能补全

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"其他东东
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"不默认打开Taglist 
let Tlist_Auto_Open=0 
"""""""""""""""""""""""""""""" 
" Tag list (ctags) 
"""""""""""""""""""""""""""""""" 
if (g:iswindows)
    let Tlist_Ctags_Cmd=$VIMRUNTIME . '/ctags'
else
    let Tlist_Ctags_Cmd='ctags'
endif
let Tlist_Show_One_File = 1 "不同时显示多个文件的tag，只显示当前文件的 
let Tlist_File_Fold_Auto_Close = 1
let Tlist_Exit_OnlyWindow = 1 "如果taglist窗口是最后一个窗口，则退出vim 
let Tlist_Use_Right_Window = 1 "在右侧窗口中显示taglist窗口
" minibufexpl插件的一般设置
let g:miniBufExplMapWindowNavVim = 1
let g:miniBufExplMapWindowNavArrows = 1
let g:miniBufExplMapCTabSwitchBufs = 1
let g:miniBufExplModSelTarget = 1  

"输入法

"python补全
let g:pydiction_location = g:userHome . '/.vim/after/complete-dict'
let g:pydiction_menu_height = 20
"let g:miniBufExplMapWindowNavVim = 1
"let g:miniBufExplMapWindowNavArrows = 1
"let g:miniBufExplMapCTabSwitchBufs = 1
"let g:miniBufExplModSelTarget = 1

" plugin - mru.vim 记录最近打开的文件
let MRU_File = $VIMFILES.'/_vim_mru_files'
let MRU_Max_Entries = 1000
let MRU_Add_Menu = 0
nmap <leader>f :MRU<CR>

"===================这里都是neocomplcache的一些设置==========================
" Disable AutoComplPop.
let g:acp_enableAtStartup = 0
" Use neocomplcache.
let g:neocomplcache_enable_at_startup = 1
" Use smartcase.
let g:neocomplcache_enable_smart_case = 1
" Set minimum syntax keyword length.
let g:neocomplcache_min_syntax_length = 3
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
"OMNI的设置，自动提示的相关设置项
if !exists('g:neocomplcache_omni_patterns')
    let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_omni_patterns.cpp = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
"==================自动提示的设置===========================================
" PIV 设置 {
let g:DisableAutoPHPFolding = 0
let g:PIVAutoClose = 0
"}

" ctrlp 设置｛
let g:ctrlp_working_path_mode = 'ra'
if g:iswindows
    let s:ctrlp_fallback = 'dir %s /-n /b /s /a-d'
elseif executable('ag')
    let s:ctrlp_fallback = 'ag %s --nocolor -l -g ""'
elseif executable('ack')
    let s:ctrlp_fallback = 'ack %s --nocolor -f'
else
    let s:ctrlp_fallback = 'find %s -type f'
endif
"}
" {{{ plugin - jsbeautify.vim 优化js代码，并不是简单的缩进，而是整个优化
" 开始优化整个文件
nmap <silent> <leader>js :call g:Jsbeautify()<cr>
" }}}

set iskeyword+=.
set termencoding=utf-8
set fileencodings=utf8,ucs-bom,gbk,cp936,gb2312,gb18030



""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Bundle 管理的工具
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let s:tmp_rtp=&rtp
let s:tmp_rtp=s:tmp_rtp . "," . g:userHome . "/.vim/bundle/vundle/"
let &rtp=s:tmp_rtp
call vundle#rc()

" 让Vundle管理工具,这是必须的哈
Bundle 'gmarik/vundle'

"通用工具集::
"顶头标签栏,可以在打开过的文件间切换,不需要设置
"Bundle "minibufexplorerpp" 
"缩进工具
Bundle 'IndentAnything'
" 最近打开的文件
Bundle 'mru.vim'
" 版本管理
Bundle 'vcscommand.vim'
" 可以方便地修改字符串，括号什么的： 修改字符串双引变单引 cs”’ 删除字符串 : ds"
Bundle 'surround.vim'
" 模仿TextMate
" 的代码提醒功能,全部提醒都用tab来展示，按了tab就有了，唯一就是要添加一些文件支持
Bundle 'snipMate'
" 文件语法检查，支持多种语言的
Bundle 'Syntastic'
" 使用 \ + t 来搜索文件整个项目中的文件
" Bundle 'Command-T'
" 替代command-T 热键是：ctrl + p <c-p>
Bundle 'ctrlp.vim'

"在quickfix中快速过滤
Bundle "QFGrep.vim"
"Visual-Mark,类似于UE中的BookMark,可以记住浏览的代码行数,来回跳转,热键是F2,<c-F2>,mm,<shift-F2>
Bundle "Visual-Mark"
"加强版的自动提示程序
Bundle 'neocomplcache-snippets_complete'
Bundle 'neocomplcache'
" original repos on github
Bundle 'tpope/vim-fugitive'
Bundle 'rstacruz/sparkup', {'rtp': 'vim/'}
Bundle 'Yggdroot/indentLine'
let g:indentLine_char = '|'
Bundle 'UltiSnips'
" vim-scripts repos
Bundle 'L9'
Bundle 'FuzzyFinder'
" non github repos
Bundle 'Auto-Pairs'
Bundle 'CaptureClipboard'
Bundle 'ctrlp-modified.vim'
Bundle 'last_edit_marker.vim'
Bundle 'synmark.vim'
Bundle "pangloss/vim-javascript"
Bundle 'Vim-Script-Updater'
Bundle 'tacahiroy/ctrlp-funky'
Bundle 'jsbeautify'
" 自动注释，热键是：<Leader>c<space>
Bundle 'The-NERD-Commenter'
"django
"Bundle 'django_templates.vim'
"Bundle 'Django-Projects'

"ruby语言的Plugin
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "snipmate-snippets"
Bundle "rails.vim"
Bundle "ruby.vim"
Bundle "ftpluginruby.vim"
Bundle "Ruby-Snippets"
Bundle "vim-addon-ruby-debug-ide"
" 自动补全end
Bundle 'ruby-macros.vim'

"C语言的Plugin
"C/C++的IDE,支持模板和各种操作
Bundle "c.vim"
"代码快速跳转工具,头文件和C文件间跳转
Bundle "a.vim"
Bundle "cpp.vim"
"自动完成工具(代码提示)
Bundle "AutoComplPop"
Bundle "OmniCppComplete"
"使用Tab直接生成代码 http://files.myopera.com/mbbill/files/code_complete.gif
Bundle "code_complete"

" javascript 的插件::
Bundle 'Javascript-OmniCompletion-with-YUI-and-j'
Bundle 'JavaScript-Indent'
"没必要用到js检查语法的插件
"Bundle 'jslint.vim'

"   PHP的插件 ::
Bundle 'ZenCoding.vim'
" Full PHP documentation manual (hit K on any function for full docs)
" Autocomplete of classes, functions, variables, constants and language
" keywords
Bundle 'PIV'
" ...
let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

"
"ctrlp设置
"
set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,*.png,*.jpg,*.gif     " MacOSX/Linux
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe,*.pyc,*.png,*.jpg,*.gif  " Windows

"设置FuzzyFinder

let mapleader = "\\"
map <leader>F :FufFile<CR>
map <leader>f :FufTaggedFile<CR>
map <leader>g :FufTag<CR>
map <leader>b :FufBuffer<CR>

" 命令行下按tab键自动完成
set wildmode=list:full
set wildmenu

" 带有如下符号的单词不要被换行分割
set iskeyword+=_,$,@,%,#,-

"使用RubyTest
let g:rubytest_cmd_spec = "rspec -fd %p"

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = '\v\.(exe|so|dll)$'
let g:ctrlp_extensions = ['funky']

let NERDTreeIgnore=['\.pyc']

"这个必须在最后的,用来解决菜单乱码问题,删除Menu然后再加载一次
if (g:iswindows && g:isGUI)
    "解决菜单乱码
    source $VIMRUNTIME/delmenu.vim
    source $VIMRUNTIME/menu.vim

    "解决consle输出乱码
    language messages zh_CN.utf-8
endif


" ==============================================================
" <<<<<<<<<<< 相关热键介绍与帮助 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
" ==============================================================
" C_vim: 热键:: 帮助: \hp , 插入函数: \if ,插入头文件 \+ih \+ich, Make: \rm,
" , MakeClean: \rmc  注释: /*   http://lug.fh-swf.de/vim/vim-c/c-hotkeys.pdf
" Bundle: :BundleList, :BundleInstall(!),  :BundleSearch(!) foo, :BundleClean(!), :h help;
"
"   PHP:: ctrl + x -> ctrl + o (Ctrl + n / p 上下选择) 
"   PHP:: ctrl + y / ,
"{{{ plugin - NERD_commenter.vim 注释代码用的，
" <leader>ca 在可选的注释方式之间切换，比如C/C++ 的块注释和行注释//
" <leader>cc 注释当前行
" <leader>cs 以”性感”的方式注释
" <leader>cA 在当前行尾添加注释符，并进入Insert模式
" <leader>cu 取消注释
" <leader>cm 添加块注释
" }}}"
