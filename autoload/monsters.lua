local Point = game.objects.Vector2d
local pathfinding = requirep 'crash:pathfinding'
local maputils = requirep 'crash:maputils'
local clock = game.time.clock

local function init(actor)
    local current_pos = actor:pos()
    actor:attr().last_pos = {x=current_pos.x, y=current_pos.y}
    actor:attr().last_move_time = clock()
    actor:attr().last_fire_time = clock()
end

local function moveTowardPlayer(actor, map)
    local player_pos = player():pos()
    local current_pos = actor:pos()
    local last_pos = actor:attr().last_pos
    last_pos = Point(last_pos.x, last_pos.y)

    -- Have we moved this update?
    if current_pos.x ~= last_pos.x or current_pos.y ~= last_pos.y then
        -- We have moved
        actor:attr().last_pos = {x=current_pos.x, y=current_pos.y}
        actor:attr().last_move_time = clock()
    end

    if player_pos:dist(current_pos) < 10 then
        if clock() - actor:attr().last_move_time > 200 then
            --print("Can't get to player, running pathfinding")
            local _, next_pos = pathfinding.pathfind(current_pos, player_pos, {draw=true, maxiters=20})
            if next_pos then
                actor:setXY(next_pos.x, next_pos.y)
            end
        end
    end
end

local function rangedAttack(actor, rate, projectile)
    local player_pos = player():pos()
    if clock() - actor:attr().last_fire_time > rate then
        if maputils.hasLOS(game.world.map(), actor:pos(), player_pos) then
            game.items.fire(projectile, actor:getX(), actor:getY(), player_pos.x, player_pos.y)
            actor:attr().last_fire_time = clock()
        end
    end
end

local function putBlood(map, p) -- p: Point
    if map:getUpper(p.x, p.y) == game.tiles.NIL then
        map:setUpper(p.x, p.y, game.tiles.fromID('world_blood_alien_' .. list.randchoice({'a','b','c','d'})))
    end
end
local function death(actor, map)
    local p = actor:pos()
    putBlood(map, p)
    putBlood(map, p + Point(math.random(-1,1), math.random(-1,1)))
end

local alien_ids = {
    'alien',
    'soldier',
    'alien_saber',
    'crawler',
    'big_crawler',
    'leader'
}
for _, actor_id in ipairs(alien_ids) do
    game.actors.addCallback(actor_id, 'onSpawn', function(actor, map) init(actor) end)
    game.actors.addCallback(actor_id, 'onDeath', function(actor, map) death(actor, map) end)
end

-- Standard hostiles

game.actors.addCallback('alien',       'update', function(actor, map) moveTowardPlayer(actor, map) end)
game.actors.addCallback('crawler',     'update', function(actor, map) moveTowardPlayer(actor, map) end)
game.actors.addCallback('alien_saber', 'update', function(actor, map) moveTowardPlayer(actor, map) end)
game.actors.addCallback('big_crawler', 'update', function(actor, map) moveTowardPlayer(actor, map) end)

-- Ranged Hostiles

game.actors.addCallback('soldier', 'update', function(actor, map)
    moveTowardPlayer(actor, map)
    rangedAttack(actor, 500, game.items.makeItem('monster_projectile'))
end)

game.actors.addCallback('leader', 'update', function(actor, map)
    moveTowardPlayer(actor, map)
    rangedAttack(actor, 500, game.items.makeItem('big_monster_projectile'))
end)
