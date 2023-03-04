
--[[ TODO: remove when all items have an option to equip ]]--
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
