return {
    "lewis6991/gitsigns.nvim",

    config = function()
        require("gitsigns").setup({
            signs = {
                add = { text = "│" },
                change = { text = "│" },
                delete = { text = "_" },
                topdelete = { text = "‾" },
                changedelete = { text = "~" },
            },
        })

        vim.keymap.set("n", "<leader>gp", function()
            require("gitsigns").preview_hunk()
        end, {
            desc = "Preview hunk",
        })

        vim.keymap.set("n", "<leader>gb", function()
            require("gitsigns").blame_line()
        end, {
            desc = "Blame line",
        })

        vim.keymap.set("n", "<leader>gr", function()
            require("gitsigns").reset_hunk()
        end, {
            desc = "Reset hunk",
        })
    end,
}
