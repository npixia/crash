local loot = {}

local makeItem = game.items.makeItem
local rngutils = requirep 'crash:rngutils'

loot.LOOT_DATA = {
    {id='glowstick',       count={2,4},  d={1,3}, weight=30},
    {id='oxygen_pack',     count={1,1},  d={1,3}, weight=5},
    {id='fire_grenade',    count={1,3},  d={1,3}, weight=5},
    {id='energy_ammo',     count={7,12}, d={1,3}, weight=5},
    {id='grenade',         count={1,2},  d={2,3}, weight=3},
    {id='medkit',          count={1,1},  d={1,3}, weight=3},
}

-- Weapons
loot.WEAPONS = {
    -- Melee
    {id='pipe',  count={1,1}, d={1,3}, weight=1},
    {id='knife', count={1,1}, d={1,3}, weight=1},
    {id='saber', count={1,1}, d={3,3}, weight=1},

    {id='energy_handgun', count={1,1}, d={1,3}, weight=1},
    {id='energy_rifle',   count={1,1}, d={3,3}, weight=1},
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

function loot.randomize(item, rng)
    local onGenerateRandom = game.items.getEventFn(item, 'onGenerateRandom')
    if onGenerateRandom then
        onGenerateRandom(item, rng)
    end
end

function loot.selectOne(pool, rng, difficulty)
    local filtered_pool = filterDifficulty(pool, difficulty)
    local selected = rngutils.randchoice(rng, filtered_pool)
    local item = makeItem(selected.id)
    loot.randomize(item, rng)
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

    for _ = 1,rng:random(1,2) do
        local item_data = getLootItem(rng, filtered_pool)
        -- Prevent duplicate items
        if not list.contains(added_items, item_data.id) then
            local item = makeItem(item_data.id)
            loot.randomize(item, rng)
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
        chest:give(makeItem('energy_ammo'), rng:random(3,10))
    end
end


return loot