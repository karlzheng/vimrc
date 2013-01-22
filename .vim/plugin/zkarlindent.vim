" zkarlindent.vim: make a find indent command in vim editor
" Author: KarlZheng (zhengkarl at gmail dot com)
"         http://www.weibo.com/zhengkarl 
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
"     See :help zkarlindent.txt
"     http://vim.wikia.com/wiki/VimTip112

function! ZKarlFindMoreIndent()
	let l:cl = line('.')
	let l:ml = line('$')
	let l:si = indent(l:cl) 
	let l:ln = l:cl + 1
	
	while l:ln <= l:ml
		let l:ci = indent(l:ln)
		if l:ci > l:si
			break
		else
			let l:ln += 1
		endif
	endwhile
	exec "norm ".l:ln."gg"
endfunc
command! ZKarlFindMoreIndent call ZKarlFindMoreIndent()
nnoremap <leader>im :ZKarlFindMoreIndent<cr>

function! ZKarlFindLessIndent()
	let l:cl = line('.')
	let l:sl = 0
	let l:si = indent(l:cl) 
	let l:ln = l:cl - 1
	
	while l:ln >= 0
		let l:ci = indent(l:ln) 
		if strlen(getline(l:ln)) == 0
		    let l:ln -= 1
		    continue
		endif
		if l:ci < l:si
			break
		else
			let l:ln -= 1
		endif
	endwhile
	exec "norm ".l:ln."gg"
endfunc
command! ZKarlFindLessIndent call ZKarlFindLessIndent()
nnoremap <leader>il :ZKarlFindLessIndent<cr>

