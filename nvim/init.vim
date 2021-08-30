call plug#begin()
  Plug 'neovim/nvim-lspconfig'
  Plug 'ms-jpq/coq_nvim', {'branch': 'coq'}
  Plug 'glepnir/lspsaga.nvim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'
  Plug 'preservim/nerdtree'
  Plug 'tpope/vim-fugitive'
  Plug 'vim-airline/vim-airline'
  Plug 'vim-airline/vim-airline-themes'
  Plug 'morhetz/gruvbox'
  Plug 'sheerun/vim-polyglot'
  Plug 'ryanoasis/vim-devicons'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'evanleck/vim-svelte', {'branch': 'main'}
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
set completeopt=menuone,noinsert,noselect

let mapleader = " "
let g:airline_theme='gruvbox'
let g:airline_powerline_fonts = 1
let g:NERDTreeShowHidden = 1
let g:NERDTreeMinimalUI = 1
let g:NERDTreeIgnore = []
let g:NERDTreeStatusline = ''
let g:NERDTreeWinSize= 25
let g:gruvbox_contrast_dark= 'hard'
let g:WebDevIconsDefaultFolderSymbolColor = 'AFAFAF'
let g:coq_settings = { 'auto_start': 'shut-up', 'clients.paths.resolution': ["file"] }

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
" Use <Tab> and <S-Tab> to navigate through popup menu inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

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
nnoremap <silent> vv <C-v>
nnoremap <silent> <Tab> :bnext<CR>
nnoremap <silent> <S-Tab> :bprevious<CR>

" NerdTree shortcuts
nnoremap <silent> <leader>n :NERDTreeFind<CR>
nnoremap <silent> <leader>t :NERDTreeToggle<CR>

" LSP Saga shortcuts
nnoremap <silent>K :Lspsaga hover_doc<CR>
inoremap <silent> <C-k> <Cmd>Lspsaga signature_help<CR>
nnoremap <silent> gh <Cmd>Lspsaga lsp_finder<CR>
nnoremap <silent> <C-j> :Lspsaga diagnostic_jump_next<CR>

" Searching shortcuts
nnoremap <silent> <leader>p <cmd>Telescope find_files<cr>
nnoremap <silent> <leader>f <cmd>Telescope live_grep<cr>
nnoremap <silent> <leader>b <cmd>Telescope buffers<cr>
nnoremap <silent> <leader>? <cmd>Telescope help_tags<cr>

" Git shortcuts
nnoremap <leader>gf :diffget //2<CR>
nnoremap <leader>gh :diffget //3<CR>
nnoremap <leader>gs :G<CR>

lua require('lsp_config')

