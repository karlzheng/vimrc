
" README
" Map keys in .vimrc:
"   map <C-G> :call GrepMenu()<CR>
"   map <C-G>t :call GrepText(expand("<cword>"))<CR>
"   map <C-G>w :call GrepWord(expand("<cword>"))<CR>
"   map <C-G>f :call GrepFunction(expand("<cword>"))<CR>
"   map <C-G>c :call GrepClass(expand("<cword>"))<CR>
"   map <C-G>b :call GrepBack()<CR>
"

"grep
highlight GrepID            ctermfg=4  guifg=LightBlue
highlight GrepColon         ctermfg=6  guifg=Cyan
highlight GrepFileName      ctermfg=5  guifg=indianred
highlight GrepLineNumber    ctermfg=2  guifg=yellowgreen
highlight GrepKeyword       ctermfg=1  guifg=Red cterm=bold gui=bold

"返回列表
let s:back_list = []

function ParseGrepLine(line)
    let splitItem = split(a:line, ":")
    let colon1 = stridx(a:line, ":")
    let colon2 = stridx(a:line, ":", colon1 + 1)
    let fileName = strpart(a:line, 0, colon1)
    let fileLine = strpart(a:line, colon1 + 1, colon2 - colon1 - 1)
    let matchLine = strpart(a:line, colon2 + 1)
    return [fileName, fileLine, matchLine]
endfunction

function GrepPattern(pattern, word)
    let cmd = "grep -P --binary-files=without-match --color=never -n"
    \ . " --exclude-dir='.svn' --exclude-dir='.git'"
    \ . " --exclude='cscope.files' --exclude='cscope.out' --exclude='tags' --exclude='*.log'"
    \ . " \"" . escape(a:pattern, '\') . "\" * -r"
    "echo cmd
    "echo "\n"
    let result = system(cmd)
    let matchList = split(result, '\n')
    let idx = 0
    if len(matchList) == 0
        echo "Nothing is matched!"
        return
    elseif len(matchList) > 100
        echo "Too Many result!"
        return
    else
        let i = 1
        for i in range(len(matchList))
            let matchItem = matchList[i]
            let parsedItem = ParseGrepLine(matchItem)
            let matchList[i] = parsedItem
            "显示序号
            echohl GrepId
            echon (i + 1). "# "
            "显示文件名
            echohl GrepFileName
            echon parsedItem[0]
            echohl GrepColon
            echon ":"
            "显示行号
            echohl GrepLineNumber
            echon parsedItem[1]
            echohl GrepColon
            echon ":"
            "显示匹配行并高亮关键词
            echohl None
            let matchLine = parsedItem[2]
            let linePos = 0
            while 1
                let wordPos = stridx(matchLine, a:word, linePos)
                if wordPos == -1
                    echon strpart(matchLine, linePos)
                    break
                else
                    echon strpart(matchLine, linePos, wordPos - linePos)
                    echohl GrepKeyword
                    echon strpart(matchLine, wordPos, strlen(a:word))
                    echohl None
                    let linePos = wordPos + strlen(a:word)
                    if linePos >= strlen(matchLine)
                        break
                    endif
                endif
            endwhile
            echon "\n"
            let i = i + 1
        endfor
        let idx = input("Jump to: ")
        if idx <= 0 || idx > len(matchList)
            echo "Invalid Selection!"
            sleep 1
            return
        endif
        let idx = idx - 1
    endif
    "记录位置
    let back_pos = [expand("%"), line('.'), strpart(getline('.'), 0 , 100)]
    call insert(s:back_list, back_pos)
    "跳到文件位置
    let selectItem = matchList[idx]
    execute "edit " . selectItem[0]
    execute selectItem[1]
endfunction

function GrepText(word)
    call GrepPattern(a:word, a:word)
endfunction

function GrepWord(word)
    call GrepPattern('\b' . a:word . '\b', a:word)
endfunction

function GrepFunction(word)
    call GrepPattern('^[^\(]+[: ]' . a:word . '\(.*\)\s+(const\s*)?[{\n]', a:word)
endfunction

function GrepClass(word)
    call GrepPattern('\bclass ' . a:word . '\b[a-zA-Z0-9_ ]*[:{\n]', a:word)
endfunction

function GrepBack()
    "显示返回列表
    for i in range(len(s:back_list))
        let back_item = s:back_list[i]
        echohl GrepId
        echon (i + 1) . '# '
        echohl GrepFileName
        echon back_item[0]
        echohl GrepColon
        echon ':'
        echohl GrepLineNumber
        echon back_item[1]
        echohl GrepColon
        echon ':'
        echohl None
        echon back_item[2]
        echon "\n"
    endfor
    "选择返回位置
    let idx = input('Back to: ')
    if idx <= 0 || idx > len(s:back_list)
        echo "Invalid Selection!"
        sleep 1
        return
    endif
    "返回位置
    let back_pos = s:back_list[idx - 1]
    execute 'edit ' . back_pos[0]
    execute back_pos[1]
endfunction

function GrepMenu()
    let word = expand("<cword>")
    let type = inputlist(['Menu:', '1# Text', '2# Word', '3# Function', '4# Class', '5# [Back to ...]'])
    echo "\n"
    if type == 1
        call GrepText(word)
    elseif type == 2
        call GrepWord(word)
    elseif type == 3
        call GrepFunction(word)
    elseif type == 4
        call GrepClass(word)
    elseif type == 5
        call GrepBack()
    endif
endfunction
