" set-perl5lib.vim --- set path into PERL5LIB if its file path includes 'lib' directory

let s:is_win = has('win32') || has('win64')

function! s:perllib_check_path(lst, lib_path)
  if empty(a:lst)
    return ""
  endif
  let dir = get(a:lst, 0)
  let _lib_path = a:lib_path . "/lib"
  if dir == "lib"
    return _lib_path
  elseif dir == "t" && filereadable(_lib_path)
    return _lib_path
  else
    return s:perllib_check_path(a:lst[1:-1], "/" . a:lib_path)
  endif
endfunction

function! s:set_perl5lib()
  let current_buffer_path_l = []
  if s:is_win
    current_buffer_path_l = split(substitute(expand('%:p'), '\\', '/', 'g'), '/')
  else
    current_buffer_path_l = split(expand('%:p'), '/')
  endif
  let lib_path = s:perllib_check_path(current_buffer_path_l, "")
  let current_perl5lib = $PERL5LIB
  
  if   (len(lib_path) && len(current_perl5lib) && (lib_path != current_perl5lib))
    || (len(lib_path) && !len(current_perl5lib))
    $PERL5LIB = lib_path . ":" . current_perl5lib
    echomsg "Added " . current_perl5lib . "into PERL5LIB"
  endif
endfunction

