local loot = {}

local rngutils = requirep 'crash:rngutils'

local LOOT_DATA = {
    {id='oxygen_pack',     count={1,1}, d={1,3}, weight=1},
    {id='grenade',         count={1,3}, d={1,3}, weight=1},
    {id='saber',           count={1,1}, d={1,3}, weight=1},
}

-- Armors
local ARMORS = {}
for weight_id, req_difficulty in pairs({light=1,medium=2,heavy=3}) do
    for _,type_id in ipairs({'jacket','pants','helmet','boots'}) do
        table.insert(ARMORS, {
            id = weight_id .. '_' .. type_id,
            d = req_difficulty
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

local function randomize(item, rng)
    local onGenerateRandom = game.items.getEventFn(item, 'onGenerateRandom')
    if onGenerateRandom then
        onGenerateRandom(item, rng)
    end
end

function loot.giveRandomArmor(rng, actor, difficulty)
    local armors = list.filter(ARMORS, function(a) return a.d <= difficulty end)
    local item = game.items.makeItem(rngutils.randchoice(rng, armors).id)
    randomize(item, rng)
    actor:give(item)
end

function loot.fillChest(rng, chest, difficulty)
    local item_table = list.filter(LOOT_DATA, function (item)
        return item.d[1] <= difficulty and item.d[2] >= difficulty
    end)

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

    if rng:random() < 0.4 then
        loot.giveRandomArmor(rng, chest, difficulty)
    end
end


return loot