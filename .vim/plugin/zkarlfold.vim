" zkarlfold.vim: make a special fold command in vim editor
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
"     See :help zkarlfold.txt

"1. case 1: the current line end with '{' char, will exec "$zfi%"
"2. case 2: else,(1) if the next line is same indent with this line, find all the next same indent lines;(2)if the next line is more indent with this line. just find all the next more indent lines, and decide the end line.
  
"setlocal foldmethod=expr
"setlocal foldexpr=(getline(v:lnum)=~'^$')?-1:((indent(v:lnum)<indent(v:lnum+1))?('>'.indent(v:lnum+1)):indent(v:lnum))
"set foldtext=getline(v:foldstart)
"set fillchars=fold:\ "(there's a space after that \)
"highlight Folded ctermfg=DarkGreen ctermbg=Black

function! ZKarlFindStartLine(curline, maxline)
	let l:line = a:curline
	if l:line >= a:maxline
		return l:line
	endif
	while l:line <= a:maxline
		if (getline(l:line) =~ '^\s*$' || getline(l:line) =~ '^\s*#ifdef' || getline(l:line) =~ '^\s*#ifndef' || getline(l:line) =~ '^\s*#define' || getline(l:line) =~ '^\s\*#endif' || getline(l:line) =~ '^\s*#if ' || getline(l:line) =~ '^\s*#else')
			let l:line += 1
			break
		elseif (getline(l:line) =~ 'while.*{\s*$' || getline(l:line) =~ 'for.*{\s*$' || getline(l:line) =~ 'if.*{\s*$')
			break
		elseif getline(l:line) =~ '\s*\w*.*(.*)' && getline(l:line + 1) =~ '{\s*'
			let l:line += 1
			break
		else
			break
		endif
	endwhile
	if l:line > a:maxline
		let l:line = a:maxline
	endif
	return l:line
endfunction


function! ZKarlFindCurrentLine(curline, maxline)
	let l:line = a:curline
	if l:line >= a:maxline
		return l:line
	endif
	while l:line <= a:maxline
		if (getline(l:line) =~ '$\s*$' || getline(l:line) =~ '^\s*$' || getline(l:line) =~ '^\s*#ifdef' || getline(l:line) =~ '^\s\*#define' || getline(l:line) =~ '^\s\*#endif')
			let l:line += 1
		else
			break
		endif
	endwhile
	if l:line > a:maxline
		let l:line = a:maxline
	endif
	return l:line
endfunction

function! ZKarlFindNextLine(curline, maxline)
	let l:line = a:curline
	if l:line >= a:maxline
		return l:line
	endif
	let l:line += 1
	while l:line <= a:maxline
		if (getline(l:line) =~ '^\s*$' || getline(l:line) =~ '^\s*#ifdef' || getline(l:line) =~ '^\s\*#define' || getline(l:line) =~ '^\s\*#endif')
			let l:line += 1
			break
		else
			break
		endif
	endwhile
	if l:line > a:maxline
		let l:line = a:maxline
	endif
	return l:line
endfunction

function! ZKarlBlockFoldFunc()
	let foldmethod_save = &foldmethod
		
	let l:startline = line('.')
	let l:curline = line('.')
	let l:maxline = line('$')
	
	let l:curline = ZKarlFindStartLine(l:curline, l:maxline)

	if getline(l:startline) =~ '#ifdef' || getline(l:startline) =~ '#if defined' || getline(l:startline) =~ '#if ' || getline(l:startline) =~ '#ifndef ' || getline(l:startline) =~ '#else'
		normal ]#
		let l:start_line = l:curline
		let l:end_line = line('.') - 1
		normal zd
		exe ":".l:start_line.",".l:end_line."fo"
	elseif getline(l:curline) =~ '{\s*$'
		exe ":".l:curline
		normal $zfi{
	elseif getline(l:curline) =~ '}\s*$'
		exe ":".l:curline
		normal $zfi{
	else
		let l:startline_indent = indent(l:curline) 
		let l:line = l:curline
		if getline(l:line) =~ '^\s*case\s*:'
			let l:line += 1
		endif
		let l:start_line = l:line
		let l:nextline = ZKarlFindNextLine(l:line, l:maxline) 
		let l:nextline_indent  = indent(l:nextline) 

		if l:nextline_indent == l:startline_indent
			"fold all the >= indent lines
			while l:line < l:maxline
				let l:line = ZKarlFindCurrentLine(l:line, l:maxline)
				let l:nextline = ZKarlFindNextLine(l:line, l:maxline)
				let l:nextline_indent = indent(l:nextline) 
				if l:nextline_indent < l:startline_indent
					echo "got the end line Nr."
					break
				endif
				let l:line += 1
			endwhile
		else
			if l:nextline_indent > l:startline_indent
				"fold all the more indent lines
				let l:start_line = l:line + 1
				while l:line < l:maxline
					let l:line = ZKarlFindCurrentLine(l:line, l:maxline)
					let l:nextline = ZKarlFindNextLine(l:line, l:maxline)
					let l:nextline_indent = indent(l:nextline) 
					if l:nextline_indent == l:startline_indent
						"got the end line Nr.
						break
					endif
					let l:line += 1
				endwhile
			else
				"skip the less indent lines fold
				echo "the next line is less indent!"
			endif
		endif
		let l:end_line = l:line
		if l:end_line > l:maxline
			let l:end_line = l:maxline
		endif
		echo ":".l:start_line.",".l:end_line."fo"
		normal zd
		exe ":".l:start_line.",".l:end_line."fo"
	endif

	exe "set foldmethod=".foldmethod_save
endfunc
nmap <silent> zi :call ZKarlBlockFoldFunc()<cr><cr>
"highlight Folded ctermfg=DarkGreen ctermbg=Black
highlight Folded ctermfg=Green ctermbg=Black

