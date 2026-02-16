-- tile.lua
local tile = {}

-- dependencies --

local pmath = require("util.pmath")
local asset = require("util.asset")

-- locales --

-- returns a table to draw an ``n``-sided alf
local function getAlf(n, x, y, delay, rad, deepness)
    rad = rad or 200
    deepness = deepness or 2
    local alf = {}

    n = (n <= 2) and 2 or n

    for i = 1, n do
        table.insert(alf, x + rad * math.cos(-delay + os.clock() + 2*math.pi/n*(i)))
        table.insert(alf, y + rad * math.sin(-delay + os.clock() + 2*math.pi/n*(i)))

        table.insert(alf, x + rad/deepness * math.cos(-delay + os.clock() + math.pi/n + 2*math.pi/n*(i)))
        table.insert(alf, y + rad/deepness * math.sin(-delay + os.clock() + math.pi/n + 2*math.pi/n*(i)))
    end

    return alf
end

-- returns a table to draw an ``n``-sided aksel
local function getAksel(n, x, y, rad)
    local aksel = {}

    for i = 1, n do
        table.insert(aksel, x + rad * math.cos(2*os.clock() + 2*math.pi/n*i))
        table.insert(aksel, y + rad * math.sin(2*os.clock() + 2*math.pi/n*i))
    end

    return aksel
end

-- tiles --

tile.empty =
{
    type = "empty",
    draw = function()
        -- :) hello!!
    end,
    update = function()
        -- :O i luv you, you're awesome
    end,
    touch = function()
        -- :I i mean, really, you'll achieve your dreams if you try hard enough
        -- (it depends...)
    end
}

-- alert tiles --

tile.alert_good =
{
    type = "alert",
    becomes = "healthy_common",

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.vines, .5))

        local triangles = love.math.triangulate(getAlf(6, x, y, 0, 4, 2 + math.sin(os.clock()) / 2))
        for _, triangle in ipairs(triangles) do
            love.graphics.polygon("fill", triangle)
        end
    end,

    update = function()
    end,
    touch = function()
    end
}
tile.alert_common =
{
    type = "alert",
    becomes = "attack_sharp",

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.blood, .5))

        local triangles = love.math.triangulate(getAlf(6, x, y, 0, 4, 2 + math.sin(os.clock()) / 2))
        for _, triangle in ipairs(triangles) do
            love.graphics.polygon("fill", triangle)
        end
    end,

    update = function()
    end,
    touch = function()
    end
}
tile.alert_angry_wall =
{
    type = "alert",
    becomes = "angry_wall",

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.bloodlike, .5))
        love.graphics.polygon("fill", getAksel(5, x, y, 3))
    end,

    update = function()
    end,
    touch = function()
    end
}
tile.alert_portal =
{
    type = "alert",
    becomes = "portal",

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.whimsical, .5))

        local triangles = love.math.triangulate(getAlf(6, x, y, 0, 4, 4))
        for _, triangle in ipairs( triangles ) do
            love.graphics.polygon("fill", triangle)
        end
    end,

    update = function()
    end,
    touch = function()
    end
}

-- healthy tiles --

tile.healthy_common =
{
    type = "healthy",
    life = 3,
    heal = 3,

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.vines, self.life / 3))

        local triangles = love.math.triangulate(getAlf(6, x, y, 0, 6, 2 + math.sin(os.clock())^2))
        for _, triangle in ipairs(triangles) do
            love.graphics.polygon("fill", triangle)
        end
    end,
    update = function(self, dt)
        self.life = self.life - dt
        if self.life <= 1 then
            return true
        end
    end,
    touch = function(self, dodger)
        dodger:heal(self.heal)
        self.life = 0
    end
}

-- attack tiles --

