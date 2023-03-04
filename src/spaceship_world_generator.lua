local SpaceShip = WorldGenerator:extend()
SpaceShip.name = 'SpaceShip'
game.worldgen.register(SpaceShip, 'crash', 'src/spaceship_world_generator.lua')

local Point = game.objects.Vector2d
local maputils = requirep 'crash:maputils'

local T = game.tiles.fromID
local floor = T'world_floor_quad_checker_a'
local wall = T'world_wall_derelict_v_a'

local Room = requirep 'towngen:room/Room'
local rpu  = requirep 'towngen:room/room_placement_utils'

local ShipRoom = Room:extend()
function ShipRoom:place(map, offset)
    rpu.fillRect(map, self.x1+offset.x, self.y1+offset.y, self.width, self.height, self.floor) 
    rpu.rect(map, self.x1+offset.x, self.y1+offset.y, self.width, self.height, self.wall)
end

function SpaceShip:generateMap(universe_seed, map, width, height, x, y, z, spawn_x, spawn_y, submap_name, params)

    local rng = game.random.generator(math.random(1,10000))

    local cx, cy = width/2, height/2
    local offset = Point(cx, cy)

    local center_room_width = rng:random(10, 16)
    local center_room_height = rng:random(3, 6) * 2 + 1
    local center_room = ShipRoom(
        -center_room_width/2,
        -center_room_height/2,
        rng:random(10, 16),
        rng:random(3,6) * 2 + 1)
    center_room.floor = floor
    center_room.wall = wall

    center_room:place(map, offset)




end

function SpaceShip:isInBounds(x, y, z, submap_name)
    return true
end

return SpaceShip