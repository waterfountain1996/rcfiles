local is_bootstrap = false
local install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.empty(vim.fn.glob(install_path)) > 0 then
    is_bootstrap = true
    vim.fn.system {
        'git',
        'clone',
        '--depth',
        '1',
        'https://github.com/wbthomason/packer.nvim',
        install_path
    }
    vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    -- manage packer itself
    use 'wbthomason/packer.nvim'

    -- colorscheme
    use 'eddyekofo94/gruvbox-flat.nvim'
    use 'morhetz/gruvbox'

    -- line (un)commenting
    use 'tpope/vim-commentary'

    -- git support
    use 'tpope/vim-fugitive'

    -- auto indent
    use 'tpope/vim-sleuth'

    use 'tpope/vim-surround'

    -- auto pairs
    use 'windwp/nvim-autopairs'

    -- stay in root directory
    use 'airblade/vim-rooter'

    -- LSP
    use {
        'neovim/nvim-lspconfig',
        requires = {
            'williamboman/mason.nvim',
            'williamboman/mason-lspconfig.nvim',
            'folke/neodev.nvim'
        }
    }

    use 'preservim/nerdtree'

    -- completion
    use {
        'hrsh7th/nvim-cmp',
        requires = {
            'hrsh7th/cmp-nvim-lsp',
            'hrsh7th/cmp-vsnip',
            'hrsh7th/cmp-buffer',
            'L3MON4D3/LuaSnip',
            'saadparwaiz1/cmp_luasnip'
        }
    }

    -- treesitter
    use {
        'nvim-treesitter/nvim-treesitter',
        run = function()
            pcall(require('nvim-treesitter.install').update { with_sync = true })
        end
    }

    -- fancy status line
    use 'nvim-lualine/lualine.nvim'
    use 'kdheepak/tabline.nvim'

    -- add indentation guides even on blank lines
    use 'lukas-reineke/indent-blankline.nvim'

    -- fuzzy finder
    use {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        requires = { 'nvim-lua/plenary.nvim' }
    }

    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        cond = vim.fn.executable 'make' == 1
    }

    if is_bootstrap then
        require('packer').sync()
    end
end)

-- ==================
--  General settings
-- ==================

-- disable errorbells
vim.o.errorbells = false

-- don't follow buffer's directory
vim.o.autochdir = false

-- hide buffers when abandoned
vim.o.hidden = true

-- disable backups
vim.o.backup      = false
vim.o.writebackup = false
vim.o.swapfile    = false

-- search options
vim.o.incsearch  = true
vim.o.hlsearch   = false
vim.o.showmatch  = true
vim.o.ignorecase = true
vim.o.smartcase  = true
vim.o.wrapscan   = true

-- don't show the previous command
vim.o.showcmd   = false
vim.o.cmdheight = 1

-- don't wrap lines
vim.o.wrap = false

-- splits will appear on the right and below
vim.o.splitright = true
vim.o.splitbelow = true

-- enable relative line numbering
vim.o.number         = true
vim.o.relativenumber = true

-- display cursor position
vim.o.ruler = true

-- highlight current line
vim.o.cursorline = true

-- draw a column at 100 chars length
vim.o.colorcolumn = '100'

-- indentation options
local indent      = 4
vim.o.tabstop     = indent
vim.o.softtabstop = indent
vim.o.shiftwidth  = indent
vim.o.smarttab    = true

-- keep cursor away from top or bottom of the screen
vim.o.scrolloff = 8

-- enable mouse support
vim.o.mouse = 'a'

-- command history
vim.o.history = 100

-- set global clipboard
vim.o.clipboard = 'unnamedplus'

-- cursor
vim.cmd [[set guicursor=]]

-- completion options
vim.o.completeopt = 'menuone,noinsert,noselect'

-- colorscheme
vim.o.termguicolors             = true
vim.g.gruvbox_italic            = true
vim.g.gruvbox_bold              = true
vim.g.gruvbox_undercurl         = true
vim.g.gruvbox_invert_selection  = false
vim.g.gruvbox_invert_signs      = true
vim.g.gruvbox_improved_warnings = true
vim.g.gruvbox_contrast_dark     = "medium"
vim.cmd [[colorscheme gruvbox]]

-- ==================
--  Basic keymaps
-- ==================

-- map leader to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- shift text in visual mode
vim.keymap.set('v', '>', '>gv', { noremap = true })
vim.keymap.set('v', '<', '<gv', { noremap = true })

-- copy text until EOL
vim.keymap.set('n', 'Y', 'yg_', { noremap = true })

-- directory tree
vim.keymap.set('n', '<C-n>', ':NERDTreeToggle<CR>', { noremap = true })

-- buffer controls
vim.keymap.set('n', '<C-k>', ':bn<CR>', { noremap = true })
vim.keymap.set('n', '<C-j>', ':bp<CR>', { noremap = true })
vim.keymap.set('n', '<C-x>', ':bd<CR>', { noremap = true })

-- highlight text on yank
local highlight_group = vim.api.nvim_create_augroup('YankHighlight', { clear = true })
vim.api.nvim_create_autocmd('TextYankPost', {
    callback = function()
        vim.highlight.on_yank()
    end,
    group = highlight_group,
    pattern = '*',
})

-- ==================
--  Plugin settings
-- ==================

vim.g.rooter_patterns = {'.git'}

