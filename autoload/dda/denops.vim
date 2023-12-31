const s:root_dir = '<sfile>'->expand()->fnamemodify(':h:h:h')
const s:sep = has('win32') ? '\' : '/'
function! dda#denops#_register() abort
  call dda#denops#_load('dda',
        \ [s:root_dir, 'denops', 'dda', 'app.ts']->join(s:sep))

  autocmd dda User DenopsClosed call s:stopped()
endfunction
function dda#denops#_load(name, path) abort
  try
    call denops#plugin#load(a:name, a:path)
  catch /^Vim\%((\a\+)\)\=:E117:/
    " Fallback to `register` for backward compatibility
    call denops#plugin#register(a:name, a:path, #{ mode: 'skip' })
  endtry
endfunction

function! s:stopped() abort
  unlet! g:dda#_initialized

  " Restore custom config
  if 'g:dda#_customs'->exists()
    for custom in g:dda#_customs
      call dda#_notify(custom.method, custom.args)
    endfor
  endif
endfunction

function! dda#denops#_running() abort
  return 'g:loaded_denops'->exists()
        \ && denops#server#status() ==# 'running'
        \ && denops#plugin#is_loaded('dda')
endfunction
