" zkarl_spaceline.vim: make quickly go space line in vim editor
" Author: KarlZheng (zhengkarl at gmail dot com)
"         http://www.weibo.com/zhengkarl
" Last Change: 10-Jan-2015 @ 18:30
" Created:     10-Jan-2015
" Requires:    Vim-7.1
" Version:     0.0.1
" Licence: This program is free software; you can redistribute it and/or
"          modify it under the terms of the GNU General Public License.
"          See http://www.gnu.org/copyleft/gpl.txt
" Download From:
"     http://www.vim.org//script.php?script_id=
" Usage:
"     See :help zkarl_spaceline.txt

function! ZKarl_Find_SpaceLine(direct)
	let l:cur_line = line('.')
	let l:goto_line = l:cur_line

	if a:direct == 'next'
		let l:end_line = line('$')
	else
		let l:end_line = 1
	endif

	let l:line = l:cur_line

	if a:direct == 'next'
		while l:line <= l:end_line
			let l:line += 1
			if l:line > l:end_line
				break
			endif
			if (getline(l:line) =~ '^\s*$')
				let l:goto_line = l:line
				break
			endif
		endwhile
	else
		while l:line >= l:end_line
			let l:line -= 1
			if l:line < l:end_line
				break
			endif
			if (getline(l:line) =~ '^\s*$')
				let l:goto_line = l:line
				break
			endif
		endwhile
	endif
	exec "norm ".l:goto_line."gg"
endfunction

nnoremap <silent><leader>gs :call ZKarl_Find_SpaceLine('next')<cr>
nnoremap <silent><leader>us :call ZKarl_Find_SpaceLine('pre')<cr>
