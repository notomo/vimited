
let s:SIGN_GROUP = 'vimited'
let s:SIGN_START = 'vimitedStart'
let s:SIGN_END = 'vimitedEnd'

let s:vars = {}
function! vimited#set(start_line, end_line) abort
    call vimited#clear()

    augroup vimited
        autocmd! vimited CursorMoved <buffer>
        autocmd CursorMoved <buffer> call s:move_if_need()
    augroup END

    let bufnr = bufnr('%')
    if !has_key(s:vars, bufnr)
        let s:vars[bufnr] = {}
        let s:vars[bufnr]['sign_id'] = {'start': 0, 'end': 0}
        let s:vars[bufnr]['before_column'] = 1
    endif
    let s:vars[bufnr]['range'] = {'start': a:start_line, 'end': a:end_line}
    let start_line = s:vars[bufnr]['range']['start']
    let end_line = s:vars[bufnr]['range']['end']

    let upside_syntax = 'syntax region VimitedOutside start=/\%1l/ end=/\%' . start_line . 'l/'
    execute upside_syntax
    call sign_define(s:SIGN_START, {'text': 'S'})
    let s:vars[bufnr]['sign_id']['start'] = sign_place(s:vars[bufnr]['sign_id']['start'], s:SIGN_GROUP, s:SIGN_START, bufnr, {'lnum': start_line})

    let last_line = line('$')
    let downside_syntax = 'syntax region VimitedOutside start=/\%' . (end_line + 1) . 'l/ end=/\%' . (last_line + 1) . 'l/'
    execute downside_syntax
    call sign_define(s:SIGN_END, {'text': 'E'})
    let s:vars[bufnr]['sign_id']['end'] = sign_place(s:vars[bufnr]['sign_id']['end'], s:SIGN_GROUP, s:SIGN_END, bufnr, {'lnum': end_line})
endfunction

function! vimited#clear() abort
    let bufnr = bufnr('%')
    if !has_key(s:vars, bufnr)
        return
    endif

    autocmd! vimited CursorMoved <buffer>
    syntax clear VimitedOutside
    call sign_unplace(s:SIGN_GROUP, {'id': s:vars[bufnr]['sign_id']['start']})
    call sign_unplace(s:SIGN_GROUP, {'id': s:vars[bufnr]['sign_id']['end']})
    unlet s:vars[bufnr]
endfunction

function! s:move_if_need() abort
    let bufnr = bufnr('%')
    let start_line = s:vars[bufnr]['range']['start']
    let end_line = s:vars[bufnr]['range']['end']
    let before_column = s:vars[bufnr]['before_column']

    let line = line('.')
    if line < start_line
        let col = line + 1 == start_line && before_column < col('.') ? 1 : before_column
        call setpos('.', [0, start_line, col, col])
    elseif line > end_line
        let col = line - 1 == end_line && before_column > col('.') ? strlen(getline(end_line)) : before_column
        call setpos('.', [0, end_line, col, col])
    endif

    let s:vars[bufnr]['before_column'] = col('.')
endfunction
