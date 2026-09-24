local M = {}

local Terminal = require("toggleterm.terminal").Terminal

local terminals = {}

local function project_root()
    return vim.fs.root(0, {
        "package.json",
        "CMakeLists.txt",
        ".git",
    }) or vim.fn.getcwd()
end

local function package_manager(root)
    if vim.uv.fs_stat(root .. "/pnpm-lock.yaml") then
        return "pnpm"
    end

    if vim.uv.fs_stat(root .. "/yarn.lock") then
        return "yarn"
    end

    if vim.uv.fs_stat(root .. "/bun.lockb")
        or vim.uv.fs_stat(root .. "/bun.lock")
    then
        return "bun"
    end

    return "npm"
end

local function command_for(pm, script)
    if pm == "yarn" then
        return "yarn " .. vim.fn.shellescape(script)
    end

    return pm .. " run " .. vim.fn.shellescape(script)
end

local function read_scripts(root)
    local path = root .. "/package.json"

    if vim.fn.filereadable(path) == 0 then
        vim.notify(
            "No package.json found in " .. root,
            vim.log.levels.WARN
        )
        return nil
    end

    local ok, package = pcall(function()
        local content = table.concat(
            vim.fn.readfile(path),
            "\n"
        )

        return vim.json.decode(content)
    end)

    if not ok or type(package) ~= "table" then
        vim.notify(
            "Invalid package.json",
            vim.log.levels.ERROR
        )
        return nil
    end

    if type(package.scripts) ~= "table" then
        vim.notify(
            "No scripts found in package.json",
            vim.log.levels.WARN
        )
        return nil
    end

    return package.scripts
end

local function terminal_for(root, script, command)
    local key = root .. "::" .. script

    if terminals[key] then
        return terminals[key]
    end

    local term

    term = Terminal:new({
        cmd = command,
        dir = root,

        direction = "horizontal",

        size = 15,

        close_on_exit = false,

        auto_scroll = true,

        display_name = script,

        on_exit = function()
            terminals[key] = nil
        end,
    })

    terminals[key] = term

    return term
end

function M.run(script)
    local root = project_root()

    local scripts = read_scripts(root)

    if not scripts then
        return
    end

    if scripts[script] == nil then
        vim.notify(
            "Script not found: " .. script,
            vim.log.levels.WARN
        )
        return
    end

    local pm = package_manager(root)
    local command = command_for(pm, script)

    local term = terminal_for(
        root,
        script,
        command
    )

    term:toggle()
end

function M.select()
    local root = project_root()

    local scripts = read_scripts(root)

    if not scripts then
        return
    end

    local names = vim.tbl_keys(scripts)

    table.sort(names)

    if #names == 0 then
        vim.notify(
            "No npm scripts found",
            vim.log.levels.WARN
        )
        return
    end

    vim.ui.select(
        names,
        {
            prompt = "Project scripts:",
            format_item = function(item)
                return item .. "  →  " .. scripts[item]
            end,
        },
        function(choice)
            if choice then
                M.run(choice)
            end
        end
    )
end

function M.root()
    return project_root()
end

return M
