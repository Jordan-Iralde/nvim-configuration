local M = {}

local function get_current_file()
    local cwd = vim.fn.getcwd()
    local file = vim.fn.expand("%:p")

    if file == "" then
        return nil
    end

    if vim.startswith(file, cwd .. "/") then
        return file:sub(#cwd + 2)
    end

    return file
end

local function get_loctree_data(file)
    local result = vim.system({
        "loct",
        "slice",
        file,
        "--json",
    }, {
        text = true,
    }):wait()

    if result.code ~= 0 then
        vim.notify(
            "Loctree error:\n" .. result.stderr,
            vim.log.levels.ERROR
        )
        return nil
    end

    -- Loctree puede imprimir mensajes antes del JSON.
    local json_start = result.stdout:find("{")

    if not json_start then
        vim.notify(
            "No se encontró JSON en la salida de Loctree",
            vim.log.levels.ERROR
        )
        return nil
    end

    local json = result.stdout:sub(json_start)

    local ok, data = pcall(vim.json.decode, json)

    if not ok then
        vim.notify(
            "No se pudo interpretar el JSON de Loctree",
            vim.log.levels.ERROR
        )
        return nil
    end

    return data
end

local function open_file(path)
    vim.cmd("edit " .. vim.fn.fnameescape(path))
end

local function build_lines(file, data)
    local lines = {}
    local targets = {}

    local function add(text, path)
        table.insert(lines, text)

        if path then
            targets[#lines] = path
        end
    end

    add("Dependency Graph")
    add("")

    add("CURRENT")
    add("  " .. file, file)
    add("")

    add("DEPENDENCIES")

    if #data.deps == 0 then
        add("  (none)")
    else
        for _, dep in ipairs(data.deps) do
            local indent = string.rep("  ", dep.depth - 1)
            add(
                indent .. "→ " .. dep.path,
                dep.path
            )
        end
    end

    add("")
    add("CONSUMERS")

    if #data.consumers == 0 then
        add("  (none)")
    else
        for _, consumer in ipairs(data.consumers) do
            add(
                "  ← " .. consumer.path,
                consumer.path
            )
        end
    end

    add("")
    add("────────────────────────────────")
    add("ENTER  open file")
    add("q      close")

    return lines, targets
end

function M.open()
    local file = get_current_file()

    if not file then
        vim.notify(
            "No hay un archivo abierto",
            vim.log.levels.WARN
        )
        return
    end

    local data = get_loctree_data(file)

    if not data then
        return
    end

    local lines, targets = build_lines(file, data)

    local buf = vim.api.nvim_create_buf(false, true)

    vim.api.nvim_buf_set_lines(
        buf,
        0,
        -1,
        false,
        lines
    )

    vim.bo[buf].buftype = "nofile"
    vim.bo[buf].bufhidden = "wipe"
    vim.bo[buf].swapfile = false
    vim.bo[buf].modifiable = false

    local width = math.floor(vim.o.columns * 0.6)
    local height = math.floor(vim.o.lines * 0.6)

    local row = math.floor((vim.o.lines - height) / 2)
    local col = math.floor((vim.o.columns - width) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        relative = "editor",
        row = row,
        col = col,
        width = width,
        height = height,
        style = "minimal",
        border = "rounded",
    })

    vim.wo[win].cursorline = true
    vim.wo[win].wrap = false

    local function close()
        if vim.api.nvim_win_is_valid(win) then
            vim.api.nvim_win_close(win, true)
        end
    end

    vim.keymap.set("n", "q", close, {
        buffer = buf,
        silent = true,
    })

    vim.keymap.set("n", "<Esc>", close, {
        buffer = buf,
        silent = true,
    })

    vim.keymap.set("n", "<CR>", function()
        local line = vim.api.nvim_win_get_cursor(win)[1]
        local target = targets[line]

        if not target then
            return
        end

        close()
        open_file(target)
    end, {
        buffer = buf,
        silent = true,
    })
end

return M
