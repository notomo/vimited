
function! vimited#set(start_line, end_line) abort
    call vimited#clear()

    let bufnr = bufnr('%')
    call vimited#area#set(bufnr, a:start_line, a:end_line)
endfunction

function! vimited#clear() abort
    let bufnr = bufnr('%')
    call vimited#area#clear(bufnr)
endfunction
