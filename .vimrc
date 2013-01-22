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
set fencs=utf-8,gbk,big5,euc-jp,utf-16le,gb2312,gb18030
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
set tabstop=8
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

let g:root_work_path = escape(getcwd(), " ")


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
	function! My_SaveVimFilePath()
		let str = expand("%:p:h")
		let str = s:Escape(str)
		execute ":!echo '".str."' > /dev/shm/vim_cur_file_path"
	endfunction
	nmap <leader>cdv :call My_SaveVimFilePath()<cr><cr>

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
		let l:_f_ = expand("%")
		let l:_cmd_ = 'echo ' . '"' . l:_f_ . '" > /dev/shm/vim_cur_edit_file_relative_path'
		let l:_resp = system(l:_cmd_)
	endfunction

	function! SaveCurrentFileNameAbsolutePath()
		let l:_f_ = expand("%:p")
		let l:_cmd_ = 'echo ' . '"' . l:_f_ . '" > /dev/shm/vim_cur_edit_file_absolute_path'
		let l:_resp = system(l:_cmd_)
	endfunction

	function! Edit_vim_cur_edit_file_relative_path()
		let l:_cmd_ = 'cat ' . '/dev/shm/vim_cur_edit_file_relative_path'
		let l:_resp = system(l:_cmd_)
		exec "e ".l:_resp
	endfunction
	
	function! Edit_vim_cur_edit_file_absolute_path()
		let l:_cmd_ = 'cat ' . '/dev/shm/vim_cur_edit_file_absolute_path'
		let l:_resp = system(l:_cmd_)
		exec "e ".l:_resp
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
	exec "LUTags ".l:filename
