local Point = game.objects.Vector2d
local maputils = requirep 'crash:maputils'

game.actors.addCallback('explosive_barrel', 'onDeath', function(actor, map)
    local origin = actor:pos()
    game.explode(origin.x, origin.y, 80, 3) -- power, radius
    local ExplosionAnimation = requirep 'crash:animations/explosion'
    game.animation_engine:add(ExplosionAnimation(origin.x, origin.y, 3))
    -- summon some fire
    game.maputils.doToCircle(origin.x, origin.y, 2,
        function (xx, yy)
            if math.random() < 0.3 and maputils.hasLOS(map, origin, Point(xx, yy)) then
                map:ignite(xx, yy)
            end
        end
    )
    return false -- don't keep
end)


