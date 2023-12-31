function! dda#completion(prompt, suffix = '', options = {}) abort
  call dda#_notify('completion', [a:prompt, a:suffix, a:options])
endfunction

function! dda#edit(input, instruction, options = {}) abort
  call dda#_notify('edit', [a:input, a:instruction, a:options])
endfunction

function! dda#_request(method, args) abort
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
function! dda#_notify(method, args) abort
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
    silent! call dda#denops#_register()
  else
    autocmd dda User DenopsReady silent! call dda#denops#_register()
  endif
endfunction
