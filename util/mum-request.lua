-- **mum-request util**.
-- Can be imported by anyone, letting them request {mum} to execute any of its functions.
local mum_request = {}

-- Sent orders (they will become tasks)
mum_request.orders = {}
-- Currently being executed tasks
mum_request.tasks  = {}

function mum_request:send(f, arg)
    table.insert(mum_request.orders, { f = f, arg = arg })
end

return mum_request