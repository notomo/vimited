if exists('g:loaded_vimited')
    finish
endif
let g:loaded_vimited = 1

command! -range VimitedSet call vimited#set(<line1>, <line2>)
command! VimitedClear call vimited#clear()
