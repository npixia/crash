local tg = game.textgen
local choice = tg.choice
local strutils = requirep 'crash:strutils'

game.items.defineTraitAction('wearable', 'equip', {},
    function(item, owner)
        local slot = item.attr.wearable
        local space_avail = owner:spaceAvailableInSlot(slot)
        if space_avail == 0 then
            print('Slot ' .. slot .. ' full. Automatically removing item')
            owner:unequipSlotOne(slot)
        end

        if not owner:equip(item) then
            print('Unable to equip item ' .. item.name)
        else
            -- remove this print
            print('debug: item equipped! ' .. item.name)
        end
    end
)

local default_slots = {
    "head",
    "chest",
    "legs",
    "feet"
}

game.items.validateTrait('wearable',
    function(attributes)
        assert(type(attributes.defense) == 'number')
        assert(type(attributes.wearable) == 'string')
        if not list.contains(default_slots, attributes.wearable) then
            print_color('orange', 'Warning: Slot ' .. attributes.wearable .. ' is not in the default list')
        end
        if attributes.paperdoll ~= nil and attributes.paperdoll.sprite ~= nil then
            if game.sprites.get(attributes.paperdoll.sprite) == 0 then
                --error("Unknown sprite " .. attributes.paperdoll.sprite)
            end
        end
    end
)

--
-- Armor Randomization
--

local weight_info = {
    light = {defense={1,1}, name=choice('light', 'thin'), desc='It offers a small amount of protection.'},
    med   = {defense={2,2}, name=choice('medium', 'padded'), desc='It offers a moderate amount of protection.'},
    heavy = {defense={3,3}, name=choice('heavy', 'thick'), desc='It is very protective.'},
}

local material = choice('mesh','kevlar','plastisteel','carbon fiber','fabric','steel','titanium')

local type_names = {
    jacket = choice('jacket', 'vest', 'chest peice'),
    pants = choice('pants','leggings'),
    helmet = choice('helmet'),
    boots = choice('boots'),
}

for weight_id, weight_data in pairs(weight_info) do
    for type_id, type_name_gen in pairs(type_names) do
        game.items.defineEvent(weight_id .. '_' .. type_id, 'onGenerateRandom', function(item, rng)
            local name = tg.generate(choice(weight_data.name .. ' ' .. material .. ' ' .. type_name_gen))
            item.attr.name = strutils.title(name)
            item.attr.desc = 'A ' .. name .. '. ' .. weight_data.desc
            if type_id == 'helmet' then
                item.attr.desc = item.attr.desc .. ' It has a headlamp attached which provides some light.'
            end
            item.attr.defense = rng:random(weight_data.defense[1], weight_data.defense[2])
        end)
    end
end
