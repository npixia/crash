local loot = {}

local LOOT_DATA = {
    {id='oxygen_pack', count={1,1}, floors={1,10}, weight=1},
    {id='grenade',     count={1,3}, floors={1,10}, weight=1},
    {id='saber',       count={1,1}, floors={1,10}, weight=1},
}


local function filterItems(items, floor)
    return items
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

local function randomize(item, rng)
    local onGenerateRandom = game.items.getEventFn(item, 'onGenerateRandom')
    if onGenerateRandom then
        onGenerateRandom(item, rng)
    end
end

function loot.fillChest(rng, chest, floor)
    local item_table = filterItems(LOOT_DATA, floor)
    local added_items = {}

    for _ = 1,5 do
        local item_data = getLootItem(rng, item_table)
        -- Prevent duplicate items
        if not list.contains(added_items, item_data.id) then
            local item = game.items.makeItem(item_data.id)
            randomize(item, rng)
            chest:give(item, rng:random(item_data.count[1], item_data.count[2]))
            table.insert(added_items, item_data.id)
        end
    end
end


return loot