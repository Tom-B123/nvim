
vim.cmd [[packadd packer.nvim]]

return require("packer").startup(function(use)
    use "wbthomason/packer.nvim"
    use "nvim-lua/plenary.nvim"
    use "BurntSushi/ripgrep"
    use ({
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        opts = {},
    })
    use "rachartier/tiny-inline-diagnostic.nvim"
    use "nvim-telescope/telescope.nvim"
    use "nvim-lualine/lualine.nvim"
    use {
        "nvimdev/dashboard-nvim",
        event = 'VimEnter',
        config = function()
            require('dashboard').setup {
                -- config
            }
        end,
        requires = {'nvim-tree/nvim-web-devicons'}
    }
    use {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }
    use "RRethy/vim-illuminate"
    use ("nvim-treesitter/nvim-treesitter", {run = ":TSUpdate"})
    use	"williamboman/mason.nvim"
    use "williamboman/mason-lspconfig.nvim"
    use "mfussenegger/nvim-jdtls"
    use "folke/neodev.nvim"
    use {
        'VonHeikemen/lsp-zero.nvim',
        requires = {
            -- LSP support
            {'neovim/nvim-lspconfig'},

            --Auto completion
            {'hrsh7th/nvim-cmp'},
            {"hrsh7th/cmp-buffer"},
            {"hrsh7th/cmp-path"},
            {"saadparwaiz1/cmp_luasnip"},
            {'hrsh7th/cmp-nvim-lsp'},
            {"hrsh7th/cmp-nvim-lua"},
            --Snippets
            {'L3MON4D3/LuaSnip'},
            {"rafamadriz/friendly-snippets"},
        }
    }


    -- Should update nvim to stop having issues with that.
    use {
        "rootiest/nvim-updater.nvim",
        tag = "*", -- Pin to GitHub releases
        config = function()
            require("nvim_updater").setup({
                source_dir = "~/.local/src/neovim",  -- Custom target directory
                build_type = "RelWithDebInfo",       -- Set the desired build type
                branch = "master",                   -- Track nightly branch
                check_for_updates = true,            -- Enable automatic update checks
                notify_updates = true,               -- Enables update notifications
                default_keymaps = false,             -- Disable default keymaps
            })

            -- Define custom keymappings here
            vim.keymap.set("n", "<Leader>cuU", function()
                require('nvim_updater').update_neovim()
            end, { desc = "Custom Update Neovim" })

            vim.keymap.set("n", "<Leader>cuD", function()
                require('nvim_updater').update_neovim({ build_type = 'Debug' })
            end, { desc = "Debug Build Neovim" })

            vim.keymap.set(
                "n",
                "<Leader>cRN",
                ":NVUpdateRemoveSource<CR>",
                { desc = "Remove Neovim Source Directory"
            })
        end,
    }
    -- use({
    --     "https://github.com/ErichDonGubler/lsp_lines.nvim",
    --     config = function()
    --         require("lsp_lines").setup()
    --     end,
    -- })
    use({
        "lervag/vimtex",
        init = function()
            -- VimTeX configuration goes here, e.g.
            vim.g.vimtex_view_method = "zathura"
            vim.g.vimtext_compiler_method = "latexmk"
        end
    })
end)

