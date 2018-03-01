""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"          FILE:  .vimrc
"         USAGE:  put it to user home directory, vim can auto exec it.
"   DESCRIPTION:
"       OPTIONS:  ---
"  REQUIREMENTS:  ---
"          BUGS:  ---
"         NOTES:  ---
"        AUTHOR: Karl Zheng (), ZhengKarl#gmail.com
"          BLOG: http://blog.csdn.net/zhengkarl
"         WEIBO: http://weibo.com/zhengkarl
"       COMPANY: Meizu
"       CREATED: 2012年05月21日 19时12分43秒 CST
"      REVISION:  ---
"
" file outline:
"	 1. global common settings
"	 2. function defition for calling
"	 3. plugin settings
"	 4. define user commands
"	 5. key re map
"	 6. run auto commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Platform
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
function! MySys()
  if has("win32")
    return "windows"
  else
    return "linux"
  endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" General settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let mapleader=","
let g:BASH_Ctrl_j='on'
let g:EditTmpFilePos = 1
let g:use_gtags=0
let g:alternateSearchPath = 'sfr:../source,sfr:../src,sfr:../include,sfr:../inc,sfr:include,sfr:../'
"let g:use_gtags=1
set nocompatible
"au BufRead ft=Help set nu
set ar
"set autochdir
set autoindent
set aw
set clipboard=unnamed
"set clipboard=unnamedplus
set cot=menuone
set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
set cscopetag
set dictionary+=~/.vim/usr_bin_cmd.txt,~/.vim/bash-support/wordlists/bash.list
"set &sessionoptions
"set encoding=prc
set encoding=utf-8
set fencs=utf-8,gbk,big5,gb2312,gb18030,euc-jp,utf-16le
"fenc; internal enc; terminal enc
set fenc=utf-8 enc=utf-8 tenc=utf-8
set fileformats=unix
"set foldenable
"set foldmethod=indent
set grepprg=mgrep.sh
set guifont=文泉驿等宽微米黑\ 10
"set guioptions-=L
set guioptions-=m
"set guioptions-=r
"set guioptions-=T
set hid
set history=500
set hlsearch
set incsearch
set isf-==
set iskeyword-=",.,/,,
" for  # * quick lookup
set iskeyword+=_
set laststatus=2
if isdirectory('arch/arm/configs/')
	set makeprg=make\ zImage\ \-j24
else
	set makeprg=make\ \-j24
en
set nocp
set ignorecase
set noexpandtab
set nu
"set ofu=syntaxcomplete#Complete
set pastetoggle=<F4>
set shiftwidth=4
set smartindent
set stal=1
set statusline=\[%{getcwd()}]\[%f]%m%r%h%w\[HEX=\%02.2B]\[DEC=\%b]\[P=%l,%v]
"setlocal noswapfile
"set noswf
set switchbuf=useopen
set tabstop=4
set termencoding=utf-8
set textwidth=10000
set whichwrap=b,s,h,l
set winaltkeys=no
set wrap
""http://blog.xuyu.org/?p=1215
"set nowrapscan

" settings
syntax on

"http://askubuntu.com/questions/67/how-do-i-enable-full-color-support-in-terminal
if $COLORTERM == 'gnome-terminal'
	set t_Co=256
else
	set t_Co=256
endif

if ! exists("g:root_work_path")
    let g:root_work_path = escape(getcwd(), " ")
endif

"user HOME dir.
if ! exists("g:homedir")
    let g:homedir = system("echo ${HOME} | tr -d '\r' | tr -d '\n' ")
endif

if ! exists("g:whoami")
    let g:whoami = system("whoami | tr -d '\r' | tr -d '\n' ")
endif

let g:absfn=g:homedir.'/dev/'.g:whoami.'/absfn'
let g:shmdir=g:homedir.'/shm/'

function! s:PreSetEnv()
	let l:d = g:shmdir.g:whoami
	if isdirectory(l:d) == 0
		let l:c = 'mkdir -p '.l:d
		let l:r = system(l:c)
	endif
	let l:f=g:shmdir.g:whoami.'/allBashCommands.txt'
	if filereadable(l:f) == 0
		let l:c = 'compgen -c > '.l:f
		let l:r = system(l:c)
	endif
	exec 'set '. 'dictionary+='.l:f
endfunc

call s:PreSetEnv()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" my functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! AddDebugLine()
	let l:msg = ''
	if &ft == "c"
		if isdirectory(g:root_work_path."/arch/arm/configs")
			let l:msg = 'pr_err("karldbg %s %d\n", __func__, __LINE__);'
		else
			if (filereadable(g:root_work_path."/build/envsetup.sh") || filereadable(g:root_work_path."/Android.mk") || filereadable(g:root_work_path."/is_android.txt"))
				let l:msg = 'ALOGE("karldbg %s %d", __func__, __LINE__);'
			else
				let l:msg = 'printf("karldbg %s %d\n", __func__, __LINE__);'
			endif
		endif
	endif
	if &ft == "cpp"
		if (filereadable(g:root_work_path."/build/envsetup.sh") || filereadable(g:root_work_path."/Android.mk") || filereadable(g:root_work_path."/is_android.txt"))
			let l:msg = 'ALOGE("karldbg %s %d", __func__, __LINE__);'
		else
			let l:msg = 'printf("karldbg %s %d\n", __func__, __LINE__);'
		endif
	endif
	if &ft == "java"
		let l:msg = 'System.err.println("karldbg " + Thread.currentThread().getStackTrace()[1].getLineNumber());'
	endif
	if &ft == "make"
		let l:msg = '$(warning "karldbg")'
	endif
	if &ft == "python"
		let l:msg = 'import inspect;print ("karldbg %s %d" %(__file__, inspect.currentframe().f_lineno))'
	endif
	if &ft == "sh"
		let l:msg = 'echo karldbg ${BASH_SOURCE[0]} $LINENO'
	endif
	if &ft == "lua"
		let l:msg = 'require "MZLog".log(3, debug.getinfo(1).currentline)'
	endif
	if l:msg != ''
		call append(line('.'), l:msg)
		exec "normal Vj=j"
	endif
endfunction

function! <SID>BufCloseOthers()
	let l:currentBufNum   = bufnr("%")
	let l:alternateBufNum = bufnr("#")
	for i in range(1,bufnr("$"))
		if buflisted(i)
			if i!=l:currentBufNum
				execute("bdelete ".i)
			endif
		endif
	endfor
endfunction

" Don't close window, when deleting a buffer
function! <SID>BufcloseCloseIt(is_buf_wipeout)
	if  &modified != 0
		echo "Current file has been modified && not saved!!, can't be closed!"
		return 1
	endif
	let l:currentBufNum = bufnr("%")
	let l:alternateBufNum = bufnr("#")

	if buflisted(l:alternateBufNum)
		buffer #
		if &ft == 'qf'
			bnext
			else
			if bufname('#') == "__Tag_List__"
				bnext
			endif
		endif
	else
		bnext
	endif
	if bufnr("%") == l:currentBufNum
		new
	endif
	try
		if (a:is_buf_wipeout)
			execute("bwipe! ".l:currentBufNum)
		else
			if buflisted(l:currentBufNum)
				execute("bdelete ".l:currentBufNum)
			endif
		endif
	catch /.*/
		return
	endtry

endfunction

function! BufCloseWindow()
	q
	let l:f=expand("%:t")
	if l:f == "-MiniBufExplorer-"
		exec "normal! \<C-W>j"
	endif
endfunction

"close draft window and quickfix window
function! <SID>BufcloseCloseDraft()
	let l:currentBufNum = bufnr("%")
	let l:alternateBufNum = bufnr("#")
	if buflisted(l:alternateBufNum)
		buffer #
	else
		bnext
	endif
	if bufnr("%") == l:currentBufNum
		new
	endif
	if buflisted(l:currentBufNum)
		try
			execute("bdelete ".l:currentBufNum)
		catch /.*/
			return
		endtry
	endif
endfunction

function! BufPos_ActivateBuffer(num)
	let l:count = 1
	for i in range(1, bufnr("$"))
		if buflisted(i) && getbufvar(i, "&modifiable")
			if l:count == a:num
				exe "buffer " . i
				return
			endif
			let l:count = l:count + 1
		endif
	endfor
	echo "No buffer!"
endfunction

function! BufPos_Initialize()
	for i in range(1, 9)
		exe "nmap " . i . " :b". i ."<CR>"
		"exe "map " . i . " :call BufPos_ActivateBuffer(" . i . ")<CR>"
	endfor
	exe "nmap 0" . " :b10<cr>"
	"exe "map <M-0> :call BufPos_ActivateBuffer(10)<CR>"
endfunction

func! BwipeCurrentBuffer()
	let l:currentBufNum = bufnr("%")
	echo l:currentBufNum
	exec "normal! \<C-o>"
	exec("bwipe ".  l:currentBufNum)
endf

function! CDAbsPath()
	let l:_cmd_ = 'cat ' . g:shmdir.g:whoami.'/filename'
	let l:_resp = system(l:_cmd_)
	exec "cd ".l:_resp
	exec "pwd"
endfunction

function! CDFilePath()
	try
		let g:last_work_path = escape(getcwd(), " ")
		if exists("g:last_work_path")
			let g:last_last_work_path = g:last_work_path
		endif
	catch
		echo v:errmsg
	endtry
	let l:pwd = escape(getcwd(), " ")
	let l:filepath = expand("%:p:h")
	let l:filepath = Escape(l:filepath)
	if l:pwd == g:root_work_path
		echo "cd ".l:filepath
		exec "cd ".l:filepath
	else
		echo "cd ".g:root_work_path
		exec "cd ".g:root_work_path
	endif
endfunction

