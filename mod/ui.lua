-- **ui module.**
-- Processes the inputs received and makes them into {mum} requests.
local ui = {}

-- references to other modules --

local ref = {}

-- dependencies --

local mreq = require("util.mum-request")
local tile = require("util.tile")

-- attributes --

ui.mode = "placing" -- placing / naming 

ui.naming_string = ""

ui.tile_preset = "attack_sharp"

ui.previous_key = ""
ui.previous_key_discard = .5

-- Stores which tile is being hovered
ui.hovering_tile = { x = 1, y = 1 }

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

-- Keymap for naming
ui.naming_keymap =
{
    ["return"] = function()
        mreq:send("setTilePreset", {})
    end,

    ["backspace"] = function()
        ui.naming_string = ui.naming_string:sub(1, #ui.naming_string - 1)
    end,

    ["escape"] = function()
        ui.mode = "placing"
    end
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

    ["ctrl+t"] = function()
        ui.mode = "naming"
    end,

    -- ::debug key
    ["alt+p"] = function()
        mreq:send("insertTile", { "squary_wall", math.random(6), math.random(6) })
    end,
}

-- methods.internal --

function ui.setRef(gr, editor)
    ref.gr      = gr
    ref.editor  = editor
end

-- methods.callbacks --

function ui:update(dt)

    -- Updating which tile has been hovered
    local scaled_x = love.mouse.getX() / 6
    local scaled_y = love.mouse.getY() / 6

    self.hovering_tile.x =
        math.ceil((scaled_x - ref.gr.sizes.grid_x) / (ref.gr.sizes.tile_wh + ref.gr.sizes.cute_margin))
    self.hovering_tile.y =
        math.ceil((scaled_y - ref.gr.sizes.grid_y) / (ref.gr.sizes.tile_wh + ref.gr.sizes.cute_margin))

    self.previous_key_discard = self.previous_key_discard - dt

    if self.previous_key_discard <= 0 then
        self.previous_key = ""
        self.previous_key_discard = .5
    end

end

function ui:mousepressed(x, y, button)

    if ui.mode == "placing" then

        if button == 1 then
            mreq:send("insertTile", { self.tile_preset, self.hovering_tile.x, self.hovering_tile.y } )            
        elseif button == 2 then
            mreq:send("removeTile", { self.hovering_tile.x, self.hovering_tile.y } )
        end
    end

end

function ui:keypressed(key)

    -- Honestly, sorry father if i'm mislead, but i won't ever use those separatedly
    key = (key == "lctrl" or key == "rctrl") and "ctrl" or key
    key = (key == "lalt" or key == "ralt") and "alt" or key

    if self.mode == "naming" then
        (self.naming_keymap[key] or function() end)()

    elseif self.mode == "placing" then

        -- checking for shortcuts
        local double_keymap_found =
            (self.double_keymap[self.previous_key .. "+" .. key] or function() end)()

        if not double_keymap_found then
            (self.single_keymap[key] or function() end)()
        end
    end

    self.previous_key_discard = .5
    self.previous_key = key
end

function ui:textinput(char)
    if ui.mode == "naming" then
        ui.naming_string = ui.naming_string .. char
    end
end

return ui