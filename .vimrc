set rtp +=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'gmarik/Vundle.vim'
Plugin 'The-NERD-tree'
Plugin 'Tagbar'
Plugin 'ctrlp.vim'
Plugin 'minibufexpl.vim'
Plugin 'neocomplcache'

call vundle#end()


set ruler
set expandtab
set tabstop=4
set shiftwidth=4
set softtabstop=4

set backspace=indent,eol,start
set copyindent

" Change the mapleader from \ to ,
let mapleader=","

" The-NERD-tree
nmap <leader>nt :NERDTreeToggle<CR>

" miniBufExpl
nmap <C-n> :bn<CR>
nmap <C-m> :bp<CR>

nmap <C-H>      <C-W>h
nmap <C-J>      <C-W>j
nmap <C-K>      <C-W>k
nmap <C-L>      <C-W>l

" neocomplcache
let g:neocomplcache_enable_at_startup = 1