"http://vim.wikia.com/wiki/Automatically_sort_Quickfix_list
func! s:CompareQuickfixEntries(i1, i2)
	let l:currentBufNum = bufnr('%')
	if bufname(a:i1.bufnr) == bufname(a:i2.bufnr)
	return a:i1.lnum == a:i2.lnum ? 0 : (a:i1.lnum < a:i2.lnum ? -1 : 1)
	else
	if l:currentBufNum == a:i1.bufnr
		return -1
	else
		if l:currentBufNum == a:i2.bufnr
		return 1
		else
		return bufname(a:i1.bufnr) < bufname(a:i2.bufnr) ? -1 : 1
		endif
	endif
	endif
endf

function! CompareTobcFn1()
	let _cmd_ = 'cat '.g:shmdir.'/bcFn1'
	echo _cmd_
	let _resp = system(_cmd_)
	let g:bcFn1 = substitute(_resp, '\n', '', 'g')
	unlet _cmd_
	unlet _resp
	let g:bcFn2 = expand("%:p")
	echo g:bcFn2
	let l:cmd_text = "!bcompare "."\"".g:bcFn1."\""." \"".g:bcFn2."\" \&"
	execute l:cmd_text
	unlet l:cmd_text
endfunction

function! CompileByGcc()
  let l:ext = expand("%:e")
  if (l:ext == "cpp")
	exec "!g++ ".expand("%")
  elseif (l:ext == "c")
	exec "!gcc ".expand("%")
  endif
endfunction

"http://stackoverflow.com/questions/2250011/can-i-have-vim-ignore-a-license-block-at-the-top-of-a-file
function! CreateCopyrightFold()
	let InCopyright = 0
	set foldmethod=manual
	for Line in range(1,line('$'))
		let lineContents = getline(Line)
		if lineContents !~ "^#"
			if InCopyright
				let CopyrightEnd = Line - 1
				exe CopyrightStart . ',' . CopyrightEnd . 'fold'
			endif
			break
		elseif lineContents =~ "Copyright"
			let InCopyright = 1
			let CopyrightStart = Line
		endif
	endfor
endfunction
"au BufRead *.py call CreateCopyrightFold()

function! CscopeSeach()
	let l:w = expand("<cword>")
	let l:c = 'cscope find s '.l:w
	let l:bwn = bufwinnr("%")
	silent! exec l:c
	cclose
	vert copen 45
	exec l:bwn. "wincmd w"
endfunction

function! DeleteSpaceLine()
	normal mo
	let l:r=@/
	exec 'g#^\s*$#d'
	let @/=l:r
	normal `o
endfunction

function! DiffSplitFiles()
	exec "windo diffoff!"
	exec "bufdo diffoff!"
	exec "diffthis"
	exec "set wrap"
	exec "normal! \<C-w>\<C-l>"
	exec "diffthis"
	exec "set wrap"
	exec "normal! \<C-w>\<C-h>"
	exec "diffthis"
	exec "set wrap"
endfunction

function! DoGitBeyondCompare()
	let l:ext = expand("%:e")
	if l:ext == "log"
		call GitDiffLog()
		exec "!p2d.sh ".g:shmdir."/gitdiff.c 1>/dev/null 2>&1 &"
	else
		exec "!p2d.sh ".expand("%")." 1>/dev/null 2>&1 &"
	endif
endfunction

function! Escape(dir)
  " See rules at :help 'path'
  return escape(escape(escape(a:dir, ','), "\\"), ' ')
endfunction

function! EnterSavedPath()
	let l:f=g:shmdir.g:whoami.'/apwdpath'
	if filereadable(l:f)
		let l:c = 'cat ' . g:shmdir.g:whoami.'/apwdpath'
		let l:r = system(l:c)
		let l:r = substitute(l:r, '\n', '', 'g')
		echo "cd ".l:r
		exec "cd ".l:r
	endif
endfunction

function! EditAbsoluteFilePath()
	let l:_cmd_ = 'cat '.g:absfn.'| wc -l'
	let l:ret = system(l:_cmd_)
	if l:ret > 1
		exec "e ".g:absfn
	else
		let l:_cmd_ = 'cat '.g:absfn.'| tr -d "\r" | tr -d "\n"'
		let l:f = system(l:_cmd_)
		"let l:f = "'".escape(l:f, '%')."'"
		let l:f = escape(l:f, '%')
		if filereadable(l:f)
			exec "e ".l:f
		else
			if isdirectory(l:f)
				exec "e ".l:f
			else
				echo "has no file: ". l:f
			endif
		endif
	endif
endfunction

func! EditBashLog()
	let l:f = g:homedir.'/.bash_history'
	if filereadable(l:f)
		exec "e ".l:f
	endif
	let l:f = g:homedir."/tmp/bash_history"
	if filereadable(l:f)
		exec "e ".l:f
	endif
endf

function! EdCommandProxy()
	let l:f = expand("%:t")
	echo l:f
	if (l:f == "scratch" || l:f == "scratch2")
		call EditWorkDiary()
	else
		call EditFileWithRelativePath()
	endif
endfunction

func! EditConfig()
	let l:has_dot_config = 0
	let l:has_arm_config = 0
	if filereadable(".config")
	let l:has_dot_config = 1
	endif
	if isdirectory("arch/arm/configs/")
	let l:has_arm_config = 1
	endif

	if l:has_dot_config && l:has_arm_config
	let l:ans= confirm("1.edit .config; 2.edit arm configs dir?", "&1 for .config \n&2 for arch/arm/configs")
	if l:ans == 1
		e .config
	endif
	if l:ans == 2
		e arch/arm/configs
	endif
	else
	if l:has_arm_config
		e arch/arm/configs
	endif
	if l:has_dot_config
		e .config
	endif
	endif
endf

function! EditCurFileRelaPath()
	let l:_cmd_ = 'cat '.g:shmdir.'/relaFn | tr -d "\r" | tr -d "\n"'
	let l:_resp = system(l:_cmd_)
	if filereadable(l:_resp)
		exec "e ".l:_resp
	else
		echo "has no file ". l:_resp
	endif
endfunction

function! EditFilePath()
	let l:filepath = Escape(expand("%:p:h"))
	execute "e ".l:filepath
endfunction

function! EditFileWithRelativePath()
	let l:f = expand("%")
	let l:df = substitute(l:f, '^/tmp/a/', "", "")
	let l:df = substitute(l:f, '^/tmp/b/', "", "")
	let l:cmd = 'cat 'g:absfn
	let l:r = system(l:cmd)
	let l:r = substitute(l:r, "\r", "", "g")
	let l:r = substitute(l:r, "\n", "", "g")
	let l:df = l:r.'/'.l:f
	echo l:df
	if filereadable(l:df)
		exec "windo diffoff!"
		exec "bufdo diffoff!"
		exec "b ".l:f
		exec "normal! \<C-w>o"
		exec "vert diffsplit ".l:df
		exec "set wrap"
		exec "normal! \<C-w>\<C-l>"
		exec "set wrap"
		exec "normal! \<C-w>\<C-h>"
		exec "normal! \<C-W>L"
		exec "normal! ]c"
	endif
endfunction

function! EditKconfig()
	let l:filepath = expand("%:p:h")
	let l:kconfig = Escape(l:filepath)."/Kconfig"
	if filereadable(l:kconfig)
		execute "e ".l:kconfig
	endif
endfunction

function! EditMakefile()
	let l:filepath = expand("%:p:h")
	let l:makefile = Escape(l:filepath)."/Makefile"
	if filereadable(l:makefile)
		execute "e ".l:makefile
	else
		let l:makefile = Escape(l:filepath)."/Android.mk"
		if filereadable(l:makefile)
			execute "e ".l:makefile
		endif
	endif
endfunction

function! EditQuickfixList()
	if filereadable(g:homedir."/dev/quickfix.txt")
	exe 'e '.g:homedir.'/dev/quickfix.txt'
	else
	exe 'e '.g:shmdir.g:whoami.'/quickfix.txt'
	endif
endfunc

function! EditScratch()
	echo g:homedir
	if filereadable(g:homedir."/tmp/.scratch.swp")
		let l:hasScratchBuf = 0
		for i in range(1,bufnr("$"))
			if buflisted(i)
				"if bufname(i) == g:homedir."/tmp/scratch"
				let l:fn = expand("#".i.":t")
				if l:fn == "scratch"
					let l:hasScratchBuf = 1
				endif
			endif
		endfor
		if l:hasScratchBuf
			let l:fn = g:homedir."/tmp/scratch"
		else
			let l:fn = g:homedir."/tmp/scratch2"
		endif
		exec "e".l:fn
	else
		e $HOME/tmp/scratch
	endif
endfunction

function! EditTmpFile(fn)
	let l:fn = a:fn
	if Is_File_Open_In_Buf(l:fn)
		let l:fn = escape(l:fn, '\\/.*$^~[]')
		call SwitchToBuf(l:fn)
		let g:EditTmpFilePos = line(".")
		"Bclose
		resize 1
		Bwipe
	else
		try
			wincmd j
			if winheight(0) > 2
				sp
				wincmd j
				if winheight(0) > 1
					resize 1
				endif
			else
				resize 1
			endif
			exec "e".l:fn
			resize 1
			exec "norm ".g:EditTmpFilePos."gg"
			resize 1
		catch
			resize 1
			echohl ErrorMsg | echo "Exception: " . v:exception | echo v:errmsg | echohl NONE
		endtry
	endif
endfunction

function! EditWorkDiary()
	let l:f = g:homedir."/tmp/workDiary/diary.txt"
	if filereadable(l:f)
		exec "e ".l:f
	else
		exec "e ".g:homedir."/person_tools/workDiary/diary.txt"
	endif
	exec "norm G"
endfunction

function! EditYankText()
	let l:f = g:shmdir.g:whoami."/yank.txt"
	if filereadable(l:f)
		exec 'e '.l:f
	else
		echo "No file: ".l:f
	endif
endfunction

function! ExecLineText(name, bang)
	let l:ans = confirm("Execute current buffer line in bash?", "&Yes\n&No")
	if l:ans == 1
		"let l:_cmd_ = 'echo "'.l:line.'" >> ~/.bash_history'
		"let _resp = system(l:_cmd_)
		let l:line = getline(".")
		let l:_cmd_ = "bash -i -c 'set -o history;history -s ".l:line."'"
		let _resp = system(l:_cmd_)
		exec ".,.w !sh"
	else
		echo ("cancel Execute current buffer line in bash?")
	endif
endfunction

"http://forum.ubuntu.org.cn/viewtopic.php?f=68&t=343460
"au VimEnter * call VimEnterCallback()
"au BufAdd *.[ch] call FindGtags(expand('<afile>'))
function! FindFiles(pat, ...)
	 let path = ''
	 for str in a:000
		 let path .= str . ','
	 endfor
	 if path == ''
		 let path = &path
	 endif
	 echo 'finding...'
	 redraw
	 call append(line('$'), split(globpath(path, a:pat), '\n'))
	 echo 'finding...done!'
	 redraw
endfunc

function! FindGtags(f)
	let dir = fnamemodify(a:f, ':p:h')
	while 1
		let tmp = dir . '/GTAGS'
		if filereadable(tmp)
			exe 'cs add ' . tmp . ' ' . dir
			break
		elseif dir == '/'
			break
		endif

		let dir = fnamemodify(dir, ":h")
	endwhile
endfunc

function! Getfilename(name, bang)
	let @"= expand("%:p")."\n"
	let @+= expand("%:p")."\n"
	let @*= expand("%:p")."\n"
endfunction

function! GetFileNameTail(name, bang)
	let @"= expand("%:t")."\n"
	let @+= expand("%:t")."\n"
	let @*= expand("%:t")."\n"
endfunction

function! GitDiffLog1()
	let l:firsttag=@g
	let l:secondtag = expand("<cword>")
	let l:_cmd_ = 'git diff '.l:firsttag.' '.l:secondtag.' > gitdiff.c'
	let _resp = system(l:_cmd_)
endfunc

function! GoNextBuffer()
	if &diff
		exec "normal ]c"
	else
		bn
		let l:c = 0
		while ( ( (expand("%:p") == "") && (l:c < 20) ) || (&ft == 'qf') )
			bn
			let l:c = l:c + 1
		endwhile
	endif
endfunction

function! GoPreBuffer()
	if &diff
		exec "normal [c"
	else
		bp
		let l:c = 0
		while ((expand("%:p") == "") && (l:c < 20) || (&ft == 'qf') )
			bp
			let l:c = l:c + 1
		endwhile
	endif
endfunction

function! GoPreQuickfix()
	cp
endfunction

function! GoNextQuickfix()
	cn
endfunction

function! GrepCurWordInCurDir()
	exec "norm "."mP"
	let l:bwn = bufwinnr("%")
	let l:lastpwd = escape(getcwd(), " ")
	let l:filepath = expand("%:p:h")
	let l:filepath = Escape(l:filepath)
	"echo "cd ".l:filepath
	exec "cd ".l:filepath
	let l:w = expand("<cword>")
	let l:w = substitute(l:w, '\n', '', 'g')
	let l:c = 'm.sh '.l:w
	let l:_resp = system(l:c)
	call ReadQuickfixFile(0)
	cclose
	vert copen 45
	exec l:bwn. "wincmd w"
	exec "norm "."`P"
