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
        sprite='crash/tg_items/tg_items_saber',
        overlay_sprite='crash/tg_items/tg_items_saber_color',
        glow=true,
        light={name='white', ['*']=0.3},
    },
    traits={'melee'},
    attributes={
        melee_damage=5,
        armor_pierce=2,
    }
}

items['knife'] = {
    desc='A knife',
    visual={
        sprite='crash/tg_items/tg_items_knife',
        overlay_sprite='crash/tg_items/tg_items_knife_color',
        overlay_color='green',
        glow=true,
        light={name='white', ['*']=0.3},
    },
    traits={'melee'},
    attributes={
        melee_damage=3,
        armor_pierce=2
    }
}

items['pipe'] = {
    desc='A knife',
    visual={
        sprite='crash/tg_items/tg_items_pipe',
    },
    traits={'melee'},
    attributes={
        melee_damage=3,
        armor_pierce=0
    }
}


return {
    traits=traits,
    items=items,
}