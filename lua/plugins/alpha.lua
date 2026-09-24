return {
    "goolord/alpha-nvim",

    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },

    config = function()
        local alpha = require("alpha")
        local dashboard = require("alpha.themes.dashboard")

        local projects = require("projects")
        local state = require("projects.state")
        local dashboard_builder = require("projects.dashboard")

        local function setup_dashboard()
            local project_list = projects.get_projects()
            local data = state.load()

            dashboard.section.header.val =
                dashboard_builder.header()

            dashboard.section.buttons.val =
                dashboard_builder.build(
                    project_list,
                    data
                )

            dashboard.section.footer.val =
                dashboard_builder.footer()
        end

        setup_dashboard()

        alpha.setup(dashboard.config)

        vim.api.nvim_create_autocmd("User", {
            pattern = "AlphaReady",
            callback = function(args)
                vim.keymap.set("n", "p", function()
                    require("projects.browser").open()
                end, {
                    buffer = args.buf,
                    silent = true,
                })
            end,
        })

        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "alpha",
            callback = function()
                setup_dashboard()
            end,
        })
    end,
}