endfunction

"http://www.vimer.cn/2010/01/饭前甜点-vimgvim自动在cpp文件中添加-h文件包含.html
function! InsertIncludeFileI(is_system_include_file)
	let sourcefilename=expand("%:t")
	let outfilename=substitute(sourcefilename,'\(\.[^.]*\)$','.h','g')
	if a:is_system_include_file
		call setline('.','#include <'.outfilename.'>')
	else
		call setline('.','#include "'.outfilename.'"')
endfunction

function! InsertYankText()
	let l:f = g:shmdir.g:whoami."/yank.txt"
	if filereadable(l:f)
		let l:l = readfile(l:f, '')
		call append('.', l:l)
	endif
endfunction

"http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
function! Is_File_Open_In_Buf(fn)
	let l:is_fn_visual = 0
	let l:fn = a:fn
	try
		for i in range(1, bufnr("$"))
			if buflisted(i)
				if bufname(i) == l:fn
					let  l:is_fn_visual = 1
					break
				endif
			endif
		endfor
	catch
		echohl ErrorMsg | echo "Exception: " . v:exception | echo v:errmsg | echohl NONE
		return l:is_fn_visual
	endtry
	return l:is_fn_visual
endfunction
function! Is_File_Visual_In_Buf(fn)
	let l:is_fn_visual = 0
	let l:fn = a:fn
	redir => l:buflist
	silent! ls
	redir END
	"for bufnum in filter(split(g:buflist, '\n'), 'v:val =~ "Quickfix List"')
	""let g:mynr = str2nr(matchstr(bufnum, "\\d\\+"))
	"let l:is_fn_visual = 1
	"endfor
	"http://rickey-nctu.blogspot.com/2009/02/vim-quickfix.html
	"echohl l:buflist
	try
		let l:fn = escape(l:fn, '\\/.*$^~[]')
		if match(l:buflist, l:fn) != -1
			let l:is_fn_visual = 1
		endif
	catch
		echohl ErrorMsg | echo "Exception: " . v:exception | echo v:errmsg | echohl NONE
		return l:is_fn_visual
	endtry
	return l:is_fn_visual
endfunction

func! LookupFullFilenameTag(line, bang)
	let g:use_LookupFile_FullNameTagExpr = 1
	exec "LUTags"
endf

function! LookupFuncIgnoreCase(pattern)
	let _tags = &tags
	try
		if g:use_LookupFile_FullNameTagExpr == 1
			let &tags = eval(g:LookupFile_FullNameTagExpr)
			let newpattern = a:pattern
		else
			let &tags = eval(g:LookupFile_TagExpr)
			let newpattern = '\c' . a:pattern
		endif
			let newpattern = '\c' . a:pattern
		echom &tags
		"let g:mytag = &tags
		let tags = taglist(newpattern)
	catch
		echohl ErrorMsg | echo "Exception: " . v:exception | echohl NONE
		return ""
	finally
		let &tags = _tags
	endtry

	" Show the matches for what is typed so far.
	let files = map(tags, 'v:val["filename"]')
	"let g:use_LookupFile_FullNameTagExpr = 0
	return files
endfunction

func! LookupPartFilenameTag(line, bang)
	let g:use_LookupFile_FullNameTagExpr = 0
	exec "LUTags"
endf

function! MakeSession(name, bang)
	if isdirectory(g:shmdir.g:whoami)
		let l:cmd = "mks! ".g:shmdir.g:whoami."/edit.vim"
	else
		let l:cmd = "mks! ".g:shmdir."/edit.vim"
	endif
	exec l:cmd
endfunction

function! MakeSessionInCurDir(name, bang)
	let l:cmd = "mks! edit.vim"
	exec l:cmd
endfunction

function! MultiGrepCurWord(name, bang)
	exec "norm "."mP"
	let l:cmd = "m.sh ".expand("<cword>")
	let l:bwn = bufwinnr("%")
	let l:_resp = system(l:cmd)
	"silent! exec l:cmd
	call ReadQuickfixFile(0)
	vert copen 45
	exec l:bwn. "wincmd w"
	exec "norm "."`P"
endfunction

function! OpenQuickfixBuf()
	if ((&ft == 'qf') && (bufname("%") == ""))
		let l:wn = winnr()
		wincmd h
		let l:h_wn = winnr()
		wincmd l
		if (l:wn == l:h_wn)
			let l:linenr = line('.')
			cclose
			vert copen 45
			exec "norm ".l:linenr."gg"
		else
			exec "normal! \<C-W>J"
			exec "normal! 10\<C-W>_"
		endif
	else
		vert copen 45
	endif
endfunction

func! ParseFilenameTag(line, bang)
	let l:line = getline('.')
	let l:col = col('.')
	let l:filename=""

	if has("python")
python << EEOOFF
import vim
line = vim.eval("l:line")
col = (int)(vim.eval("l:col")) - 1
filename = ""
print col
if line == "":
	print "error"
else:
	ll = len(line)
	index = 0
	index1 = 0
	index2 = 0
	index = line.find('#include')
	if (index != -1):
		index1 = line.find('"', index)
		if (index1 != -1):
			if line[index1 + 1] == '.':
				while line[index1 + 1] == '.':
					index1 += 1
				if line[index1 + 1] == '/':
					index1 += 1
			index2 = line.find('"', index1+1)
			filename = line[index1+1:index2]
		else:
			index1 = line.find('<', index)
			if (index1 != -1):
				index2 = line.find('>', index1+1)
				filename = line[index1+1:index2]
		vim.command("let l:filename = \'%s\'"%(filename))
	else:
		vim.command('let l:filename = expand("<cword>")')
		#filename = vim.eval("l:filename")
EEOOFF
endif
	let g:use_LookupFile_FullNameTagExpr = 1
	if l:filename == ""
	    let l:filename = expand("<cword>")
	endif
	exec "LUTags ".l:filename
endf

"au! CursorHold *.[ch] nested call PreviewWord()
func! PreviewWord()
  if &previewwindow			" don't do this in the preview window
    return
  endif
  let w = expand("<cword>")		" get the word under cursor
  if w =~ '\a'			" if the word contains a letter

    " Delete any existing highlight before showing another tag
    silent! wincmd P			" jump to preview window
    if &previewwindow			" if we really get there...
      match none			" delete existing highlight
      wincmd p			" back to old window
    endif

    " Try displaying a matching tag for the word under the cursor
    try
       exe "ptag " . w
    catch
      return
    endtry

    silent! wincmd P			" jump to preview window
    if &previewwindow		" if we really get there...
	 if has("folding")
	   silent! .foldopen		" don't want a closed fold
	 endif
	 call search("$", "b")		" to end of previous line
	 let w = substitute(w, '\\', '\\\\', "")
	 call search('\<\V' . w . '\>')	" position cursor on match
	 " Add a match highlight to the word at this position
      hi previewWord term=bold ctermbg=green guibg=green
	 exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
      wincmd p			" back to old window
    endif
  endif
