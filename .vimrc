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
"	 4. key re map
"	 5. misc.
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
let g:use_gtags=0
"let g:use_gtags=1
let g:BASH_Ctrl_j='on'

set nocompatible
"au BufRead ft=Help set nu
set ar
"set autochdir
set autoindent
set aw
"set clipboard+=unnamed
set cot=menuone
set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
set cscopetag
set dictionary+=~/.vim/usr_bin_cmd.txt,~/.vim/bash-support/wordlists/bash.list
"set encoding=prc
set encoding=utf-8
set fencs=utf-8,gbk,big5,gb2312,gb18030,euc-jp,utf-16le
"fenc; internal enc; terminal enc
set fenc=utf-8 enc=utf-8 tenc=utf-8
set fileformats=unix
"set foldenable
"set foldmethod=indent
set grepprg=mgrep.sh
"set guioptions-=L
set guioptions-=m
"set guioptions-=r
"set guioptions-=T
set hid
set history=400
set history=500
set hlsearch
set incsearch
set isf-==,/
set iskeyword-=",/,,
" for  # * quick lookup
set iskeyword+=_
set laststatus=2
if isdirectory('arch/arm/configs/')
	set makeprg=make\ zImage\ \-j24
else
	set makeprg=make\ \-j24
en
set nocp
set noignorecase
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
set textwidth=78
set whichwrap=b,s,h,l
set winaltkeys=no
set wrap
""http://blog.xuyu.org/?p=1215
"set nowrapscan
"http://askubuntu.com/questions/67/how-do-i-enable-full-color-support-in-terminal
if $COLORTERM == 'gnome-terminal'
	set t_Co=256
else
	set t_Co=256
endif

if ! exists("g:root_work_path")
    let g:root_work_path = escape(getcwd(), " ")
endif

if ! exists("g:whoami")
    let g:whoami = system("whoami | tr -d '\r' | tr -d '\n' ")
endif

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" my functions
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" common functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! s:Escape(dir)
	  " See rules at :help 'path'
	  return escape(escape(escape(a:dir, ','), "\\"), ' ')
	endfunction

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" path operate related functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! SaveFilePath()
		let l:f = expand("%:p:h")
		let l:f = s:Escape(f)
		if (l:f != "")
		    let l:_cmd_ = 'echo ' . '"' . l:f . '" > /dev/shm/'.g:whoami.'/apwdpath'
		    let l:_resp = system(l:_cmd_)
		else
		    echo "Current file is noname."
		endif
	endfunction

	"Switch to current dir
	function! My_FilePath_Switch_Func()
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
		let l:filepath = s:Escape(l:filepath)
		if l:pwd == g:root_work_path
			echo "cd ".l:filepath
			execute "cd ".l:filepath
		else
			echo "cd ".g:root_work_path
			exec "cd ".g:root_work_path
		endif
	endfunction
	nmap <silent> <c-s> :call My_FilePath_Switch_Func()<cr>

	function! Edit_FilePath()
		let l:filepath = s:Escape(expand("%:p:h"))
		execute "e ".l:filepath
	endfunction
	nmap <silent> <leader>ep :call Edit_FilePath()<cr>

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
	nmap <leader>ec :call EditConfig()<cr>

	function! Edit_Kconfig()
		let l:filepath = expand("%:p:h")
		let l:kconfig = s:Escape(l:filepath)."/Kconfig"
		if filereadable(l:kconfig)
		    execute "e ".l:kconfig
		endif
	endfunction
	nmap <silent> <leader>ek :call Edit_Kconfig()<cr>

	function! Edit_Makefile()
		let l:filepath = expand("%:p:h")
		let l:makefile = s:Escape(l:filepath)."/Makefile"
		if filereadable(l:makefile)
		    execute "e ".l:makefile
		else
			let l:makefile = s:Escape(l:filepath)."/Android.mk"
			if filereadable(l:makefile)
				execute "e ".l:makefile
			endif
		endif
	endfunction
	nmap <silent> <leader>em :call Edit_Makefile()<cr>
	
	function! EditScratch()
		if filereadable("/home/karlzheng/tmp/.scratch.swp")
			e ~/tmp/scratch2
		else
			e $HOME/tmp/scratch
		endif
	endfunction

	function! My_Save_CurrentFileName()
		let l:str = expand("%:p")
		let l:str = s:Escape(str)
		let @* = l:str
		let @+ = '"'.l:str.'"'
		execute ":!echo '".l:str."' > /dev/shm/filename"
	endfunction

	function! My_Save_CompareFileName()
		let str = expand("%:p")
		let str = s:Escape(str)
		execute ":!echo '".str."' > /dev/shm/beyond_compare_file_a"
	endfunction

	function! My_CompareToFileName()
		let _cmd_ = 'cat /dev/shm/beyond_compare_file_a'
		echo _cmd_
		let _resp = system(_cmd_)
		let g:select_for_compare_file1 = substitute(_resp, '\n', '', 'g')
		unlet _cmd_
		unlet _resp
		let g:select_for_compare_file2 = expand("%:p")
		echo g:select_for_compare_file2
		let l:cmd_text = "!bcompare "."\"".g:select_for_compare_file1."\""." \"".g:select_for_compare_file2."\" \&"
		execute l:cmd_text
		unlet l:cmd_text
	endfunction

	function! Select_for_compare()
		let g:select_for_compare_file1 = expand("%:p")
		echo g:select_for_compare_file1
	endfunction
	"nmap <silent> <leader>ba :call Select_for_compare()<cr>

	function! Compare_to_selected()
		let g:select_for_compare_file2 = expand("%:p")
		echo g:select_for_compare_file2
		let l:cmd_text = "!bcompare "."\"".g:select_for_compare_file1."\""." \"".g:select_for_compare_file2."\" \&"
		echo g:select_for_compare_file2
		execute l:cmd_text
		unlet l:cmd_text
	endfunction
	"nmap <silent> <leader>bb :call Compare_to_selected()<cr>

	function! DoGitBeyondCompare()
		let l:ext = expand("%:e")
		if l:ext == "log"
		    call GitDiffLog()
		    exec "!p2d.sh /dev/shm/gitdiff.c 1>/dev/null 2>&1 &"
		else
		    exec "!p2d.sh ".expand("%")." 1>/dev/null 2>&1 &"
		endif
	endfunction
	nmap <leader>kb :call DoGitBeyondCompare()<cr><cr>

