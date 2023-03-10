local makeItem = game.items.makeItem
local Point = game.objects.Vector2d
local tg = game.textgen
local choice = tg.choice
local strutils = requirep 'crash:strutils'

game.items.defineTraitAction('ranged', 'fire', {fn_type='MAP', default=true},
    function(item, owner, map, x, y)
        local ammo_id = item.attr.ranged_ammo_type
        if ammo_id then
            local ammo = makeItem(ammo_id)
            local r = owner:remove(ammo, 1)
            if r == 1 then
                -- Just use throw event for now
                local projectile = makeItem('energy_projectile')
                projectile.attr.ammo_base_damage = item.attr.ranged_base_damage

                -- If we are a few tiles away, roll for accuracy
                if Point(x, y):dist(owner:pos()) > item.attr.range then
                    print('far, testing for accuracy..')
                    if math.random() > item.attr.accuracy then
                        -- miss
                        print('miss')
                        x = x + math.random(-1, 1)
                        y = y + math.random(-1, 1)
                    else
                        print('perfect shot')
                    end
                else
                    print('close, not rolling for accuracy')
                end

                game.items.fire(projectile, owner:getX(), owner:getY(), x, y)
            else
                print('Out of ammo!')
                return {time=0}
            end
        else
            print('No ammo equipped!')
            return {time=0}
        end
        return {time=100}
    end
)


game.items.defineEvent('energy_handgun', 'onGenerateRandom', function(item, rng)
    local name = tg.generate(choice('laser', 'plasma', 'energy') .. ' ' .. choice('handgun', 'pistol', 'micro rifle'))
    item.attr.name = name:title()
    item.attr.desc = "If the target is further than the weapon's range, the weapon's accuracy is used to compute likelyhood of a perfect hit. Click to shoot."
    item.attr.ranged_base_damage = 1 + (rng:random(1,10)/10)
    item.attr.accuracy = rng:random(3,7)/10
    item.attr.range = rng:random(2, 4)
end)

game.items.defineEvent('energy_rifle', 'onGenerateRandom', function(item, rng)
    local name = tg.generate(choice('laser', 'plasma', 'energy') .. ' ' .. choice('rifle', 'long gun'))
    item.attr.name = name:title()
    item.attr.desc = "If the target is further than the weapon's range, the weapon's accuracy is used to compute likelyhood of a perfect hit. Click to shoot."
    item.attr.ranged_base_damage = 2 + (rng:random(1,10)/10)
    item.attr.accuracy = rng:random(5,9)/10
    item.attr.range = rng:random(7,13)
end)