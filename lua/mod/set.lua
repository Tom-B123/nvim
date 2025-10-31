 --vim.opt.guicursor = ""
local options = {

    nu = true,
    relativenumber = true,

    tabstop = 4,
    softtabstop = 4,
    shiftwidth = 4,
    expandtab = true,

    smartindent = true,

    wrap = false,
    swapfile = false,
    backup = false,
    undodir = "/users/tomhb/appdata/local/nvim-data/undodir",

    hlsearch = false,
    incsearch = true,

    termguicolors = true,

    scrolloff = 8,


}

vim.g.mapleader = " "

vim.opt.shortmess:append "c"

vim.keymap.set("n", "<leader>pv", ":Ex<CR>")
for k,v in pairs(options) do
    vim.opt[k] = v
end
