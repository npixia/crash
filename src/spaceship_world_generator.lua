local SpaceShip = WorldGenerator:extend()
SpaceShip.name = 'SpaceShip'
game.worldgen.register(SpaceShip, 'crash', 'src/spaceship_world_generator.lua')

local Point = game.objects.Vector2d
local maputils = requirep 'crash:maputils'

local T = game.tiles.fromID
local floor = T'world_floor_quad_checker_a'
local wall = T'world_wall_derelict_v_a'
local highlight = T'world_wall_alien_v_a'

local Room = requirep 'towngen:room/Room'
local rpu  = requirep 'towngen:room/room_placement_utils'

local ShipRoom = Room:extend()
function ShipRoom:place(map, offset)
    local wall = self.wall or wall
    local floor = self.floor or floor
    rpu.fillRect(map, self.x1+offset.x, self.y1+offset.y, self.width, self.height, floor) 
    rpu.rect(map, self.x1+offset.x, self.y1+offset.y, self.width, self.height, wall)
    map:set(self.x1+offset.x, self.y1+offset.y, highlight)
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
    center_room.floor = floor
    center_room.wall = wall

    center_room:place(map, offset)

    -- Place a room directly above and below
    local S = Point(rng:random(7,14), rng:random(3,14))
    local room_2_a = ShipRoom(0, half_ch, S.x, S.y)
    local room_2_b = ShipRoom(0, -(half_ch+S.y-1), S.x, S.y)

    room_2_a:place(map, offset)
    room_2_b:place(map, offset)

    local rooms = {room_2_a, room_2_b, center_room}


    for _=0,rng:random(2,5) do
        self.addSplitRoom(map, rng, offset, half_ch, rooms)
    end
end

function SpaceShip.addSplitRoom(map, rng, offset, half_ch, rooms)
    S = Point(rng:random(7,14), rng:random(3,14))
    local min_overlap = -half_ch
    local room_offset = rng:random(min_overlap+1, 10)
    print(f'min_overlap={min_overlap}, room_offest={room_offset}')
    local room_x = 0
    local done = false
    local start_x = 100

    for i=0,100 do
        room_x = start_x - i
        if done then break end
        local room = ShipRoom(room_x, half_ch + room_offset, S.x, S.y)
        for _, r in ipairs(rooms) do
            -- TODO: Need to check that interior intersect
            if room:intersects(r) then
                done = true
                break
            end
        end
    end

    if done == false then
        print('No intersect found')
    else
        local split_room_a = ShipRoom(room_x, half_ch + room_offset, S.x, S.y)
        local split_room_b = ShipRoom(room_x, -(half_ch+S.y-1) - room_offset, S.x, S.y)
        split_room_a:place(map, offset)
        split_room_b:place(map, offset)
        table.insert(rooms, split_room_a)
        table.insert(rooms, split_room_b)
    end
end

function SpaceShip:isInBounds(x, y, z, submap_name)
    return true
end

return SpaceShip