function! dda#denops#_running() abort
  return 'g:loaded_denops'->exists()
        \ && denops#server#status() ==# 'running'
        \ && denops#plugin#is_loaded('dda')
endfunction

function! dda#denops#_request(method, args) abort
  if s:init()
    return {}
  endif

  " Note: If call denops#plugin#wait() in vim_starting, freezed!
  if has('vim_starting')
    call dda#util#print_error(
          \ 'You cannot call dda.vim in vim_starting.')
    return {}
  endif

  if denops#plugin#wait('dda')
    return {}
  endif
  return denops#request('dda', a:method, a:args)
endfunction
function! dda#denops#_notify(method, args) abort
  if s:init()
    return {}
  endif

  if dda#denops#_running()
    if denops#plugin#wait('dda')
      return {}
    endif
    call denops#notify('dda', a:method, a:args)
  else
    " Lazy call notify
    execute printf('autocmd User DDAReady call '
          \ .. 'denops#notify("dda", "%s", %s)', a:method, string(a:args))
  endif

  return {}
endfunction

function dda#denops#_load(name, path) abort
  try
    call denops#plugin#load(a:name, a:path)
  catch /^Vim\%((\a\+)\)\=:E117:/
    " Fallback to `register` for backward compatibility
    call denops#plugin#register(a:name, a:path, #{ mode: 'skip' })
  endtry
endfunction

const s:root_dir = '<sfile>'->expand()->fnamemodify(':h:h:h')
const s:sep = has('win32') ? '\' : '/'
function! s:register() abort
  call dda#denops#_load('dda',
        \ [s:root_dir, 'denops', 'dda', 'app.ts']->join(s:sep))

  autocmd dda User DenopsClosed call s:stopped()
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

function! s:init() abort
  if 'g:dda#_initialized'->exists()
    return
  endif

  if !has('patch-8.2.0662') && !has('nvim-0.8')
    call dda#util#print_error(
          \ 'dda requires Vim 8.2.0662+ or neovim 0.8.0+.')
    return 1
  endif

  augroup dda
    autocmd!
    autocmd User DDAReady :
  augroup END

  let g:dda#_started = reltime()

  " Note: dda.vim must be registered manually.

  " Note: denops load may be started
  if 'g:loaded_denops'->exists() && denops#server#status() ==# 'running'
    silent! call s:register()
  else
    autocmd dda User DenopsReady silent! call s:register()
  endif
endfunction
