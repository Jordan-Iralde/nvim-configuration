local M = {}

M.endpoint = "https://llama.codetlab.com/v1/chat"

function M.ask(message, callback)
    local body = vim.json.encode({
        message = message,
    })

    vim.system({
        "curl",
        "-s",
        "-X",
        "POST",
        M.endpoint,
        "-H",
        "Content-Type: application/json",
        "-d",
        body,
    }, {
        text = true,
    }, function(result)
        vim.schedule(function()
            if result.code ~= 0 then
                vim.notify(
                    "AI request failed: " .. result.stderr,
                    vim.log.levels.ERROR
                )
                return
            end

            callback(result.stdout)
        end)
    end)
end

return M
