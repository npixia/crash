local saturation = 0.1
game.items.defineAction('oxygen_pack', 'use', {},
    function(item, owner)
        game.effect.hunger(item, owner, 1, item.attr.oxygen_amount, saturation)
        print('You add [color=#6688FF] ' .. math.floor(item.attr.oxygen_amount) .. ' oxygen[/color] to your tank')
        return {remove_item=true, time=100}
    end
)

game.items.defineEvent('oxygen_pack', 'onGenerateRandom', function(item, rng)
    item.attr.oxygen_amount=rng:random(20,42)
end)

