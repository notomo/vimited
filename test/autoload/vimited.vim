
let s:suite = themis#suite('vimited')
let s:assert = VimitedTestAssert()

function! s:suite.before_each()
    call VimitedTestBeforeEach()
endfunction

function! s:suite.after_each()
    call VimitedTestAfterEach()
endfunction

function! s:suite.set_with_one_line()
    let lines = [
        \ 'hoge',
        \ 'hoge',
        \ 'hoge',
    \ ]
    call append(0, lines)

    2VimitedSet
    doautocmd vimited CursorMoved
    call s:assert.line_number(2)
endfunction

function! s:suite.set()
    let lines = [
        \ 'hoge',
        \ 'hoge',
        \ 'hoge',
        \ 'hoge',
        \ 'hoge',
    \ ]
    call append(0, lines)

    2,3VimitedSet
    doautocmd vimited CursorMoved
    call s:assert.line_number(3)

    normal! gg
    doautocmd vimited CursorMoved
    call s:assert.line_number(2)

    normal! b
    doautocmd vimited CursorMoved
    normal! b
    doautocmd vimited CursorMoved
    normal! b
    doautocmd vimited CursorMoved
    normal! b
    doautocmd vimited CursorMoved
    call s:assert.line_number(2)
    call s:assert.column_number(1)

    normal! e
    doautocmd vimited CursorMoved
    normal! e
    doautocmd vimited CursorMoved
    normal! e
    doautocmd vimited CursorMoved
    normal! e
    doautocmd vimited CursorMoved
    call s:assert.line_number(3)
    call s:assert.column_number(4)

    normal! gg
    doautocmd vimited CursorMoved
    call s:assert.line_number(2)
    call s:assert.column_number(4)

    execute "normal! i\<Up>"
    doautocmd vimited CursorMovedI
    call s:assert.line_number(2)
    call s:assert.column_number(4)

    VimitedClear
    normal! gg
    call s:assert.line_number(1)
    call s:assert.not_exists_autocmd('vimited')
endfunction

function! s:suite.clear_nothing()
    VimitedClear
endfunction

function! s:suite.changed()
    let lines = [
        \ 'hoge',
        \ 'hoge',
        \ 'hoge',
        \ 'hoge',
        \ 'hoge',
    \ ]
    call append(0, lines)

    2,3VimitedSet
    doautocmd vimited CursorMoved

    call append(2, ['foo'])
    doautocmd vimited TextChanged

    normal! G
    doautocmd vimited CursorMoved

    call s:assert.line_number(4)
endfunction
