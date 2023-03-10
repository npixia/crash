local pathfinding = {}

local Arr2d = game.objects.Arr2d
local PriorityQueue = game.objects.PriorityQueue
local Point = game.objects.Vector2d

-- loc: Point
local function getNeighbors(loc, map)
    local n = {}
    for i=-1,1 do
        for j=-1,1 do
            local p = Point(i,j) + loc
            if not map:isSolid(p.x, p.y) then
                table.insert(n, p)
            end
        end
    end
    return n
end


function pathfinding.pathfind(from, to, options)
    local map = game.world.currentMap()
    local green = rgb(0,255,0)
    if options == nil then options = {} end
    local maxiters = options.maxiters or 1000

    local canvas = game.render.getCanvas('pathfind_debug')
    canvas:setDrawType('overlay')
    canvas:clear()

    if map:isSolid(to.x, to.y) then
        if options.draw then canvas:putWithColor(to.x, to.y, ord('X'), rgb(255, 0, 0)) end
        return {}, nil
    end

    local frontier = PriorityQueue()
    local start = from:copy()
    start.cost = 0
    frontier:push(start, 99)

    local came_from = Arr2d()
    came_from:set(start.x, start.y, start)

    local itercount = 0
    local current = start
    while not frontier:empty() do
        current = frontier:pop()
        if current.x == to.x and current.y == to.y then break end
        local neighbors = getNeighbors(current, map)
        for i,next in pairs(neighbors) do
            if not came_from:contains(next.x, next.y) then
                next.cost = current.cost + 1
                if itercount < maxiters then frontier:push(next, -1 * (next.cost + 2*to:dist(next))) end
                came_from:set(next.x, next.y, current:copy())
            end
        end
        itercount = itercount + 1
    end

    if current.x == to.x and current.y == to.y then
        if options.draw then canvas:putWithColor(current.x, current.y, ord('*'), rgb(255, 255, 0)) end
    else
        return {}, nil
    end

    local total_cost = current.cost

    local prev = {}
    local path = {}
    while not (current.x == prev.x and current.y == prev.y)  do
        prev = current
        current = came_from:get(current.x, current.y)
        if current == nil then break end
        if options.draw then canvas:putWithColor(current.x, current.y, ord('='), rgb(0,0,255)) end
        table.insert(path, current)
    end

    list.pop(path)
    list.pop(path)
    list.reverse(path)
    local next_step = path[1]
    if options.draw and next_step ~= nil then canvas:putWithColor(next_step.x, next_step.y, ord('^'), rgb(255,255,0)) end
    return path, next_step
end

return pathfinding
