require("neodev").setup({})
require("mason").setup()
require("mason-lspconfig").setup()

require("tiny-inline-diagnostic").setup({
    -- Choose a preset style for diagnostic appearance
    -- Available: "modern", "classic", "minimal", "powerline", "ghost", "simple", "nonerdfont", "amongus"
    preset = "modern",

    -- Make diagnostic background transparent
    transparent_bg = false,

    -- Make cursorline background transparent for diagnostics
    transparent_cursorline = true,

    -- Customize highlight groups for colors
    -- Use Neovim highlight group names or hex colors like "#RRGGBB"
    hi = {
        error = "DiagnosticError",     -- Highlight for error diagnostics
        warn = "DiagnosticWarn",       -- Highlight for warning diagnostics
        info = "DiagnosticInfo",       -- Highlight for info diagnostics
        hint = "DiagnosticHint",       -- Highlight for hint diagnostics
        arrow = "NonText",             -- Highlight for the arrow pointing to diagnostic
        background = "CursorLine",     -- Background highlight for diagnostics
        mixing_color = "Normal",       -- Color to blend background with (or "None")
    },

    -- List of filetypes to disable the plugin for
    disabled_ft = {},

    options = {
        -- Display the source of diagnostics (e.g., "lua_ls", "pyright")
        show_source = {
            enabled = false,           -- Enable showing source names
            if_many = false,           -- Only show source if multiple sources exist for the same diagnostic
        },

        -- Use icons from vim.diagnostic.config instead of preset icons
        use_icons_from_diagnostic = false,

        -- Color the arrow to match the severity of the first diagnostic
        set_arrow_to_diag_color = false,


        -- Throttle update frequency in milliseconds to improve performance
        -- Higher values reduce CPU usage but may feel less responsive
        -- Set to 0 for immediate updates (may cause lag on slow systems)
        throttle = 20,

        -- Minimum number of characters before wrapping long messages
        softwrap = 30,

        -- Control how diagnostic messages are displayed
        -- NOTE: When using display_count = true, you need to enable multiline diagnostics with multilines.enabled = true
        --       If you want them to always be displayed, you can also set multilines.always_show = true.
        add_messages = {
            messages = true,           -- Show full diagnostic messages
            display_count = false,     -- Show diagnostic count instead of messages when cursor not on line
            use_max_severity = false,  -- When counting, only show the most severe diagnostic
            show_multiple_glyphs = true, -- Show multiple icons for multiple diagnostics of same severity
        },

        -- Settings for multiline diagnostics
        multilines = {
            enabled = false,           -- Enable support for multiline diagnostic messages
            always_show = false,       -- Always show messages on all lines of multiline diagnostics
            trim_whitespaces = false,  -- Remove leading/trailing whitespace from each line
            tabstop = 4,               -- Number of spaces per tab when expanding tabs
            severity = nil,            -- Filter multiline diagnostics by severity (e.g., { vim.diagnostic.severity.ERROR })
          },

        -- Show all diagnostics on the current cursor line, not just those under the cursor
        show_all_diags_on_cursorline = false,

        -- Display related diagnostics from LSP relatedInformation
        show_related = {
            enabled = true,           -- Enable displaying related diagnostics
            max_count = 3,             -- Maximum number of related diagnostics to show per diagnostic
        },

        -- Enable diagnostics display in insert mode
        -- May cause visual artifacts; consider setting throttle to 0 if enabled
        enable_on_insert = false,

        -- Enable diagnostics display in select mode (e.g., during auto-completion)
        enable_on_select = false,

        -- Handle messages that exceed the window width
        overflow = {
            mode = "wrap",             -- "wrap": split into lines, "none": no truncation, "oneline": keep single line
            padding = 0,               -- Extra characters to trigger wrapping earlier
        },

        -- Break long messages into separate lines
        break_line = {
            enabled = false,           -- Enable automatic line breaking
            after = 30,                -- Number of characters before inserting a line break
        },

        -- Custom function to format diagnostic messages
        -- Receives diagnostic object, returns formatted string
        -- Example: function(diag) return diag.message .. " [" .. diag.source .. "]" end
        format = nil,

        -- Virtual text display priority
        -- Higher values appear above other plugins (e.g., GitBlame)
        virt_texts = {
            priority = 2048,
        },

        -- Filter diagnostics by severity levels
        -- Remove severities you don't want to display
        severity = {
            vim.diagnostic.severity.ERROR,
            vim.diagnostic.severity.WARN,
            vim.diagnostic.severity.INFO,
            vim.diagnostic.severity.HINT,
        },

        -- Events that trigger attaching diagnostics to buffers
        -- Default is {"LspAttach"}; change only if plugin doesn't work with your LSP setup
        overwrite_events = nil,

        -- Automatically disable diagnostics when opening diagnostic float windows
        override_open_float = false,
    },
})

-- Reserve a space in the gutter
-- This will avoid an annoying layout shift in the screen
vim.opt.signcolumn = 'yes'

-- Add cmp_nvim_lsp capabilities settings to lspconfig
-- This should be executed before you configure any language server
local lspconfig_defaults = require('lspconfig').util.default_config
lspconfig_defaults.capabilities = vim.tbl_deep_extend(
    'force',
    lspconfig_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities()
)


-- This is where you enable features that only work
-- if there is a language server active in the file
vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function(event)
        local opts = {buffer = event.buf}

        vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
        vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
        vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
        vim.keymap.set('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', opts)
        vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
        vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
        vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
        vim.keymap.set('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
        vim.keymap.set({'n', 'x'}, '<F3>', '<cmd>lua vim.lsp.buf.format({async = true})<cr>', opts)
        vim.keymap.set('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
    end,
})


local cmp = require'cmp'

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
            -- vim.snippet.expand(args.body) -- For native neovim snippets (Neovim v0.10+)

            -- For `mini.snippets` users:
            -- local insert = MiniSnippets.config.expand.insert or MiniSnippets.default_insert
            -- insert({ body = args.body }) -- Insert at cursor
            -- cmp.resubscribe({ "TextChangedI", "TextChangedP" })
            -- require("cmp.config").set_onetime({ sources = {} })
        end,
    },
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        -- { name = 'vsnip' }, -- For vsnip users.
        { name = 'luasnip' }, -- For luasnip users.
        -- { name = 'ultisnips' }, -- For ultisnips users.
        -- { name = 'snippy' }, -- For snippy users.
    }, {
        { name = 'buffer' },
    })
})

-- To use git you need to install the plugin petertriho/cmp-git and uncomment lines below
-- Set configuration for specific filetype.
--[[ cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({
        { name = 'git' },
    }, {
        { name = 'buffer' },
    })
})
require("cmp_git").setup() ]]-- 

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({ '/', '?' }, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
      { name = 'cmdline' }
    }),
    matching = { disallow_symbol_nonprefix_matching = false }
})
-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()
-- Put LSPs here!
vim.lsp.enable("clangd")--.setup({capabilities = capabilities})
vim.lsp.enable("html")--.setup({capabilities = capabilities})
vim.lsp.enable("eslint")--.setup({capabilities = capabilities})
vim.lsp.enable("rust_analyzer")--.setup({capabilities = capabilities})
vim.lsp.enable("ltex")--.setup({capabilities = capabilities})
vim.lsp.enable("sqlls")
vim.lsp.enable("blue")--.setup({capabilities = capabilities})
-- require("lspconfig").pyright.setup({capabilities = capabilities})
vim.lsp.enable("lua_ls")--.setup({capabilities = capabilities})
vim.lsp.enable("pyright")
vim.lsp.enable("jdtls")--.setup({capabilities = capabilities})
