local traits = {}

-- Override built-in ranged trait
traits['ranged']={
    defaults={
        accuracy=1.0,
        range=3,
    },
    required={
        'ranged_ammo_type',
        'ranged_base_damage',
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
            name='Accuracy',
            icon='crash/tg_interface/tg_interface_option_attack',
            key='accuracy',
            show_icon_in_item_name=false,
            show_value_in_item_name=false,
        },
        {
            name='Range',
            icon='crash/tg_interface/tg_interface_option_attack',
            key='range',
            show_icon_in_item_name=false,
            show_value_in_item_name=false,
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

items['energy_handgun'] = {
    desc='An energy handgun',
    visual={
        sprite='crash/tg_items/tg_items_gun_pistol',
    },
    traits={'ranged'},
    attributes={
        ranged_base_damage=1,
        ranged_ammo_type='energy_ammo',
        accuracy=0.5,
        range=3,
    }
}

items['energy_rifle'] = {
    desc='An energy rigle',
    visual={
        sprite='crash/tg_items/tg_items_gun_rifle',
    },
    traits={'ranged'},
    attributes={
        ranged_base_damage=2,
        ranged_ammo_type='energy_ammo',
        accuracy=0.8,
        range=10,
    }
}

items['energy_ammo'] = {
    desc='An energy cell used for weapon ammunition',
    visual={
        sprite='crash/tg_items/tg_items_ammo'
    },
    traits={'ammo'},
}

items['energy_projectile'] = {
    desc='dev',
    visual={
        sprite='crash/tg_fx/tg_fx_iceball',
        glow=true,
        light={
            format='float',
            r=0.7,
            g=0.7,
            b=0.9,
        }
    },
}

items['monster_projectile'] = {
    desc='dev',
    visual={
        sprite='crash/tg_fx/tg_fx_voidball',
        glow=true,
        light={
            format='float',
            r=0.8,
            g=0.6,
            b=0.8,
        }
    },
    attributes={
        ammo_base_damage=2,
    }
}

items['big_monster_projectile'] = {
    desc='dev',
    visual={
        sprite='crash/tg_fx/tg_fx_voidimpact_1',
        glow=true,
        light={
            format='float',
            r=0.8,
            g=0.6,
            b=0.8,
        }
    },
    attributes={
        ammo_base_damage=4,
    }
}



return {traits=traits, items=items}