-- **salo module.**
-- Saves (sa) and loads (lo) attack sequences.
local salo = {}

-- dependencies -- could suck

local tile = require("util.tile")

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

local codetile =
{
    ["empty"] = "00",
    ["breathe"] = "99",

    ["alert_common"] = "01",
    ["alert_good"] = "02",
    ["alert_angry_wall"] = "03",
    ["alert_portal"] = "04",
    ["alert_squary_wall"] = "05", -- todo

    ["attack_sharp"] = "11",
    ["healthy_common"] = "12",
    ["angry_wall"] = "13",
    ["portal"] = "14",
    ["squary_wall"] = "15",
}

local ref = {}

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

    file:close()
end

-- Saves current attack sequence in ``saves/(filename).atse``.
function salo.save(filename)

    local path = "saves/" .. filename .. ".atse"
    local file = io.open(path, "w")
    if not file then error("\"" .. path .. "\" can't exist.") end

    local last_i = ref.editor.sequence_size
    local attseq = ref.editor.attack_sequence
    for _, atpat in ipairs(attseq) do

        for x = 1, 6 do

            for y = 1, 6 do
                local t = atpat.hitting_spots[x][y]
                file:write(codetile[t.name])
            end

            file:write("\n")

        end

    end

    file:close()
end


return salo