endfun

function! Python4CompareToFileName()
	if has("python")
	"learn use python in vim script from autotag.vim
python << EEOOFF
import fileinput
import vim
try:
	input = fileinput.FileInput(g:shmdir."/bcFn1")
	bcFn1 = input.readline()
	vim.command("let g:bcFn1=%s" % bcFn1)
finally:
	input.close()
EEOOFF
	endif
    let l:cmd_text = "!bcompare "."\"".g:bcFn1."\""." \"".g:bcFn2."\" \&"
    echo g:bcFn2
    execute l:cmd_text
	unlet l:cmd_text
endfunction

func! QuitAllBuffers_key()
	"http://rickey-nctu.blogspot.com/2009/02/vim-quickfix.html
	redir => l:buflist
	silent! ls
	redir END
	if match(l:buflist, "\\d\\+.*\+") != -1
	echo "has modified"
	let l:ans = confirm("Save all and quit ?", "&Yes\n&No")
	if l:ans == 1
		exec "wqa"
	endif
	else
	exec "qa"
	endif
endf

func! QuickfixToggle()
	let l:bwn = bufwinnr("%")
	if Is_File_Visual_In_Buf("[Quickfix List")
		cclose
	else
		call OpenQuickfixBuf()
	endif
	exec l:bwn. "wincmd w"
endf

func! QuitAllBuffers()
	let l:has_modified_buffer = 0
	for i in range(1, bufnr("$"))
	if buflisted(i)
		try
		exec "b".i
		catch
		continue
		endtry
		if  &modified != 0
		let l:has_modified_buffer = 1
		endif
	endif
	endfor
	if l:has_modified_buffer != 0
	let l:ans = confirm("Save all and quit ?", "&Yes\n&No")
	if l:ans == 1
		exec "wqa"
	endif
	else
	"let l:ans = confirm("Quit all buf ?", "&Yes\n&No")
	if isdirectory(g:shmdir.g:whoami)
		let l:cmd = "mks! ".g:shmdir.".g:whoami."/edit.vim"
		exec l:cmd
	endif
	exec "qa"
	endif
endf

func! QuitAllBuffersWithoutSaving()
	let l:has_modified_buffer = 0
	for i in range(1, bufnr("$"))
		if buflisted(i)
			try
			exec "b".i
			catch
			continue
			endtry
			if  &modified != 0
			let l:has_modified_buffer = 1
			endif
		endif
	endfor
	if l:has_modified_buffer != 0
		let l:ans = confirm("Quit all buffer without saving ?", "&Yes\n&No")
		if l:ans == 1
			exec "qa!"
		endif
	endif
endf

