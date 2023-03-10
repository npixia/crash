local Point = game.objects.Vector2d

game.items.defineAction('debug_stick', 'use', {fn_type='MAP', default=true},
    function(item, owner, map, x, y)
        local pathfinding = requirep 'crash:pathfinding'
        local ox, oy = owner:getXY()
        local path, next_step = pathfinding.pathfind(Point(x, y), Point(ox, oy), {draw=true, maxiters=100})
        print('Path length= ' .. to_str(#path))
    end
)