# vimited

This plugin limit the cursor in the selected range.

## [Try this plugin in your browser](https://rhysd.github.io/vim.wasm/?file=%2Fusr%2Flocal%2Fshare%2Fvim%2Fautoload%2Fvimited.vim%3Dhttps%3A%2F%2Fraw.githubusercontent.com%2Fnotomo%2Fvimited%2Fmaster%2Fautoload%2Fvimited.vim&file=%2Fusr%2Flocal%2Fshare%2Fvim%2Fplugin%2Fvimited.vim%3Dhttps%3A%2F%2Fraw.githubusercontent.com%2Fnotomo%2Fvimited%2Fmaster%2Fplugin%2Fvimited.vim)
You can try this plugin on [vim.wasm](https://github.com/rhysd/vim.wasm) in your browser.

1. Select a range by `Shift+V`.
2. Press `:`.
3. Input `VimitedSet<Enter>`.
4. Try to move the cursor outside of the range.

```vim
" set a limit
:VimitedSet

" clear the limit
:VimitedClear
```