endf
command! -nargs=* -complete=tag -bang ParseFilenameTag :call ParseFilenameTag("<args>", "<bang>")

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	" buffer functions
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
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
	command! Bwipe  call <SID>BufcloseCloseIt(1)
	command! Bclose call <SID>BufcloseCloseIt(0)
	nmap <leader>bd :Bclose<cr>
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
		let l:saved_reg = @"
		if a:is_VisualSearch
			execute "normal! vgvy"
		else
			execute "normal! yiw"
		endif
		let l:pattern = escape(@", '\\/.*$^~[]')
		let l:pattern = substitute(l:pattern, "\n$", "", "")
		let @/ = l:pattern
		if a:direction == 'b'
			call search(l:pattern, 'bn')
		else
			exec "normal! /" . l:pattern
		endif
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
	nmap <c-q> :call BwipeCurrentBuffer()<cr>

	func! AddDebugLine()
	    let l:msg = ''
	    if &ft == "c"
		if isdirectory(g:root_work_path."/arch/arm/configs")
		    let l:msg = 'pr_err("mzdbg %s %d\n", __func__, __LINE__);'
		else
		    let l:msg = 'printf("mzdbg %s %d\n", __func__, __LINE__);'
		endif
	    endif
	    if &ft == "make"
		let l:msg = '$(warning "mzdbg")'
	    endif
	    if &ft == "python"
		let l:msg = 'import inspect;print ("mzdbg %s %d" %(__file__, inspect.currentframe().f_lineno))'
	    endif
	    if &ft == "sh"
		let l:msg ='echo mzdbg $(basename $0) $LINENO'
	    endif
	    if l:msg != ''
		call append(line('.'), l:msg)
		exec "normal Vj=j"
	    endif
	endfunction
	nmap <silent> <leader>al :call AddDebugLine()<cr>

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
	au FileType c,cpp,h,hpp set shiftwidth=8 |set tabstop=8 | set iskeyword-=-,>()
	au FileType c,cpp,h,hpp set fo-=l | set textwidth=80
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
			let LineContents = getline(Line)
			if LineContents !~ "^#"
				if InCopyright
					let CopyrightEnd = Line - 1
					exe CopyrightStart . ',' . CopyrightEnd . 'fold'
				endif
				break
			elseif LineContents =~ "Copyright"
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
		colorscheme borland
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
		let Tlist_Ctags_Cmd = '/usr/bin/ctags'
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
		nmap [s :cscope find s <cword><CR>
		nmap [t :cscope find t <cword><CR>
	endif

	"http://vim.wikia.com/wiki/Autocmd_to_update_ctags_file
	function! UPDATE_TAGS()
		let l:_f_ = expand("%:p")
		let l:_cmd_ = '"ctags -a --c++-kinds=+p --fields=+iaS --extra=+q " ' . '"' . l:_f_ . ' & "'
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
		let g:use_LookupFile_FullNameTagExpr = 0
		return files
	endfunction

	"nmap <silent> <leader>lf :LUTags <C-R>=expand("<cword>")<cr><cr>
	nmap <silent> <leader>lt :LUTags<cr>
	nmap <silent> <leader>lf :call ParseFilenameTag("", "")<CR>
	nmap <silent> <leader>lb :LUBufs<cr>
	nmap <silent> <leader>lw :LUWalk<cr>

	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	"Quickfix
	"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
	function! ReadQuickfixFile()
		let l:whoami = system("whoami | tr -d '\r' | tr -d '\n' ")
		if filereadable("/home/karlzheng/241/quickfix.txt")
			"exe 'cg /home/karlzheng/241/quickfix.txt'
			let l:_resp = system('rsync -avurP /home/karlzheng/241/quickfix.txt /dev/shm/karlzheng/quickfix.txt')
			let l:_resp = system('rsync -avurP /dev/shm/karlzheng/quickfix.txt /home/karlzheng/241/quickfix.txt')
		endif
		exe 'cg /dev/shm/'.l:whoami.'/quickfix.txt'
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
	    let l:whoami = system("whoami | tr -d '\r' | tr -d '\n' ")
	    call writefile(l:qf_data_list, "/dev/shm/".l:whoami."/quickfix.txt")
	    if ! isdirectory('/home/karlzheng/')
		call writefile(l:qf_data_list, $HOME."/quickfix.txt")
	    endif
	    if filereadable($HOME.'/241/quickfix.txt')
		call writefile(l:qf_data_list, $HOME."/241/quickfix.txt")
	    endif
	endfunc
	nmap <leader>sq :call SaveQuickfixToFile()<cr>
	
	function! EditQuickfixList()
	    if filereadable("/home/karlzheng/241/quickfix.txt")
		exe 'e /home/karlzheng/241/quickfix.txt'
	    else
		exe 'e /dev/shm/karlzheng/quickfix.txt'
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
	let g:miniBufExplorerMoreThanOne = 2   " Display when more than 2 buffers
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
	nnoremap <Esc><Esc> :q<cr>
	
	nmap <silent> ,32 f vt "xx$"xp
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
	nmap <silent> <leader>dm :%s#.*mzdbg.*\n##<cr>
	nmap <silent> <leader>do :windo diffoff!<cr>:bufdo diffoff!<cr>
	nmap <silent> <leader>dp :%d<cr>"+P:1,/^\S/-2d<cr>
	nmap <silent> <leader>dr :%s#\r\n#\r#g<cr>
	nmap <silent> <leader>ds :%s#\s*$##g<cr>
	nmap <silent> <leader>dt :diffthis<cr>:set wrap<cr>

	nmap <silent> <leader>e. :e .<cr>
	nmap <silent> <leader>e1 :e ~/tmp/tmp_work_file/1.c<cr>
	nmap <silent> <leader>e2 :e ~/tmp/tmp_work_file/2.c<cr>
	nmap <silent> <leader>ea :call Edit_vim_cur_edit_file_absolute_path()<cr>
	nmap <silent> <leader>eb :call Edit_vim_cur_edit_file_relative_path()<cr>
	nmap <silent> <leader>ee :e!<cr>
	nmap <silent> <leader>eh :e %:h<cr>
	if MySys() == "linux"
		nmap <leader>es :e ~/tmp/scratch<cr>
		":setl buftype=nofile<cr>
	else
		nmap <leader>es :tabnew $TEMP/scratch.txt<cr>
	endif
	nmap <silent> <leader>em :e mgrep.mk<cr>
	nmap <silent> <leader>et :vs ~/tmp/tmp_work_file/%:t<cr>
	nmap <silent> <leader>ev :e ~/.vimrc<cr>
	nmap <silent> <leader>vb :vs ~/.bashrc<cr>
	nmap <leader>fa :call SaveCurrentFileNameAbsolutePath()<cr>
	nmap <leader>fb :call SaveCurrentFileNameRelativePath()<cr>
	nmap <leader>fc :cs find c
	nmap <leader>fg :cs find g
	nmap <leader>fs :cs find s
	nmap <leader>fi :setlocal foldmethod=indent<cr>zR
	nmap <leader>fm :setlocal foldmethod=manual<cr>
	nmap <silent> <leader>fn :call My_Save_CurrentFileName()<cr><cr>
	nmap <leader>gi gg/include<cr>
	nmap <silent> <leader>gc :git checkout -- %<cr>
	nmap <silent> <leader>ge :!gedit %&<cr>
	nmap <silent> <leader>gg :call My_compile_command()<cr>
	" for function GitDiffLog1()
	nnoremap <leader>gw "gyiw
	nmap <silent> <leader>ko :!kompare % 1>/dev/null 2>&1 &<cr><cr>
	"http://vim.wikia.com/wiki/Search_and_replace_in_multiple_buffers
	"http://vim.wikia.com/wiki/Highlight_current_line
	nmap <silent> <Leader>lc ml:execute 'match Search /\%'.line('.').'l/'<CR>
	nmap <silent> <leader>ls :ls<cr>
	nmap <silent> <leader>jj ggVGJ
	nmap <leader>ma :set modifiable<cr>
	nmap <silent> <leader>mj :make<cr>
	nmap <silent> <leader>mz :!make zImage -j4<cr>
	nmap <leader>mv1 :mks! ~/tmp/vimcurrentedit.vim<cr>
	nmap <leader>mv2 :mks! vimcurrentedit.vim<cr>
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
	nmap <silent> <leader>rd :r ~/tmp/delay.c<cr>
	nmap <silent> <leader>rm :r ~/tmp/main.c<cr>
	nmap <silent> <leader>rn :%d<CR>"+p
	nmap <silent> <leader>rr :reg<cr>
	nmap <silent> <leader>rs :20 vs ~/.stardict/iremember/tofel.txt<CR>
	nmap <silent> <leader>rt :r ~/tmp/tmp_work_file/%:t<cr>
	nmap <silent> <leader>sc :set ft=c<cr>
	nmap <silent> <leader>sd :call SvnDiffCurrentFile()<cr>
	nmap <silent> <leader>sl :!svn log %<cr>
	nmap <silent> <leader>sn :set nu<cr>
	nmap <silent> <leader>sm :set ft=make<cr>
	nmap <silent> <leader>sp :set paste<cr>
	nmap <silent> <leader>ss :source %<cr>
	nmap <silent> <leader>srv :call SvnRevertCurrentFile()<cr>
	nmap <leader>sv1 :source ~/tmp/vimcurrentedit.vim<cr>
	nmap <leader>sv2 :source vimcurrentedit.vim<cr>
	nmap <silent> <leader>tl :TlistToggle<cr>
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
	nnoremap Y ggY``p

	nnoremap <silent> * :call MySpecialSearch('f', 0)<CR>
	nnoremap <silent> # :call MySpecialSearch('b', 0)<CR>
	"http://hi.baidu.com/denmeng/blog/item/b6d482fc59f4c81e09244dce.html
	nnoremap <leader><space> @=((foldclosed(line('.')) < 0) ? ((foldlevel('.') > 0) ? 'zc':'zfi{') : 'zo')<CR>

	nnoremap <silent> <F2> :Grep
	nnoremap <silent> <F3> :Grep \<<cword>\> %<CR> <CR>
	nnoremap <silent> <F4> :Grep \<<cword>\s*= %<CR> <CR>
	nnoremap <silent> <F6> :cp<CR>
	nnoremap <silent> <F7> :cn<CR>
	nnoremap <silent> <F8> :TlistToggle<CR>

	nnoremap <silent> <C-6> <C-S-6>

	nnoremap <silent> <C-j>  <C-w>j
	nnoremap <silent> <C-k>  <C-w>k
	nnoremap <silent> <C-h>  <c-w>h
	nnoremap <silent> <C-l>  <c-w>l

	nnoremap <silent> <C-n> :bn<cr>
	nnoremap <silent> <C-p> :bp<cr>
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

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" the end of my .vimrc
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
let g:my_vimrc_is_loaded = 1

