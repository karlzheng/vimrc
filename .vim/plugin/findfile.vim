
function FindFile()
  if ! filereadable('cscope.files')
    echo "ERROE: Can not read cscope.files"
    return
  endif
  tabnew

  let select = 0
  let fileList = readfile('cscope.files')
  let lastFilter = ""
  let filter = ""
  let filePos = 0
  let matchItems = []
  while 1
    call setline(1, "Filter: " . filter . "_")

    "如果是删除一个字符则清除之前的搜索结果
    if len(filter) < len(lastFilter)
      let filePos = 0
      let matchItems = []
    endif

    "搜索文件
    if len(matchItems) == 0 || len(filter) != len(lastFilter)
      "从上次搜索结果里筛选
      let newMatchItems = []
      for matchItem in matchItems
        if stridx(tolower(matchItem), filter) >= 0
          call add(newMatchItems, matchItem)
        endif
      endfor
      let matchItems = newMatchItems

      "从上次搜索结束处继续搜索
      while len(matchItems) < winheight(0) - 1 && filePos < len(fileList)
        let line = fileList[filePos]
        if stridx(tolower(line), filter) >= 0
          call add(matchItems, line)
        endif
        let filePos = filePos + 1
      endwhile
    endif

    "显示文件
    if select >= len(matchItems)
      let select = len(matchItems) - 1
    elseif select < 0 && len(matchItems) > 0
      let select = 0
    endif
    for i in range(0, len(matchItems) - 1)
      let matchItem = matchItems[i]
      if i == select
        call setline(i + 2, "->" . matchItem)
      else
        call setline(i + 2, "  " . matchItem)
      endif
    endfor

    "显示颜色
    syntax clear
    if filter != ""
      syntax case ignore
      execute 'syntax match FindFileFilter "' . filter . '"'
      highlight FindFileFilter ctermfg=darkgreen
    endif

    "删除后面的行
    for i in range(0, winheight(0) - len(matchItems) - 2)
      call setline(winheight(0) - i, "")
    endfor
    redraw

    "处理按键
    let lastFilter = filter
    let nr = getchar()
    let c = nr2char(nr)
    if nr == "\<BS>" "删除
      let filter = strpart(filter, 0, strlen(filter) - 1)
    elseif nr == "\<Esc>"
      let select = -1
      break
    elseif nr == "\<Up>" "向上
      let select = select - 1
      if select == -1
        let select = len(matchItems) - 1
      endif
      let select = select % len(matchItems)
    elseif nr == "\<Down>"  "向下
      let select = select + 1
      let select = select % len(matchItems)
    elseif c == "\<Enter>"  "回车
      break
    elseif c =~ "[a-z0-9\._-]"  "普通字符
      let filter = filter . c
    endif
  endwhile

  "获得选择的文件
  if select < 0 || filter == ""
    let file = ""
  else
    let file = getline(select + 2)
    if strlen(file) > 2
      let file = strpart(file, 2)
    else
      let file = ""
    endif
  endif

  "退出并打开文件
  if strlen(file) > 0
    execute "edit! " . file
  else
    quit!
  endif
endfunction
