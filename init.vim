let g:python_host_prog = $PYENV_ROOT.'/versions/neovim2/bin/python'
let g:python3_host_prog = $PYENV_ROOT.'/versions/neovim3/bin/python'
let mapleader = "\<Space>"

set number             "行番号を表示
set autoindent         "改行時に自動でインデントする
set tabstop=2          "タブを何文字の空白に変換するか
set shiftwidth=2       "自動インデント時に入力する空白の数
set expandtab          "タブ入力を空白に変換
set splitright         "画面を縦分割する際に右に開く
set clipboard=unnamed  "yank した文字列をクリップボードにコピー
set hls                "検索した文字をハイライトする
set ignorecase smartcase
set rtp+=$GOPATH/src/golang.org/x/lint/misc/vim

inoremap <silent> jj <ESC>
inoremap ' ''<esc>i
inoremap " ""<esc>i
inoremap ( ()<esc>i
inoremap { {}<esc>i
inoremap [ []<esc>i
inoremap < <><esc>i
noremap <c-h> <c-w><c-h>
noremap <c-j> <c-w><c-j>
noremap <c-k> <c-w><c-k>
noremap <c-l> <c-w><c-l>
nnoremap <leader>t :split<CR>:wincmd j<CR>:terminal<CR>
tnoremap <silent> <ESC> <C-\><C-n>

autocmd QuickFixCmdPost *grep* cwindow

autocmd FileType go setlocal noexpandtab
autocmd FileType go setlocal tabstop=4
autocmd FileType go setlocal shiftwidth=4
autocmd FileType vue syntax sync fromstart
autocmd TermOpen * startinsert

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')

if &compatible
  set nocompatible
endif
set runtimepath+=~/.cache/dein/repos/github.com/Shougo/dein.vim
if dein#load_state('~/.cache/dein')
  call dein#begin('~/.cache/dein')
  call dein#load_toml('~/.config/nvim/dein.toml', {'lazy': 0})
  call dein#load_toml('~/.config/nvim/dein_lazy.toml', {'lazy': 1})
  call dein#end()
  call dein#save_state()
endif
if dein#check_install()
  call dein#install()
endif
set background=dark
set termguicolors
colorscheme elly
filetype plugin indent on
syntax enable

"" treesitter
lua <<EOF
require'nvim-treesitter.configs'.setup {
  highlight = {
    enable = true,
  },
  indent = {
    enable = true,
  },
  ignore_install = { "phpdoc" },
  ensure_installed = 'all'
}
EOF

command! -bang -nargs=* Rg
\ call fzf#vim#grep(
\   'rg --line-number --no-heading '.shellescape(<q-args>), 0,
\   fzf#vim#with_preview({'options': '--exact --reverse --delimiter : --nth 3..'}, 'right:50%:wrap'))
