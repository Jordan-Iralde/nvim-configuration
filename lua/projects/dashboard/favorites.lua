local M = {}

function M.build(project_list, state)
    local section = {}

    local favorites = {}

    for _, project in ipairs(project_list) do
        if state.favorites[project.name] then
            table.insert(favorites, project)
        end
    end

    if #favorites == 0 then
        return section
    end

    table.insert(section, {
        type = "text",
        val = "FAVORITES",
        opts = {
            position = "center",
            hl = "Title",
        },
    })

    for _, project in ipairs(favorites) do
        table.insert(section, {
            type = "button",
            val = "  ★ " .. project.name,
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
