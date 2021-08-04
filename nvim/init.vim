syntax on
colorscheme onedark

call plug#begin()
  Plug 'preservim/nerdtree'
  Plug 'ryanoasis/vim-devicons'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver']
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'rust-lang/rust.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
call plug#end()

let g:airline_theme='onedark'
let g:airline_powerline_fonts = 1
let g:onedark_termcolors=256

let mapleader = " "
let g:rustfmt_autosave = 1

set encoding=UTF-8
set background=dark
set nu
set nuw=1
set scrolloff=10
set ai
set si
set clipboard=unnamedplus

" NERDTree config
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
let g:NERDTreeWinSize=25

autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

" Close all open buffers on entering a window if the only
" buffer that's left is the NERDTree buffer
function! s:CloseIfOnlyNerdTreeLeft()
  if exists("t:NERDTreeBufName")
    if bufwinnr(t:NERDTreeBufName) != -1
      if winnr("$") == 1
        q
      endif
    endif
  endif
endfunction

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Basic shortcuts 
nnoremap <silent> <leader>w <C-w>w
nnoremap <silent> <leader>h <C-w>h
nnoremap <silent> <leader>j <C-w>j
nnoremap <silent> <leader>k <C-w>k
nnoremap <silent> <leader>l <C-w>l
nnoremap <silent> <leader>v <C-w>v<C-w>w
nnoremap <silent> <leader>q :q<CR>
nnoremap <silent> <leader>s :w<CR>
nnoremap <silent> <leader>a :wq<CR>
nnoremap <silent> <leader>o <C-o>
nnoremap <silent> <leader>x :bp\|bd #<CR>
nnoremap <silent> <leader>, :vertical resize -5<CR>
nnoremap <silent> <leader>. :vertical resize +5<CR>
nnoremap <silent> <leader>e :$<CR>
nnoremap <silent> <leader>r :0<CR>
nnoremap <silent> V <C-v>
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>

" NerdTree shortcuts
nnoremap <silent> <leader>n :NERDTreeFind<CR>
nnoremap <silent> <leader>t :NERDTreeToggle<CR>

" GoTo code shortcuts.
nmap <silent> gh :call <SID>show_documentation()<CR>
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Searching shortcuts
nnoremap <silent> <leader>p :FZF<CR>
nnoremap <silent> <Leader>f :Rg<CR>

" Git shortcuts
nnoremap <leader>gd :Gvdiff<Space>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>ga :vertical Git diff --name-status<Space>
