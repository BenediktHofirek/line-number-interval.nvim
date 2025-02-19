function! line_number_interval#enable() abort

    let l:ui_type = ['gui', 'cterm']
    let l:fg_bg = ['fg', 'bg']

    let s:linenr_color = {}
    for l:type in l:ui_type
        let s:linenr_color[l:type] = {}
        for l:fb in l:fg_bg
            let s:linenr_color[l:type][l:fb] = synIDattr(synIDtrans(hlID('LineNr')), l:fb, l:type)
            if s:linenr_color[l:type][l:fb] ==# ''
                let s:linenr_color[l:type][l:fb] = 'NONE'
            endif
        endfor
    endfor

    if !hlexists('DimLineNr')
        execute 'highlight DimLineNr'
            \ 'guifg='   s:linenr_color.gui.bg   'guibg='   s:linenr_color.gui.bg
            \ 'ctermfg=' s:linenr_color.cterm.bg 'ctermbg=' s:linenr_color.cterm.bg
    endif

    let s:dim_linenr_color = {}
    for l:type in l:ui_type
        let s:dim_linenr_color[l:type] = {}
        for l:fb in l:fg_bg
            let s:dim_linenr_color[l:type][l:fb] = synIDattr(synIDtrans(hlID('DimLineNr')), l:fb, l:type)
            if s:dim_linenr_color[l:type][l:fb] ==# ''
                let s:dim_linenr_color[l:type][l:fb] = 'NONE'
            endif
        endfor
    endfor

    if s:dim_linenr_color.cterm.fg ==# 'NONE'
        let s:dim_linenr_color.cterm.fg = 0
    endif

    if s:dim_linenr_color.gui.fg ==# 'NONE'
        let s:dim_linenr_color.gui.fg = 'Black'
    endif

    if !hlexists('HighlightedLineNr')
        execute 'highlight HighlightedLineNr'
            \ 'guifg='   s:linenr_color.gui.fg   'guibg='   s:linenr_color.gui.bg
            \ 'ctermfg=' s:linenr_color.cterm.fg 'ctermbg=' s:linenr_color.cterm.bg
    endif

    execute 'highlight LineNr'
        \ 'guifg='   s:dim_linenr_color.gui.fg   'guibg='   s:dim_linenr_color.gui.bg
        \ 'ctermfg=' s:dim_linenr_color.cterm.fg 'ctermbg=' s:dim_linenr_color.cterm.bg

    call sign_define('LineNumberInterval', {
        \ 'numhl': 'HighlightedLineNr'
        \ })

    for i in range(1, 20)
        if hlexists('HighlightedLineNr' . i)
            call sign_define('LineNumberInterval' . i, {
                \ 'numhl': 'HighlightedLineNr' . i
                \ })
        endif
    endfor

    augroup LineNumberInterval
        autocmd!
        autocmd TextChanged,TextChangedT,BufRead,BufNewFile,CursorMoved,CursorMovedI * call line_number_interval#update()
    augroup END

    call line_number_interval#update()
    redraw

    let s:enabled_line_number_interval = 1
endfunction

