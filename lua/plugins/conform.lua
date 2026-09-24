return {
    "stevearc/conform.nvim",

    event = {
        "BufReadPre",
        "BufNewFile",
    },

    cmd = {
        "ConformInfo",
    },

    opts = {
        formatters_by_ft = {
            javascript = { "prettier" },
            javascriptreact = { "prettier" },

            typescript = { "prettier" },
            typescriptreact = { "prettier" },

            json = { "prettier" },
            css = { "prettier" },
            scss = { "prettier" },
            html = { "prettier" },
            markdown = { "prettier" },
        },

        format_on_save = {
            timeout_ms = 1000,
            lsp_format = "fallback",
        },
    },

    keys = {
        {
            "<leader>cf",
            function()
                require("conform").format({
                    async = true,
                    lsp_format = "fallback",
                })
            end,
            mode = "",
            desc = "Format buffer",
        },
    },
}
