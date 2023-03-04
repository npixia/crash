local actors = {}

local function monsterSprite(type)
    return 'crash/tg_monsters/tg_monsters_' .. type
end
--tg_monsters_alien_soldier_u1
actors['alien'] = {
    name='alien',
    visual={
        sprite=monsterSprite('alien_soldier_u1')
    },
    destructible={
        type='monster',
        max_hp=6,
        defense=0,
        xp=2,
    },
    ai={
        type='monster',
        energy_per_turn=150,
    }
}

return {actors=actors}