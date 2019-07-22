
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
        let s:vars[bufnr]['sign_id'] = {s:SIGN_START : 0, s:SIGN_END : 0}
        let s:vars[bufnr]['before_column'] = 1
    endif
    let s:vars[bufnr]['range'] = {'start': a:start_line, 'end': a:end_line}
    let start_line = s:vars[bufnr]['range']['start']
    let end_line = s:vars[bufnr]['range']['end']

    let upside_syntax = 'syntax region VimitedOutside start=/\%1l/ end=/\%' . start_line . 'l/'
    execute upside_syntax
    call s:signs.set(s:SIGN_START, 'S', bufnr, start_line)

    let last_line = line('$')
    let downside_syntax = 'syntax region VimitedOutside start=/\%' . (end_line + 1) . 'l/ end=/\%' . (last_line + 1) . 'l/'
    execute downside_syntax
    call s:signs.set(s:SIGN_END, 'E', bufnr, end_line)

    syntax sync fromstart
endfunction

function! vimited#clear() abort
    let bufnr = bufnr('%')
    if !has_key(s:vars, bufnr)
        return
    endif

    autocmd! vimited CursorMoved <buffer>
    syntax clear VimitedOutside
    call s:signs.unset(s:SIGN_START, bufnr)
    call s:signs.unset(s:SIGN_END, bufnr)
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

function! s:set_sign(name, text, bufnr, line) abort
    call sign_define(a:name, {'text': a:text})
    let s:vars[a:bufnr]['sign_id'][a:name] = sign_place(s:vars[a:bufnr]['sign_id'][a:name], s:SIGN_GROUP, a:name, a:bufnr, {'lnum': a:line})
endfunction

function! s:unset_sign(name, bufnr) abort
    call sign_unplace(s:SIGN_GROUP, {'id': s:vars[a:bufnr]['sign_id'][a:name]})
endfunction

let s:signs = {}
if has('signs')
    let s:signs['set'] = function('s:set_sign')
    let s:signs['unset'] = function('s:unset_sign')
else
    let s:signs['set'] = {... -> ''}
    let s:signs['unset'] = {... -> ''}
endif
