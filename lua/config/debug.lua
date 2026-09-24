local dap = require("dap")
local dapui = require("dapui")

dapui.setup()

dap.listeners.before.attach.dapui_config = function()
    dapui.open()
end

dap.listeners.before.launch.dapui_config = function()
    dapui.open()
end

dap.listeners.before.event_terminated.dapui_config = function()
    dapui.close()
end

dap.listeners.before.event_exited.dapui_config = function()
    dapui.close()
end

dap.adapters.codelldb = {
    type = "executable",
    command = vim.fn.stdpath("data") .. "/mason/bin/codelldb",
}

dap.configurations.cpp = {
    {
        name = "Launch simulation",
        type = "codelldb",
        request = "launch",

        program = function()
            local root = vim.fs.root(0, {
                "CMakeLists.txt",
                ".git",
            })

            return root .. "/build/simulation"
        end,

        cwd = function()
            return vim.fs.root(0, {
                "CMakeLists.txt",
                ".git",
            })
        end,

        stopOnEntry = false,
    },
}
