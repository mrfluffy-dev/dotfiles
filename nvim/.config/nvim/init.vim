call plug#begin('~/.vim/plugged')

Plug 'mads-hartmann/bash-language-server'
Plug 'vscode-langservers/vscode-css-languageserver-bin'
Plug 'palantir/python-language-server'
Plug 'preservim/nerdtree'
Plug 'sumneko/lua-language-server'
Plug 'CarloWood/neovim-true-color-scheme-editor'
Plug 'rust-lang/rls'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'airblade/vim-gitgutter'
Plug 'dylanaraps/wal.vim'
Plug 'ap/vim-css-color'
Plug 'haskell/haskell-language-server'
Plug 'neoclide/coc.nvim' , {'branch': 'release'}
call plug#end()
colorscheme wal

set number relativenumber
autocmd VimEnter * NERDTree
