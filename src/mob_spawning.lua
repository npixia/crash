local mob_spawning = {}

local rngutils = requirep 'crash:rngutils'

local function spawn(map, rooms, offset, rng, id, attempts)
    local count = 0
    for _ = 1,attempts do
        local room = rngutils.randchoice(rng, rooms)
        local p = offset + room:interior():interior():rngPointInterior(rng)
        if map:getUpper(p.x, p.y) == game.tiles.NIL then
            map:spawn(id, p.x, p.y)
            count = count + 1
        end
    end
    return count
end

function mob_spawning.spawnFloor(map, rooms, offset, difficulty, rng)
    local count = 0
    local function spawn_(id, attempts)
        count = count + spawn(map, rooms, offset, rng, id, attempts)
    end

    if difficulty == 1 then
        spawn_('crawler',     rng:random(7, 10))
        spawn_('big_crawler', rng:random(1, 3))
    else
        -- Difficulty > 1
        spawn_('crawler', rng:random(1, 3))
        spawn_('big_crawler', rng:random(1, 3))
        spawn_('alien_saber', rng:random(3, 5))
        spawn_('soldier', rng:random(3, 5))
    end

    if difficulty == 3 then
        spawn_('leader', rng:random(1,2))
    end

    print('Spawned ' .. count .. ' creatures')
end

return mob_spawning