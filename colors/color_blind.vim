" Vim colorscheme: basic256
" Version: 0.0.0
" Copyright (C) 2010-2011 vol <github@volment.com>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
" Init  "{{{1

highlight clear
set background=dark

if exists('syntax_on')
  syntax reset
endif

let g:colors_name = 'basic256'




" Variables  "{{{1

let s:color_rgb_table = [
\   '#292929', '#c41700', '#679b00', '#c49300',
\   '#074080', '#9b0059', '#007676', '#818181',
\   '#474747', '#ff614c', '#b9f73e', '#ffd24c',
\   '#4581c4', '#dd429a', '#37bbbb', '#ffffff',
\ ]




" Utilities  "{{{1
function! s:attributes(expr)  "{{{2
  let _ = &term ==# 'win32' ? {
  \ 'r': 'reverse',
  \ 's': 'standout',
  \ } : {
  \ 'b': 'bold',
  \ 'c': 'undercurl',
  \ 'i': 'italic',
  \ 'r': 'reverse',
  \ 's': 'standout',
  \ 'u': 'underline',
  \ }
  let attrs = []
  for key in split(a:expr, '.\zs')
    if has_key(_, key)
      call insert(attrs, _[key])
    endif
  endfor
  return empty(attrs) ? 'NONE' : join(attrs, ',')
endfunction




function! s:color(color)  "{{{2
  if type(a:color) == type('')
    return a:color
  elseif has('gui_running')
    return s:color_rgb(a:color)
  elseif &term ==# 'win32'
    let _ = [0, 4, 2, 6, 1, 5, 3, 7, 8, 12, 10, 14, 9, 13, 11, 15]
    return _[a:color % len(_)]
  else
    return a:color % &t_Co
  endif
endfunction




function! s:color_rgb(color)  "{{{2
  if len(s:color_rgb_table) > a:color % 256
    return s:color_rgb_table[a:color % 256]
  endif

  let _ = []
  let [r, g, b] = [0, 0, 0]

  for i in range(240, 25, -1)
    let rgb = [r, g, b]

    for j in range(3)
      if rgb[j] != 0
        let rgb[j] = (rgb[j] * 40) + 55
      endif
    endfor

    let b += 1
    if b > 5
      let b = 0
      let g += 1
    endif
    if g > 5
      let g = 0
      let r += 1
    endif

    call insert(_, '#'.join(map(rgb, 'printf("%02x", v:val)'), ''))
  endfor

  for i in range(24, 1, -1)
    let rgb = []

    for j in range(3)
      call add(rgb, 8 + (24 - i) * 10)
    endfor

    call add(_, '#'.join(map(rgb, 'printf("%02x", v:val)'), ''))
  endfor

  return extend(s:color_rgb_table, _)[a:color % 256]
endfunction




function! s:highlight(name, config)  "{{{2
  let _ = []
  let type = has('gui_running') ? 'gui' : 'cterm'
  let reversed_p = 0

  if has_key(a:config, 'attr')
    if &term ==# 'win32' && a:config['attr'] =~# 'r'
      let reversed_p = !0
    endif
    call insert(_, ['', s:attributes(a:config['attr'])])
  endif
  if has_key(a:config, 'fg')
    call insert(_, [reversed_p ? 'bg' : 'fg', s:color(a:config['fg'])])
  endif
  if has_key(a:config, 'bg')
    call insert(_, [reversed_p ? 'fg' : 'bg', s:color(a:config['bg'])])
  endif
  if has_key(a:config, 'sp') && has('gui_running')
    call insert(_, ['sp', s:color(a:config['sp'])])
  endif

  execute 'highlight' a:name 'NONE' join(map(_, 'type . join(v:val, "=")'))
endfunction




" Highlighting  "{{{1
" Basic  "{{{2

if has('gui_running')
  call s:highlight('Normal'     , {'fg': '#e2e2e2', 'bg': '#171717'})
  call s:highlight('Cursor'     , {'fg': 'bg', 'bg': 243})
  call s:highlight('CursorIM'   , {'fg': 'bg', 'bg': 255})
  call s:highlight('lCursor'    , {'fg': 'bg', 'bg': 255})
else
  call s:highlight('Normal'     , {})
endif

call s:highlight('SpecialKey'   , {'fg': 8})
call s:highlight('NonText'      , {'fg': 249})
call s:highlight('Directory'    , {'fg': 255})
call s:highlight('MatchParen'   , {'attr': 'b', 'fg': 0, 'bg': 255})
call s:highlight('LineNr'       , {'fg': 255})
call s:highlight('CursorLineNr' , {'bg': 0})
call s:highlight('Question'     , {'fg': 243})
call s:highlight('VertSplit'    , {'attr': 'r', 'fg': 8})
call s:highlight('Title'        , {'fg': 255})
call s:highlight('Visual'       , {'bg': 15, 'fg': 16})
call s:highlight('VisualNOS'    , {'attr': 'r'})
call s:highlight('WildMenu'     , {'attr': 'br', 'fg': 246})

call s:highlight('ErrorMsg'     , {'bg': 9, 'fg': 0})
call s:highlight('MoreMsg'      , {'bg': 243})
call s:highlight('ModeMsg'      , {'bg': 249, 'fg': 0})
call s:highlight('WarningMsg'   , {'fg': 246})

call s:highlight('IncSearch'    , {'attr': 'r'})
call s:highlight('Search'       , {'attr': 'r', 'fg': 246})

call s:highlight('StatusLine'   , {'attr': 'b', 'bg': 8, 'fg': 15})
call s:highlight('StatusLineNC' , {'bg': 8})

call s:highlight('Folded'       , {'fg': 255})
call s:highlight('FoldColumn'   , {'fg': 255})
call s:highlight('SignColumn'   , {'fg': 255})
call s:highlight('Conceal'      , {'bg': 8})

call s:highlight('DiffAdd'      , {'bg': 249})
call s:highlight('DiffChange'   , {'bg': 252})
call s:highlight('DiffDelete'   , {'fg': 8})
call s:highlight('DiffText'     , {'bg': 252})

if has('gui_running')
  call s:highlight('SpellBad'   , {'attr': 'c', 'sp': 240})
  call s:highlight('SpellCap'   , {'attr': 'c', 'sp': 249})
  call s:highlight('SpellRare'  , {'attr': 'c', 'sp': 252})
  call s:highlight('SpellLocal' , {'attr': 'c', 'sp': 255})
else
  call s:highlight('SpellBad'   , {'bg': 240})
  call s:highlight('SpellCap'   , {'bg': 249})
  call s:highlight('SpellRare'  , {'bg': 252})
  call s:highlight('SpellLocal' , {'bg': 255})
endif

call s:highlight('Pmenu'        , {'attr': 'u'})
call s:highlight('PmenuSel'     , {'attr': 'r', 'fg': 246})
call s:highlight('PmenuSbar'    , {})
call s:highlight('PmenuThumb'   , {'bg': 246})

call s:highlight('TabLine'      , {'bg': 8})
call s:highlight('TabLineSel'   , {'attr': 'bu', 'fg': 15, 'bg': 8})
call s:highlight('TabLineFill'  , {'bg': 8})

call s:highlight('CursorColumn' , {'bg': 0})
call s:highlight('CursorLine'   , {'bg': 0})
call s:highlight('ColorColumn'  , {'bg': 8})




" Syntax  "{{{2

call s:highlight('Comment'      , {'fg': 10})
call s:highlight('Constant'     , {'fg': 252})
call s:highlight('Special'      , {'fg': 240})
call s:highlight('Identifier'   , {'attr': 'b', 'fg': 255})
call s:highlight('Statement'    , {'fg': 246})
call s:highlight('PreProc'      , {'fg': 249})
call s:highlight('Type'         , {'fg': 243})
call s:highlight('Underlined'   , {'attr': 'u', 'fg': 249})
call s:highlight('Ignore'       , {'fg': 0})
call s:highlight('Error'        , {'bg': 9})
call s:highlight('Todo'         , {'attr': 'u', 'fg': 246})

highlight link String         Constant
highlight link Character      Constant
highlight link Number         Constant
highlight link Boolean        Constant
highlight link Float          Constant
highlight link Function       Identifier
highlight link Conditional    Statement
highlight link Repeat         Statement
highlight link Label          Statement
highlight link Operator       Statement
highlight link Keyword        Statement
highlight link Exception      Statement
highlight link Include        PreProc
highlight link Define         PreProc
highlight link Macro          PreProc
highlight link PreCondit      PreProc
highlight link StorageClass   Type
highlight link Structure      Type
highlight link Typedef        Type
highlight link Tag            Special
highlight link SpecialChar    Special
highlight link Delimiter      Special
highlight link SpecialComment Special
highlight link Debug          Special




" __END__  "{{{1
" vim: foldmethod=marker
