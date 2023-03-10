local maputils = {}

local rngutils = requirep 'crash:rngutils'

function maputils.fillRect(map, x, y, w, h, tile)
    for i = 0, w-1 do
        for j = 0,h-1 do
            map:set(x+i, y+j, tile)
        end
    end
end

function maputils.fillRectVariants(map, x, y, w, h, tile, variants, variant_chance, rng)
    local function getTile()
        if rng:random() < variant_chance then
            return rngutils.randchoice(rng, variants)
        else
            return tile
        end
    end

    for i = 0, w-1 do
        for j = 0,h-1 do
            map:set(x+i, y+j, getTile())
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

function maputils.rectVariants(map, x, y, w, h, tile, variants, variant_chance, rng)
    local function getTile()
        if rng:random() < variant_chance then
            return rngutils.randchoice(rng, variants)
        else
            return tile
        end
    end

    -- top & bottom
    for i = 0, w-1 do
        map:set(x+i, y, getTile())
        map:set(x+i, y+h-1, getTile())
    end

    -- right and left
    for j = 0,h-1 do
        map:set(x, y+j, getTile())
        map:set(x+w-1, y+j, getTile())
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