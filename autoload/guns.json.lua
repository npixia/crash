local traits = {}

-- Override built-in ranged trait
traits['ranged']={
    required={
        'ranged_ammo_type',
        'ranged_base_damage'
    },
    stats={
        {
            name='Ranged Base Damage',
            icon='crash/tg_interface/tg_interface_option_attack',
            key='ranged_base_damage',
            show_icon_in_item_name=true,
            show_value_in_item_name=true,
        },
        {
            name='Ranged Ammo Type',
            icon='crash/tg_interface/tg_interface_option_bag',
            key='ranged_ammo_type',
            show_icon_in_item_name=false,
            show_value_in_item_name=false,
        },
    }
}

-- Override built-in ammo trait
traits['ammo'] = {
    defaults={
        ammo_base_damage=1,
    },
    stats={
        {
            name= 'Ammo Base Damage',
            icon='crash/tg_interface/tg_interface_option_bag',
            key= 'ammo_base_damage',
            show_icon_in_item_name=true,
            show_value_in_item_name=true,
        },
    }
}

local items = {}

items['energy_pistol'] = {
    desc='An energy pistol',
    visual={
        sprite='crash/tg_items/tg_items_gun_pistol',
    },
    traits={'ranged'},
    attributes={
        ranged_base_damage=1,
        ranged_ammo_type='pistol_ammo',
    }
}

items['pistol_ammo'] = {
    desc='An energy cell used for weapon ammunition',
    visual={
        sprite='crash/tg_items/tg_items_ammo'
    },
    traits={'ammo'},
}

items['energy_projectile'] = {
    desc='dev',
    visual={
        sprite='crash/tg_fx/tg_fx_iceball'
    }
}

return {traits=traits, items=items}