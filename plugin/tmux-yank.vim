" Include guard.
if exists("g:loaded_tmux_yank")
    finish
endif
let g:loaded_tmux_yank = 1

function! s:TmuxAvailable()
      return executable('tmux')
endfunction

" Function to yank to OSC-52.
function! TmuxYank()
    if !s:TmuxAvailable()
        return
    endif
    let buffer=system('base64 -w0', @0)
    let buffer=substitute(buffer, "\n$", "", "")
    let buffer='\e]52;c;'.buffer.'\x07'
    silent exe "!echo -ne ".shellescape(buffer)." > ".system("tmux display -p '#{pane_tty}'")
endfunction

" Autoforward yank events.
set clipboard+=unnamedplus
augroup TmuxYankAuto
    autocmd!
    autocmd TextYankPost * if v:event.operator ==# 'y' | call TmuxYank() | endif
augroup END
