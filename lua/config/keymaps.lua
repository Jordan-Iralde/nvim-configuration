local map = vim.keymap.set

-- Find
map("n", "<leader>ff", "<cmd>Telescope find_files<cr>", {
    desc = "Find files",
})

map("n", "<leader>fg", "<cmd>Telescope live_grep<cr>", {
    desc = "Find text",
})

map("n", "<leader>fb", "<cmd>Telescope buffers<cr>", {
    desc = "Find buffers",
})

map("n", "<leader>fh", "<cmd>Telescope help_tags<cr>", {
    desc = "Find help",
})

-- Explorer
map("n", "<leader>e", "<cmd>Oil<cr>", {
    desc = "Explorer",
})

-- Save
map("n", "<leader>w", "<cmd>write<cr>", {
    desc = "Save",
})

-- Quit
map("n", "<leader>q", "<cmd>quit<cr>", {
    desc = "Quit",
})

-- Diagnostics
map("n", "<leader>xd", vim.diagnostic.open_float, {
    desc = "Diagnostic details",
})

map("n", "]d", function()
    vim.diagnostic.jump({
        count = 1,
        float = true,
    })
end, {
    desc = "Next diagnostic",
})

map("n", "[d", function()
    vim.diagnostic.jump({
        count = -1,
        float = true,
    })
end, {
    desc = "Previous diagnostic",
})

-- Quickfix
map("n", "<leader>xq", "<cmd>cwindow<cr>", {
    desc = "Toggle quickfix",
})

map("n", "<leader>xn", "<cmd>cnext<cr>", {
    desc = "Next quickfix item",
})

map("n", "<leader>xp", "<cmd>cprev<cr>", {
    desc = "Previous quickfix item",
})

-- Buffers
map("n", "<leader>bn", "<cmd>bnext<cr>", {
    desc = "Next buffer",
})

map("n", "<leader>bp", "<cmd>bprevious<cr>", {
    desc = "Previous buffer",
})

map("n", "<leader>bd", "<cmd>bdelete<cr>", {
    desc = "Delete buffer",
})

-- Splits
map("n", "<leader>sv", "<cmd>vsplit<cr>", {
    desc = "Vertical split",
})

map("n", "<leader>sh", "<cmd>split<cr>", {
    desc = "Horizontal split",
})

-- Window navigation
map("n", "<C-h>", "<C-w>h", {
    desc = "Move left",
})

map("n", "<C-j>", "<C-w>j", {
    desc = "Move down",
})

map("n", "<C-k>", "<C-w>k", {
    desc = "Move up",
})

map("n", "<C-l>", "<C-w>l", {
    desc = "Move right",
})

-- Build
local build = require("config.build")

map("n", "<leader>bc", build.configure, {
    desc = "CMake configure",
})

map("n", "<leader>bb", build.build, {
    desc = "Build project",
})

map("n", "<leader>br", build.run, {
    desc = "Run project",
})

map("n", "<leader>xn", "<cmd>cnext<cr>", {
    desc = "Next build error",
})

map("n", "<leader>xp", "<cmd>cprev<cr>", {
    desc = "Previous build error",
})

map("n", "<leader>bx", build.clean, {
    desc = "Clean build",
})

map("n", "<leader>brb", build.rebuild, {
    desc = "Rebuild project",
})

-- LSP
map("n", "gd", vim.lsp.buf.definition, {
    desc = "Go to definition",
})

map("n", "grr", vim.lsp.buf.references, {
    desc = "Find references",
})

map("n", "K", vim.lsp.buf.hover, {
    desc = "Hover documentation",
})

map("n", "<leader>cr", vim.lsp.buf.rename, {
    desc = "Rename symbol",
})

map("n", "<leader>ca", vim.lsp.buf.code_action, {
    desc = "Code action",
})

-- Navigation
map("n", "<leader>o", "<cmd>AerialToggle!<cr>", {
    desc = "Code outline",
})

map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<cr>", {
    desc = "Find symbols",
})

map("n", "<leader>fw", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", {
    desc = "Find workspace symbols",
})

-- Dependency
map("n", "<leader>dg", function()
    require("config.dependency").open()
end, {
    desc = "Dependency graph",
})

-- Project scripts
local project_runner = require("config.project_runner")

map("n", "<leader>rs", project_runner.select, {
    desc = "Run project script",
})

map("n", "<leader>rd", function()
    project_runner.run("dev")
end, {
    desc = "Run dev server",
})

map("n", "<leader>rb", function()
    project_runner.run("build")
end, {
    desc = "Build project",
})

map("n", "<leader>rl", function()
    project_runner.run("lint")
end, {
    desc = "Lint project",
})

map("n", "<leader>rt", function()
    project_runner.run("test")
end, {
    desc = "Test project",
})
