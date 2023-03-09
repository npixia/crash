local heal_turns = 15
local heal_amount = 0.5

game.items.defineAction('medkit', 'use', {},
    function(item, owner)
        local A = item.attr
        game.effect.heal(item, owner, heal_turns, heal_amount)
        return {remove_item=true, time=100}
    end
)