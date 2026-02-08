-- **gr module.**
-- Graphics module. Draws.
local gr = {}

-- references to other modules
local ref = {}

-- methods --
-- methods.internal --

-- Sets the references of the other modules
function gr.setRef(ui, editor)
    ref.ui      = ui
    ref.editor  = editor
end

-- rough draws ::temp

function gr.drawCurrentAtpat()

end

function gr.drawEditorDebug()
    love.graphics.print(
        "editor.atpat_index = " .. ref.editor.atpat_index .. "\n" ..
        "editor.sequence_size = " .. ref.editor.sequence_size .. "\n",
        10, 10)
end

return gr