local M = {}

function M.setup()
    local configs = require("lspconfig.configs")
    local lspconfig = require("lspconfig")

    if not configs.loctree_lsp then
        configs.loctree_lsp = {
            default_config = {
                cmd = { "loctree-lsp" },
                filetypes = {
                    "typescript",
                    "typescriptreact",
                    "javascript",
                    "javascriptreact",
                    "python",
                    "rust",
                    "cpp",
                    "c",
                },
                root_dir = lspconfig.util.root_pattern(
                    ".loctree",
                    ".git"
                ),
                settings = {},
            },
        }
    end

    lspconfig.loctree_lsp.setup({})
end

return M