func! QuifixBufReadPost_Process()
	let qflist = getqflist()
	if len(qflist) == 0
		if exists("g:Quickfix_uniqedList")
			call setqflist(g:Quickfix_uniqedList)
		endif
	endif
	"if Is_File_Visual_In_Buf("[Quickfix List")
		"cclose | vert copen 45
	"endif
	exec "normal! \<C-W>L"
	exec "normal! 45\<C-W>|"
endf

function! ReadDate()
	exec 'r !echo "date: $(LANG=en.UTF-8 date +\%Y/\%m/\%d\ \%a\ \%r)"'
endfunction

function! ReadQuickfixFile(onlyOneWindow)
	if filereadable(g:homedir."/dev/quickfix.txt")
		"exe 'cg '.g:homedir.'/dev/quickfix.txt'
		let l:_resp = system('rsync -avurP ' .g:homedir.'/dev/quickfix.txt '.g:shmdir.'/karlzheng/quickfix.txt')
		let l:_resp = system('rsync -avurP '.g:homedir.'/karlzheng/quickfix.txt' .g:homedir.'/dev/quickfix.txt')
	endif
	exe 'cg '.g:shmdir.g:whoami.'/quickfix.txt'
	call OpenQuickfixBuf()
	if a:onlyOneWindow
		exec "normal \<c-w>\<c-o>"
	endif
endfunc

" Rename.vim - Copyright June 2007 by Christian J. Robinson <heptite@gmail.com>
function! Rename(name, bang)
	let l:curfile = expand("%:p")
	let v:errmsg = ""
	silent! exe "saveas" . a:bang . " " . a:name
	if v:errmsg =~# '^$\|^E329'
		if expand("%:p") !=# l:curfile && filewritable(expand("%:p"))
			silent exe "bwipe! " . l:curfile
			if delete(l:curfile)
				echoerr "Could not delete " . l:curfile
			endif
		endif
	else
		echoerr v:errmsg
	endif
endfunction

func! ReplaceFilePath4fp()
	let l:line = getline(".")
	let l:aRegex = '$(fp)'
	let l:findstr = matchstr(l:line, l:aRegex)
	if l:findstr != ""
		echo "got it"
		let l:f = g:absfn
		if filereadable(l:f)
			let l:l = readfile(l:f, '', 1)
			let l:str = l:l[0]
			let l:line = substitute(l:line, '$(fp)', l:str, "")
			call setline(".", l:line)
		endif
	endif
endf

func! ReplaceMyUserName()
	let l:line = getline(".")
	let l:line = substitute(l:line, 'ssh://.*@', 'ssh://kangliang.zkl@', "")
	let l:line = substitute(l:line, 'http://.*@', 'http://kangliang.zkl@', "")
	call setline(".", l:line)
endfunction

function! SaveAbsPathFileName()
	let l:f = expand("%:p")
	if (l:f != "")
		let l:_cmd_ = 'echo "' . l:f . '" > ' . g:absfn
		let l:_resp = system(l:_cmd_)
	else
		echo "Current file is noname."
	endif
endfunction

function! SaveBCFn1()
	let str = expand("%:p")
	let str = Escape(str)
	execute ":!echo '".str."' > ".g:shmdir."/bcFn1"
endfunction

function! SaveCurrentFileName()
	let l:str = expand("%:p")
	let l:str = Escape(str)
	let @* = l:str
	let @+ = '"'.l:str.'"'
	execute ":!echo '".l:str."' > ".g:shmdir."/filename"
endfunction

function! SaveFile2Tar()
	let l:f = expand("%")
	let l:_cmd_ = 'tar cf /tmp/file.tar "'. l:f .'"'
	let l:_resp = system(l:_cmd_)
endfunction

function! SaveFilePath()
	let l:f = expand("%:p:h")
	let l:f = Escape(f)
	if (l:f != "")
		let l:_cmd_ = 'echo ' . '"' . l:f . '" > '.g:shmdir.g:whoami.'/apwdpath'
		let l:_resp = system(l:_cmd_)
	else
		echo "Current file is noname."
	endif
endfunction

"http://vim.1045645.n5.nabble.com/Saving-the-Quickfix-List-td1179523.html
function! SaveQuickfixToFile()
	let l:qflist = getqflist()
	let l:qf_data_list = []
	for i in range(len(l:qflist))
	if has_key(l:qflist[i], 'bufnr')
		if l:qflist[i].bufnr != 0
		let l:tmp_str = ""
		let l:tmp_str = fnamemodify(bufname(l:qflist[i].bufnr), ':p').":"
		let l:tmp_str = l:tmp_str.string(l:qflist[i].lnum).":"
		let l:tmp_str = l:tmp_str.l:qflist[i].text
		call add(l:qf_data_list, l:tmp_str)
		endif
	endif
	endfor
	call writefile(l:qf_data_list, g:shmdir.g:whoami."/quickfix.txt")
	if ! isdirectory(g:homedir)
	call writefile(l:qf_data_list, g:homedir."/quickfix.txt")
	endif
	if filereadable(g:homedir.'/dev/quickfix.txt')
	call writefile(l:qf_data_list, g:homedir."/dev/quickfix.txt")
	endif
endfunc

function! SaveYankText()
	let l:lines = []
	"let l:line = getline(".")
	let l:w = expand("<cword>")
	call add(l:lines, l:w)
	call writefile(l:lines, g:shmdir.g:whoami."/yank.txt")
	"exec 'norm yy"+yy"*yy'
	exec 'norm "+yw"*yw'
endfunction

function! SaveYankTextInVisual()
	let l:fl = line("'<")
	let l:ll = line("'>")
	silen exec 'norm gvy'
	let l:lines = getline(l:fl, l:ll)
	let @*=@"
	let @+=@"
	call writefile(l:lines, g:shmdir.g:whoami."/yank.txt", "b")
endfunction

function! SaveRelaPathFileName()
	let l:f = expand("%:")
	if (l:f != "")
		let l:f = substitute(l:f, '^/tmp/a/', "", "")
		let l:f = substitute(l:f, '^/tmp/b/', "", "")
		let l:f = substitute(l:f, '^a/', "", "")
		let l:f = substitute(l:f, '^b/', "", "")
		"let l:_cmd_ = 'echo ' . '"' . l:f . '" > '.g:shmdir.'/relaFn'
		let l:_cmd_ = 'echo ' . '"' . l:f . '" > g:absfn
		let l:_resp = system(l:_cmd_)
	else
		echo "Current file is noname."
	endif
endfunction

"http://www.2cto.com/os/201109/103898.html
function! Sdcv(word, bang)
	if (a:word == "")
		"let expl=system('sdcv -n ' . expand("<cword>") . '| fold -s -w 45')
		let expl=system('dict ' . expand("<cword>") . '| fold -s -w 45')
	else
		"let expl=system('sdcv -n ' . a:word . '| fold -s -w 45')
		let expl=system('dict ' . a:word . '| fold -s -w 45')
	endif
	"call PythonProcessLnText(expl)
	let l:currentBufNum = bufnr("%")
	let l:is_exist_dict_tmp = 0
	let l:BufNum = 0
	for i in range(1,bufnr("$"))
		if buflisted(i)
			if bufname(i) == "diCt-tmp" && l:currentBufNum != i && bufname(l:currentBufNum) != g:homedir."/.stardict/iremember/tofel.txt"
				"if bufname(i) == "diCt-tmp" && l:currentBufNum != i
				let l:is_exist_dict_tmp = 1
				let l:BufNum = i
			endif
		endif
	endfor
	if (l:is_exist_dict_tmp == 1)
		execute("bdelete ".l:BufNum)
	else
		windo if expand("%")=="diCt-tmp" | q! | endif
		exec "bel 50 vs diCt-tmp"
		"exec "bel 50 sp diCt-tmp"
		setlocal buftype=nofile bufhidden=hide noswapfile textwidth=50
		1s/^/\=expl/
		3
	endif
	call SwitchToBuf(bufname(l:currentBufNum))
	if bufname(l:currentBufNum) == g:homedir."/.stardict/iremember/tofel.txt"
		"exec "b".l:currentBufNum
		"call SwitchToBuf(bufname(l:currentBufNum))
	endif
endfunction

func! SepLineToWord()
	let l:line = getline(".")
	let l:line = substitute(l:line, ':', ' ', "g")
	call setline(".", l:line)
	"exec 'g/\s/exe 's//\r/g''
	exec "s/\\s/\r/g"
endfunction

function! SetCFileTabStop()
	if isdirectory(g:root_work_path."/arch/arm/configs")
		set shiftwidth=8
		set tabstop=8
	else
		set shiftwidth=4
		set tabstop=4
	endif
	set iskeyword-=-,>()
	set fo-=l
	set textwidth=80
endfunction

function! SetColorColumn()
	let col_num = virtcol(".")
	let cc_list = split(&cc, ',')
	if count(cc_list, string(col_num)) <= 0
		execute "set cc+=".col_num
	else
		execute "set cc-=".col_num
	endif
endfunction

function! SetColorColumnC80()
	let col_num = 80
	let cc_list = split(&cc, ',')
	if count(cc_list, string(col_num)) <= 0
		execute "set cc+=".col_num
	else
		execute "set cc-=".col_num
	endif
endfunction

function! SetLineNumber()
	"for i in range(0,15)
		"call setline(line('.')+i, i.' '.getline(line('.')+i))
	"endfor
endfunction

function! ShowGitDiffInBcompare()
	call GitDiffLog()
	exec "!p2d.sh ".g:shmdir."/gitdiff.c 1>/dev/null 2>&1 &"
	call SwitchToBuf("gitdiff.c")
	q
	let l:f=expand("%:t")
	if l:f == "-MiniBufExplorer-"
		exec "normal! \<C-W>j"
	endif
	let l:f=expand("%:t")
	if l:f == "__Tag_List__"
		exec "normal! \<C-W>l"
	endif
endfunc

function! ShowGitDiffInKompare()
	call GitDiffLog()
	exec "!kompare ".g:shmdir."/gitdiff.c 1>/dev/null 2>&1 &"
	call SwitchToBuf("gitdiff.c")
	q
	let l:f=expand("%:t")
	if l:f == "-MiniBufExplorer-"
		exec "normal! \<C-W>j"
	endif
	let l:f=expand("%:t")
	if l:f == "__Tag_List__"
		exec "normal! \<C-W>l"
	endif
endfunc

function! SourceSession(name, bang)
	if isdirectory(g:shmdir.g:whoami)
		let l:cmd = "source ".g:shmdir.g:whoami."/edit.vim"
		exec l:cmd
	endif
endfunction

function! SourceSessionInCurDir(name, bang)
	let l:cmd = "source edit.vim"
	exec l:cmd
endfunction

func! SortUniqQFList()
	let sortedList = sort(getqflist(), 's:CompareQuickfixEntries')
	let uniqedList = []
	let last = ''
	for item in sortedList
		let this = bufname(item.bufnr) . "\t" . item.lnum
		if this !=# last
			call add(uniqedList, item)
			let last = this
		endif
	endfor
	let g:Quickfix_uniqedList = uniqedList
	if len(g:Quickfix_uniqedList) == 1
		call setqflist(uniqedList)
	else
		call setqflist([])
	endif
	"exec "vert copen 45"
endf

" From an idea by Michael Naumann
function! SpecialVisualSearch(direction, is_VisualSearch)
	"execute "set hls"
	let l:saved_reg = @"
	if a:is_VisualSearch
		execute "normal! vgvy"
	else
		execute "normal! yiw"
	endif
	let l:pattern = escape(@", '\\/.*$^~[]')
	let l:pattern = substitute(l:pattern, "\n$", "", "")
	if a:direction == 'b'
		"exec "normal ?" . l:pattern."?"
		execute "normal ?" . l:pattern . "^M"
		"exec "normal ?"
		"exec "normal! N"
		"call search(l:pattern, 'bn')
	else
		exec "normal! /" . l:pattern
		"exec "normal! N"
		"call search(l:pattern, 'n')
	endif
	let @/ = l:pattern
	let @" = l:saved_reg
endfunction

function! SvnDiffCurrentFile()
	if isdirectory('.svn')
		exec "!svn diff %"
	else
		exec "!git diff %"
	endif
endfunc

function! SvnRevertCurrentFile()
	if isdirectory('.svn')
		exec "!svn revert %"
	else
		exec "!git checkout %"
	endif
endfunc

" Switch to buffer according to file name
function! SwitchToBuf(filename)
	"let fullfn = substitute(a:filename, "^\\~/", $HOME . "/", "")
	" find in current tab
	let bufwinnr = bufwinnr(a:filename)
	if bufwinnr != -1
		exec bufwinnr . "wincmd w"
		return
	else
		" find in each tab
		"tabfirst
		"let tab = 1
		"while tab <= tabpagenr("$")
			"let bufwinnr = bufwinnr(a:filename)
			"if bufwinnr != -1
				"exec "normal " . tab . "gt"
				"exec bufwinnr . "wincmd w"
				"return
			"endif
			"tabnext
			"let tab = tab + 1
		"endwhile
		" not exist, new tab
		"exec "tabnew " . a:filename
		exec "e " . a:filename
	endif
endfunction

"http://vim.wikia.com/wiki/VimTip431
function! ToggleSlash(independent) range
  let from = ''
  for lnum in range(a:firstline, a:lastline)
    let line = getline(lnum)
    let first = matchstr(line, '[/\\]')
    if !empty(first)
      if a:independent || empty(from)
        let from = first
      endif
      let opposite = (from == '/' ? '\' : '/')
      call setline(lnum, substitute(line, from, opposite, 'g'))
    endif
  endfor
endfunction
command! -bang -range ToggleSlash <line1>,<line2>call ToggleSlash(<bang>1)
noremap <silent> <F7> :ToggleSlash<CR>

function! VimEnterCallback()
	 for f in argv()
		 if fnamemodify(f, ':e') != 'c' && fnamemodify(f, ':e') != 'h'
			 continue
		 endif
		 call FindGtags(f)
	 endfor
endfunc

function! UpdateCscope()
	let l:curfile = expand("%")
	let l:command="!echo " . l:curfile . " >> modify.files"
	exec l:command
	let l:command="!cscope -bkq -f newcscope.out -i modify.files"
	exec l:command
	:cs reset
endfunction

function! UpdateGtags(f)
	let l:root_gtags_file=g:root_work_path . "/GTAGS"
	if filereadable(l:root_gtags_file) && filereadable("/usr/bin/gtags")
		let dir = fnamemodify(a:f, ':p:h')
		exe 'silent !cd ' . dir . ' && global -u &> /dev/null &'
	endif
endfunction
"au BufWritePost *.c,*.h,*.hpp,*.cpp,*.java call UpdateGtags(expand('<afile>'))

"http://vim.wikia.com/wiki/Autocmd_to_update_ctags_file
function! UpdateTags()
	let l:f = expand("%:p")
	let l:_cmd_ = '"ctags -a --c++-kinds=+p --fields=+iaS --extra=+q " ' . '"' . l:f . ' & "'
	let l:_resp = system(l:_cmd_)
	if g:use_gtags && filereadable("/usr/bin/gtags")
		exec ':silent !global -u > /dev/null 2>&1 &'
	endif
endfunction

if &diff
	set wrap
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

filetype plugin indent on
let g:searchfold_do_maps = 0
"让Vim在图形界面与终端中的Alt组合键相同
"http://lilydjwg.is-programmer.com/posts/23574.html
let g:EchoFuncKeyPrev="-"
let g:EchoFuncKeyNext="="
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                   colorcolumn setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"http://www.vimer.cn/2012/05/vimgvim支持对齐线.html
let g:indent_guides_guide_size = 1

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                     color scheme setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Colorsheme Scroller, http://www.vim.org/scripts/script.php?script_id=1488
"map <silent><F2> :NEXTCOLOR<cr>
"map <silent><F3> :PREVCOLOR<cr>
if has("gui_running")
	colorscheme borland
	"colorscheme breeze
	"colorscheme 256_adaryn
	"hi normal guibg=#294d4a
else
	colorscheme 256_adaryn
	"colorscheme blue2
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"                       taglist setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:Tlist_Show_One_File = 1
let tlist_txt_settings = 'txt;c:content;f:figures;t:tables'
if MySys() == "windows"
	let Tlist_Ctags_Cmd = 'ctags'
elseif MySys() == "linux"
	let Tlist_Ctags_Cmd = 'ctags'
endif
let Tlist_Exit_OnlyWindow = 1
let Tlist_Use_Right_Window = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" ctags
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if filereadable("/usr/include/tags")
	set tags=/usr/include/tags
endif
if filereadable("./tags")
	let mytags="tags+=" . "./tags"
	if filereadable("./newtags")
		let mytags=mytags . ",./newtags"
	endif
	exe "set " . mytags
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" cscope && gtags
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if g:use_gtags && filereadable("/usr/bin/gtags")
	let g:Gtags_OpenQuickfixWindow = 1
	set cscopeprg=gtags-cscope
	"set cscopequickfix=c-,d-,e-,f-,g0,i-,s-,t-
	"cs add GTAGS
	let s:mycstags="cs add " . getcwd() . "/GTAGS"
	exe s:mycstags
else
	if filereadable("cscope.out")
		let s:mycstags="cs add " . "cscope.out "
		exe s:mycstags
	endif
	if filereadable("newcscope.out")
		let s:mycstags="cs add " . "newcscope.out"
		exe s:mycstags
	endif
endif

if has("cscope")
	"nmap {c :cscope find c <cword><CR>
	nmap <expr><silent> [c (&diff ? "[c" : ":cscope find c <cword><CR>")
	nnoremap <silent> [a :call MultiGrepCurWord("", "")<cr><cr>
	nnoremap [w :call GrepCurWordInCurDir()<cr>
	nmap [d :cscope find d <cword><CR>
	nmap [e :cscope find e <cword><CR>
	nmap [f :cscope find f <cword><CR>
	nmap [g :cscope find g <cword><CR>
	nmap [i :cscope find i <cword><CR>
	nmap [I :cscope find i %:t<CR>
	"nmap [s :cscope find s <cword><CR><c-q><cr><c-q><cr>
	nmap [s :call CscopeSeach()<CR>
	nmap [t :cscope find t <cword><CR>
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" SrcExpl settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:SrcExpl_isUpdateTags = 0
let g:SrcExpl_gobackKey = ""
let g:SrcExpl_pluginList = ["Source_Explorer"]

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" lookupfile setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:LookupFile_LookupFunc = 'LookupFuncIgnoreCase'
let g:LookupFile_MinPatLength = 4
let g:LookupFile_PreserveLastPattern = 1
let g:LookupFile_PreservePatternHistory = 1
let g:LookupFile_AlwaysAcceptFirst = 1
let g:LookupFile_AllowNewFiles = 0
let g:LookupFile_UsingSpecializedTags = 1
let g:LookupFile_Bufs_LikeBufCmd = 0
let g:LookupFile_ignorecase = 1
let g:LookupFile_smartcase = 1
let g:use_LookupFile_FullNameTagExpr = 0
if filereadable("./filenametags")
	let g:LookupFile_TagExpr = '"./filenametags"'
endif
if filereadable("./fullfilenametags")
	let g:LookupFile_FullNameTagExpr = '"./fullfilenametags"'
endif

"nmap <silent> <leader>lf :LUTags <C-R>=expand("<cword>")<cr><cr>
"nmap <silent> <leader>lt :LUTags<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" winmanager setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:winManagerWindowLayout = "TagList|FileExplorer,BufExplorer"
let g:winManagerWindowLayout = "FileExplorer,BufExplorer"
let g:winManagerWidth = 30
let g:defaultExplorer = 0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" netrw setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:netrw_winsize = 30

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" file explorer setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"Split vertically
let g:explVertical=1

"Window size
let g:explWinSize=35

let g:explSplitLeft=0
let g:explSplitRight=1
let g:explSplitBelow=1

"Hide some files
"let g:explHideFiles='^\.,.*\.class$,.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'
"let g:explHideFiles='.*\.swp$,.*\.pyc$,.*\.swo$,\.DS_Store$'
let g:explHideFiles=''

"Hide the help thing..
let g:explDetailedHelp=0

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" showmarks setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable ShowMarks
"let showmarks_enable = 1
let showmarks_enable = 0
" Show which marks
let showmarks_include = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
" Ignore help, quickfix, non-modifiable buffers
let showmarks_ignore_type = "hqm"
" Hilight lower & upper marks
let showmarks_hlline_lower = 1
let showmarks_hlline_upper = 1

hi ShowMarksHLl ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi ShowMarksHLu ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black
hi ShowMarksHLo ctermbg=Yellow   ctermfg=Black  guibg=#FFDB72    guifg=Black
hi ShowMarksHLm ctermbg=Magenta  ctermfg=Black  guibg=#FFB3FF    guifg=Black

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" mark setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <silent> <leader>hl <Plug>MarkSet
vmap <silent> <leader>hl <Plug>MarkSet
nmap <silent> <leader>hh <Plug>MarkClear
vmap <silent> <leader>hh <Plug>MarkClear
nmap <silent> <leader>hr <Plug>MarkRegex
vmap <silent> <leader>hr <Plug>MarkRegex

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" minibuffer setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let loaded_minibufexplorer = 1         " *** Enable minibuffer plugin
let g:miniBufExplorerMoreThanOne = 0   " Display when more than 2 buffers
let g:miniBufExplSplitToEdge = 1       " Always at top
let g:miniBufExplMaxSize = 3           " The max height is 3 lines
let g:miniBufExplMinSize = 1

"let g:miniBufExplMapWindowNavVim = 1   " map CTRL-[hjkl]
let g:miniBufExplUseSingleClick = 1    " select by single click
let g:miniBufExplModSelTarget = 1      " Dont change to unmodified buffer
"let g:miniBufExplForceSyntaxEnable = 1 " force syntax on
"let g:miniBufExplVSplit = 25
"let g:miniBufExplSplitBelow = 0


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" bufexplorer setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:bufExplorerDefaultHelp=1       " Do not show default help.
let g:bufExplorerShowRelativePath=1  " Show relative paths.
let g:bufExplorerSortBy='mru'        " Sort by most recently used.
let g:bufExplorerSplitRight=1        " Split right.
let g:bufExplorerSplitVertical=1     " Split vertically.
let g:bufExplorerSplitVertSize=3  " Split width
let g:bufExplorerUseCurrentWindow=1  " Open in new window.
let g:bufExplorerMaxHeight=240        " Max height


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" pre defined of macro of key strobe actions.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let @m=":s#^#//#,nl"
let @n=":s#^//##,nl"
let @s=":s/^/#/,nl"


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" misc of .vimrc; useless.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
func! PythonProcessLnText(expl)
	if has("python")
	"learn use python in vim script from autotag.vim
python << EEOOFF
import vim
def process_line_text(text):
	print text
process_line_text(vim.eval("a:expl"))
EEOOFF
	endif
endf

"!cat /dev/shm/bcFn1 | python -c "import sys,fileinput as f;[sys.stdout.write(str(f.lineno())+a) for a in f.input()]"

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" User defined commands
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command! -nargs=* -complete=file -bang ExecLineText :call ExecLineText("<args>", "<bang>")
command! -nargs=+ -complete=dir FindFiles :call FindFiles(<f-args>)
command! -nargs=* -complete=file -bang Getfilename :call Getfilename("<args>", "<bang>")
command! -nargs=* -complete=file -bang GetFileNameTail :call GetFileNameTail("<args>", "<bang>")
command! -nargs=* -complete=tag -bang LookupFullFilenameTag :call LookupFullFilenameTag("<args>", "<bang>")
command! -nargs=* -complete=tag -bang LookupPartFilenameTag :call LookupPartFilenameTag("<args>", "<bang>")
command! -nargs=* -complete=file -bang MK :call MakeSession("<args>", "<bang>")
command! -nargs=* -complete=file -bang G :call MultiGrepCurWord("<args>", "<bang>")
command! -nargs=* -complete=file -bang MC :call MakeSessionInCurDir("<args>", "<bang>")
command! -nargs=* -complete=tag -bang ParseFilenameTag :call ParseFilenameTag("<args>", "<bang>")
command! -nargs=* -complete=file -bang P2d :!p2d.sh %
command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")
command! -nargs=* -complete=file -bang SS :call SourceSession("<args>", "<bang>")
command! -nargs=* -complete=tag -bang Sdcv :call Sdcv("<args>", "<bang>")
command! -nargs=* -complete=file -bang SC :call SourceSessionInCurDir("<args>", "<bang>")

command! Bclose call <SID>BufcloseCloseIt(0)
command! BcloseDraft call <SID>BufcloseCloseDraft()
command! BcloseOthers call <SID>BufCloseOthers()
command! Bwipe  call <SID>BufcloseCloseIt(1)
command! CG call ReadQuickfixFile(1)
command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
command! EditAbsoluteFilePath call EditAbsoluteFilePath()

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" normal mode key remap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap ,, ,
nnoremap - "_dd

" ALT + hjkl
if has("gui_running")
	nnoremap <silent> ê 1<C-w>+
	nnoremap <silent> ë 1<C-w>-
	nnoremap <silent> è 1<C-W><
	nnoremap <silent> ì 1<C-W>>
else
	nnoremap <silent> j 1<C-w>+
	nnoremap <silent> k 1<C-w>-
	nnoremap <silent> h 1<C-W><
	nnoremap <silent> l 1<C-W>>
	nnoremap <silent> J 1<C-W>+
	nnoremap <silent> K 1<C-W>-
	nnoremap <silent> H 1<C-W><
	nnoremap <silent> L 1<C-W>>

	nnoremap <silent> n :cn<cr>
	nnoremap <silent> p :cp<cr>
endif

nnoremap <silent> ,1ea :1sp<cr>:call EditAbsoluteFilePath()<cr>
nnoremap <silent> ,32 f vt "xx$"xp
nnoremap <cr> :nohl<cr><cr>
nnoremap <leader>ac :call EnterSavedPath()<cr>
nnoremap <silent> <leader>al :call AddDebugLine()<cr>
nnoremap <leader>ap :call SaveFilePath()<cr>
nnoremap <silent> <leader>ba :call SaveBCFn1()<cr><cr>
nnoremap <silent> <leader>bb :call CompareTobcFn1()<cr><cr>
nnoremap <silent> <leader>bc :call Python4CompareToFileName()<cr><cr>
nnoremap <leader>bd :Bclose<cr>
nnoremap <leader>bw :Bwipe<cr>
nnoremap <silent> <leader>c8 :call SetColorColumnC80()<CR>
"nnoremap <leader>cc :botright lw 10<cr>
nnoremap <leader>cd :call CDFilePath()<cr>
nnoremap <silent> <leader>ch :call SetColorColumn()<CR>
nnoremap <silent> <leader>cf :cgete getmatches()<cr>
nnoremap <silent> <leader>cg :call ReadQuickfixFile(0)<cr>
nnoremap <leader>cn :cn<cr>
nnoremap <leader>cp :cp<cr>
nnoremap <leader>cq :cclose<cr>
nnoremap <leader>cw :call OpenQuickfixBuf()<cr>
nnoremap <silent> <leader>da :%d<cr>
nnoremap <silent> <leader>db :bdelete<cr>
nnoremap <leader>ddo :BcloseOthers<cr>
nnoremap <silent> <leader>de :%s#\s*$##g<cr>:nohl<cr><c-o>
nnoremap <silent> <leader>df :call DiffSplitFiles()<cr>
nnoremap <silent> <leader>dl :bdelete #<cr>
nnoremap <silent> <leader>dk :%s#.*karlzheng_todel.*\n##<cr>
nnoremap <silent> <leader>dm :%s#.*karldbg.*\n##<cr>
nnoremap <silent> <leader>do :windo diffoff!<cr>:bufdo diffoff!<cr>
nnoremap <silent> <leader>dp :%d<cr>"+P:1,/^\S/-2d<cr>:w<cr>/karldbg<cr>
nnoremap <silent> <leader>dr :%s#\r\n#\r#g<cr>
nnoremap <silent> <leader>ds :call DeleteSpaceLine()<cr>
nnoremap <silent> <leader>dt :Rename! ~/tmp/del_%:t<cr>
nnoremap <silent> <leader>d# :bd#<cr>
nnoremap <silent> <leader>e. :e .<cr>
nnoremap <silent> <leader>e1 :e ~/tmp/tmp_work_file/1.c<cr>
nnoremap <silent> <leader>e2 :e ~/tmp/tmp_work_file/2.c<cr>
nnoremap <silent> <leader>ea :call EditAbsoluteFilePath()<cr>
nnoremap <leader>ec :call EditConfig()<cr>
nnoremap <silent> <leader>ed :call EdCommandProxy()<cr>
nnoremap <silent> <leader>ee :e!<cr>
nnoremap <silent> <leader>ef :sp<cr>:wincmd w<cr>:resize 1<cr>:e /tmp/file.log<cr>
nnoremap <silent> <leader>eg :sp<cr>:wincmd w<cr>:resize 2<cr>:e /tmp/st/<cr>
nnoremap <silent> <leader>eh :e %:h<cr>
nnoremap <silent> <leader>ei :call EditTmpFile(g:homedir."/person_tools/myindex.mk")<cr>
nnoremap <silent> <leader>ek :call EditKconfig()<cr>
nnoremap <silent> <leader>el :call ExecLineText("", "")<cr>
"nnoremap <silent> <leader>em :e mgrep.mk<cr>
"nnoremap <silent> <leader>em :call EditMakefile()<cr>
nnoremap <silent> <leader>em :call EditTmpFile(g:homedir."/person_tools/m.ini")<cr>
nnoremap <silent> <leader>ep :call EditFilePath()<cr>
nnoremap <silent> <leader>eq :call EditQuickfixList()<cr>
nnoremap <silent> <leader>er :call EditCurFileRelaPath()<cr>
nnoremap <silent> <leader>es :call EditScratch()<cr>
nnoremap <silent> <leader>et :e ~/tmp/tee.log<cr>
nnoremap <silent> <leader>ev :e ~/.vimrc<cr>
nnoremap          <leader>ey :call EditYankText()<cr>
nnoremap          <leader>fa :call SaveAbsPathFileName()<cr>
nnoremap          <leader>fb :call SaveRelaPathFileName()<cr>
nnoremap          <leader>fc :cs find c
nnoremap <silent> <leader>fe :Sexplore!<cr>
nnoremap <leader>fg :cs find g
nnoremap <leader>fm :setlocal foldmethod=manual<cr>
nnoremap <leader>fs :cs find s
nnoremap <leader>fi :setlocal foldmethod=indent<cr>zR
nnoremap <silent> <leader>fn :call SaveCurrentFileName()<cr><cr>
nnoremap <leader>fp :call CDAbsPath()<cr>
nnoremap <leader>gb :call GitDiffLog()<CR>:!p2d.sh g:shmdir/gitdiff.c 1>/dev/null 2>&1 &<CR><CR>
nnoremap <leader>gd :call GitDiffLog()<cr>
nnoremap <leader>gf :GitEditFileInLine<cr>
nnoremap <leader>gi G?#include<cr>
nnoremap <leader>gm :call GetFileNameTail("", "")<CR>
nnoremap <leader>gn :call Getfilename("", "")<CR>
nnoremap <leader>go :call GitDiffLog()<CR>:!kompare g:shmdir/gitdiff.c 1>/dev/null 2>&1 &<CR><CR>
nnoremap <silent> <leader>gc :git checkout -- %<cr>
nnoremap <silent> <leader>ge :!gedit %&<cr>
nnoremap <silent> <leader>gg :call CompileByGcc()<cr>
nnoremap <silent> <leader>gj ggVGgJ
nnoremap <silent> <leader>gs :call ZKarl_Find_SpaceLine('next')<cr>
nnoremap <leader>gw "gyiw
nnoremap <leader>ih :call InsertIncludeFileN(0)<CR>
"nnoremap <leader>kb :!p2d.sh % 1>/dev/null 2>&1 &<cr><cr>
nnoremap <leader>kb :call DoGitBeyondCompare()<cr><cr>
nnoremap <leader>kk :call Sdcv("", "")<CR>
nnoremap <leader>ko :!kompare % 1>/dev/null 2>&1 &<cr><cr>
nnoremap <silent> <leader>lb :LUBufs<cr>
"http://vim.wikia.com/wiki/Search_and_replace_in_multiple_buffers
"http://vim.wikia.com/wiki/Highlight_current_line
nnoremap <silent> <Leader>lc ml:execute 'match Search /\%'.line('.').'l/'<CR>
nnoremap <silent> <leader>lf :call LookupFullFilenameTag("", "")<CR>
nnoremap <silent> <leader>ll :call ParseFilenameTag("", "")<CR>
nnoremap <silent> <leader>ls :ls<cr>
nnoremap <silent> <leader>lt :LookupPartFilenameTag<cr>
nnoremap <silent> <leader>lw :LUWalk<cr>
nnoremap <silent> <leader>jj ggVGJ
nnoremap <leader>ma :set modifiable<cr>
nnoremap <silent> <leader>mj :make -j16<cr>
nnoremap <silent> <leader>mk :MarksBrowser<cr>
nnoremap <silent> <leader>ml :e /tmp/minicom.log<cr>
nnoremap <silent> <leader>mz :make zImage -j16<cr>
nnoremap <silent> <leader>nl :nohl<cr>
nnoremap <silent> <leader>nn :set nonu<cr>
nnoremap <silent> <leader>pt :!pr.sh &<cr><cr>
nnoremap <silent> <leader>pv :sp /tmp/pt.txt<cr>2<C-W>_<C-W><C-W>
nnoremap <silent> <leader>qh <C-W>h:bd<cr>
nnoremap <silent> <leader>qj <C-W>j:bd<cr>
nnoremap <silent> <leader>qk <C-W>k:bd<cr>
nnoremap <silent> <leader>ql <C-W>l:bd<cr>
nnoremap <silent> <leader>qq :q<cr>
nnoremap <silent> <leader>qw :wq<cr>
nnoremap <silent> <leader>qf :call QuitAllBuffersWithoutSaving()<cr>
nnoremap <silent> <leader>qa :qa<cr>
nnoremap <leader>r1 :r ~/tmp/tmp_work_file/1.txt<cr>
nnoremap <silent> <leader>ra :!./a.out<cr>
"nnoremap <silent> <leader>rd :r ~/tmp/delay.c<cr>
nnoremap <silent> <leader>rd :call ReadDate()<cr>
nnoremap <leader>rf :call ReplaceFilePath4fp()<cr>
nnoremap <leader>ri :rviminfo<cr>
nnoremap <silent> <leader>rl :%d<CR>"+p
nnoremap <silent> <leader>rm :r ~/tmp/main.c<cr>
nnoremap <leader>rn :call ReplaceMyUserName()<cr>
nnoremap <silent> <leader>rr :reg<cr>
nnoremap <silent> <leader>rs :20 vs ~/.stardict/iremember/tofel.txt<CR>
nnoremap <silent> <leader>rt :r ~/tmp/tmp_work_file/%:t<cr>
nnoremap <silent> <leader>sc :set ft=c<cr>
nnoremap <silent> <leader>sd :call SvnDiffCurrentFile()<cr>
nnoremap <leader>sf :call SaveFile2Tar()<cr>
"nnoremap <silent> <leader>sl :!svn log %<cr>
"nnoremap <silent> <leader>sl :s#/# #g<cr>:s# \+#\r#g<cr>
nnoremap <silent> <leader>sl :call SepLineToWord()<cr>
nnoremap <silent> <leader>sn :set nu<cr>
nnoremap <silent> <leader>sm :set ft=make<cr>
nnoremap <silent> <leader>sp :split<cr>
nnoremap <leader>sq :call SaveQuickfixToFile()<cr>
nnoremap <silent> <leader>ss :source %<cr>
nnoremap <silent> <leader>srv :call SvnRevertCurrentFile()<cr>
nnoremap <silent> <leader>tl :TlistToggle<cr>
nnoremap <silent> <leader>us :call ZKarl_Find_SpaceLine('pre')<cr>
nnoremap <silent> <leader>vb :e ~/.bashrc<cr>Gk$
nnoremap <leader>vl :call EditBashLog()<cr>
nnoremap <silent> <leader>vs :vs<cr>
nnoremap <silent> <leader>vt :vs ~/tmp/tee.log<cr><c-w>L
"nnoremap <silent> <leader>vt :vs ~/tmp/tmp_work_file/%:t<cr>
nnoremap <silent> <leader>wj <C-W>j
nnoremap <silent> <leader>wk <C-W>k
nnoremap <silent> <leader>wh <C-W>h
nnoremap <silent> <leader>wl <C-W>l
nnoremap <silent> <leader>WH <C-W>h
nnoremap <silent> <leader>WJ <C-W>j
nnoremap <silent> <leader>WK <C-W>k
nnoremap <silent> <leader>WL <C-W>l
nnoremap <silent> <leader>wm :WMToggle<cr>
nnoremap <leader>w1 :w! ~/tmp/tmp_work_file/1.c<cr>
nnoremap <leader>w2 :w! ~/tmp/tmp_work_file/2.c<cr>
nnoremap <leader>wt :silent! w! ~/tmp/tmp_work_file/%:t<cr>
nnoremap <silent> <leader>wa :wa<cr>
nnoremap <silent> <leader>wf :w!<cr>
nnoremap          <leader>wi :wviminfo<cr>
nnoremap <silent> <leader>wq :wq<cr>
nnoremap <silent> <leader>ww :w<cr>
nnoremap <silent> <leader>WW :w<cr>
nnoremap <leader>uc :call UpdateCscope()<cr>
nnoremap <silent> <leader>ya ggVGy``
nnoremap Y ggY``P
"nnoremap <silent> * :call SpecialVisualSearch('f', 0)<CR>
"nnoremap <silent> # :call SpecialVisualSearch('b', 0)<CR>
nnoremap <silent> # #N
nnoremap <silent> * *N
nnoremap <silent> <leader># :e#<cr>
"http://hi.baidu.com/denmeng/blog/item/b6d482fc59f4c81e09244dce.html
nnoremap <leader><space> @=((foldclosed(line('.')) < 0) ? ((foldlevel('.') > 0) ? 'zc':'zfi{') : 'zo')<CR>
nnoremap <silent> <F3> :Grep \<<cword>\> %<CR> <CR>
"nnoremap <silent> <F4> :exec 'Bgrep '.expand("<cword>")<cr>
cnoremap <silent> <F3> Bgrep
"nnoremap <silent> <F4> :Grep \<<cword>\s*= %<CR> <CR>
"nnoremap <silent> <F4> :SrcExplToggle<CR>:nunmap g:SrcExpl_jumpKey<cr>
"nnoremap <silent> <F4> :SrcExplToggle<CR>
"nnoremap <silent> <F6> :cp<CR>
"nnoremap <silent> <F7> :cn<CR>
"nnoremap <silent> <F7> :SrcExplToggle<CR>
nnoremap <silent> <F8> :TlistToggle<CR>
nnoremap <silent> <C-6> <C-S-6>
nnoremap <c-a> :call QuickfixToggle()<cr>
nnoremap <c-d> :call QuitAllBuffers_key()<cr>
nnoremap <c-e> :call EditTmpFile("/tmp/file.log")<cr>
nnoremap <c-g><c-b> :call ShowGitDiffInBcompare()<CR><cr>
nnoremap <c-g><c-c> :call ShowGitDiffInKompare()<CR><cr>
nnoremap <c-g><c-d> :call GitDiffLog()<cr>
nnoremap <silent> <C-j>  <C-w>j
nnoremap <silent> <C-k>  <C-w>k
nnoremap <silent> <C-h>  <c-w>h
nnoremap <silent> <C-l>  <c-w>l
nnoremap <silent> <c-n> :call GoNextBuffer()<cr>
nnoremap <silent> <c-p> :call GoPreBuffer()<cr>
nnoremap <c-s> :w!<cr>
"nnoremap <c-t> :Ydc<CR>
nnoremap <c-t> :call EditTmpFile(g:homedir.'/tmp/tee.log')<cr>
nnoremap <c-q> :Bclose<cr>
nnoremap <c-x><c-c> :call QuitAllBuffers()<cr>
nnoremap <c-x><c-d> :Bclose<cr>
nnoremap <c-x><c-w> :Bwipe<cr>
nnoremap <c-x><c-p> O<ESC>"+Pj"_dd
nnoremap <c-x><c-n> "+p
nnoremap <C-W><C-B> :BottomExplorerWindow<cr>
nnoremap <c-y> :call SaveYankText()<cr>
"nnoremap <C-W><C-F> :FirstExplorerWindow<cr>
nnoremap <Esc><Esc> :call BufCloseWindow()<cr>

nnoremap <silent> d dw
nnoremap <silent> n :call GoNextQuickfix()<cr>
nnoremap <silent> p :call GoPreQuickfix()<cr>

" Move to next/previous line with same indentation
"https://github.com/hmgle/gle_vimrc/blob/master/vimrc
nnoremap <silent> ]d :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%>' . line('.') . 'l\S', 'e')<CR>
nnoremap <silent> ]u :call search('^'. matchstr(getline('.'), '\(^\s*\)') .'\%<' . line('.') . 'l\S', 'be')<CR>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" insert mode key remap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
inoremap b <ESC>bi
inoremap f <ESC>lWi
inoremap h <ESC>hli
inoremap j <ESC>gja
inoremap k <c-g>k
inoremap l <ESC>lli
inoremap <C-a> <Home>
inoremap <c-b> <ESC>lhi
inoremap <c-B> <ESC>lhi
inoremap <c-d> <ESC>:call QuitAllBuffers_key()<cr>
inoremap <C-e> <End>
inoremap <c-F> <ESC>lli
inoremap <c-f> <ESC>lli
inoremap <C-h> <ESC>"_s
inoremap <c-i><c-h> <ESC>:call InsertIncludeFileI(0)<CR>
inoremap <C-k> <ESC>l"_Da
inoremap <C-l> <ESC>l"_s
inoremap <C-o> <C-c>
inoremap <c-s> <ESC>:w!<cr>li
inoremap <c-u> <c-g>u<c-u>
inoremap <c-w> <ESC>ldbi
inoremap <c-y> <ESC>:call InsertYankText()<cr>i
inoremap <C-Del> <c-g>u<c-c>lC
inoremap <expr> <CR> pumvisible()?"\<C-Y>":"\<CR>"
"http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
"inoremap <c-j> <ESC>gjli
"inoremap <c-k> <c-g>u<c-c>lC
"inoremap <c-k> <c-g>k
"inoremap <C-l> <C-o>:set im<cr><C-l>
"nnoremap <C-l> :set noim<cr>

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" visual mode key remap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
vmap <silent> j 4j
vmap <silent> k 4k
vmap <leader>cl :!column -t<CR>
vmap <leader>w1 :w! ~/tmp/tmp_work_file/1.txt<cr>
"Basically you press * or # to search for the current selection !! Really useful
vnoremap <silent> * :call SpecialVisualSearch('f', 1)<CR>
vnoremap <silent> # :call SpecialVisualSearch('b', 1)<CR>
"http://tech.groups.yahoo.com/group/vim/message/105517
":au CursorHold * exec 'match IncSearch /'.expand("<cword>").'/'
"nnoremap <leader>h :exec 'match IncSearch /'.expand("<cword>").'/'<cr>
vnoremap <Leader># "9y?<C-R>='\V'.substitute(escape(@9,'\?'),'\n','\\n','g')<CR><CR>
vnoremap <Leader>* "9y/<C-R>='\V'.substitute(escape(@9,'\/'),'\n','\\n','g')<CR><CR>
"http://hi.baidu.com/denmeng/blog/item/b6d482fc59f4c81e09244dce.html
vnoremap <leader><space> @=((foldclosed(line('.')) < 0) ? ((foldlevel('.') > 0) ? 'zc':'zf') : 'zo')<CR>
vnoremap <c-y> <ESC>:call SaveYankTextInVisual()<CR>

xnoremap <c-p> "_dP

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Ex mode key remap
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"http://stackoverflow.com/questions/1694599/how-do-i-get-vims-sh-command-to-source-my-bashrc
cabbr WQ wq
cabbr QA qa
cabbr Wq wq
cabbr W <c-r>=(getcmdtype() == ':' && getcmdpos() == 1 ? 'w' : 'W')<CR>
cabbr WA <c-r>=(getcmdtype() == ':' && getcmdpos() == 2 ? 'wa' : 'WA')<CR>
"cmap WA<cr> wa<cr>
cabbr !sh<c-r>=(getcmdtype() == ':' && getcmdpos() == 3 ? '!bash --login' : '!sh')<CR>
"cmap sh<CR> !bash --login<CR>
"http://vim.wikia.com/wiki/Replace_a_builtin_command_using_cabbrev
cnoremap  vi<cr>


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"buffer autocmd
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd") && exists("+omnifunc")
	autocmd Filetype *
	\	if &omnifunc == "" |
	\		setlocal omnifunc=syntaxcomplete#Complete |
	\	endif
endif
autocmd! bufwritepost .vimrc source ~/.vimrc
au BufRead,BufNewFile *.txt setlocal ft=txt
au BufRead,BufNewFile *.rc setlocal ft=make
au FileType help set nu
au FileType c,cpp,h,hpp call SetCFileTabStop()
"au FileType c,cpp,h,hpp set shiftwidth=8 |set tabstop=8 | set iskeyword-=-,>()
"au FileType c,cpp,h,hpp set fo-=l | set textwidth=80
"http://easwy.com/blog/archives/advanced-vim-skills-advanced-move-method/
"autocmd FileType c,cpp setl fdm=syntax | setl fen
"autocmd FileType c,cpp set shiftwidth=4 | set expandtab | set iskeyword -=-
"autocmd FileType c,cpp set fo=tcq
"au FileType sh set dictionary+=~/.vim/usr_bin_cmd.txt,~/.vim/bash-support/wordlists/bash.list
"map <c-u> <c-l><c-j>:q<cr>:botright cw 10<cr>
"au BufReadPost quickfix  cclose | vert copen 45
au! QuickfixCmdPost * call SortUniqQFList()
au! BufReadPost quickfix  call QuifixBufReadPost_Process()
autocmd BufWinEnter \[Buf\ List\] setl nonumber
autocmd BufRead,BufNew :call UMiniBufExplorer
"autocmd BufWrite *.cpp,*.h,*.c call UpdateCscope()
"autocmd BufWrite *.cpp,*.h,*.c call UpdateTags()
autocmd VimEnter * call BufPos_Initialize()


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" the end of my .vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:my_vimrc_is_loaded = 1