function! line_number_interval#update() abort
    call sign_unplace('LineNumberGroup', {'buffer': bufname('%')})

    if &relativenumber
        if g:line_number_interval#use_custom
            let l:lnum = line('.') - 1
            let l:numfold = 0
            while l:lnum >= line('w0')
                let l:numfolddelta = 0
                if foldclosed(l:lnum) != -1
                    let l:numfolddelta = l:lnum - foldclosed(l:lnum)
                    let l:numfold += l:numfolddelta
                endif
                let l:match = match(g:line_number_interval#custom_interval, '^' . (line('.') - l:lnum - l:numfold) . '$')
                if l:match != -1
                    if hlexists('HighlightedLineNr' . (l:match + 1))
                        call sign_place('', 'LineNumberGroup', 'LineNumberInterval' . (l:match + 1), bufname('%'), {'lnum': l:lnum})
                    else
                        call sign_place('', 'LineNumberGroup', 'LineNumberInterval', bufname('%'), {'lnum': l:lnum})
                    endif
                endif
                let l:lnum -= 1 + l:numfolddelta
            endwhile

            let l:lnum = line('.') + 1
            if foldclosed(line('.')) != -1
                let l:numfold = 1
            else
                let l:numfold = 0
            endif
            while l:lnum <= line('w$')
                let l:numfolddelta = 0
                if foldclosedend(l:lnum) != -1
                    let l:numfolddelta = foldclosedend(l:lnum) - l:lnum
                    let l:numfold += l:numfolddelta
                endif
                let l:match = match(g:line_number_interval#custom_interval, '^' . (l:lnum - line('.') - l:numfold) . '$')
                if l:match != -1
                    if hlexists('HighlightedLineNr' . (l:match + 1))
                        call sign_place('', 'LineNumberGroup', 'LineNumberInterval' . (l:match + 1), bufname('%'), {'lnum': l:lnum})
                    else
                        call sign_place('', 'LineNumberGroup', 'LineNumberInterval', bufname('%'), {'lnum': l:lnum})
                    endif
                endif
                let l:lnum += 1 + l:numfolddelta
            endwhile

        else
            let l:lnum = line('.') - 1
            let l:numfold = 0
            while l:lnum >= line('w0')
                let l:numfolddelta = 0
                if foldclosed(l:lnum) != -1
                    let l:numfolddelta = l:lnum - foldclosed(l:lnum)
                    let l:numfold += l:numfolddelta
                endif
                if (line('.') - l:lnum - l:numfold) % g:line_number_interval == 0
                    call sign_place('', 'LineNumberGroup', 'LineNumberInterval', bufname('%'), {'lnum': l:lnum})
                endif
                let l:lnum -= 1 + l:numfolddelta
            endwhile

            let l:lnum = line('.') + 1
            if foldclosed(line('.')) != -1
                let l:numfold = 1
            else
                let l:numfold = 0
            endif
            while l:lnum <= line('w$')
                let l:numfolddelta = 0
                if foldclosedend(l:lnum) != -1
                    let l:numfolddelta = foldclosedend(l:lnum) - l:lnum
                    let l:numfold += l:numfolddelta
                endif
                if (l:lnum - line('.') - l:numfold) % g:line_number_interval == 0
                    call sign_place('', 'LineNumberGroup', 'LineNumberInterval', bufname('%'), {'lnum': l:lnum})
                endif
                let l:lnum += 1 + l:numfolddelta
            endwhile
        endif

    elseif &number
        let l:lnum = line('w0')
        while l:lnum <= line('w$')
            if l:lnum % g:line_number_interval == 0 && l:lnum != line('.')
                call sign_place('', 'LineNumberGroup', 'LineNumberInterval', bufname('%'), {'lnum': l:lnum})
            endif
            let l:lnum += 1
        endwhile

        if g:line_number_interval#use_custom
            let l:lnum = line('.') - 1
            let l:numfold = 0
            while l:lnum >= line('w0')
                let l:numfolddelta = 0
                if foldclosed(l:lnum) != -1
                    let l:numfolddelta = l:lnum - foldclosed(l:lnum)
                    let l:numfold += l:numfolddelta
                endif
                let l:match = match(g:line_number_interval#custom_interval, '^' . (line('.') - l:lnum - l:numfold) . '$')
                if l:match != -1
                    if hlexists('HighlightedLineNr' . (l:match + 1))
                        call sign_place('', 'LineNumberGroup', 'LineNumberInterval' . (l:match + 1), bufname('%'), {'lnum': l:lnum})
                    endif
                endif
                let l:lnum -= 1 + l:numfolddelta
            endwhile

            let l:lnum = line('.') + 1
            if foldclosed(line('.')) != -1
                let l:numfold = 1
            else
                let l:numfold = 0
            endif
            while l:lnum <= line('w$')
                let l:numfolddelta = 0
                if foldclosedend(l:lnum) != -1
                    let l:numfolddelta = foldclosedend(l:lnum) - l:lnum
                    let l:numfold += l:numfolddelta
                endif
                let l:match = match(g:line_number_interval#custom_interval, '^' . (l:lnum - line('.') - l:numfold) . '$')
                if l:match != -1
                    if hlexists('HighlightedLineNr' . (l:match + 1))
                        call sign_place('', 'LineNumberGroup', 'LineNumberInterval' . (l:match + 1), bufname('%'), {'lnum': l:lnum})
                    endif
                endif
                let l:lnum += 1 + l:numfolddelta
            endwhile
        endif
    endif
endfunction
