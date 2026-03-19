-- **salo module.**
-- Saves (sa) and loads (lo) attack sequences.
local salo = {}

-- Each tile has a specific code two number code for it.
local tilecode =
{
    [00] = "empty",
    [99] = "breathe",

    [01] = "alert_common",
    [02] = "alert_good",
    [03] = "alert_angry_wall",
    [04] = "alert_portal",
    [05] = "alert_squary_wall", -- todo

    [11] = "attack_sharp",
    [12] = "healthy_common",
    [13] = "angry_wall",
    [14] = "portal",
    [15] = "squary_wall",
}

local ref = {}

-- dependencies -- could suck

local tile = require("util.tile")

-- attributes --


-- methods --

function salo.setRef(editor)
    ref.editor = editor
end

-- Constructs an attack sequence from ``saves/(filename).atse``and loads it to {editor}.
function salo.load(filename)

    local path = "saves/" .. filename .. ".atse"
    local file = io.open(path, "r")
    if not file then error("\"" .. path .. "\" doesn't exist.") end

    local attack_sequence = { }

    -- (inserts each tile at [index~][x~][y~])
    -- (until there are no more lines to read) -> (::conclude::)
    local index = 1
    while (true) do

        attack_sequence[index] = getEmptyAtpat()
        -- (inserts each tile at [index][x~][y~])
        local x = 1
        repeat
            -- (gets one row of tiles)
            local line = file:read('l')
            if not line then goto conclude end

            attack_sequence[index].hitting_spots[x] = {}

            -- (inserts each tile at [x][y~])
            local y = 1
            for code in string.gmatch(line, "(%d%d)") do

                -- (matches code with tile)
                local matching_tile = tilecode[tonumber(code)]
                assert(matching_tile, "wellllllll, " .. code .. " is bullshit")

                -- (inserts each tile at [x][y])
                attack_sequence[index].hitting_spots[x][y] = tile:new(matching_tile)

                -- (y++ so previous step can repeat)
                y = y + 1

            end
            -- (x++ so previous step can repeat)
            x = x + 1

        until (x == 6 + 1)
        -- (index++ so previous step can repeat)
        index = index + 1
    end

    ::conclude::

    table.remove(attack_sequence)
    ref.editor:loadAttseq(attack_sequence)

end


return salo