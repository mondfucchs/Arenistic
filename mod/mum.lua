-- **mum module: module's unified mechanism.**
-- Integrates all other modules' functionality into functions that execute by one or more frames.
local mum = {}

-- dependencies --

local pmath = require("util.pmath")

-- references to other modules
local ref = {}

-- methods --
-- methods.internal --

-- Sets the references of the other modules
function mum.setRef(ui, editor, gr)
    ref.ui      = ui
    ref.editor  = editor
    ref.gr      = gr
end

-- methods.tasks --

-- Adds a new atpat to {editor}
function mum.addAtpat()
    return function()
        ref.editor:addAtpat()
        return true
    end
end

-- Moves the {editor}'s atpat_index ``d`` units
function mum.moveAtpatIndex(d)
    return function()
        ref.editor.atpat_index =
            pmath.clamp( ref.editor.atpat_index + d, 1, ref.editor.sequence_size )
        return true
    end
end

return mum