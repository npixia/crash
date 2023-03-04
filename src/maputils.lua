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

return maputils