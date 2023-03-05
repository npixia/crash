local SpaceShip = WorldGenerator:extend()
SpaceShip.name = 'SpaceShip'
game.worldgen.register(SpaceShip, 'crash', 'src/spaceship_world_generator.lua')

local Point = game.objects.Vector2d
local maputils = requirep 'crash:maputils'

local T = game.tiles.fromID
local floor_tile_id = 'world_floor_quad_checker_a'
local wall_tile_id = 'world_wall_derelict_v_a'
local highlight_tile_id = 'world_wall_alien_v_a'
local wall_interior_tile_id = 'world_wall_lab_v_a'

local Room = requirep 'towngen:room/Room'
function Room:interior()
    return Room(self.x1+1, self.y1+1, self.width-2, self.height-2)
end

local rpu  = requirep 'towngen:room/room_placement_utils'

local ShipRoom = Room:extend()
function ShipRoom:place(map, offset)
    local wall = self.wall or T(wall_tile_id)
    local floor = self.floor or T(floor_tile_id)
    rpu.fillRect(map, self.x1+offset.x, self.y1+offset.y, self.width, self.height, floor) 
    rpu.rect(map, self.x1+offset.x, self.y1+offset.y, self.width, self.height, wall)
    map:set(self.x1+offset.x, self.y1+offset.y, T(highlight_tile_id))
end
function ShipRoom:interior()
    return ShipRoom(self.x1+1, self.y1+1, self.width-2, self.height-2)
end
function Room:rngPointAlongWall(rng)
    local x, y
    if rng:random() < 0.5 then
        -- Along horizontal walls
        x = rng:random(1, self.width-2)
        y = rng:random() < 0.5 and 1 or self.height - 2
    else
        -- Along vertical walls
        y = rng:random(1, self.height-2)
        x = rng:random() < 0.5 and 1 or self.width - 2
    end

    return Point(self.x1 + x, self.y1 + y)
end



function SpaceShip:generateMap(universe_seed, map, width, height, x, y, z, spawn_x, spawn_y, submap_name, params)

    local rng = game.random.generator(math.random(1,10000))

    local cx, cy = width/2, height/2
    local offset = Point(cx, cy)

    local center_room_width = rng:random(10, 16)
    local half_ch = rng:random(3, 6)
    local center_room_height = half_ch * 2 + 1
    local center_room = ShipRoom(
        -center_room_width/2,
        -half_ch,
        center_room_width,
        center_room_height)
    center_room.floor = T(floor_tile_id)
    center_room.wall = T(wall_tile_id)


    -- Place a room directly above and below
    local S = Point(rng:random(7,14), rng:random(5,14))
    local room_2_a = ShipRoom(0, half_ch-1, S.x, S.y)
    local room_2_b = ShipRoom(0, -(half_ch+S.y-2), S.x, S.y)


    local rooms = {room_2_a, room_2_b, center_room}
    local doors = {}

    local num_room_levels = rng:random(7,10)
    local levels_placed = 0
    for _=0,100 do
        local placed_room = false
        if rng:random() < 0.5 then
            placed_room = self.addSplitRoom(rng, half_ch, rooms, doors)
        else
            placed_room = self.addCenterRoom(rng, rooms, doors)
        end

        if placed_room then
            levels_placed = levels_placed + 1
            if levels_placed >= num_room_levels then
                break
            end
        end
    end

    for _, room in ipairs(rooms) do
        room:place(map, offset)
    end
    for _, room in ipairs(rooms) do
        local r = room:interior()
        r.wall = T(wall_interior_tile_id)
        r:place(map, offset)
    end
    --print('Got ' .. #doors .. ' doors')
    local t_door = T'world_door_hatch_h_closed'
    for _, door in ipairs(doors) do
        local d = door + offset
        if rng:random() < 0.5 then
            d.x = d.x-1
        end
        map:set(d.x, d.y, t_door)
        map:setUpper(d.x-1, d.y, game.tiles.NIL)
        map:setUpper(d.x+1, d.y, game.tiles.NIL)
    end

    -- Add doors for center room
    local cdoor_x = offset.x+center_room.x2-3
    map:set(cdoor_x, offset.y+center_room.y1+1, t_door)
    map:setUpper(cdoor_x, offset.y+center_room.y1, game.tiles.NIL)
    map:set(cdoor_x, offset.y+center_room.y2-2, t_door)
    map:setUpper(cdoor_x, offset.y+center_room.y2-1, game.tiles.NIL)

    -- Add terminal to rooms
    local terminal  = T'world_terminal_b'
    for _, room in ipairs(rooms) do
        local p = room:interior():rngPointAlongWall(rng)
        map:setUpper(offset.x+p.x, offset.y+p.y, terminal)
    end
end

-- return true if a room was placed
function SpaceShip.addCenterRoom(rng, rooms, doors)
    local half_h = rng:random(3, 20)
    local S = Point(rng:random(6, 8), half_h * 2 + 1)
    local room_y = -half_h
    local room_x, door = SpaceShip.findBackOfShipIntersection(rooms, room_y, S.x, S.y, rng)
    if room_x and door then
        local room = ShipRoom(room_x, room_y, S.x, S.y)
        table.insert(rooms, room)
        table.insert(doors, door)
        return true
    else
        return false
    end
    
end

-- return true if a room was placed
function SpaceShip.addSplitRoom(rng, half_ch, rooms, doors)
    local S = Point(rng:random(7,14), rng:random(6,14))
    local min_overlap = -half_ch
    local room_offset = rng:random(min_overlap+1, 10)
    --print(f'min_overlap={min_overlap}, room_offest={room_offset}')
    local room_y_1 = half_ch + room_offset
    local room_x, door = SpaceShip.findBackOfShipIntersection(rooms, room_y_1, S.x, S.y, rng)

    if room_x and door then
        local split_room_a = ShipRoom(room_x, room_y_1, S.x, S.y)
        local split_room_b = ShipRoom(room_x, -(half_ch+S.y-1) - room_offset, S.x, S.y)
        table.insert(rooms, split_room_a)
        table.insert(rooms, split_room_b)

        table.insert(doors, door)
        table.insert(doors, Point(door.x, -door.y))
        return true
    else
        return false
    end
end

-- return room_x (int), and a valid door location (Point)
function SpaceShip.findBackOfShipIntersection(rooms, room_y, room_width, room_height, rng)
    local start_x = 100
    for i=0,100 do
        local room_x = start_x - i
        local room = ShipRoom(room_x, room_y+1, room_width, room_height-1)
        for _, r in ipairs(rooms) do
            -- TODO: Need to check that interior intersect
            local roomi, ri = room:interior(), r:interior()
            if roomi:intersects(ri) then
                local door = SpaceShip.findDoorLocation(rng, roomi, ri)
                if door then
                    return room_x, door
                else
                    -- Intersected but no valid door location
                    return nil, nil
                end
            end
        end
    end
    return nil, nil -- not found
end


-- Find a door location along the +x side of room 1 and -x side of room 2
-- Retun Point
function SpaceShip.findDoorLocation(rng, room1, room2)
    for _=1,30 do
        -- pick a random location along the wall
        local door = Point(room1.x1, room1.y1+rng:random(1, room1.height-2))
        -- Make sure it is also inside room 2
        if door.y > room2.y1 and door.y < room2.y2-1 then
            return door
        end

    end
    --print('no valid door loc')
    return nil
end

function SpaceShip:isInBounds(x, y, z, submap_name)
    return true
end

return SpaceShip