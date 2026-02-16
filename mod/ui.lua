-- **ui module.**
-- Processes the inputs received and makes them into {mum} requests.
local ui = {}

-- dependencies --

local mreq = require("util.mum-request")

-- attributes --

ui.previous_key = ""
ui.previous_key_discard = .5

-- Keymap for one keys
ui.single_keymap =
{
    ["n"] = function()
        mreq:send("addAtpat", {})
        return true
    end,

    ["d"] = function()
        mreq:send("deleteCurrentAtpat", {})
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
    ["ctrl+left"] = function()
        mreq:send("exhaustAtpatIndex", { "beginning" })
        return true
    end,

    ["ctrl+right"] = function()
        mreq:send("exhaustAtpatIndex", { "end" })
        return true
    end,

    ["alt+d"] = function()
        DEBUG = not DEBUG
        return true
    end,

    -- ::debug key
    ["alt+p"] = function()
        mreq:send("insertTile", { "squary_wall", math.random(6), math.random(6) })
    end,
}

-- methods.callbacks --

function ui:update(dt)

    self.previous_key_discard = self.previous_key_discard - dt

    if self.previous_key_discard <= 0 then
        self.previous_key = ""
        self.previous_key_discard = .5
    end

end

function ui:mousepressed(x, y, button)

end

function ui:keypressed(key)
    -- Honestly, sorry father if i'm mislead, but i won't ever use those separatedly
    key = (key == "lctrl" or key == "rctrl") and "ctrl" or key
    key = (key == "lalt" or key == "ralt") and "alt" or key

    -- checking for shortcuts
    local double_keymap_found =
        (self.double_keymap[self.previous_key .. "+" .. key] or function() end)()

    if not double_keymap_found then
        (self.single_keymap[key] or function() end)()
    end

    self.previous_key_discard = .5
    self.previous_key = key
end

function ui:textinput(char)

end

return ui