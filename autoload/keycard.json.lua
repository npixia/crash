local items = {}

for i= 1,5 do
    items['keycard_' .. i] = {
        name='Keycard',
        desc='A manual override key card. It opens the stairs to the next floor of the ship',
        visual={
            sprite='crash/tg_items/tg_items_pass_green'
        },
        stats={
            {
                name='Floor',
                has_value=true,
                key='floor_name',
                show_value_in_item_name=true
            }
        },
        attributes={
            floor=i,
            floor_name='[[Floor ' .. i .. ']]',
        }
    }
end

return {items=items}