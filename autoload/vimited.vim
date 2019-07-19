
let s:start_line = -1
let s:end_line = -1
function! vimited#set(start_line, end_line) range abort
    let s:start_line = a:start_line
    let s:end_line = a:end_line

    augroup vimited
        autocmd!
        " FIXME: <buffer> causes something wrong.
        autocmd CursorMoved * call s:move_if_need()
    augroup END

    let upside_syntax = 'syntax region VimitedOutside start=/\%1l/ end=/\%' . s:start_line . 'l/'
    execute upside_syntax

    let last_line = line('$')
    let downside_syntax = 'syntax region VimitedOutside start=/\%' . (s:end_line + 1) . 'l/ end=/\%' . (last_line + 1) . 'l/'
    execute downside_syntax
endfunction

function! vimited#clear() abort
    autocmd! vimited CursorMoved
    syntax clear VimitedOutside
endfunction

function! s:move_if_need() abort
    let line = line('.')
    if line < s:start_line
        let pos = getpos('.')
        call setpos('.', [0, s:start_line, pos[2]])
    elseif line > s:end_line
        let pos = getpos('.')
        call setpos('.', [0, s:end_line, pos[2]])
    endif
endfunction
