local M = {}

local function render(buf, filter)
    local projects = require("projects").get_projects()
    local state = require("projects.state")

    filter = filter or ""

    local lines = {}
    local project_by_line = {}

    table.insert(lines, "PROJECT BROWSER")
    table.insert(lines, "")
    table.insert(lines, "Enter abrir   f favorito   u/d mover   r refrescar   / buscar   q salir")
    table.insert(lines, "")

    local recent_map = {}

    for i, name in ipairs(state.load().recent) do
        recent_map[name] = i
    end

    for _, project in ipairs(projects) do
        local matches =
            filter == ""
            or project.name:lower():find(filter:lower(), 1, true)
            or project.path:lower():find(filter:lower(), 1, true)

        if matches then
            local favorite = state.is_favorite(project.name)
            local recent = recent_map[project.name]

            local marker = favorite and "★" or " "
            local recent_text = recent and ("recent #" .. recent) or ""

            local line = string.format(
                "%s %-24s │ %-12s │ %s",
                marker,
                project.name,
                recent_text,
                project.path
            )

            table.insert(lines, line)
            project_by_line[#lines] = project
        end
    end

    vim.bo[buf].modifiable = true

    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        lines
    )

    vim.bo[buf].modifiable = false

    return project_by_line
end

function M.open()
    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_name(buf, "Project Browser")

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].filetype = "project-browser"

    vim.cmd("botright vsplit")
    vim.api.nvim_win_set_buf(0, buf)

    local filter = ""
    local project_by_line = render(buf, filter)

    local function refresh()
        project_by_line = render(buf, filter)
    end

    local function current_project()
        local line = vim.api.nvim_win_get_cursor(0)[1]
        return project_by_line[line]
    end

    vim.keymap.set("n", "<CR>", function()
        local project = current_project()

        if project then
            require("projects").open(project)
        end
    end, { buffer = buf })

    vim.keymap.set("n", "f", function()
        local project = current_project()

        if project then
            require("projects.state").toggle_favorite(project.name)
            refresh()
        end
    end, { buffer = buf })

    vim.keymap.set("n", "u", function()
        local project = current_project()

        if project then
            require("projects.state").move(project.name, -1)
            refresh()
        end
    end, { buffer = buf })

    vim.keymap.set("n", "d", function()
        local project = current_project()

        if project then
            require("projects.state").move(project.name, 1)
            refresh()
        end
    end, { buffer = buf })

    vim.keymap.set("n", "r", function()
        refresh()
    end, { buffer = buf })

    vim.keymap.set("n", "/", function()
        vim.ui.input({
            prompt = "Buscar proyecto: ",
            default = filter,
        }, function(input)
            if input == nil then
                return
            end

            filter = input
            refresh()
        end)
    end, { buffer = buf })

   vim.keymap.set("n", "q", function()
    vim.cmd("bd!")

    vim.schedule(function()
        if vim.fn.exists("*Alpha") == 1 then
            vim.cmd("Alpha")
        end
    end)
end, {
    buffer = buf,
    silent = true,
})

    vim.keymap.set("n", "t", function()
    local project = current_project()

    if not project then
        return
    end

    vim.cmd("cd " .. vim.fn.fnameescape(project.path))

    local ok, toggleterm = pcall(require, "toggleterm")

    if ok then
        toggleterm.toggle()
    else
        vim.cmd("terminal")
    end
    end, { buffer = buf })
end

return M
