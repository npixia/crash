local Point = game.objects.Vector2d
local pathfinding = requirep 'crash:pathfinding'

game.actors.addCallback('alien', 'onSpawn', function(actor, map)
    local current_pos = actor:pos()
    actor:attr().last_pos = {x=current_pos.x, y=current_pos.y}
    actor:attr().last_move_time = game.time.clock()
end)

game.actors.addCallback('alien', 'update', function(actor, map)
    local player_pos = player():pos()
    local current_pos = actor:pos()
    local last_pos = actor:attr().last_pos
    last_pos = Point(last_pos.x, last_pos.y)

    -- Have we moved this update?
    if current_pos.x ~= last_pos.x or current_pos.y ~= last_pos.y then
        -- We have moved
        actor:attr().last_pos = {x=current_pos.x, y=current_pos.y}
        actor:attr().last_move_time = game.time.clock()
    end

    if player_pos:dist(current_pos) < 10 then
        if game.time.clock() - actor:attr().last_move_time > 200 then
            print("Can't get to player, running pathfinding")
            local _, next_pos = pathfinding.pathfind(current_pos, player_pos, {draw=true, maxiters=20})
            if next_pos then
                actor:setXY(next_pos.x, next_pos.y)
            end
        end
    end

end)