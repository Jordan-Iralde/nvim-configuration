return {
    "nvim-telescope/telescope.nvim",

    dependencies = {
        "nvim-lua/plenary.nvim",
    },

    config = function()
        local telescope = require("telescope")
        local builtin = require("telescope.builtin")

        telescope.setup({
            defaults = {
                layout_strategy = "horizontal",

                layout_config = {
                    preview_width = 0.55,
                },
            },
        })

        vim.keymap.set("n", "<leader>ff", builtin.find_files, {
            desc = "Find files",
        })

        vim.keymap.set("n", "<leader>fg", builtin.live_grep, {
            desc = "Find text",
        })

        vim.keymap.set("n", "<leader>fb", builtin.buffers, {
            desc = "Find buffers",
        })

        vim.keymap.set("n", "<leader>fh", builtin.help_tags, {
            desc = "Find help",
        })
    end,
}
