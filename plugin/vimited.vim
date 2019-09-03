if exists('g:loaded_vimited')
    finish
endif
let g:loaded_vimited = 1

"" Set a range the cursor is able to move.
command! -range VimitedSet call vimited#set(<line1>, <line2>)

"" Clear the range that set by |VimitedSet|.
command! VimitedClear call vimited#clear()

"" A highlight group for outside the range.
highlight default link VimitedOutside Comment