function! My_Python4CompareToFileName()
	if has("python")
	"learn use python in vim script from autotag.vim
python << EEOOFF
import fileinput
import vim
try:
	input = fileinput.FileInput("/dev/shm/beyond_compare_file_a")
	select_for_compare_file1 = input.readline()
	vim.command("let g:select_for_compare_file1=%s" % select_for_compare_file1)
finally:
	input.close()
EEOOFF
	endif
    let l:cmd_text = "!bcompare "."\"".g:select_for_compare_file1."\""." \"".g:select_for_compare_file2."\" \&"
    echo g:select_for_compare_file2
    execute l:cmd_text
	unlet l:cmd_text
endfunction
nmap <silent> <leader>bc :call My_Python4CompareToFileName()<cr><cr>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" diff operation relative settings
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	if &diff
	    set wrap
	endif
	" see :h diff
	command! DiffOrig vert new | set bt=nofile | r # | 0d_ | diffthis
			\ | wincmd p | diffthis


	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" file quick open related functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! SaveCurrentFileNameRelativePath()
		let l:f = expand("%")
		if (l:f != "")
		    let l:f = substitute(l:f, '^/tmp/a/', "", "")
		    let l:f = substitute(l:f, '^/tmp/b/', "", "")
		    let l:f = substitute(l:f, '^a/', "", "")
		    let l:f = substitute(l:f, '^b/', "", "")
		    let l:_cmd_ = 'echo ' . '"' . l:f . '" > /dev/shm/cur_file_rela_path'
		    let l:_resp = system(l:_cmd_)
		else
		    echo "Current file is noname."
		endif
	endfunction

	function! EditWorkDiary()
		exec "e ~/person_tools/workDiary/diary.txt"
		exec "norm G"
	endfunction

	function! EditFileWithRelativePath()
	    let l:f = expand("%")
	    let l:df = substitute(l:f, '^/tmp/a/', "", "")
	    let l:df = substitute(l:f, '^/tmp/b/', "", "")
	    let l:r = system('cat /dev/shm/diff_file_rela_path')
	    let l:r = substitute(l:r, "\r", "", "g")
	    let l:r = substitute(l:r, "\n", "", "g")
	    let l:df = l:r.'/'.l:f
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

	function! EdCommandProxy()
		let l:f = expand("%:t")
		echo l:f
		if (l:f == "scratch")
			call EditWorkDiary()
		else
			call EditFileWithRelativePath()
		endif
	endfunction

	function! SaveFile2Tar()
		let l:f = expand("%")
		let l:_cmd_ = 'tar cf /tmp/file.tar "'. l:f .'"'
		let l:_resp = system(l:_cmd_)
	endfunction

	function! SaveCurrentFileNameAbsolutePath()
		let l:f = expand("%:p")
		if (l:f != "")
		    let l:_cmd_ = 'echo ' . '"' . l:f . '" > /dev/shm/'.g:whoami.'/absfn'
		    let l:_resp = system(l:_cmd_)
		else
		    echo "Current file is noname."
		endif
	endfunction

	function! EditCurFileRelaPath()
		let l:_cmd_ = 'cat ' . '/dev/shm/cur_file_rela_path | tr -d "\r" | tr -d "\n"'
		let l:_resp = system(l:_cmd_)
		if filereadable(l:_resp)
			exec "e ".l:_resp
		else
			echo "has no file ". l:_resp
		endif
	endfunction

	function! Edit_vim_cur_edit_file_absolute_path()
		let l:_cmd_ = 'cat ' . '/dev/shm/'.g:whoami.'/absfn | tr -d "\r" | tr -d "\n"'
		let l:f = system(l:_cmd_)
		"let l:f = "'".escape(l:f, '%')."'"
		let l:f = escape(l:f, '%')
		if filereadable(l:f)
			exec "e ".l:f
		else
			echo "has no file: ". l:f
		endif
	endfunction

	function! Vim_cd_absolute_path()
		let l:_cmd_ = 'cat ' . '/dev/shm/'.g:whoami.'/filename'
		let l:_resp = system(l:_cmd_)
		exec "cd ".l:_resp
		exec "pwd"
	endfunction

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" lookupfile functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! UpdateGtags(f)
		let l:root_gtags_file=g:root_work_path . "/GTAGS"
		if filereadable(l:root_gtags_file) && filereadable("/usr/bin/gtags")
			let dir = fnamemodify(a:f, ':p:h')
			exe 'silent !cd ' . dir . ' && global -u &> /dev/null &'
		endif
	endfunction
	"au BufWritePost *.c,*.h,*.hpp,*.cpp,*.java call UpdateGtags(expand('<afile>'))

	command! -nargs=+ -complete=dir FindFiles :call FindFiles(<f-args>)
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

	function! VimEnterCallback()
		 for f in argv()
			 if fnamemodify(f, ':e') != 'c' && fnamemodify(f, ':e') != 'h'
				 continue
			 endif
			 call FindGtags(f)
		 endfor
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
command! -nargs=* -complete=tag -bang ParseFilenameTag :call ParseFilenameTag("<args>", "<bang>")

