-- **ui module.**
-- Processes the inputs received and makes them into {mum} requests.
local ui = {}

-- dependencies --

local mreq = require("util.mum-request")

-- attributes --

ui.previous_key = ""

-- Keymap for one keys
ui.single_keymap =
{
    ["n"] = function()
        mreq:send("addAtpat", {})
        return true
    end,

    ["left"] = function()
        mreq:send("moveAtpatIndex", { -1 })
        return true
    end,

    ["right"] = function()
        mreq:send("moveAtpatIndex", { 1 })
        return true
    end,
}

-- Keymap for two keys
ui.double_keymap =
{

}

-- methods.callbacks --

function ui:update(dt)

end

function ui:mousepressed(x, y, button)

end

function ui:keypressed(key)
    -- checking for shortcuts
    local double_keymap_found =
        (self.double_keymap[self.previous_key .. "+" .. key] or function() end)()

    if not double_keymap_found then
        (self.single_keymap[key] or function() end)()
    end

    self.previous_key = key
end

function ui:textinput(char)

end

return ui