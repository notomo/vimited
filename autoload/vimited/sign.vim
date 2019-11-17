
let s:GROUP = 'vimited'

function! vimited#sign#new(bufnr, line, text) abort
    call sign_define(a:text, {'text': a:text})
    let sign = {
        \ 'bufnr': a:bufnr,
        \ 'text': a:text,
        \ 'id': sign_place(0, s:GROUP, a:text, a:bufnr, {'lnum': a:line}),
    \ }

    function! sign.set(line) abort
        call sign_place(self.id, s:GROUP, self.text, self.bufnr, {'lnum': a:line})
    endfunction

    function! sign.unset() abort
        call sign_unplace(s:GROUP, {'id': self.id})
    endfunction

    function! sign.line_number() abort
        let signs = sign_getplaced(self.bufnr, {'group': s:GROUP, 'id': self.id})[0]['signs']
        return signs[0]['lnum']
    endfunction

    return sign
endfunction
