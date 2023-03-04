local traits = {
    -- Override built-in melee trait
    melee={
        required={
            'melee_damage',
        },
        defaults={
            melee_range=2,
            armor_pierce=0
        },
        stats={
            {
                name='Damage',
                icon='crash/tg_interface/tg_interface_option_attack',
                key='melee_damage',
                show_icon_in_item_name=true,
                show_value_in_item_name=true
            },
            {
                name='Armor Pierce',
                icon='crash/tg_interface/tg_interface_option_cancel',
                key='armor_pierce',
                show_icon_in_item_name=true,
                show_value_in_item_name=true
            }
        }
    }
}

local items = {}

items['saber'] = {
    desc='A sword-like saber',
    visual={
        sprite='crash/tg_items/tg_items_saber_blue'
    },
    traits={'melee'},
    attributes={
        melee_damage=2,
    }
}



return {
    traits=traits,
    items=items,
}