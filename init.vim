" default
set tabstop=4
set shiftwidth=4

call plug#begin()

" lspconfig 설치
Plug 'neovim/nvim-lspconfig'

" one dark theme
Plug 'navarasu/onedark.nvim'
" tokyonight theme
Plug 'folke/tokyonight.nvim'

" nerdtree
Plug 'preservim/nerdtree'

" 자동완성
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'

" add pictograms to lsp
Plug 'onsails/lspkind.nvim'

" discord presence
Plug 'andweeb/presence.nvim'

" github copilot
Plug 'github/copilot.vim'

" fzf
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" vim airline (화면 부가정보)
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" git 관련 기능
Plug 'tpope/vim-fugitive'

" 주석 기능
Plug 'preservim/nerdcommenter'

" 괄호사용관련
Plug 'tpope/vim-surround'

" treesitter
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

" indent line
Plug 'lukas-reineke/indent-blankline.nvim'

" highlighit log file
Plug 'mtdl9/vim-log-highlighting'

" markdown viewer
Plug 'toppair/peek.nvim'

" code format
Plug 'stevearc/conform.nvim'

" cursor animation
Plug 'sphamba/smear-cursor.nvim'
call plug#end()

" nerdtree 설정
map <C-t> :NERDTreeToggle<CR>

" vim airline 설정
let g:airline_powerline_fonts = 1        " powerline 폰트 사용
let g:airline#extensions#tabline#enabled = 1    " 탭 라인 활성화
let g:airline#extensions#tabline#enabled = 1              " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'          " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1       " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format

" nerdcommenter 설정
let g:NERDCreateDefaultMappings = 0        " 기본 매핑 비활성화
let g:NERDToggleCheckAllLines = 1        " 주석 토글시 모든 라인 주석처리
nnoremap // <Plug>NERDCommenterToggle
vnoremap // <Plug>NERDCommenterToggle

" custom keymap
noremap <C-j> 4j
noremap <C-k> 4k
noremap <C-h> 4h
noremap <C-l> 4l

" line number 설정
set nu
set relativenumber

" 공백 변환
set list

" width 80에 라인표시
set colorcolumn=80

" set theme
"lua require('onedark').setup { style = 'darker' }
"lua require('onedark').load()
"colorscheme onedark
colorscheme tokyonight-night

lua << EOF

vim.lsp.enable({
	'lua_ls', -- lua language server
	'gopls', -- go language server
	'jsonls', -- json language server
	'marksman', -- markdown language server
	'pyright', -- python language server
	'rust_analyzer', -- rust language server
	'vtsls', -- typescript language server
	'vue_ls', -- vue language server
	'yamlls', -- yaml language server
})

require('smear_cursor').enabled = true
require('smear_cursor').setup{
	cursor_color='#38E57B',
	stiffness = 0.8,
	trailing_stiffness = 0.5,
	never_draw_over_target = false,
	distance_stop_animating = 0.5,
	hide_target_hack = true,
    never_draw_over_target = true,
}

vim.diagnostic.config({
  virtual_text = true,      -- 라인 옆에 에러 메시지 출력
  signs = true,             -- gutter(좌측)에 아이콘 표시
  underline = true,         -- 에러난 부분 밑줄
  update_in_insert = false, -- 입력 중에도 실시간으로 업데이트할지
  severity_sort = true,     -- 심각도별 정렬
})


local capabilities = require('cmp_nvim_lsp').default_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.o.completeopt = 'menu,menuone,noselect'
local cmp = require('cmp')
local lspkind = require('lspkind')
cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'buffer' },
        { name = 'path' },
    },
    formatting = {
        format = lspkind.cmp_format(),
    },
    snippet = {
        expand = function(args)
            vim.snippet.expand(args.body)
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-n>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
        ['<C-p>'] = cmp.mapping(cmp.mapping.select_prev_item() , {'i','c'}),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), {'i','c'}),
        ['<CR>'] = cmp.mapping(cmp.mapping.confirm({ select = false })),
    })
})
cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' },
    },
})
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' },
    }, {
        { name = 'cmdline' },
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})

-- treesitter 설정
require'nvim-treesitter.configs'.setup {
    ensure_installed = {
        "bash",
        "css",
        "dockerfile",
        "csv",
        "html",
        "java",
        "javascript",
        "json",
        "kotlin",
        "markdown",
        "python",
        "scss",
        "typescript",
        "vim",
        "vue",
        "yaml",
        "go",
        "rust",
    },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
}

-- blankline
require("ibl").setup()

-- markdown preview
vim.api.nvim_create_user_command('PeekOpen', require('peek').open, {})
vim.api.nvim_create_user_command('PeekClose', require('peek').close, {})

-- formatter
require('conform').setup({
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		html = { "prettier" },
		css = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		python = { "black" },
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})
vim.api.nvim_create_user_command("Format", function(args)
  local range = nil
  if args.count ~= -1 then
    local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]
    range = {
      start = { args.line1, 0 },
      ["end"] = { args.line2, end_line:len() },
    }
  end
  require("conform").format({ async = true, lsp_format = "fallback", range = range })
end, { range = true })

EOF

