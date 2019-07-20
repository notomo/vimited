
let s:SIGN_GROUP = 'vimited'
let s:SIGN_START = 'vimitedStart'
let s:SIGN_END = 'vimitedEnd'

let s:start_line = -1
let s:end_line = -1
let s:before_column = -1
let s:start_sign_id = 0
let s:end_sign_id = 0
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
    call sign_define(s:SIGN_START, {'text': 'S'})
    let s:start_sign_id = sign_place(s:start_sign_id, s:SIGN_GROUP, s:SIGN_START, '%', {'lnum': s:start_line})

    let last_line = line('$')
    let downside_syntax = 'syntax region VimitedOutside start=/\%' . (s:end_line + 1) . 'l/ end=/\%' . (last_line + 1) . 'l/'
    execute downside_syntax
    call sign_define(s:SIGN_END, {'text': 'E'})
    let s:end_sign_id = sign_place(s:end_sign_id, s:SIGN_GROUP, s:SIGN_END, '%', {'lnum': s:end_line})
endfunction

function! vimited#clear() abort
    autocmd! vimited CursorMoved
    syntax clear VimitedOutside
    call sign_unplace(s:SIGN_GROUP)
endfunction

function! s:move_if_need() abort
    let line = line('.')
    if line < s:start_line
        let col = line + 1 == s:start_line && s:before_column < col('.') ? 1 : s:before_column
        call setpos('.', [0, s:start_line, col])
    elseif line > s:end_line
        let col = line - 1 == s:end_line && s:before_column > col('.') ? strlen(getline(s:end_line)) : s:before_column
        call setpos('.', [0, s:end_line, col])
    endif
    let s:before_column = col('.')
endfunction
