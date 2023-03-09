local maputils = {}

function maputils.fillRect(map, x, y, w, h, tile)
    for i = 0, w-1 do
        for j = 0,h-1 do
            map:set(x+i, y+j, tile)
        end
    end
end


function maputils.rect(map, x, y, w, h, tile)
    -- top & bottom
    for i = 0, w-1 do
        map:set(x+i, y, tile)
        map:set(x+i, y+h-1, tile)
    end

    -- right and left
    for j = 0,h-1 do
        map:set(x, y+j, tile)
        map:set(x+w-1, y+j, tile)
    end

end

function maputils.hasLOS(map, from, to)
    local points = game.util.traceLine(from.x, from.y, to.x, to.y)
    for i,p in ipairs(points) do
        if map:getUpper(p[1], p[2]).is_solid then
            return false 
        end
    end
    return true
end

return maputils