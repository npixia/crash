local makeItem = game.items.makeItem

game.items.defineTraitAction('ranged', 'fire', {fn_type='MAP', default=true},
    function(item, owner, map, x, y)
        local ammo_id = item.attr.ranged_ammo_type
        if ammo_id then
            local item = makeItem(ammo_id)
            local r = owner:remove(item, 1)
            if r == 1 then
                -- Just use throw event for now
                game.items.fire(makeItem('energy_projectile'), owner:getX(), owner:getY(), x, y)
            else
                print('Out of ammo!')
                return {time=0}
            end
        else
            print('No ammo equipped!')
            return {time=0}
        end
        print('time=100')
        return {time=100}
    end
)


