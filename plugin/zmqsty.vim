" Vim plugin to fit the Zmq coding style
" License:      Distributed under the same terms as Vim itself.
"
" This script is forked from vim-linux-coding-style created by Vivien Didelot:
" https://github.com/vivien/vim-linux-coding-style
"
" For those who want to apply these options conditionally, you can define an
" array of patterns in your vimrc and these options will be applied only if
" the buffer's path matches one of the pattern. In the following example,
" options will be applied only if "/linux/" or "/kernel" is in buffer's path.
"
"   let g:zmqsty_patterns = [ "/linux/", "/kernel/" ]

if exists("g:loaded_zmqsty")
    finish
endif
let g:loaded_zmqsty = 1

set wildignore+=*.ko,*.mod.c,*.order,modules.builtin

augroup zmqsty
    autocmd!

    autocmd FileType c,cpp,h call s:ZmqConfigure()
    autocmd FileType diff,kconfig setlocal tabstop=4
augroup END

function s:ZmqConfigure()
    let apply_style = 0

    if exists("g:zmqsty_patterns")
        let path = expand('%:p')
        for p in g:zmqsty_patterns
            if path =~ p
                let apply_style = 1
                break
            endif
        endfor
    else
        let apply_style = 1
    endif

    if apply_style
        call s:ZmqCodingStyle()
    endif
endfunction

command! ZmqCodingStyle call s:ZmqCodingStyle()

function! s:ZmqCodingStyle()
    call s:ZmqFormatting()
    call s:ZmqKeywords()
    call s:ZmqHighlighting()
endfunction

function s:ZmqFormatting()
    setlocal tabstop=4
    setlocal shiftwidth=4
    setlocal softtabstop=4
    setlocal textwidth=80
    setlocal expandtab

    setlocal cindent
    setlocal cinoptions=:0,l1,t0,g0,(0
endfunction

function s:ZmqKeywords()
    syn keyword cOperator likely unlikely
    syn keyword cType u8 u16 u32 u64 s8 s16 s32 s64
    syn keyword cType __u8 __u16 __u32 __u64 __s8 __s16 __s32 __s64
endfunction

function s:ZmqHighlighting()
    highlight default link ZmqError ErrorMsg

    syn match ZmqError / \+\ze\t/     " spaces before tab
    syn match ZmqError /\%81v.\+/     " virtual column 81 and more

    " Highlight trailing whitespace, unless we're in insert mode and the
    " cursor's placed right after the whitespace. This prevents us from having
    " to put up with whitespace being highlighted in the middle of typing
    " something
    autocmd InsertEnter * match ZmqError /\s\+\%#\@<!$/
    autocmd InsertLeave * match ZmqError /\s\+$/
endfunction

" vim: ts=4 et sw=4

