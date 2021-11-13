" Rust configuration based on https://github.com/sharksforarms/vim-rust

call plug#begin(stdpath('data') . '/plugged')

Plug 'https://github.com/joshdick/onedark.vim'
Plug 'https://github.com/ctrlpvim/ctrlp.vim'
Plug 'https://github.com/preservim/nerdcommenter'
Plug 'https://github.com/prabirshrestha/vim-lsp'
Plug 'https://github.com/rust-lang/rust.vim'
Plug 'https://github.com/neovim/nvim-lspconfig'
Plug 'https://github.com/hrsh7th/nvim-cmp'
Plug 'https://github.com/hrsh7th/cmp-nvim-lsp'
Plug 'https://github.com/hrsh7th/cmp-vsnip'
Plug 'https://github.com/hrsh7th/cmp-path'
Plug 'https://github.com/hrsh7th/cmp-buffer'
Plug 'https://github.com/simrat39/rust-tools.nvim'
Plug 'https://github.com/hrsh7th/vim-vsnip'
Plug 'https://github.com/nvim-lua/popup.nvim'
Plug 'https://github.com/nvim-lua/plenary.nvim'
Plug 'https://github.com/nvim-telescope/telescope.nvim'

call plug#end()

syntax on
filetype plugin indent on

let g:onedark_color_overrides = {
\ "background": {"gui": "#111414", "cterm": "235", "cterm16": "0" },
\}
if (has("autocmd"))
	augroup colorextend
		autocmd!
		let s:white = { "gui": "ABB2BF" }
		let s:blue = { "gui": "#61AFEF" }
		let s:yellow = { "gui": "#E5C07B" }
		let s:green = { "gui": "#98C379" }
		autocmd ColorScheme * call onedark#extend_highlight("Operator", { "fg": s:white })
		autocmd ColorScheme * call onedark#extend_highlight("Keyword", { "fg": s:blue })
		autocmd ColorScheme * call onedark#extend_highlight("Function", { "fg": s:yellow })
		autocmd ColorScheme * call onedark#extend_highlight("StorageClass", { "fg": s:blue })
		autocmd ColorScheme * call onedark#extend_highlight("Number", { "fg": s:green })
		autocmd ColorScheme * call onedark#extend_highlight("Boolean", { "fg": s:green })
		autocmd ColorScheme * call onedark#extend_highlight("Float", { "fg": s:green })
		autocmd ColorScheme * call onedark#extend_highlight("SpecialChar", { "fg": s:green })
    augroup END
endif
colorscheme onedark

set ff=unix

set autoindent
set smartindent

set nocompatible
set nobackup
set nowritebackup
set noswapfile

set tabstop=4
set shiftwidth=4
set smarttab
set noexpandtab

set number

set mouse=a

set signcolumn=number

set hlsearch
set incsearch
set ignorecase
set smartcase

set backspace=indent,eol,start
set whichwrap+=<,>,h,l,[,]

set hidden

let mapleader = ","

nnoremap <leader>w :w<CR>
nnoremap <leader>e :e<CR>
nnoremap <leader>q :bd<CR>

nnoremap <leader>b :CtrlPBuffer<CR>
let g:ctrlp_custom_ignore = {
			\ 'dir': '\v[\/](\.git|target)',
	\ }
let g:ctrlp_max_files=0
let g:ctrlp_max_depth=10

set completeopt=menuone,noinsert,noselect
set shortmess+=c

" Configure LSP through rust-tools.nvim plugin.
" rust-tools will configure and enable certain LSP features for us.
" See https://github.com/simrat39/rust-tools.nvim#configuration
lua <<EOF
local nvim_lsp = require'lspconfig'

local opts = {
    tools = { -- rust-tools options
        autoSetHints = true,
        hover_with_actions = true,
        inlay_hints = {
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        -- on_attach is a callback called when the language server attachs to the buffer
        -- on_attach = on_attach,
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        }
    },
}

require('rust-tools').setup(opts)
EOF

" Setup Completion
" See https://github.com/hrsh7th/nvim-cmp#basic-configuration
lua <<EOF
local cmp = require'cmp'
cmp.setup({
  -- Enable LSP snippets
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ['<C-p>'] = cmp.mapping.select_prev_item(),
    ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.close(),
    ['<CR>'] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    })
  },

  -- Installed sources
  sources = {
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  },
})
EOF

nnoremap <silent> <c-]> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>

" Set updatetime for CursorHold
" 300ms of no cursor movement to trigger CursorHold
set updatetime=300
" Show diagnostic popup on cursor hold
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

let g:rustfmt_autosave = 1

cd ~/project/game0
