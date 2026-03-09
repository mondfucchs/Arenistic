-- **gr module.**
-- Graphics module. Draws.
local gr = {}

-- references to other modules
local ref = {}

-- dependencies --

local asset = require("util.asset")

-- attributes --

-- straight from
gr.sizes = {
    tile_wh = 10,
    grid_x = 5,
    grid_y = 5,
    tiny_margin = 20,
    cute_margin = 2,
    mid_margin = 40,
}

-- methods --
-- methods.internal --

-- Sets the references of the other modules
function gr.setRef(ui, editor)
    ref.ui      = ui
    ref.editor  = editor
end

-- methods.draws --

local arena_canvas = love.graphics.newCanvas(80, 80)
function gr.getDrawnArena()

    local grid   = ref.editor.attack_sequence[ ref.editor.atpat_index ].hitting_spots
    local width  = ref.editor.arena_width
    local height = ref.editor.arena_height

    love.graphics.setCanvas(arena_canvas)
    love.graphics.clear()

    for x = 1, width do
        for y = 1, height do

            local tile_center_x = gr.sizes.grid_x + (gr.sizes.tile_wh + gr.sizes.cute_margin) * (x - 1) + gr.sizes.tile_wh / 2
            local tile_center_y = gr.sizes.grid_y + (gr.sizes.tile_wh + gr.sizes.cute_margin) * (y - 1) + gr.sizes.tile_wh / 2

            grid[x][y]:draw(tile_center_x, tile_center_y)

        end
    end

    love.graphics.setCanvas()
    return arena_canvas

end

function gr.drawHovering()

    -- hovering tile coordinates
    local x = ref.ui.hovering_tile.x
    local y = ref.ui.hovering_tile.y

    local tile_x = gr.sizes.grid_x + (gr.sizes.tile_wh + gr.sizes.cute_margin) * (x - 1)
    local tile_y = gr.sizes.grid_y + (gr.sizes.tile_wh + gr.sizes.cute_margin) * (y - 1)

    love.graphics.setColor(1, 1, 1, 0.5)
    love.graphics.rectangle("fill", tile_x, tile_y, gr.sizes.tile_wh, gr.sizes.tile_wh)

end

function gr.displayAttackSequence()

    local highlight_color = asset.color.default
    local common_color    = asset.color.disabled

    local height = 2
    local width  = 80 / ref.editor.sequence_size
    local ox, oy = 0, 90 - height

    for i, _ in ipairs(ref.editor.attack_sequence) do

        love.graphics.setColor( ref.editor.atpat_index == i and highlight_color or common_color)

        love.graphics.rectangle(
            "fill", ox + width * (i - 1), oy,
            width, height
        )

    end

end

-- ::debug
function gr.showDebug()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print(
        ref.ui.hovering_tile.x .. " " .. ref.ui.hovering_tile.y
    )
end

return gr