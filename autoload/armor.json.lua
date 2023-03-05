local traits = {}
local items = {}

traits['wearable'] = {
    required={
        'wearable'
    },
    defaults={
        equipped_sprite=0,
        equipped_color='#ffffff',
        defense=1,
    },
    stats={
        {
            name='Defense',
            icon='crash/tg_interface/tg_interface_option_defend',
            key='defense',
            show_icon_in_item_name=true,
            show_value_in_item_name=true,
        },
        {
            name='Equipment Slot',
            icon='crash/tg_interface/tg_interface_option_equip',
            key='armor_slot',
            show_icon_in_item_name=false,
            show_value_in_item_name=false,
        }
    }
}

traits['light'] = {
    required={
        'brightness'
    },
    stats={
        {
            name='Light',
            icon='crash/tg_interface/tg_interface_option_alert',
            key='brightness',
            show_icon_in_item_name=true,
            show_value_in_item_name=true,
        },
    }
}



local function armorSprite(type, color)
    return 'crash/tg_items/tg_items_armor_' .. type .. '_' .. color
end


local function makeArmorSet(items, id_base, name, defense, color)
    items[id_base .. '_helmet'] ={
        name= name .. ' Helmet',
        desc= 'A ' .. name .. ' space suit helmet. It has a headlamp attached which provides some light',
        visual={
            sprite=armorSprite('helm', color),
            color='white'
        },
        traits={ 'wearable', 'light' },
        attributes={
            wearable='head',
            paperdoll={
                sprite='paperdoll/helmet1',
                light={name='white', ['*']=0.8}
            },
            defense=defense,
            brightness=1,
        }
    }

    items[id_base .. '_jacket'] ={
        name= name .. ' Jacket',
        desc= 'A ' .. name .. ' space suit jacket',
        visual={
            sprite=armorSprite('chest', color),
            color='white'
        },
        traits={ 'wearable' },
        attributes={
            wearable='chest',
            paperdoll={
                sprite='paperdoll/shirt'
            },
            defense=defense
        }
    }

    items[id_base .. '_pants'] ={
        name= name .. ' Pants',
        desc= name .. ' space suit pants',
        visual={
            sprite=armorSprite('pants', color),
            color= 'white'
        },
        traits={ 'wearable' },
        attributes={
            wearable='legs',
            paperdoll={
                sprite='paperdoll/pants'
            },
            defense=defense

        }
    }

    items[id_base .. '_boots'] ={
        name= name .. ' Boots',
        desc= 'A pair of ' .. name .. ' space suit boots',
        visual={
            sprite= armorSprite('boots', color),
            color= 'white'
        },
        traits={ 'wearable' },
        attributes={
            wearable='feet',
            paperdoll={
                sprite='paperdoll/boots'
            },
            defense=defense
        }
    }
end

makeArmorSet(items, 'space_suit', 'Basic', 1, 'grey')
makeArmorSet(items, 'enhanced', 'Enhanced', 2, 'red')
makeArmorSet(items, 'armored', 'Armored', 3, 'blue')

return {
    traits=traits,
    items=items,
}