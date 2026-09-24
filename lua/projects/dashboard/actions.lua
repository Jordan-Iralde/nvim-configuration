local M = {}

local function open_nvim_config()
    require("oil").open(vim.fn.expand("~/.config/nvim"))
end

local function open_github_directory()
    require("oil").open(vim.fn.expand("~/Documents/Github"))
end

function M.build()
    return {
        {
            type = "button",
            val = "  [ P ]  Project Browser",
            on_press = function()
                require("projects.browser").open()
            end,
            opts = {
                width = 60,
                position = "center",
            },
        },

        {
            type = "button",
            val = "  [ C ]  Neovim Config",
            on_press = open_nvim_config,
            opts = {
                width = 60,
                position = "center",
            },
        },

        {
            type = "button",
            val = "  [ G ]  GitHub Directory",
            on_press = open_github_directory,
            opts = {
                width = 60,
                position = "center",
            },
        },
    }
end

function M.setup_mappings(bufnr)
    vim.keymap.set("n", "C", open_nvim_config, {
        buffer = bufnr,
        silent = true,
        nowait = true,
    })

    vim.keymap.set("n", "G", open_github_directory, {
        buffer = bufnr,
        silent = true,
        nowait = true,
    })

    vim.keymap.set("n", "P", function()
        require("projects.browser").open()
    end, {
        buffer = bufnr,
        silent = true,
        nowait = true,
    })
end

return M
