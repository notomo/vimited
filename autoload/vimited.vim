
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
endfunction

function! vimited#clear() abort
    autocmd! vimited CursorMoved
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
