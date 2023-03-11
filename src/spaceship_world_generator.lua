local SpaceShip = WorldGenerator:extend()
SpaceShip.name = 'SpaceShip'
game.worldgen.register(SpaceShip, 'crash', 'src/spaceship_world_generator.lua')

local Point = game.objects.Vector2d
local maputils = requirep 'crash:maputils'
local rngutils = requirep 'crash:rngutils'
local mob_spawning = requirep 'crash:mob_spawning'
local tile_info = requirep 'crash:tile_info'
local loot = requirep 'crash:loot'

local T = game.tiles.fromID
local floor_tile_id = 'world_floor_quad_checker_a'
local wall_tile_id = 'exterior_wall'

local Room = requirep 'towngen:room/Room'
function Room:interior()
    return Room(self.x1+1, self.y1+1, self.width-2, self.height-2)
end

local rpu  = requirep 'towngen:room/room_placement_utils'

local function isLastFloor(z)
    return -1 * z == 4
end

local ShipRoom = Room:extend()
function ShipRoom:place(map, offset, rng)
    if self.floor_variants then
        maputils.fillRectVariants(
            map,
            self.x1+offset.x, self.y1+offset.y,
            self.width, self.height,
            self.floor, self.floor_variants,
            0.2, rng) 
    else
        maputils.fillRect(
            map,
            self.x1+offset.x, self.y1+offset.y,
            self.width, self.height,
            self.floor) 
    end

    if self.wall_variants then
        maputils.rectVariants(
            map,
            self.x1+offset.x, self.y1+offset.y,
            self.width, self.height,
            self.wall, self.wall_variants,
            0.2, rng)
    else
        maputils.rect(map,
            self.x1+offset.x, self.y1+offset.y,
            self.width, self.height,
            self.wall)
    end

end
function ShipRoom:interior()
    local r = ShipRoom(self.x1+1, self.y1+1, self.width-2, self.height-2)
    r.wall = self.wall
    r.floor = self.floor
    return r
end
function ShipRoom:copy()
    local r = ShipRoom(self.x1, self.y1, self.width, self.height)
    r.wall = self.wall
    r.floor = self.floor
    return r
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
function Room:rngPointInterior(rng, margin)
    margin = margin or 0
    return Point(
        self.x1 + margin + rng:random(1, math.max(1, self.width-(2*(1+margin)))),
        self.y1 + margin + rng:random(1, math.max(1, self.height-(2*(1+margin))))
    )
end
function Room:isInside(p)
    return (p.x > self.x1 and
            p.x < self.x2-1 and
            p.y > self.y1 and
            p.y < self.y2-1)
end

-- Convert relative cardinal direction to N/S/E/W id
local function toDir(p)
    if p.x < 0 then
        return 'W'
    elseif p.x > 0 then
        return 'E'
    elseif p.y < 0 then
        return 'N'
    elseif p.y > 0 then
        return 'S'
    else
        return ''
    end
end

local function fromDir(dir)
    if dir == 'N' then
        return Point(0, -1)
    elseif dir == 'S' then
        return Point(0, 1)
    elseif dir == 'W' then
        return Point(-1, 0)
    elseif dir == 'E' then
        return Point(1, 0)
    end
end

