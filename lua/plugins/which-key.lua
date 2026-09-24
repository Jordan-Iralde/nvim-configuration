return {
    "folke/which-key.nvim",

    event = "VeryLazy",

    config = function()
        local wk = require("which-key")

        wk.add({
            { "<leader>f", group = "Find" },
            { "<leader>g", group = "Git" },
            { "<leader>b", group = "Build" },
            { "<leader>d", group = "Debug" },
            { "<leader>e", group = "Explorer" },
            { "<leader>t", group = "Terminal" },
        })
    end,
}