require("nvim-autopairs").setup { check_ts = true }

-- NERDTree
vim.g.NERDTreeIgnore = {
	"egg-info$",
	"^env$",
	"^venv$",
	"__pycache__",
	".pytest_cache",
}
vim.g.NERDTreeDirArrowExpandable = "~"
vim.g.NERDTreeDirArrowCollapsible = "$"

-- status line

require('tabline').setup { enable = true }

require('lualine').setup {
    options = {
        icons_enabled = false,
        theme = 'gruvbox-flat',
        component_separators = '|',
        section_separators = '',
    },
    tabline = {
		lualine_a = {},
		lualine_b = {},
		lualine_c = { require'tabline'.tabline_buffers },
		lualine_x = { require'tabline'.tabline_tabs },
		lualine_y = {},
		lualine_z = {},
    }
}

-- identation
require('indent_blankline').setup {
    char = '┊',
    show_trailing_blankline_indent = false,
}

-- telescope
require('telescope').setup {
    defaults = {
        mappings = {
            i = {
                ['<C-u>'] = false,
                ['<C-d>'] = false,
                ['<ESC>'] = require('telescope.actions').close,
            },
        },
    },
}

pcall(require('telescope').load_extension, 'fzf')

vim.keymap.set(
    'n',
    '<leader>?',
    require('telescope.builtin').oldfiles,
    { desc = '[?] Find recently opened files' }
)

vim.keymap.set(
    'n',
    '<leader><space>',
    require('telescope.builtin').buffers,
    { desc = '[ ] Find existing buffers' }
)

vim.keymap.set(
    'n',
    '<leader>/', function()
        -- You can pass additional configuration to telescope to change theme, layout, etc.
        require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
            winblend = 0,
            previewer = false,
        })
    end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set(
    'n',
    '<leader>f',
    require('telescope.builtin').find_files,
    { desc = '[S]earch [F]iles' }
)

vim.keymap.set(
    'n',
    '<leader>g',
    require('telescope.builtin').git_files,
    { desc = '[S]earch [G]it files' }
)

vim.keymap.set(
    'n',
    'fzf',
    require('telescope.builtin').live_grep,
    { desc = '[S]earch by [G]rep' }
)

vim.keymap.set(
    'n',
    '<leader>sh',
    require('telescope.builtin').help_tags,
    { desc = '[S]earch [H]elp' }
)

vim.keymap.set(
    'n',
    '<leader>sw',
    require('telescope.builtin').grep_string,
    { desc = '[S]earch current [W]ord' }
)

vim.keymap.set(
    'n',
    '<leader>cd',
    require('telescope.builtin').diagnostics,
    { desc = '[C]ode [D]iagnostics' }
)

-- treesitter
require('nvim-treesitter.configs').setup {
    ensure_installed = { 'c', 'cpp', 'lua', 'python', 'rust', 'typescript', 'help', 'vim' },
    highlight = { enable = true },
    indent = { enable = true, },
    incremental_selection = {
        enable = true,
        keymaps = {
            init_selection = '<c-space>',
            node_incremental = '<c-space>',
            scope_incremental = '<c-s>',
            node_decremental = '<c-backspace>',
        },
    },
}

-- diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)

-- LSP settings.
local on_attach = function(_, bufnr)
    local nmap = function(keys, func, desc)
        if desc then
            desc = 'LSP: ' .. desc
        end

        vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
    end

    nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
    nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
    nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
    nmap('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
    nmap('gR', vim.lsp.buf.rename, '[R]e[n]ame')
    nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
    nmap('<leader>K', vim.lsp.buf.signature_help, 'Signature Documentation')
    nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
    nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
    nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')

    -- Create a command `:Format` local to the LSP buffer
    vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
        vim.lsp.buf.format()
    end, { desc = 'Format current buffer with LSP' })
end

local servers = {
    clangd = {},
    pyright = {},
    rust_analyzer = {},
    tsserver = {},
    -- sumneko_lua = {
    --     Lua = {
    --         diagnostics = { globals = { 'vim' } },
    --         workspace = {
    --             checkThirdParty = false,
    --             library = {
    --                 [vim.fn.expand('$VIMRUNTIME/lua')] = true,
    --                 [vim.fn.stdpath('config') .. '/lua'] = true,
    --             },
    --         },
    --         telemetry = { enable = false },
    --     },
    -- },
}

-- Setup neovim lua configuration
require('neodev').setup()

-- nvim-cmp supports additional completion capabilities, so broadcast that to servers
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

-- Setup mason so it can manage external tooling
require('mason').setup()

-- Ensure the servers above are installed
local mason_lspconfig = require 'mason-lspconfig'

mason_lspconfig.setup {
    ensure_installed = vim.tbl_keys(servers),
}

mason_lspconfig.setup_handlers {
    function(server_name)
        if server_name == 'clangd' then
            require('lspconfig')[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                cmd = { 'clangd', '--enable-config' },
                settings = servers[server_name],
            }
        else
            require('lspconfig')[server_name].setup {
                capabilities = capabilities,
                on_attach = on_attach,
                settings = servers[server_name],
            }
        end
    end,
}

-- =================
--  Code completion
-- =================

local cmp = require 'cmp'
local luasnip = require 'luasnip'

cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = cmp.mapping.preset.insert {
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
    },
}
