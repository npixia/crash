local loot = {}

local rngutils = requirep 'crash:rngutils'

loot.LOOT_DATA = {
    {id='oxygen_pack',     count={1,1}, d={1,3}, weight=1},
    {id='grenade',         count={1,3}, d={1,3}, weight=1},
}

-- Weapons
loot.WEAPONS = {
    {id='pipe',  count={1,1}, d={1,3}, weight=1},
    {id='knife', count={1,1}, d={1,3}, weight=1},
    {id='saber', count={1,1}, d={3,3}, weight=1},
}

-- Armors
loot.ARMORS = {}
for weight_id, req_difficulty in pairs({light=1,medium=2,heavy=3}) do
    for _,type_id in ipairs({'jacket','pants','helmet','boots'}) do
        table.insert(loot.ARMORS, {
            id = weight_id .. '_' .. type_id,
            d = {req_difficulty, req_difficulty},
        })
    end
end



local function getLootItem(rng, items)
    local weighted_sum_data = {}
    local total_weight = 0
    for i,data in ipairs(items) do
        total_weight = total_weight + data.weight
        table.insert(weighted_sum_data, total_weight)
    end

    local r = rng:random() * total_weight
    for i, weight in ipairs(weighted_sum_data) do
        if r < weight then
            return items[i]
        end
    end
    return items[#items]
end

local function filterDifficulty(pool, difficulty)
    return list.filter(pool, function (item)
        return item.d[1] <= difficulty and item.d[2] >= difficulty
    end)
end

local function randomize(item, rng)
    local onGenerateRandom = game.items.getEventFn(item, 'onGenerateRandom')
    if onGenerateRandom then
        onGenerateRandom(item, rng)
    end
end

function loot.selectOne(pool, rng, difficulty)
    local filtered_pool = filterDifficulty(pool, difficulty)
    local selected = rngutils.randchoice(rng, filtered_pool)
    local item = game.items.makeItem(selected.id)
    randomize(item, rng)
    return selected, item
end

function loot.giveOne(pool, rng, actor, difficulty)
    local filtered_pool = filterDifficulty(pool, difficulty)
    local _, item = loot.selectOne(filtered_pool, rng, difficulty)
    actor:give(item)
end

function loot.fillChest(rng, chest, difficulty)
    local filtered_pool = filterDifficulty(loot.LOOT_DATA, difficulty)

    local added_items = {}

    for _ = 1,5 do
        local item_data = getLootItem(rng, filtered_pool)
        -- Prevent duplicate items
        if not list.contains(added_items, item_data.id) then
            local item = game.items.makeItem(item_data.id)
            randomize(item, rng)
            chest:give(item, rng:random(item_data.count[1], item_data.count[2]))
            table.insert(added_items, item_data.id)
        end
    end

    -- Weapons and armor
    if rng:random() < 0.4 then
        local _, item = loot.selectOne(loot.ARMORS, rng, difficulty)
        chest:give(item)
    end

    if rng:random() < 0.4 then
        local _, item = loot.selectOne(loot.WEAPONS, rng, difficulty)
        chest:give(item)
    end
end


return loot