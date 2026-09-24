local M = {}

local header = require("projects.dashboard.header")
local favorites = require("projects.dashboard.favorites")
local recent = require("projects.dashboard.recent")
local actions = require("projects.dashboard.actions")

function M.header()
    return header.build()
end

function M.build(project_list, state)
    local sections = {}

    sections = vim.list_extend(
        sections,
        favorites.build(project_list, state)
    )

    sections = vim.list_extend(
        sections,
        recent.build(project_list, state)
    )

    sections = vim.list_extend(
        sections,
        actions.build()
    )

    return sections
end

function M.footer()
    return {
        "",
        "recent projects · favorites · project browser",
        "",
        "development environment",
    }
end

return M
