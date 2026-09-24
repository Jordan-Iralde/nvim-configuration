return {
    "neovim/nvim-lspconfig",

    config = function()
        -- Diagnostics
        vim.diagnostic.config({
            severity_sort = true,

            underline = true,

            signs = {
                text = {
                    [vim.diagnostic.severity.ERROR] = "✘",
                    [vim.diagnostic.severity.WARN] = "▲",
                    [vim.diagnostic.severity.INFO] = "●",
                    [vim.diagnostic.severity.HINT] = "󰌵",
                },
            },

            virtual_text = {
                spacing = 2,
                prefix = "●",
                current_line = true,
            },

            float = {
                border = "rounded",
                source = "if_many",
            },

            update_in_insert = false,
        })

        -- C / C++
        vim.lsp.config("clangd", {
            cmd = {
                vim.fn.stdpath("data") .. "/mason/bin/clangd",
            },
        })

        vim.lsp.enable("clangd")

        -- TypeScript / JavaScript / React
        vim.lsp.config("ts_ls", {
            cmd = {
                vim.fn.stdpath("data") .. "/mason/bin/typescript-language-server",
                "--stdio",
            },
        })

        vim.lsp.enable("ts_ls")

        -- ESLint
        vim.lsp.config("eslint", {
            cmd = {
                vim.fn.stdpath("data") .. "/mason/bin/vscode-eslint-language-server",
                "--stdio",
            },
        })

        vim.lsp.enable("eslint")

        -- Python
        vim.lsp.config("pyright", {
            cmd = {
                vim.fn.stdpath("data") .. "/mason/bin/pyright-langserver",
                "--stdio",
            },
        })

        vim.lsp.enable("pyright")

        -- Ruff
        vim.lsp.config("ruff", {
            cmd = {
                vim.fn.stdpath("data") .. "/mason/bin/ruff",
                "server",
            },
        })

        vim.lsp.enable("ruff")
    end,
}
