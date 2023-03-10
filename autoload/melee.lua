local tg = game.textgen
local choice = tg.choice
local strutils = requirep 'crash:strutils'

game.items.defineEvent('pipe', 'onGenerateRandom', function(item, rng)
    local name, damage
    if rng:random() < 0.5 then
        name = tg.generate(choice('small', 'thin') .. ' ' .. choice('plastic', 'carbon fiber') .. ' pipe')
        damage = 2
    else
        name = tg.generate(choice('large', 'heavy', 'thick') .. ' ' .. choice('metal', 'steel') .. ' pipe')
        damage = rng:random(3,4)
    end

    item.attr.name = strutils.title(name)
    item.attr.desc = 'A ' .. name
    item.attr.melee_damage = damage
end)

game.items.defineEvent('knife', 'onGenerateRandom', function(item, rng)
    local name = tg.generate(choice('laser', 'plasma') .. ' ' .. choice('knife', 'shiv'))
    item.attr.name = strutils.title(name)
    item.attr.desc = 'A ' .. name
    item.attr.melee_damage = rng:random(2, 3)
    item.attr.armor_pierce = rng:random(1, 2)
    item.attr._color_overlay = Color.fromHSV(rng:random(0,359), 100, 70):rgba()
end)

game.items.defineEvent('saber', 'onGenerateRandom', function(item, rng)
    local name = tg.generate(choice('laser', 'plasma') .. ' ' .. choice('sword', 'saber'))
    item.attr.name = strutils.title(name)
    item.attr.desc = 'A ' .. name
    item.attr.melee_damage = rng:random(4, 5)
    item.attr.armor_pierce = rng:random(1, 2)
    item.attr._color_overlay = Color.fromHSV(rng:random(0,359), 100, 70):rgba()
end)