-- **pmath util**.
-- additional math funcs
local pmath = {}

function pmath.clamp(n, min, max)
    return math.max(math.min(n, max), min)
end

return pmath