
let s:suite = themis#suite('vimited')
let s:assert = themis#helper('assert')

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
    call s:assert.equals(line('.'), 2)
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
    call s:assert.equals(line('.'), 3)

    normal! gg
    doautocmd vimited CursorMoved
    call s:assert.equals(line('.'), 2)

    normal! b
    doautocmd vimited CursorMoved
    normal! b
    doautocmd vimited CursorMoved
    normal! b
    doautocmd vimited CursorMoved
    normal! b
    doautocmd vimited CursorMoved
    call s:assert.equals(line('.'), 2)
    call s:assert.equals(col('.'), 1)

    normal! e
    doautocmd vimited CursorMoved
    normal! e
    doautocmd vimited CursorMoved
    normal! e
    doautocmd vimited CursorMoved
    normal! e
    doautocmd vimited CursorMoved
    call s:assert.equals(line('.'), 3)
    call s:assert.equals(col('.'), 4)

    normal! gg
    doautocmd vimited CursorMoved
    call s:assert.equals(line('.'), 2)
    call s:assert.equals(col('.'), 4)

    VimitedClear
    normal! gg
    call s:assert.equals(line('.'), 1)
endfunction

function! s:suite.clear_nothing()
    VimitedClear
endfunction
