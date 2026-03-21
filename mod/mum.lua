-- **mum module: module's unified mechanism.**
-- Integrates all other modules' functionality into functions that execute by one or more frames.
local mum = {}

-- dependencies --

local asset = require("util.asset")
local pmath = require("util.pmath")
local tile  = require("util.tile")

-- references to other modules
local ref = {}

-- methods --
-- methods.internal --

-- Sets the references of the other modules
function mum.setRef(ui, editor, gr, salo)
    ref.ui      = ui
    ref.editor  = editor
    ref.gr      = gr
    ref.salo    = salo
end

-- methods.tasks --

-- tasks: attack sequence list
do

-- Adds a new atpat to {editor}
function mum.addAtpat()
    return function()
        ref.editor:addAtpat()
        asset.sound.hurt:play()
        return true
    end
end

-- Deletes the atpat_index th atpat {editor}
function mum.deleteCurrentAtpat()
    return function()
        if ref.editor.sequence_size > 1 then
            ref.editor:deleteAtpat(ref.editor.atpat_index)
        end
        asset.sound.hurt:play()
        return true
    end
end

-- Moves the {editor}'s atpat_index ``d`` units
function mum.moveAtpatIndex(d)
    return function()
        ref.editor.atpat_index =
            pmath.clamp( ref.editor.atpat_index + d, 1, ref.editor.sequence_size )
        asset.sound.move:play()
        return true
    end
end

-- Moves the {editor}'s atpat_index to the ``to``
function mum.exhaustAtpatIndex(to)
    return function()
        ref.editor.atpat_index = ( to == "beginning" and 1 or ref.editor.sequence_size )
        return true
    end
end

end

-- tasks: editing attack pattern
do

-- Inserts a tile of preset ``preset`` in current attack pattern in positions ``x``, ``y``
function mum.insertTile(preset, x, y)
    return function ()
        asset.sound.collide:play()
        ref.editor:addTile(preset, x, y)

        return true
    end
end

-- Removes the tile in positions ``x``, ``y``
function mum.removeTile(x, y)
    return function ()
        asset.sound.collide:play()
        ref.editor:removeTile(x, y)

        return true
    end
end

end

-- tasks: editing configs
do

function mum.setTilePreset( unsave )
    local named = ref.ui.naming_string

    return function()
        if tile[named] then
            -- Functional
            ref.ui.tile_preset   = named
            ref.ui.naming_string = ""
            ref.ui.mode          = "placing"
            if not unsave then table.insert(ref.ui.previous_tile_presets, named) end
            -- so i go hahah
            asset.sound.heal:play()

        else
            -- Functional
            ref.ui.naming_string = ""
            ref.ui.mode          = "placing"
            -- so i go buaaaaa
            asset.sound.choke:play()

        end

        return true
    end
end

function mum.setFilename()
    local named = ref.ui.naming_string

    return function()
        -- Functional
        ref.ui.filename = named
        ref.ui.naming_string = ""
        ref.ui.mode          = "placing"
        -- Soigoha
        asset.sound.heal:play()

        return true
    end
end

end

-- tasks: storing and loading
do

function mum.loadAttseq(quietly)

    -- Functional
    ref.salo.load(ref.ui.filename)

    return function()
        if quietly then return true end
        -- So i go hahaha
        asset.sound.portal:play()
        return true
    end

end

function mum.saveAttseq(quietly)

    -- Functional
    ref.salo.save(ref.ui.filename)

    return function()
        if quietly then return true end
        -- So i go hahaha wait is it the same code NOOOO AND THE DRY PRINCPLE!!!??
        asset.sound.portal:play()
        return true
    end

end

end

return mum