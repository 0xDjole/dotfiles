call plug#begin()
  Plug 'preservim/nerdtree'
  Plug 'neoclide/coc.nvim', {'branch': 'release'}
  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'junegunn/fzf.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'morhetz/gruvbox'
  Plug 'sheerun/vim-polyglot'
  Plug 'ryanoasis/vim-devicons'
call plug#end()

set termguicolors
set encoding=UTF-8
set background=dark
set nu
set nuw=1
set scrolloff=10
set ai
set si
set clipboard=unnamedplus

let mapleader = " "
let g:coc_global_extensions = ['coc-emmet', 'coc-css', 'coc-html', 'coc-json', 'coc-prettier', 'coc-tsserver', 'coc-rust-analyzer']
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
let g:NERDTreeWinSize=25
let g:gruvbox_contrast_dark='hard'

colorscheme gruvbox
autocmd WinEnter * call s:CloseIfOnlyNerdTreeLeft()

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
nnoremap <leader>gl :Gvdiff :0<CR>
nnoremap <leader>ge :clo<CR>
nnoremap <leader>gs :Gstatus<CR>
nnoremap <leader>ga :vertical Git diff --name-status<CR>

" Tab to complete
function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