function SpaceShip:generateMap(universe_seed, map, width, height, x, y, z, spawn_x, spawn_y, submap_name, params)
    if z == 0 then return end
    local difficulty = math.min(3, -1 * (z)) -- 1..3
    --print('map_z=' .. z .. ' difficulty=' .. difficulty)
    local last_floor = isLastFloor(z)
    if isLastFloor(z) then
        --print('Final floor!')
    end

    local rng = game.random.generator(math.random(1,10000))

    local cx, cy = width/2, height/2

    local prev_floor_stair_loc = nil
    if z < -1 then
        prev_floor_stair_loc = game.world.data()['floor_' .. ((-1*z)-1) .. '_down_stair']
        prev_floor_stair_loc = Point(prev_floor_stair_loc.x, prev_floor_stair_loc.y)
    end
    --print('Prev floor stairs = ' .. to_str(prev_floor_stair_loc))

    -- Generate ship layout
    local rooms, doors, center_room, stair_loc
    local can_place_prev_floor_stairs = false
    
    for layout_attempt_number = 1,100 do
        rooms, doors, center_room, stair_loc = SpaceShip.generateLayout(rng, width, height)
        -- Make sure the down stairs can be placed in a room
        -- And make sure the down stairs are not the same as the up stairs
        if prev_floor_stair_loc == nil then
            can_place_prev_floor_stairs = true
        else
            for _, room in ipairs(rooms) do
                if room:interior():isInside(prev_floor_stair_loc) then
                    can_place_prev_floor_stairs = true
                    break
                end
            end
            if prev_floor_stair_loc.x == stair_loc.x and prev_floor_stair_loc.y == prev_floor_stair_loc.y then
                can_place_prev_floor_stairs = false
            end
        end

        if can_place_prev_floor_stairs then
            --print('Found good layout on attempt #' .. layout_attempt_number)
            break
        end
    end

    if not can_place_prev_floor_stairs then
        print("Can't place previous floor stairs :(")
    end

    --
    -- Place Tiles
    --

    local offset = Point(cx, cy)

    for _, room in ipairs(rooms) do
        room = room:copy()
        room.wall = T'exterior_wall'
        room.floor = T(floor_tile_id)
        room:place(map, offset)
    end
    for _, room in ipairs(rooms) do
        local r = room:interior()

        if r.wall == nil then
            local wall_type = rngutils.randchoice(rng, tile_info.wall_types)
            r.wall = T('world_' .. wall_type.base)
            r.wall_variants = list.map(wall_type.variants, function(id) return T('world_' .. id) end)
        end

        if r.floor == nil then
            local floor_type = rngutils.randchoice(rng, tile_info.floor_types)
            r.floor = T('world_' .. floor_type.base)
            r.floor_variants = list.map(floor_type.variants, function(id) return T('world_' .. id) end)
        end

        r:place(map, offset, rng)
    end
    --print('Got ' .. #doors .. ' doors')
    local t_door = T'world_door_hatch_h_closed'
    local t_door_open = T'world_door_hatch_h_open'
    for _, door in ipairs(doors) do
        local d = door + offset
        if rng:random() < 0.5 then
            d.x = d.x-1
        end
        local door_tile = t_door
        if rng:random() < 0.3 then
            door_tile = t_door_open
        end
        map:set(d.x, d.y, door_tile)
        map:setUpper(d.x-1, d.y, game.tiles.NIL)
        map:setUpper(d.x+1, d.y, game.tiles.NIL)
    end

    -- Add doors for center room
    local cdoor_x = offset.x+center_room.x2-3
    map:set(cdoor_x, offset.y+center_room.y1+1, t_door)
    map:setUpper(cdoor_x, offset.y+center_room.y1, game.tiles.NIL)
    map:set(cdoor_x, offset.y+center_room.y2-2, t_door)
    map:setUpper(cdoor_x, offset.y+center_room.y2-1, game.tiles.NIL)

    if z == -1 then
        map:setUpper(cx-1, cy, T'world_terminal_c')  
    end

    -- Add terminal to rooms
    --local terminal  = T'world_terminal_b'
    --for _, room in ipairs(rooms) do
    --    local p = room:interior():rngPointAlongWall(rng)
    --    map:setUpper(offset.x+p.x, offset.y+p.y, terminal)
    --end

    -- Add lights to rooms
    local light_locations = {}
    local lights = {}
    for _, dir in ipairs({'N','S','E','W'}) do
        lights[dir] = T('world_wall_light_blue_' .. dir) -- .. '_bright')
    end
    for _, room in ipairs(rooms) do
        local light_placed = false
        local attempts = 0
        repeat
            local p = offset + room:interior():rngPointAlongWall(rng)
            if map:getUpper(p.x, p.y) == game.tiles.NIL then
                local dir_id = rngutils.randchoice(rng, {'N', 'S', 'E', 'W'})
                local dir = fromDir(dir_id)
                local wall_check_loc = p + dir
                if map:getUpper(wall_check_loc.x, wall_check_loc.y).is_solid then
                    map:setUpper(p.x, p.y, lights[dir_id])
                    table.insert(light_locations, {x=p.x, y=p.y})
                    light_placed = true
                else
                    --print(to_str(map:getUpper(wall_check_loc.x, wall_check_loc.y)) .. ' is not solid')
                end
            else
                --print('Point along wall is not nil')
            end
            attempts = attempts + 1
        until light_placed or attempts > 100
    end
    -- Store light locations
    map:attr().light_locations = light_locations

   

    -- Add staircase
    if not last_floor then
        map:setLower(offset.x+stair_loc.x, offset.y+stair_loc.y, T'world_wall_rust_stair_down')
        map:setUpper(offset.x+stair_loc.x, offset.y+stair_loc.y, game.tiles.NIL)
    end

    if prev_floor_stair_loc then
        local p = prev_floor_stair_loc
        map:setUpper(offset.x+p.x, offset.y+p.y, T'world_wall_rust_stair_up')
        local up = offset + p
        game.world.data()['floor_' .. (-1*z) .. '_up_stair_offset'] = {x=up.x, y=up.y}
    end

    game.world.data()['floor_' .. (-1*z) .. '_down_stair'] = {x=stair_loc.x, y=stair_loc.y}


    -- Place engineers
    local num_engineers_to_place = 2
    while num_engineers_to_place > 0 do
        local room = rooms[rng:random(1, #rooms)]
        local p = offset + room:rngPointInterior(rng, 1)
        if map:getUpper(p.x, p.y) == game.tiles.NIL and p:dist(offset + stair_loc) > 10 then
            local engineer_id = map:spawn('engineer', p.x, p.y)
            local engineer = map:actors():getActor(engineer_id)
            -- If we are not on the last floor, give them the key card to the next floor
            if not last_floor then
                local next_floor = -1*z + 1
                local keycard = game.items.makeItem('keycard_' .. next_floor)
                engineer:give(keycard)
                loot.giveOne(loot.ARMORS, rng, engineer, difficulty)
                loot.giveOne(loot.WEAPONS, rng, engineer, difficulty)
            end
            map:setUpper(p.x, p.y, T'world_blood_red_c')
            num_engineers_to_place = num_engineers_to_place - 1
            --print('Placed engineer @ ' .. to_str(p))
        end
    end

    -- Chests
    for _, room in ipairs(rooms) do
        if rng:random() < 0.4 then
            local p = offset + room:interior():rngPointAlongWall(rng)
            if map:getUpper(p.x, p.y) == game.tiles.NIL then
                local chest_id = map:spawn('chest', p.x, p.y)
                local chest = map:actors():getActor(chest_id)
                loot.fillChest(rng, chest, difficulty)
            end
        end
    end

    -- Special last floor placement
    if last_floor then
        local generator_loc = Point(0,0)
        repeat
            generator_loc = offset + center_room:interior():rngPointInterior(rng)
        until map:getUpper(generator_loc.x, generator_loc.y) == game.tiles.NIL

        map:setUpper(generator_loc.x, generator_loc.y, T'world_switch_off')
        --print('Placed generator @ ' .. to_str(generator_loc))
        print('You hear the [color=yellow]backup power control[/color] alarm nearby...')
    end

    -- Chem barrels
    for _=1,rng:random(2, 2 + difficulty * 2) do
        local room = rngutils.randchoice(rng, rooms)
        if room.width > 7 and room.height > 7 then
            local p = offset + room:rngPointInterior(rng)
            --print('Checking ' ..  to_str(p) .. ' for barrel')
            --print(to_str(map:getUpper(p.x, p.y)))
            if map:getUpper(p.x, p.y) == game.tiles.NIL then
                map:spawn('explosive_barrel', p.x, p.y)
                --print('placed explosive barrel')
                for _=1,rng:random(1,7) do
                    local q = offset + room:rngPointInterior(rng)
                    if map:getUpper(q.x, q.y) == game.tiles.NIL then
                        map:setUpper(q.x, q.y, game.tiles.fromID('world_barrel'))
                        --print('placed barrel')
                    end
                end
            end
        end
    end


    mob_spawning.spawnFloor(map, rooms, offset, difficulty, rng)
end

-- Return list of rooms, list of doors, and down staircase location
function SpaceShip.generateLayout(rng, width, height)
    local cx, cy = width/2, height/2
    local half_cw = rng:random(5, 8)
    local half_ch = rng:random(3, 6)
    local center_room_width  = half_cw * 2 + 1
    local center_room_height = half_ch * 2 + 1
    local center_room = ShipRoom(
        -half_cw,
        -half_ch,
        center_room_width,
        center_room_height)
    center_room.floor = T(floor_tile_id)
    center_room.wall = T(wall_tile_id)

    -- Place a room directly above and below
    local S = Point(rng:random(9,14), rng:random(5,14))
    local room_2_a = ShipRoom(0, half_ch-1, S.x, S.y)
    local room_2_b = ShipRoom(0, -(half_ch+S.y-2), S.x, S.y)


    local rooms = {room_2_a, room_2_b, center_room}
    local doors = {}

    local num_room_levels = rng:random(7,10)
    local levels_placed = 0
    for _=0,100 do
        local placed_room = false
        if rng:random() < 0.5 then
            placed_room = SpaceShip.addSplitRoom(rng, half_ch, rooms, doors)
        else
            placed_room = SpaceShip.addCenterRoom(rng, rooms, doors)
        end

        if placed_room then
            levels_placed = levels_placed + 1
            if levels_placed >= num_room_levels then
                break
            end
        end
    end

    -- Add stairs
    -- Stairs must be somewhat near the center of the ship
    -- Floors below are randomly generated until they have a valid
    -- configuration the the stairs will fit into
    -- Keeping them near the center increases the chances
    local stair_attempts = 10
    local stair_loc = Point(0,0)
    for _=1,stair_attempts do
        local room = rooms[rng:random(1,#rooms)]:interior()
        local point = Point(rng:random(room.x1+1, room.x2-2),
                            rng:random(room.y1+1, room.y2-2))
        if point.x > 10 and point.x < 40 and point.y > -15 and point.y < 15 then
            --print('Found stair loc' .. to_str(point))
            stair_loc = point
            break
        else
            --print('Not good stair loc' .. to_str(point))
        end
    end

    return rooms, doors, center_room, stair_loc

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