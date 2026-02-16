-- asset.lua
local asset = {}

asset.image =
{
    eckert_tile = love.graphics.newImage("asset/eckert.png"),
    eckert_win  = love.graphics.newImage("asset/massdrilling.png"),
    eckert_dead = love.graphics.newImage("asset/eckert_dead.png"),
    mauchly =
    {
        idle = love.graphics.newImage("asset/mauchly.png"),
        hurt = love.graphics.newImage("asset/mauchly_hurt.png"),
        dead = love.graphics.newImage("asset/mauchly_dead.png")
    }
}

asset.sound =
{
    arena_acted = love.audio.newSource("asset/arena_acted.wav", "static"),
    heal = love.audio.newSource("asset/heal.wav", "static"),
    hurt = love.audio.newSource("asset/hurt.wav", "static"),
    move = love.audio.newSource("asset/move.wav", "static"),
    portal = love.audio.newSource("asset/portal.wav", "static"),
    collide = love.audio.newSource("asset/collide.wav", "static"),
    breathe = love.audio.newSource("asset/breathe.wav", "static"),
    choke = love.audio.newSource("asset/choke.wav", "static"),
    hitboss = love.audio.newSource("asset/hitboss.wav", "static"),
    bossdeath = love.audio.newSource("asset/boss_death.wav", "static"),
    eckertdeath = love.audio.newSource("asset/eckertdeath.wav", "static")
}

asset.color =
{
    default = { 1, 1, 1 },
    disabled = { .6, .5, .5 },
    blood = { 1, .2, .2 },
    bloodlike = { .8, .5, .5 },
    whimsical = { .8, .1, .8 },
    vines = { .2, 1, .2 },
    concrete = { .75, .75, .75 },

    alpha = function(clr, a)
        return { clr[1], clr[2], clr[3], a }
    end,
}

return asset