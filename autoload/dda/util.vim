function! dda#util#get_text(mode = mode()) abort
  return a:mode ==# 'c' ? getcmdline() :
        \ a:mode ==# 't' && !has('nvim') ? term_getline('', '.')
        \ : getline('.')
endfunction
function! dda#util#get_input(mode = mode()) abort
  const is_insert = (a:mode ==# 'i') || (a:mode ==# 't')
  const text = ddc#util#get_text(a:mode)
  const col = a:mode ==# 't' && !has('nvim') ?
        \ term_getcursor(bufnr('%'))[1] :
        \ a:mode ==# 'c' ? getcmdpos() : col('.')
  const pos = a:mode ==# 'c' ? col - 1 :
        \ is_insert ? col - 1 : col
  const input = pos >= len(text) ?
        \     text :
        \     text->matchstr(
        \         '^.*\%' .. (is_insert || col <= 0 ? col : col - 1)
        \         .. 'c' .. (is_insert ? '' : '.'))

  return input
endfunction
function! dda#util#get_next_input(mode = mode()) abort
  const text = ddc#util#get_text(a:mode)
  return text[len(ddc#util#get_input(a:mode)) :]
endfunction
