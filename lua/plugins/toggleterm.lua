return {
    "akinsho/toggleterm.nvim",
    version = "*",

    config = function()
        require("toggleterm").setup({
            direction = "horizontal",
            size = 15,

            start_in_insert = true,

            persist_size = true,
            persist_mode = true,

            close_on_exit = true,

            auto_scroll = true,
        })

        local terminals = {}

        local function project_root()
            return vim.fs.root(0, {
                "package.json",
                "CMakeLists.txt",
                ".git",
            }) or vim.fn.getcwd()
        end

        local function toggle_project_terminal()
            local root = project_root()

            if not terminals[root] then
                local Terminal =
                    require("toggleterm.terminal").Terminal

                terminals[root] = Terminal:new({
                    dir = root,

                    direction = "horizontal",

                    size = 15,

                    display_name = "terminal",

                    close_on_exit = true,

                    auto_scroll = true,

                    on_exit = function()
                        terminals[root] = nil
                    end,
                })
            end

            terminals[root]:toggle()
        end

        vim.keymap.set(
            "n",
            "<leader>t",
            toggle_project_terminal,
            {
                desc = "Project terminal",
            }
        )
    end,
}
