#!/bin/bash

# install nvim
# add repository
sudo apt-add-repository ppa:neovim-ppa/stable

# Update package lists
echo "Updating package lists..."
sudo apt update -y

# Install Neovim
echo "Installing Neovim..."
sudo apt install -y neovim


# Configure Neovim
echo "Configuring Neovim..."
mkdir -p ~/.config/nvim

cat <<EOL > ~/.config/nvim/init.vim
if &compatible
  set nocompatible
endif

" Load external settings
runtime! option.vim

" Enable syntax highlighting
syntax enable
EOL

cat <<EOL > ~/.config/nvim/option.vim
" ######################## Appearance ########################
set termguicolors
set title
set number
set relativenumber
set wrap
set showmatch
set list
set listchars=tab:»-,trail:-,extends:»,precedes:«,nbsp:%,eol:↲
set matchtime=3

" ######################## Search & Replace ########################
set ignorecase
set smartcase
set wrapscan
set hlsearch
set incsearch
set inccommand=split

" ######################## Indentation ########################
set smartindent
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" ######################## Completion ########################
set wildmode=list:longest
set infercase
set wildmenu

" ######################## Operations ########################
set clipboard+=unnamedplus
set backspace=indent,eol,start
set hidden
set textwidth=0

" ######################## Logging ########################
set history=500
set noswapfile
set noundofile
set nobackup
set nowritebackup
set viminfo=

" ######################## Misc ########################
filetype plugin indent on
set encoding=utf-8
EOL

# Update .bashrc for Neovim
echo "Updating .bashrc for Neovim..."
echo 'export XDG_CONFIG_HOME=${HOME}/.config' >> ~/.bashrc
source ~/.bashrc


