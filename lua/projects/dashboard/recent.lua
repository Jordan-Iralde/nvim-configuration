local M = {}

function M.build(project_list, state)
    local section = {}
    local recent_projects = {}

    local projects_by_name = {}

    for _, project in ipairs(project_list) do
        projects_by_name[project.name] = project
    end

    for _, name in ipairs(state.recent) do
        local project = projects_by_name[name]

        if project then
            table.insert(recent_projects, project)
        end
    end

    if #recent_projects == 0 then
        return section
    end

    table.insert(section, {
        type = "text",
        val = "RECENT",
        opts = {
            position = "center",
            hl = "Title",
        },
    })

    for _, project in ipairs(recent_projects) do
        table.insert(section, {
            type = "button",
            val = "  → " .. project.name,
            on_press = function()
                require("projects").open(project)
            end,
            opts = {
                width = 60,
                position = "center",
                shortcut = "",
                cursor = 1,
            },
        })
    end

    table.insert(section, {
        type = "text",
        val = "",
        opts = {
            position = "center",
        },
    })

    return section
end

return M
