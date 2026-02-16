
-- configs --

love.graphics.setDefaultFilter("nearest", "nearest")

-- dependencies --

local mum           = require("mod.mum")
local gr            = require("mod.gr")
local ui            = require("mod.ui")
local editor        = require("mod.editor")

local mum_request   = require("util.mum-request")

-- meh!
---@diagnostic disable-next-line
table.unpack = table.unpack or unpack

-- globals --

DEBUG = true
-- Current procress
-- (*NOTE: this is vague. I wanted it to be some kind of "game mode", but I can't imagine a good implementation of this by now.)
PROCEDURE = "none"

-- locales --

-- Executes {mum} and updates tasks and orders inside mum_request
local function mother(dt)
    -- executing tasks
    local new_tasks = {}
    for _, task in ipairs(mum_request.tasks) do
        if not task(dt) then
            table.insert(new_tasks, task)
        end
    end
    mum_request.tasks = new_tasks

    -- making orders into tasks
    for _, order in ipairs(mum_request.orders) do
        local task = mum[order.f]( table.unpack(order.arg) )

        table.insert(
            mum_request.tasks,
            task
        )
    end
    mum_request.orders = {}
end

-- callbacks --

function love.load()
    mum.setRef(ui, editor, gr)
    gr.setRef (ui, editor)
end

function love.update(dt)
    mother(dt)
    -- modules
    ui:update(dt)
end

function love.draw()

    local drawn_arena = gr.getDrawnArena()
    love.graphics.setColor(1, 1, 1)
    love.graphics.draw(drawn_arena, 0, 0, 0, 6, 6)

end

-- callbacks.input --

function love.mousepressed(x, y, button)
    ui:mousepressed(x, y, button)
end

function love.keypressed(key)
    ui:keypressed(key)
end

function love.textinput(char)
    ui:textinput(char)
end