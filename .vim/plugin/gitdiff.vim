""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" gitdiff.vim: make a git diff command in vim editor
" Author: KarlZheng (zhengkarl at gmail dot com)
" Last Change: 10-Jan-2012 @ 18:30
" Created:     11-Oct-2011
" Requires:    Vim-7.1
" Version:     0.0.1
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt 
" Download From:
"     http://www.vim.org//script.php?script_id=
" Usage:
"     See :help gitdiff.txt
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

function! GitDiffLog()
	 let l:curline = line('.')
	 let l:maxline = line('$')
	 let l:gitdiff_filename = "/tmp/gitdiff.c"

	 "find the firsttag
	 let l:line = l:curline + 1
	 while l:line <= l:maxline
		 let l:linetext = getline(l:line)
		 if matchstr(l:linetext, "^commit ") != ""
			 let l:firsttag= strpart(l:linetext, 7, 40)
			 break
		 endif
		 let l:line = l:line + 1
	 endwhile
	 
	 "find the second tag (new tag)
	 let l:line = l:curline
	 while l:line >= 0
		 let l:linetext = getline(l:line)
		 if matchstr(l:linetext, "^commit ") != ""
			 let l:secondtag = strpart(l:linetext, 7, 40)
			 let l:repoDir = getline(l:line -1)
			 if isdirectory(l:repoDir)
			     exec "cd ".l:repoDir
			 endif
			 break
		 endif
		 let l:line = l:line - 1
	 endwhile

	 if l:curline == 1
		 let l:_cmd_ = 'git diff > ' . l:gitdiff_filename
	 else
		 let l:_cmd_ = 'git diff '.l:secondtag.'^ '.l:secondtag.' -p -U10 --raw > ' .  l:gitdiff_filename
	 endif
	 let g:ccc = l:_cmd_

	 let _resp = system(l:_cmd_)
	 let g:rrr = _resp

	 if ! isdirectory("~/person_tools/")
		 let l:_cmd_ = 'git diff '.l:secondtag.'^ '.l:secondtag.' -p -U100000 --raw > ' . "~/diff.patch"
		 let _resp = system(l:_cmd_)
	 endif

	let l:dict = {}
	let l:gitdiffbuf = 0 
	let l:gitdiffwnd = 0 

	redir => g:mymsg
	for i in range(1, bufnr("$"))                                        
		let l:buffilename = bufname(i)
		let l:wn = bufwinnr(l:buffilename)
		if l:wn != -1
			let l:dict[l:wn] = l:buffilename
			if matchstr(l:buffilename, "gitdiff") != ""
				echo "match"
				let l:gitdiffbuf = i
				let l:gitdiffwnd = l:wn
			endif
		endif
	endfor

	if l:gitdiffbuf != 0 
		if l:gitdiffwnd != 0
			exe l:gitdiffwnd . "wincmd w"
		endif
		exe "e " . l:gitdiff_filename
	else
		exe "vs"
		exe "wincmd L"
		exe "e " . l:gitdiff_filename
	endif
	 let l:maxline = line('$')
	 let l:line = 1
	 while l:line <= l:maxline
		 let l:linetext = getline(l:line)
		 if matchstr(l:linetext, "--- a/") != ""
			 break
		 endif
		 let l:line = l:line + 1
	 endwhile
	exe "normal ".l:line."gg"
	exe "wincmd h"
	redir END
endfunc

function! GitDiffLog_and_bcompare()
	GitDiffLog()
	exec "!patch2dir.sh /dev/shm/gitdiff.c 1>/dev/null 2>&1 &"
endfunc

"nnoremap <leader>gb :call GitDiffLog_and_bcompare()<cr>

function! <SID>GitEditFileInLine()
	let l:linetext = getline('.')

	if matchstr(l:linetext, "^--- a/") != ""
		let l:linetext = "sp ".substitute(l:linetext, "--- a/", "", "")
		let l:nextlinetext = getline(line('.') + 2)
	elseif matchstr(l:linetext, "^--- ") != ""
		let l:linetext = "sp ".substitute(l:linetext, "--- ", "", "")
		let l:nextlinetext = getline(line('.') + 2)
	elseif matchstr(l:linetext, "^+++ b/") != ""
		let l:linetext = "sp ".substitute(l:linetext, "^+++ b/", "", "")
		let l:nextlinetext = getline(line('.') + 1)
	elseif matchstr(l:linetext, "^+++ ") != ""
		let l:linetext = "sp ".substitute(l:linetext, "+++ ", "", "")
		let l:nextlinetext = getline(line('.') + 1)
	endif
	let l:linetext = substitute(l:linetext, "\t.*$", "", "")
	let l:linenu = substitute(nextlinetext, "@@.*-\\d*,\\d*\\s\+\\(\\d*\\).*", "\\1", "g")
	exec l:linetext
	exec "normal ".l:linenu."gg"
	"exe "wincmd J"
endfunction

command! GitEditFileInLine call <SID>GitEditFileInLine()

function! <SID>GitkCurCommit()
	 let l:ln = getline('.')

	 if matchstr(l:ln, "^commit ") != ""
		 let l:tag= strpart(l:ln, 7, 40)
		 let l:cmd = "gitk ".l:tag." &"
		 let _resp = system(l:cmd)
	 endif
endfunc

command! GitkCurCommit call <SID>GitkCurCommit()

command! GitDiffLog call GitDiffLog()
