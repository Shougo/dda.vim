function! dda#completion(prompt, suffix = '', options = {}) abort
  call dda#denops#_notify('completion', [a:prompt, a:suffix, a:options])
endfunction

function! dda#edit(input, instruction, options = {}) abort
  call dda#denops#_notify('edit', [a:input, a:instruction, a:options])
endfunction
