
let s:areas = {}

function! vimited#area#set(bufnr, start_line, end_line) abort
    if !has_key(s:areas, a:bufnr)
        let area = s:new(a:bufnr, a:start_line, a:end_line)
        let s:areas[a:bufnr] = area
    else
        let area = s:areas[a:bufnr]
    endif

    call area.set(a:start_line, a:end_line)
endfunction

function! vimited#area#clear(bufnr) abort
    if !has_key(s:areas, a:bufnr)
        return
    endif

    let area = s:areas[a:bufnr]
    call area.unset()
    unlet s:areas[a:bufnr]
endfunction

function! s:new(bufnr, start_line, end_line) abort
    let area = {
        \ 'bufnr': a:bufnr,
        \ 'start': vimited#sign#new(a:bufnr, a:start_line, 'S'),
        \ 'end': vimited#sign#new(a:bufnr, a:end_line, 'E'),
        \ 'column': 1,
    \ }

    augroup vimited
        execute printf('autocmd! vimited CursorMoved <buffer=%s>', a:bufnr)
        execute printf('autocmd CursorMoved <buffer=%s> call s:move_cursor_if_need(%s)', a:bufnr, a:bufnr)
        execute printf('autocmd CursorMovedI <buffer=%s> call s:move_cursor_if_need(%s)', a:bufnr, a:bufnr)
        execute printf('autocmd TextChanged <buffer=%s> call s:move_if_need(%s)', a:bufnr, a:bufnr)
        execute printf('autocmd TextChangedI <buffer=%s> call s:move_if_need(%s)', a:bufnr, a:bufnr)
    augroup END

    function! area.set(start_line, end_line) abort
        call self.start.set(a:start_line)
        call self.end.set(a:end_line)

        call self._set_syntax(a:start_line, a:end_line)
    endfunction

    function! area.unset() abort
        execute printf('autocmd! vimited CursorMoved <buffer=%s>', self.bufnr)
        execute printf('autocmd! vimited CursorMovedI <buffer=%s>', self.bufnr)
        execute printf('autocmd! vimited TextChanged <buffer=%s>', self.bufnr)
        execute printf('autocmd! vimited TextChangedI <buffer=%s>', self.bufnr)

        syntax clear VimitedOutside

        call self.start.unset()
        call self.end.unset()
    endfunction

    function! area.move_if_need() abort
        syntax clear VimitedOutside

        let start_line = self.start.line_number()
        let end_line = self.end.line_number()
        call self._set_syntax(start_line, end_line)
    endfunction

    function! area.move_cursor_if_need() abort
        let line = line('.')
        let start_line = self.start.line_number()
        let end_line = self.end.line_number()
        let before_column = self.column

        if line < start_line
            let col = line + 1 == start_line && before_column < col('.') ? 1 : before_column
            call setpos('.', [0, start_line, col, col])
        elseif line > end_line
            let col = line - 1 == end_line && before_column > col('.') ? strlen(getline(end_line)) : before_column
            call setpos('.', [0, end_line, col, col])
        endif

        let self.column = col('.')
    endfunction

    function! area._set_syntax(start_line, end_line) abort
        let upside_syntax = 'syntax region VimitedOutside start=/\%1l/ end=/\%' . a:start_line . 'l/'
        execute upside_syntax

        let last_line = line('$')
        let downside_syntax = 'syntax region VimitedOutside start=/\%' . (a:end_line + 1) . 'l/ end=/\%' . (last_line + 1) . 'l/'
        execute downside_syntax

        syntax sync fromstart
    endfunction

    let s:areas[a:bufnr] = area

    return area
endfunction

function! s:move_if_need(bufnr) abort
    let area = s:areas[a:bufnr]
    call area.move_if_need()
endfunction

function! s:move_cursor_if_need(bufnr) abort
    let area = s:areas[a:bufnr]
    call area.move_cursor_if_need()
endfunction
