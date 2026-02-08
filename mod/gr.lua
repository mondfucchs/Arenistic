-- **gr module.**
-- Graphics module. Draws.
local gr = {}

-- references to other modules
local ref = {}

-- attributes --

gr.palette =
{
    black = { 13 /255, 10 /255, 11 /255 },
    dusty = { 95 /255, 91 /255, 114/255 },
    white = { 243/255, 239/255, 245/255 },
    olive = { 112/255, 139/255, 117/255 }
}

-- methods --
-- methods.internal --

-- Sets the references of the other modules
function gr.setRef(ui, editor)
    ref.ui      = ui
    ref.editor  = editor
end

-- methods.draws --

function gr.drawBackground()
    love.graphics.setColor(gr.palette.white)
    love.graphics.rectangle("fill", 0, 0, love.graphics.getWidth(), love.graphics.getHeight())
end

-- rough draws ::temp

function gr.drawCurrentAtpat()

end

function gr.drawAtpatList()
    local x = 0
    local y = love.graphics.getHeight() - 40
    local w = love.graphics.getWidth() / ref.editor.sequence_size
    local h = 40

    for i = 1, ref.editor.sequence_size do
        local atpat = ref.editor.attack_sequence[i]

        love.graphics.setColor(gr.palette.dusty)
        if i == ref.editor.atpat_index then
            love.graphics.setColor(gr.palette.olive)
        end

        love.graphics.rectangle("fill", x + 1, y + 1, w - 2, h - 2)
        x = x + w
    end
end

function gr.drawEditorDebug()
    love.graphics.setColor(gr.palette.black)
    love.graphics.print(
        "editor.atpat_index = " .. ref.editor.atpat_index .. "\n" ..
        "editor.sequence_size = " .. ref.editor.sequence_size .. "\n",
        10, 10)
end

return gr