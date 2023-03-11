local actors = {}

local function monsterSprite(type)
    return 'crash/tg_monsters/tg_monsters_' .. type
end
--tg_monsters_alien_soldier_u1
actors['alien'] = {
    name='alien',
    visual={ sprite=monsterSprite('alien_soldier_u1') },
    destructible={
        type='monster',
        max_hp=6,
        defense=0,
        xp=1,
    },
    ai={ type='monster', energy_per_turn=150, }
}

actors['soldier'] = {
    name='alien soldier',
    visual={ sprite=monsterSprite('alien_soldier_l1') },
    destructible={
        type='monster',
        max_hp=6,
        defense=0,
        xp=1,
    },
    ai={
        type='monster',
        energy_per_turn=150,
        attack_name='strike',
    }
}

actors['alien_saber'] = {
    name='alien soldier',
    visual={ sprite=monsterSprite('alien_psion_l1') },
    destructible={
        type='monster',
        max_hp=6,
        defense=0,
        xp=1,
    },
    ai={
        type='monster',
        energy_per_turn=150,
        attack_name='saber'
    }
}

actors['crawler'] = {
    name='crawler',
    visual={ sprite=monsterSprite('crawler_u1') },
    destructible={
        type='monster',
        max_hp=3,
        defense=0,
        xp=1,
    },
    ai={
        type='monster',
        energy_per_turn=120,
        attack_amount=2,
    }
}

actors['big_crawler'] = {
    name='crawler',
    visual={ sprite=monsterSprite('crawler_queen_u1') },
    destructible={
        type='monster',
        max_hp=10,
        defense=1,
        xp=1
    },
    ai={
        type='monster',
        energy_per_turn=300,
        attack_amount=6,
    }
}

actors['leader'] = {
    name='leader',
    visual={ sprite=monsterSprite('jelly_d1') },
    destructible={
        type='monster',
        max_hp=6,
        defense=1,
        xp=1,
    },
    ai={
        type='monster',
        energy_per_turn=120,
        attack_name='slash',
    }
}



return {actors=actors}