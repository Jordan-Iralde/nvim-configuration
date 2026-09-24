local M = {}

local projects_dir = vim.fn.expand("~/Documents/Github")

local function read_description(path)
    local readme = path .. "/README.md"
    local file = io.open(readme, "r")

    if not file then 
        return "Sin README.md"
    end

    local description = {}

    for line in file:lines() do
        line = vim.trim(line)

        if line ~= "" and not vim.startswith(line, "#") then
            table.insert(description, line)

            if #description == 2 then
                break
            end
        end
    end

    file:close()

    if #description == 0 then
        return "Sin descripción"
    end

    return table.concat(description, " ")
end

function M.get_projects()
    local state = require("projects.state")

    local projects = {}
    local entries = vim.fn.readdir(projects_dir)

    for _, name in ipairs(entries) do
        local path = projects_dir .. "/" .. name

        if vim.fn.isdirectory(path) == 1 then
            table.insert(projects, {
                name = name,
                path = path,
                description = read_description(path),
                favorite = state.is_favorite(name),
            })
        end
    end

    local data = state.ensure_order(projects)

    local by_name = {}

    for _, project in ipairs(projects) do
        by_name[project.name] = project
    end

    local ordered = {}

    for _, name in ipairs(data.order) do
        if by_name[name] then
            table.insert(ordered, by_name[name])
        end
    end

    return ordered
end

function M.open(project)
    local state = require("projects.state")

    state.touch_recent(project.name)

    vim.cmd("cd " .. vim.fn.fnameescape(project.path))

    -- Intentamos abrir README como punto de entrada.
    local readme = project.path .. "/README.md"

    if vim.fn.filereadable(readme) == 1 then
        vim.cmd("edit " .. vim.fn.fnameescape(readme))
    else
        vim.cmd("enew")
    end
end

return M
