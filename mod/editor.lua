-- **editor module.**
-- Stores and edits the battle
local editor = {}

-- dependencies --

local pmath = require("util.pmath")
local tile  = require("util.tile")

-- locales --

local function getEmptyAtpat()
    local hitting_spots = {}
    for i = 1, 6 do
        hitting_spots[i] = {}
        for j = 1, 6 do
            hitting_spots[i][j] = tile:new("angry_wall")
        end
    end

    return { hitting_spots = hitting_spots }
end

-- attributes --

editor.attack_sequence = { getEmptyAtpat() }
editor.sequence_size   = 1
editor.atpat_index     = 1

editor.arena_width     = 6
editor.arena_height    = 6

-- methods.internal --

-- Adds one more attack pattern into ``attack_sequence``
function editor:addAtpat()
    -- Adds an empty atpat at the end of attack sequence
    table.insert(self.attack_sequence, getEmptyAtpat())

    -- Already moves index to it, if we're already in the last atpat
    -- (If we are not in the last atpat, we probably don't want to go to the new one)
    if self.atpat_index == self.sequence_size then
        self.atpat_index = self.atpat_index + 1
    end

    self.sequence_size = self.sequence_size + 1
end

-- Deletes the ith attack pattern from ``attack_sequence``
function editor:deleteAtpat(i)
    table.remove(self.attack_sequence, i)
    self.sequence_size = self.sequence_size - 1

    -- So we don't get off bounds
    self.atpat_index = pmath.clamp(self.atpat_index, 1, self.sequence_size)
end

return editor