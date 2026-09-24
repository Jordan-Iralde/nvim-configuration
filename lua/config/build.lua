local M = {}

local function project_root()
    local root = vim.fs.root(0, {
        "CMakeLists.txt",
        ".git",
    })

    return root or vim.fn.getcwd()
end

local function cmake_target(root)
    local cmake_file = root .. "/CMakeLists.txt"

    local lines = vim.fn.readfile(cmake_file)

    for _, line in ipairs(lines) do
        local target = line:match("^%s*add_executable%s*%(%s*([%w_%-]+)")

        if target then
            return target
        end
    end

    return nil
end

function M.configure()
    local root = project_root()

    vim.fn.chdir(root)

    vim.cmd("terminal cmake -S . -B build -G Ninja -DCMAKE_BUILD_TYPE=Debug")
end

function M.build()
    local root = project_root()

    vim.fn.chdir(root)

    vim.opt.makeprg = "cmake --build build"

    vim.opt.errorformat = {
        "%f:%l:%c: %t%*[^:]: %m",
        "%f:%l: %t%*[^:]: %m",
    }

    vim.cmd("make")

    vim.cmd("cwindow")
end

function M.run()
    local root = project_root()
    local target = cmake_target(root)

    if not target then
        vim.notify(
            "No executable target found in CMakeLists.txt",
            vim.log.levels.ERROR
        )
        return
    end

    vim.fn.chdir(root)

    vim.cmd("botright split")
    vim.cmd("resize 15")

    vim.cmd("terminal ./build/" .. target)
end

function M.clean()
    local root = project_root()

    vim.fn.chdir(root)

    vim.cmd("terminal cmake --build build --target clean")
end

function M.rebuild()
    local root = project_root()

    vim.fn.chdir(root)

    vim.cmd(
        "terminal cmake --build build --clean-first"
    )
end 

return M
