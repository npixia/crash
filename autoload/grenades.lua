local Point = game.objects.Vector2d
local maputils = requirep 'crash:maputils'

game.items.defineEvent('grenade', 'onThrownImpact', 
    function(item, map, x, y)
        local origin = Point(x, y)
        game.explode(x, y, 80, 2) -- power, radius
        local ExplosionAnimation = requirep 'crash:animations/explosion'
        game.animation_engine:add(ExplosionAnimation(x, y, 3))
        -- summon some fire
        game.maputils.doToCircle(x, y, 2,
            function (xx, yy)
                if math.random() < 0.3 and maputils.hasLOS(map, origin, Point(xx, yy)) then
                    map:ignite(xx, yy)
                end
            end
        )
        return false -- don't keep
    end
)

game.items.defineEvent('fire_grenade', 'onThrownImpact', 
    function(item, map, x, y)
        local origin = Point(x, y)
        local ExplosionAnimation = requirep 'crash:animations/explosion'
        game.animation_engine:add(ExplosionAnimation(x, y, 4))
        -- summon some fire
        game.maputils.doToCircle(x, y, 4,
            function (xx, yy)
                if math.random() < 0.7 and maputils.hasLOS(map, origin, Point(xx, yy)) then
                    map:ignite(xx, yy)
                end
            end
        )
        return false -- don't keep
    end
)