tile.attack_sharp =
{
    type = "attack",
    life = 3,
    damage = 2,
    excited = 0,

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.blood, self.life / 3))

        local triangles = love.math.triangulate(getAlf(6, x, y, 0, 6 + self.excited, 3 + math.sin(os.clock())^2))
        for _, triangle in ipairs(triangles) do
            love.graphics.polygon("fill", triangle)
        end
    end,
    update = function(self, dt)
        self.life = self.life - dt
        if self.life <= 1 then
            return true
        end
        self.excited = pmath.clamp(self.excited - dt*4, 0, math.huge)
    end,
    touch = function(self, dodger)
        dodger:hurt(self.damage)
    end
}

-- wall tiles --

tile.squary_wall =
{
    type = "wall",
    life = 9,
    excited = 0,

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.concrete, self.life / 5 * (1 + self.excited/5) ))
        love.graphics.polygon("fill", getAksel(4, x, y, 5 + self.excited))
    end,

    update = function(self, dt)
        self.life = self.life - dt
        if self.life <= 1 then
            return true
        end
        self.excited = pmath.clamp(self.excited - dt*4, 0, math.huge)
    end,

    touch = function(self, dodger, arena)
        self.excited = self.excited + 3

        local dx = math.random() < .5 and -1 or 1
        local dy = math.random() < .5 and -1 or 1

        arena:moveDodger(dx, dy, true)
    end,

    collide = function(self, dodger)
        self.excited = self.excited + 1
    end
}
tile.angry_wall =
{
    type = "wall",
    life = 9,
    damage = 2,
    excited = 0,

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.bloodlike, self.life / 5 * (1 + self.excited/5) ))
        love.graphics.polygon("fill", getAksel(5, x, y, 5 + self.excited))
    end,

    update = function(self, dt)
        self.life = self.life - dt
        if self.life <= 1 then
            return true
        end
        self.excited = pmath.clamp(self.excited - dt*4, 0, math.huge)
    end,

    touch = function(self, dodger, arena)
        self.excited = self.excited + 3

        local dx = math.random() < .5 and -1 or 1
        local dy = math.random() < .5 and -1 or 1

        arena:moveDodger(dx, dy, true)
    end,

    collide = function(self, dodger)
        dodger:hurt(self.damage)
        self.excited = self.excited + 1
    end
}

-- misc tiles --

tile.portal =
{
    type    = "misc",
    life    = 6,
    excited = 0,
    heal    = 3,

    stubborn= true,

    draw    = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.whimsical, self.life / 12))
        local background_triangles = love.math.triangulate(getAlf(7, x, y, 2, 8 + self.excited, 4))
        for _, triangle in ipairs( background_triangles ) do
            love.graphics.polygon("fill", triangle)
        end

        love.graphics.setColor(asset.color.alpha(asset.color.whimsical, self.life / 6))
        local triangles = love.math.triangulate(getAlf(7, x, y, 0, 7 + self.excited, 4))
        for _, triangle in ipairs( triangles ) do
            love.graphics.polygon("fill", triangle)
        end
    end,
    update  = function(self, dt)
        self.life = self.life - dt
        if self.life <= 1 then
            return true
        end

        self.excited = pmath.clamp(self.excited - dt*4, 0, math.huge) 
    end,
    touch   = function(self, dodger)
        asset.sound.portal:play()

        dodger:heal(self.heal)
        dodger.grid_position.x = math.random(6)
        dodger.grid_position.y = math.random(6)
    end
}

-- visual-only (whim) tiles --

tile.breathe =
{
    type = "whim",
    life = 2,
    excited = 0,

    draw = function(self, x, y)
        love.graphics.setColor(asset.color.alpha(asset.color.concrete, self.life / 3 ))
        love.graphics.polygon("fill", getAlf(5, x, y, 0, 4 + self.excited, .5))
    end,

    update = function(self, dt)
        self.life = self.life - dt
        if self.life <= 0 then
            return true
        end
        self.excited = pmath.clamp(self.excited - dt*4, 0, math.huge)
    end,

    touch = function()
    end,
}

-- functions --

-- returns a new tile with preset set as ``tile[preset]``
function tile:new(preset)
    assert(self[preset], "tile.lua doesn't have a " .. tostring(preset) .. " tile.")
    local t = {}
    setmetatable(t, { __index = self[preset] })
    return t
end

return tile