func! LookupPartFilenameTag(line, bang)
	let g:use_LookupFile_FullNameTagExpr = 0
	exec "LUTags"
endf
command! -nargs=* -complete=tag -bang LookupPartFilenameTag :call LookupPartFilenameTag("<args>", "<bang>")

func! LookupFullFilenameTag(line, bang)
	let g:use_LookupFile_FullNameTagExpr = 1
	exec "LUTags"
endf
command! -nargs=* -complete=tag -bang LookupFullFilenameTag :call LookupFullFilenameTag("<args>", "<bang>")

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" buffer functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

	command! -nargs=* -complete=file -bang ExecBufferLine :call ExecBufferLine("<args>", "<bang>")
	function! ExecBufferLine(name, bang)
		let l:ans = confirm("Execute current buffer line in bash?", "&Yes\n&No")
		if l:ans == 1
		    exec ".,.w !sh"
		else
		    echo ("cancel Execute current buffer line in bash?")
		endif
	endfunction

	command! -nargs=* -complete=file -bang Getfilename :call Getfilename("<args>", "<bang>")
	function! Getfilename(name, bang)
		let @"= expand("%:p")."\n"
	endfunction

	function! YankText()
	    if &clipboard == ""
		let l:lines = []
		let l:line = getline(".")
		call add(l:lines, l:line)
		call writefile(l:lines, "/dev/shm/".g:whoami."/yank.txt")
	    endif
		exec 'norm yy"+yy"*yy'
	endfunction
	nnoremap <c-y> :call YankText()<cr>

	function! EditYankText()
		let l:f = "/dev/shm/".g:whoami."/yank.txt"
		exec 'e '.l:f
	endfunction
	nnoremap <leader>ey :call EditYankText()<cr>

	" Rename.vim - Copyright June 2007 by Christian J. Robinson <heptite@gmail.com>
	command! -nargs=* -complete=file -bang Rename :call Rename("<args>", "<bang>")
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

	function! GoPreBuffer()
	    if &diff
		exec "normal [c"
	    else
		bp
		if &ft == "qf"
			bp
		endif
	    endif
	endfunction
	function! GoNextBuffer()
	    if &diff
		exec "normal ]c"
	    else
		bn
		if &ft == "qf"
			bn
		endif
	    endif
	endfunction
	nnoremap <silent> <c-n> :call GoNextBuffer()<cr>
	nnoremap <silent> <c-p> :call GoPreBuffer()<cr>

	function! GoPreQuickfix()
		cp
	endfunction
	function! GoNextQuickfix()
		cn
	endfunction
	nnoremap <silent> n :call GoNextQuickfix()<cr>
	nnoremap <silent> p :call GoPreQuickfix()<cr>

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
			tabfirst
			let tab = 1
			while tab <= tabpagenr("$")
				let bufwinnr = bufwinnr(a:filename)
				if bufwinnr != -1
					exec "normal " . tab . "gt"
					exec bufwinnr . "wincmd w"
					return
				endif
				tabnext
				let tab = tab + 1
			endwhile
			" not exist, new tab
			exec "tabnew " . a:filename
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
	command! BcloseOthers call <SID>BufCloseOthers()
	nmap <leader>ddo :BcloseOthers<cr>

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
		if buflisted(l:currentBufNum)
			try
				if (a:is_buf_wipeout)
					execute("bwipe ".l:currentBufNum)
				else
					execute("bdelete ".l:currentBufNum)
				endif
			catch /.*/
				return
			endtry
		endif
	endfunction
	
	function! BufCloseWindow()
		q
		let l:f=expand("%:t")
		if l:f == "-MiniBufExplorer-"
			exec "normal! \<C-W>j"
		endif
	endfunction
	nnoremap <Esc><Esc> :call BufCloseWindow()<cr>
	
	command! Bwipe  call <SID>BufcloseCloseIt(1)
	command! Bclose call <SID>BufcloseCloseIt(0)
	nmap <c-x><c-d> :Bclose<cr>
	nmap <leader>bd :Bclose<cr>
	nmap <c-x><c-w> :Bwipe<cr>
	nmap <leader>bw :Bwipe<cr>

	"close draft window and quickfix window
	command! BcloseDraft call <SID>BufcloseCloseDraft()
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

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" functions for Visual mode
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" From an idea by Michael Naumann
	function! MySpecialSearch(direction, is_VisualSearch)
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

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" c file edit functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"http://www.vimer.cn/2010/01/饭前甜点-vimgvim自动在cpp文件中添加-h文件包含.html
	function! InsertIncludeFileI(is_system_include_file)
		let sourcefilename=expand("%:t")
		let outfilename=substitute(sourcefilename,'\(\.[^.]*\)$','.h','g')
		if a:is_system_include_file
			call setline('.','#include <'.outfilename.'>')
		else
			call setline('.','#include "'.outfilename.'"')
	endfunction
	imap <c-i><c-h> <ESC>:call InsertIncludeFileI(0)<CR>
	nmap ,ih :call InsertIncludeFileN(0)<CR>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" gcc compile related functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! My_compile_command()
	  let l:ext = expand("%:e")
	  if (l:ext == "cpp")
		exec "!g++ ".expand("%")
	  elseif (l:ext == "c")
		exec "!gcc ".expand("%")
	  endif
	endfunction

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" svn related functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! SvnRevertCurrentFile()
		if isdirectory('.svn')
			exec "!svn revert %"
		else
			exec "!git checkout %"
		endif
	endfunc

	function! SvnDiffCurrentFile()
		if isdirectory('.svn')
			exec "!svn diff %"
		else
			exec "!git diff %"
		endif
	endfunc

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" git related functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! GitDiffLog1()
		let l:firsttag=@g
		let l:secondtag = expand("<cword>")
		let l:_cmd_ = 'git diff '.l:firsttag.' '.l:secondtag.' > gitdiff.c'
		let _resp = system(l:_cmd_)
	endfunc
	
	function! ShowGitDiffInBcompare()
		call GitDiffLog()
		exec "!p2d.sh /dev/shm/gitdiff.c 1>/dev/null 2>&1 &"
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
	nmap <c-g><c-b> :call ShowGitDiffInBcompare()<CR><cr>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" dictionary functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"http://www.2cto.com/os/201109/103898.html
	function! Sdcv(word, bang)
		if (a:word == "")
			"let expl=system('sdcv -n ' . expand("<cword>") . '| fold -s -w 45')
			let expl=system('dict ' . expand("<cword>") . '| fold -s -w 45')
		else
			"let expl=system('sdcv -n ' . a:word . '| fold -s -w 45')
			let expl=system('dict ' . a:word . '| fold -s -w 45')
		endif
		"call MyPythonProcessLineText(expl)
		let l:currentBufNum = bufnr("%")
		let l:is_exist_dict_tmp = 0
		let l:BufNum = 0
		for i in range(1,bufnr("$"))
			if buflisted(i)
				if bufname(i) == "diCt-tmp" && l:currentBufNum != i && bufname(l:currentBufNum) != "/home/karlzheng/.stardict/iremember/tofel.txt"
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
		if bufname(l:currentBufNum) == "/home/karlzheng/.stardict/iremember/tofel.txt"
			"exec "b".l:currentBufNum
			"call SwitchToBuf(bufname(l:currentBufNum))
		endif
	endfunction
	nmap <leader>kk :call Sdcv("", "")<CR>
	command! -nargs=* -complete=tag -bang Sdcv :call Sdcv("<args>", "<bang>")

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Buffer realted settings
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" buffer initial
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
	autocmd VimEnter * call BufPos_Initialize()

	func! BwipeCurrentBuffer()
		let l:currentBufNum = bufnr("%")
		echo l:currentBufNum
		exec "normal! \<C-o>"
		exec("bwipe ".  l:currentBufNum)
	endf

	func! QuickfixToggle()
	    if Is_quickfix_visual()
		cclose
	    else
		call OpenQuickfixBuf()
	    endif
	endf
	nmap <c-q> :call QuickfixToggle()<cr>

	"http://vim.wikia.com/wiki/Toggle_to_open_or_close_the_quickfix_window
	function! Is_quickfix_visual()
	    let l:is_quickfix_visual = 0
	    redir => l:buflist
	    silent! ls
	    redir END
	    "for bufnum in filter(split(g:buflist, '\n'), 'v:val =~ "Quickfix List"')
		""let g:mynr = str2nr(matchstr(bufnum, "\\d\\+"))
		"let l:is_quickfix_visual = 1
	    "endfor
	    "http://rickey-nctu.blogspot.com/2009/02/vim-quickfix.html
	    if match(l:buflist, "[Quickfix List") != -1
		let l:is_quickfix_visual = 1
	    endif
	    return l:is_quickfix_visual
	endfunction

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
		if isdirectory('/dev/shm/'.g:whoami)
		    let l:cmd = "mks! /dev/shm/".g:whoami."/edit.vim"
		    exec l:cmd
		endif
		exec "qa"
	    endif
	endf
	nmap <c-x><c-c> :call QuitAllBuffers()<cr>

	command! -nargs=* -complete=file -bang M1 :call MakeSessionInCurDir("<args>", "<bang>")
	function! MakeSessionInCurDir(name, bang)
		let l:cmd = "mks! edit.vim"
		exec l:cmd
	endfunction

	command! -nargs=* -complete=file -bang MS :call MakeSession("<args>", "<bang>")
	function! MakeSession(name, bang)
		if isdirectory('/dev/shm/'.g:whoami)
		    let l:cmd = "mks! /dev/shm/".g:whoami."/edit.vim"
		else
		    let l:cmd = "mks! /dev/shm/edit.vim"
		endif
		exec l:cmd
	endfunction

	command! -nargs=* -complete=file -bang S1 :call SourceSessionInCurDir("<args>", "<bang>")
	function! SourceSessionInCurDir(name, bang)
		let l:cmd = "source edit.vim"
		exec l:cmd
	endfunction

	command! -nargs=* -complete=file -bang SS :call SourceSession("<args>", "<bang>")
	function! SourceSession(name, bang)
		if isdirectory('/dev/shm/'.g:whoami)
		    let l:cmd = "source /dev/shm/".g:whoami."/edit.vim"
		    exec l:cmd
		endif
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
	nmap <c-d> :call QuitAllBuffers_key()<cr>
	imap <c-d> <ESC>:call QuitAllBuffers_key()<cr>

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
		if &ft == "make"
			let l:msg = '$(warning "karldbg")'
		endif
		if &ft == "python"
			let l:msg = 'import inspect;print ("karldbg %s %d" %(__file__, inspect.currentframe().f_lineno))'
		endif
		if &ft == "sh"
			let l:msg ='echo karldbg $(basename $0) $LINENO'
		endif
		if l:msg != ''
			call append(line('.'), l:msg)
			exec "normal Vj=j"
		endif
	endfunction
	nmap <silent> <leader>al :call AddDebugLine()<cr>

	func! ReplaceMyUserName()
	    let l:line = getline(".")
	    let l:line = substitute(l:line, 'ssh://.*@', 'ssh://kangliang.zkl@', "")
	    let l:line = substitute(l:line, 'http://.*@', 'http://kangliang.zkl@', "")
	    call setline(".", l:line)
	endfunction
	nmap <leader>rn :call ReplaceMyUserName()<cr>

	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"buffer autocmd
	""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	if has("autocmd") && exists("+omnifunc")
		autocmd Filetype *
		\	if &omnifunc == "" |
		\		setlocal omnifunc=syntaxcomplete#Complete |
		\	endif
	endif

	function! C_file_shiftwidth_setting()
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

	autocmd! bufwritepost .vimrc source ~/.vimrc

	au BufRead,BufNewFile *.txt setlocal ft=txt
	au BufRead,BufNewFile *.rc setlocal ft=make
	au FileType help set nu
	au FileType c,cpp,h,hpp call C_file_shiftwidth_setting()
	"au FileType c,cpp,h,hpp set shiftwidth=8 |set tabstop=8 | set iskeyword-=-,>()
	"au FileType c,cpp,h,hpp set fo-=l | set textwidth=80
	"http://easwy.com/blog/archives/advanced-vim-skills-advanced-move-method/
	"autocmd FileType c,cpp setl fdm=syntax | setl fen
	"autocmd FileType c,cpp set shiftwidth=4 | set expandtab | set iskeyword -=-
	"autocmd FileType c,cpp set fo=tcq
	"au FileType sh set dictionary+=~/.vim/usr_bin_cmd.txt,~/.vim/bash-support/wordlists/bash.list

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


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Plugin setting
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

	filetype plugin indent on

	let g:searchfold_do_maps = 0

	"让Vim在图形界面与终端中的Alt组合键相同
	"http://lilydjwg.is-programmer.com/posts/23574.html
	let g:EchoFuncKeyPrev="-"
	let g:EchoFuncKeyNext="="

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"                   colorcolumn setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"http://www.vimer.cn/2012/05/vimgvim支持对齐线.html
	let g:indent_guides_guide_size = 1
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

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"                     color scheme setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"Colorsheme Scroller, http://www.vim.org/scripts/script.php?script_id=1488
	"map <silent><F2> :NEXTCOLOR<cr>
	"map <silent><F3> :PREVCOLOR<cr>
	if has("gui_running")
		"colorscheme borland
		colorscheme breeze
		"colorscheme 256_adaryn
		"hi normal guibg=#294d4a
	else
		colorscheme 256_adaryn
	endif

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"                       taglist setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let g:Tlist_Show_One_File = 1
	let tlist_txt_settings = 'txt;c:content;f:figures;t:tables'
	if MySys() == "windows"
		let Tlist_Ctags_Cmd = 'ctags'
	elseif MySys() == "linux"
		let Tlist_Ctags_Cmd = 'ctags'
	endif
	let Tlist_Exit_OnlyWindow = 1
	let Tlist_Use_Right_Window = 0
	nmap <silent> <leader>tl :Tlist<cr>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" ctags
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" cscope && gtags
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
		nmap [d :cscope find d <cword><CR>
		nmap [e :cscope find e <cword><CR>
		nmap [f :cscope find f <cword><CR>
		nmap [g :cscope find g <cword><CR>
		nmap [i :cscope find i <cword><CR>
		nmap [I :cscope find i %:t<CR>
		nmap [s :cscope find s <cword><CR><c-q><cr><c-q><cr>
		nmap [t :cscope find t <cword><CR>
	endif

	"http://vim.wikia.com/wiki/Autocmd_to_update_ctags_file
	function! UPDATE_TAGS()
		let l:f = expand("%:p")
		let l:_cmd_ = '"ctags -a --c++-kinds=+p --fields=+iaS --extra=+q " ' . '"' . l:f . ' & "'
		let l:_resp = system(l:_cmd_)
		if g:use_gtags && filereadable("/usr/bin/gtags")
			exec ':silent !global -u > /dev/null 2>&1 &'
		endif
	endfunction
	autocmd BufWrite *.cpp,*.h,*.c call UPDATE_TAGS()

	function! UPDATE_Cscope()
		let l:curfile = expand("%")
		let l:command="!echo " . l:curfile . " >> modify.files"
		exec l:command
		let l:command="!cscope -bkq -f newcscope.out -i modify.files"
		exec l:command
		:cs reset
	endfunction
	"autocmd BufWrite *.cpp,*.h,*.c call UPDATE_Cscope()
	nmap <leader>uc :call UPDATE_Cscope()<cr>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" SrcExpl settings
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let g:SrcExpl_isUpdateTags = 0
	let g:SrcExpl_gobackKey = ""
	let g:SrcExpl_pluginList = ["Source_Explorer"]

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" lookupfile setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let g:LookupFile_LookupFunc = 'LookupFile_IgnoreCaseFunc'
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

	function! LookupFile_IgnoreCaseFunc(pattern)
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

	"nmap <silent> <leader>lf :LUTags <C-R>=expand("<cword>")<cr><cr>
	nmap <silent> <leader>lf :call LookupFullFilenameTag("", "")<CR>
	"nmap <silent> <leader>lt :LUTags<cr>
	nmap <silent> <leader>lt :LookupPartFilenameTag<cr>
	nmap <silent> <leader>ll :call ParseFilenameTag("", "")<CR>
	nmap <silent> <leader>lb :LUBufs<cr>
	nmap <silent> <leader>lw :LUWalk<cr>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"Quickfix
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! ReadQuickfixFile()
		if filereadable("/home/karlzheng/dev/quickfix.txt")
			"exe 'cg /home/karlzheng/dev/quickfix.txt'
			let l:_resp = system('rsync -avurP /home/karlzheng/dev/quickfix.txt /dev/shm/karlzheng/quickfix.txt')
			let l:_resp = system('rsync -avurP /dev/shm/karlzheng/quickfix.txt /home/karlzheng/dev/quickfix.txt')
		endif
		exe 'cg /dev/shm/'.g:whoami.'/quickfix.txt'
		call OpenQuickfixBuf()
	endfunc

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
	    call writefile(l:qf_data_list, "/dev/shm/".g:whoami."/quickfix.txt")
	    if ! isdirectory('/home/karlzheng/')
		call writefile(l:qf_data_list, $HOME."/quickfix.txt")
	    endif
	    if filereadable($HOME.'/dev/quickfix.txt')
		call writefile(l:qf_data_list, $HOME."/dev/quickfix.txt")
	    endif
	endfunc
	nmap <leader>sq :call SaveQuickfixToFile()<cr>

	function! EditQuickfixList()
	    if filereadable("/home/karlzheng/dev/quickfix.txt")
		exe 'e /home/karlzheng/dev/quickfix.txt'
	    else
		exe 'e /dev/shm/'.g:whoami.'/quickfix.txt'
	    endif
	endfunc
	nmap <leader>eq :call EditQuickfixList()<cr>

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

	func! QuifixBufReadPost_Process()
		let qflist = getqflist()
		if len(qflist) == 0
			if exists("g:Quickfix_uniqedList")
				call setqflist(g:Quickfix_uniqedList)
			endif
		endif
		cclose | vert copen 45
	endf

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
	nmap <leader>cn :cn<cr>
	nmap <leader>cp :cp<cr>
	nmap <leader>cw :call OpenQuickfixBuf()<cr>
	nmap <leader>cq :cclose<cr>
	"nmap <leader>cc :botright lw 10<cr>
	"map <c-u> <c-l><c-j>:q<cr>:botright cw 10<cr>
	"au BufReadPost quickfix  cclose | vert copen 45
	au! QuickfixCmdPost * call SortUniqQFList()
	au! BufReadPost quickfix  call QuifixBufReadPost_Process()

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" winmanager setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"let g:winManagerWindowLayout = "TagList|FileExplorer,BufExplorer"
	let g:winManagerWindowLayout = "FileExplorer,BufExplorer"
	let g:winManagerWidth = 30
	let g:defaultExplorer = 0
	"nmap <C-W><C-F> :FirstExplorerWindow<cr>
	nmap <C-W><C-B> :BottomExplorerWindow<cr>
	nmap <silent> <leader>wm :WMToggle<cr>
	autocmd BufWinEnter \[Buf\ List\] setl nonumber

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" netrw setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let g:netrw_winsize = 30
	nmap <silent> <leader>fe :Sexplore!<cr>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" file explorer setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" markbrowser setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	nmap <silent> <leader>mk :MarksBrowser<cr>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" showmarks setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" mark setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	nmap <silent> <leader>hl <Plug>MarkSet
	vmap <silent> <leader>hl <Plug>MarkSet
	nmap <silent> <leader>hh <Plug>MarkClear
	vmap <silent> <leader>hh <Plug>MarkClear
	nmap <silent> <leader>hr <Plug>MarkRegex
	vmap <silent> <leader>hr <Plug>MarkRegex

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" minibuffer setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

	autocmd BufRead,BufNew :call UMiniBufExplorer

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" bufexplorer setting
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let g:bufExplorerDefaultHelp=1       " Do not show default help.
	let g:bufExplorerShowRelativePath=1  " Show relative paths.
	let g:bufExplorerSortBy='mru'        " Sort by most recently used.
	let g:bufExplorerSplitRight=1        " Split right.
	let g:bufExplorerSplitVertical=1     " Split vertically.
	let g:bufExplorerSplitVertSize=3  " Split width
	let g:bufExplorerUseCurrentWindow=1  " Open in new window.
	let g:bufExplorerMaxHeight=240        " Max height


""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key remap of all modes.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" pre defined of macro of key strobe actions.
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	let @m=":s#^#//#,nl"
	let @n=":s#^//##,nl"
	let @s=":s/^/#/,nl"


	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" insert mode key remap
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	inoremap <silent> <C-a> <Home>
	inoremap <silent> <C-e> <End>
	inoremap <silent> <C-h> <Left>
	inoremap <silent> <C-l> <Right>
	inoremap <C-o> <C-c>
	inoremap <C-Del> <c-g>u<c-c>lC
	"http://vim.wikia.com/wiki/Recover_from_accidental_Ctrl-U
	inoremap <c-j> <c-g>j
	"inoremap <c-k> <c-g>u<c-c>lC
	inoremap <c-k> <c-g>k
	inoremap <c-u> <c-g>u<c-u>
	inoremap <c-w> <c-g>u<c-w>
	"inoremap <C-l> <C-o>:set im<cr><C-l>
	"nnoremap <C-l> :set noim<cr>
	inoremap <expr> <CR> pumvisible()?"\<C-Y>":"\<CR>"

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" Ex mode key remap
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" normal mode key remap
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	nnoremap ,, ,
	nnoremap - "_dd

	nmap <silent> ,32 f vt "xx$"xp
	nmap <leader>ap :call SaveFilePath()<cr>
	nmap <silent> <leader>ba :call My_Save_CompareFileName()<cr><cr>
	nmap <silent> <leader>bb :call My_CompareToFileName()<cr><cr>
	nmap <silent> <leader>c8 :call SetColorColumnC80()<CR>
	nmap <silent> <leader>ch :call SetColorColumn()<CR>
	nmap <silent> <leader>cf :cgete getmatches()<cr>
	nmap <silent> <leader>cg :call ReadQuickfixFile()<cr>
	nmap <silent> <leader>d# :bd#<cr>
	nmap <silent> <leader># :e#<cr>
	nmap <silent> <leader>da :%d<cr>
	nmap <silent> <leader>db :bdelete<cr>
	nmap <silent> <leader>df :Rename ~/tmp/del_%:t<cr>
	nmap <silent> <leader>dl :bdelete #<cr>
	nmap <silent> <leader>dk :%s#.*karlzheng_todel.*\n##<cr>
	nmap <silent> <leader>dm :%s#.*karldbg.*\n##<cr>
	nmap <silent> <leader>do :windo diffoff!<cr>:bufdo diffoff!<cr>
	nmap <silent> <leader>dp :%d<cr>"+P:1,/^\S/-2d<cr>:w<cr>/karldbg<cr>
	nmap <silent> <leader>dr :%s#\r\n#\r#g<cr>
	nmap <silent> <leader>ds :%s#\s*$##g<cr>
	nmap <silent> <leader>dt :diffthis<cr>:set wrap<cr>

	nmap <silent> <leader>e. :e .<cr>
	nmap <silent> <leader>e1 :e ~/tmp/tmp_work_file/1.c<cr>
	nmap <silent> <leader>e2 :e ~/tmp/tmp_work_file/2.c<cr>
	nmap <silent> <leader>ea :call Edit_vim_cur_edit_file_absolute_path()<cr>
	nmap <silent> <leader>eb :call EditCurFileRelaPath()<cr>
	nmap <silent> <leader>ed :call EdCommandProxy()<cr>
	nmap <silent> <leader>ee :e!<cr>
	nmap <silent> <leader>eh :e %:h<cr>
	nmap <silent> <leader>el :call ExecBufferLine("", "")<cr>
	"nmap <silent> <leader>em :e mgrep.mk<cr>
	nmap <silent> <leader>es :call EditScratch()<cr>
	nmap <silent> <leader>et :vs ~/tmp/tmp_work_file/%:t<cr>
	nmap <silent> <leader>ev :e ~/.vimrc<cr>
	nmap          <leader>gn :call Getfilename("", "")<CR>
	nmap <leader>fa :call SaveCurrentFileNameAbsolutePath()<cr>
	nmap <leader>fb :call SaveCurrentFileNameRelativePath()<cr>
	nmap <leader>fc :cs find c
	nmap <leader>fg :cs find g
	nmap <leader>fs :cs find s
	nmap <leader>fi :setlocal foldmethod=indent<cr>zR
	nmap <leader>fm :setlocal foldmethod=manual<cr>
	nmap <silent> <leader>fn :call My_Save_CurrentFileName()<cr><cr>
	nmap <leader>fp :call Vim_cd_absolute_path()<cr>
	nmap <leader>gb :call GitDiffLog()<CR>:!p2d.sh /dev/shm/gitdiff.c 1>/dev/null 2>&1 &<CR><CR>
	nmap <leader>gi gg/include<cr>
	nmap <leader>go :call GitDiffLog()<CR>:!kompare /dev/shm/gitdiff.c 1>/dev/null 2>&1 &<CR><CR>
	nmap <silent> <leader>gc :git checkout -- %<cr>
	nmap <silent> <leader>ge :!gedit %&<cr>
	nmap <silent> <leader>gg :call My_compile_command()<cr>
	" for function GitDiffLog1()
	nnoremap <leader>gw "gyiw
	"nmap <leader>kb :!p2d.sh % 1>/dev/null 2>&1 &<cr><cr>
	nmap <leader>ko :!kompare % 1>/dev/null 2>&1 &<cr><cr>
	"http://vim.wikia.com/wiki/Search_and_replace_in_multiple_buffers
	"http://vim.wikia.com/wiki/Highlight_current_line
	nmap <silent> <Leader>lc ml:execute 'match Search /\%'.line('.').'l/'<CR>
	nmap <silent> <leader>ls :ls<cr>
	nmap <silent> <leader>jj ggVGJ
	nmap <leader>ma :set modifiable<cr>
	nmap <silent> <leader>mj :make -j16<cr>
	nmap <silent> <leader>mz :make zImage -j16<cr>
	nmap <silent> <leader>nl :nohl<cr>
	nmap <silent> <leader>nn :set nonu<cr>
	nmap <silent> <leader>pt :!pr.sh &<cr><cr>
	nmap <silent> <leader>pv :sp /tmp/pt.txt<cr>2<C-W>_<C-W><C-W>
	nmap <silent> <leader>qh <C-W>h:bd<cr>
	nmap <silent> <leader>qj <C-W>j:bd<cr>
	nmap <silent> <leader>qk <C-W>k:bd<cr>
	nmap <silent> <leader>ql <C-W>l:bd<cr>
	nmap <silent> <leader>qq :q<cr>
	nmap <silent> <leader>qw :wq<cr>
	nmap <silent> <leader>qf :q!<cr>
	nmap <silent> <leader>qa :qa<cr>
	nmap <leader>r1 :r ~/tmp/tmp_work_file/1.txt<cr>
	nmap <silent> <leader>ra :!./a.out<cr>
	"nmap <silent> <leader>rd :r ~/tmp/delay.c<cr>
	nmap <silent> <leader>rd :r !date<cr>
	nmap <silent> <leader>rm :r ~/tmp/main.c<cr>
	nmap <silent> <leader>rl :%d<CR>"+p
	nmap <silent> <leader>rr :reg<cr>
	nmap <silent> <leader>rs :20 vs ~/.stardict/iremember/tofel.txt<CR>
	nmap <silent> <leader>rt :r ~/tmp/tmp_work_file/%:t<cr>
	nmap <silent> <leader>sc :set ft=c<cr>
	nmap <silent> <leader>sd :call SvnDiffCurrentFile()<cr>
	nmap <leader>sf :call SaveFile2Tar()<cr>
	nmap <silent> <leader>sl :!svn log %<cr>
	nmap <silent> <leader>sn :set nu<cr>
	nmap <silent> <leader>sm :set ft=make<cr>
	nmap <silent> <leader>sp :set paste<cr>
	nmap <silent> <leader>ss :source %<cr>
	nmap <silent> <leader>srv :call SvnRevertCurrentFile()<cr>
	nmap <silent> <leader>tl :TlistToggle<cr>
	nmap <silent> <leader>vb :vs ~/.bashrc<cr>
	nmap <silent> <leader>vs :vs<cr>
	nmap <silent> <leader>vt :vs ~/tmp/tmp_work_file/%:t<cr>
	nmap <silent> <leader>wj <C-W>j
	nmap <silent> <leader>wk <C-W>k
	nmap <silent> <leader>wh <C-W>h
	nmap <silent> <leader>wl <C-W>l
	nmap <silent> <leader>WJ <C-W>j
	nmap <silent> <leader>WK <C-W>k
	nmap <silent> <leader>WH <C-W>h
	nmap <silent> <leader>WL <C-W>l
	nmap <leader>w1 :w! ~/tmp/tmp_work_file/1.c<cr>
	nmap <leader>w2 :w! ~/tmp/tmp_work_file/2.c<cr>
	nmap <leader>wt :silent! w! ~/tmp/tmp_work_file/%:t<cr>
	nmap <silent> <leader>wa :wa<cr>
	nmap <silent> <leader>wf :w!<cr>
	nmap <silent> <leader>wq :wq<cr>
	nmap <silent> <leader>ww :w<cr>
	nmap <silent> <leader>WW :w<cr>
	nmap <silent> <leader>ya ggVGy``
	nnoremap Y ggY``P

	"nnoremap <silent> * :call MySpecialSearch('f', 0)<CR>
	"nnoremap <silent> # :call MySpecialSearch('b', 0)<CR>
	nnoremap <silent> # #N
	nnoremap <silent> * *N
	"http://hi.baidu.com/denmeng/blog/item/b6d482fc59f4c81e09244dce.html
	nnoremap <leader><space> @=((foldclosed(line('.')) < 0) ? ((foldlevel('.') > 0) ? 'zc':'zfi{') : 'zo')<CR>

	cnoremap <silent> <F3> Bgrep
	nnoremap <silent> <F3> :Grep \<<cword>\> %<CR> <CR>
	"nnoremap <silent> <F4> :Grep \<<cword>\s*= %<CR> <CR>
	"nnoremap <silent> <F4> :SrcExplToggle<CR>:nunmap g:SrcExpl_jumpKey<cr>
	nnoremap <silent> <F4> :SrcExplToggle<CR>
	nnoremap <silent> <F6> :cp<CR>
	nnoremap <silent> <F7> :cn<CR>
	"nnoremap <silent> <F7> :SrcExplToggle<CR>
	nnoremap <silent> <F8> :TlistToggle<CR>

	nnoremap <silent> <C-6> <C-S-6>

	nnoremap <silent> <C-j>  <C-w>j
	nnoremap <silent> <C-k>  <C-w>k
	nnoremap <silent> <C-h>  <c-w>h
	nnoremap <silent> <C-l>  <c-w>l

	"<C-down>
	nnoremap <silent>  [1;5B 4j
	"<C-up>
	nnoremap <silent>  [1;5A 4k

	if has("gui_running")
		nmap <silent> ê 1<C-w>+
		nmap <silent> ë 1<C-w>-
		nmap <silent> è 1<C-W><
		nmap <silent> ì 1<C-W>>
	else
		nmap <silent> j 1<C-w>+
		nmap <silent> k 1<C-w>-
		nmap <silent> h 1<C-W><
		nmap <silent> l 1<C-W>>
		nmap <silent> J 1<C-W>+
		nmap <silent> K 1<C-W>-
		nmap <silent> H 1<C-W><
		nmap <silent> L 1<C-W>>
	endif

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" visual mode key remap
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	vmap <silent> j 4j
	vmap <silent> k 4k
	vmap <leader>cl :!column -t<CR>
	vmap <leader>w1 :w! ~/tmp/tmp_work_file/1.txt<cr>
	"Basically you press * or # to search for the current selection !! Really useful
	vnoremap <silent> * :call MySpecialSearch('f', 1)<CR>
	vnoremap <silent> # :call MySpecialSearch('b', 1)<CR>
	"http://tech.groups.yahoo.com/group/vim/message/105517
	":au CursorHold * exec 'match IncSearch /'.expand("<cword>").'/'
	"nnoremap <leader>h :exec 'match IncSearch /'.expand("<cword>").'/'<cr>
	vnoremap <Leader># "9y?<C-R>='\V'.substitute(escape(@9,'\?'),'\n','\\n','g')<CR><CR>
	vnoremap <Leader>* "9y/<C-R>='\V'.substitute(escape(@9,'\/'),'\n','\\n','g')<CR><CR>
	"http://hi.baidu.com/denmeng/blog/item/b6d482fc59f4c81e09244dce.html
	vnoremap <leader><space> @=((foldclosed(line('.')) < 0) ? ((foldlevel('.') > 0) ? 'zc':'zf') : 'zo')<CR>
	vnoremap <c-y> "+y

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" misc of .vimrc; useless.
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! Test_func1()
	  redir => g:mymsg
	  silent execute "pwd"
	  redir END
	  echo g:mymsg
	  "let v:statusmsg=""
	  "execute "cd /usr/src"
	  "echo v:statusmsg
	  "return v:statusmsg
	  ""let g:mymsg = v:statusmsg
	endfunction

func! MyPythonProcessLineText(expl)
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

	"!cat /dev/shm/beyond_compare_file_a | python -c "import sys,fileinput as f;[sys.stdout.write(str(f.lineno())+a) for a in f.input()]"

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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" key map
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
imap <c-b> <ESC>bi
imap <c-B> <ESC>Bi

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" the end of my .vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:my_vimrc_is_loaded = 1
