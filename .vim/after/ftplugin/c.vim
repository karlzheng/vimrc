" OmniCppComplete initialization
call omni#cpp#complete#Init()

setlocal indentexpr=GetMyCIndent()

function! GetMyCIndent()
    let theIndent = cindent(v:lnum)

    let m = matchstr(getline(v:lnum - 1),
    \                '^\s*\w\+\s\+\S\+.*=\s*{\ze[^;]*$')
    if !empty(m)
        let theIndent = len(m)
    endif

    return theIndent
endfunction

"https://www.coder.work/article/1564475
"使用matchstr()而不是matchlist()可以使代码更易于理解(len(m)代替len(m[0]))。
"在行的开头保留空格，以便可以嵌套声明(例如，在函数中)。
"在赋值运算符之前允许两个以上的单词。这会处理static声明。
"仅检查第一个左方括号({)，以便表达式也匹配一维数组(或结构)。
"不匹配包含分号(;)的表达式，因为这表明声明位于一行中(即，下一行不应该在左括号下对齐)。我认为这是比在行尾查找方括号或逗号更通用的方法。
