game.items.defineEvent('glowstick', 'onThrownImpact',
    function(item, map, x, y, pre_x, pre_y)
        map:spawn('glowstick', pre_x, pre_y)
        return false -- don't drop item
    end
)

game.actors.addCallback('glowstick', 'onDeath', function(actor, map) 
    local p = actor:pos()
    if map:getUpper(p.x, p.y) == game.tiles.NIL then
        map:setUpper(p.x, p.y, game.tiles.fromID('glowstick_juice'))
    end
end)