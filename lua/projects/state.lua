local M = {}

local path = vim.fn.stdpath("config") .. "/projects.json"

local function default_state()
    return {
        order = {},
        favorites = {},
        recent = {},
    }
end

function M.load()
    local file = io.open(path, "r")

    if not file then
        return default_state()
    end

    local content = file:read("*a")
    file:close()

    local ok, data = pcall(vim.json.decode, content)

    if not ok or type(data) ~= "table" then
        return default_state()
    end

    data.order = data.order or {}
    data.favorites = data.favorites or {}
    data.recent = data.recent or {}

    return data
end

function M.save(data)
    local file = io.open(path, "w")

    if not file then
        return
    end

    file:write(vim.json.encode(data))
    file:close()
end

function M.touch_recent(name)
    local data = M.load()

    local recent = {}

    for _, project in ipairs(data.recent) do
        if project ~= name then
            table.insert(recent, project)
        end
    end

    table.insert(recent, 1, name)

    while #recent > 10 do
        table.remove(recent)
    end

    data.recent = recent

    M.save(data)
end

function M.is_favorite(name)
    local data = M.load()
    return data.favorites[name] == true
end

function M.toggle_favorite(name)
    local data = M.load()

    data.favorites[name] = not data.favorites[name]

    M.save(data)

    return data.favorites[name]
end

function M.ensure_order(projects)
    local data = M.load()

    local names = {}

    for _, project in ipairs(projects) do
        names[project.name] = true
    end

    local order = {}
    local used = {}

    for _, name in ipairs(data.order) do
        if names[name] then
            table.insert(order, name)
            used[name] = true
        end
    end

    local missing = {}

    for _, project in ipairs(projects) do
        if not used[project.name] then
            table.insert(missing, project.name)
        end
    end

    table.sort(missing, function(a, b)
        return a:lower() < b:lower()
    end)

    for _, name in ipairs(missing) do
        table.insert(order, name)
    end

    data.order = order

    M.save(data)

    return data
end

function M.move(name, direction)
    local data = M.load()

    local index

    for i, project in ipairs(data.order) do
        if project == name then
            index = i
            break
        end
    end

    if not index then
        return
    end

    local target = index + direction

    if target < 1 or target > #data.order then
        return
    end

    data.order[index], data.order[target] =
        data.order[target], data.order[index]

    M.save(data)
end

return M
