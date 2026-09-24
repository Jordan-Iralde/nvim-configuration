-- Leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.timeoutlen = 250
-- Tree-sitter parsers
vim.opt.rtp:prepend(vim.fn.stdpath("data") .. "/site")

-- lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.opt.rtp:prepend(lazypath)

-- Plugins
require("lazy").setup("plugins")

-- Core configuration
require("config.options")
require("config.keymaps")
require("config.debug")
require("config.loctree").setup()
