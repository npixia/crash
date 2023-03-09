local tiles = {}
local items = {}

local all_tiles = game.sys.read 'pkg/crash/sprites/crash/tg_world/all_tiles.txt'
all_tiles = string.lines(all_tiles)
all_tiles = list.map(all_tiles, function(fname) return fname:sub(0, #fname-4):sub(4, #fname) end)

local function tile(args)
    local id = args[1]
    local name = args[2]
    local layer = args.layer or 'lower'
    local upper_solid = true
    if args.solid == false then upper_solid = false end
    local sprite_base = args.sprite or id

    local pixel_color = '#333'
    if layer == 'lower' then
        pixel_color = '#ccc'
    end

    local sprite = f'crash/tg_world/tg_{sprite_base}'
    tiles[id]= {
        display_name=name,
        sprite=sprite,
        layer=layer,
        pixel_color=pixel_color,
        -- Can only be broken by explosives
        tool={ type='explosive', hardness=0, hp=1},
    }
    items[id]={
        name=name,
        desc=name,
        visual={
            sprite=sprite,
        }
    }
    if layer == 'upper' and upper_solid then
        tiles[id].opacity = 1.0
        tiles[id].solid = true
        tiles[id].casts_shadow = true
    end

    return tiles[id]
end



tile{'world_floor_quad_grey_a', 'Tile Floor'}
tile{'world_wall_lab_v_a', 'Wall', layer='upper'}

for _, tile_name in ipairs(all_tiles) do
    if #tile_name > 2 then
        if tile_name:count('floor') > 0 then
            tile{tile_name, 'Floor'}
        end
        if tile_name:count('wall') > 0 then
            tile{tile_name, 'Wall', layer='upper'}
        end
    end
end

local required_tiles = {
    'ice', 'thick_ice', 'gravel', 'grass', 'dirt', 'farmland', 'farmland_wet'
}
for _,t in ipairs(required_tiles) do
    tiles[t] = {layer='lower'}
end

tiles['world_floor_sand_d'].light = "orange"

--
-- DOORS
--
local function door(closed_id, open_id, name)
    local closed_door = tile{closed_id, name, layer='upper'}
    local open_door = tile{open_id, name, layer='upper'}

    open_door.pixel_color = '#ff00ff'
    closed_door.pixel_color = '#ff00ff'

    open_door.solid = false
    open_door.wall = false
    open_door.pixel_color = '#ff00ff'
    open_door.opacity = 0.0
    open_door.casts_shadow = false
end

door('world_door_hatch_h_closed', 'world_door_hatch_h_open', 'Door')

--
-- TERMINAL
--

local terminals = {
    a=tile{'world_terminal_a', 'Terminal (Activated)', layer='upper', solid=false},
    b=tile{'world_terminal_b', 'Terminal', layer='upper', solid=false},
    c=tile{'world_terminal_c', 'Terminal (No Power)', layer='upper', solid=false},
}
for _,terminal in pairs(terminals) do
    terminal.pixel_color = '#00ff00'
end
terminals['b'].light = {
    format='float',
    r=0.0,
    g=0.2,
    b=0.0,
}

--
-- STAIRS
-- 
local function stairs(id)
    local down_stair = tile{id .. '_down', 'Down Stairs', layer='lower'}
    local up_stair = tile{id .. '_up', 'Up Stairs', layer='upper', solid=false}
    local down_stair_locked = tile{id .. '_down_locked', 'Down Stairs (Locked)', layer='lower'}

    up_stair.pixel_color = '#ffff00'
    down_stair.pixel_color = '#ffff00'
    down_stair_locked.pixel_color = '#ffff00'

    down_stair_locked.sprite = f'crash/tg_world/tg_' .. id .. '_down'

    -- For debugging
    up_stair.light = {name='blue', ['*']=0.5}
    down_stair.light = {name='blue', ['*']=0.5}
    down_stair_locked.light = {name='blue', ['*']=0.5}
end

stairs('world_wall_rust_stair')


--
-- BLOOD
--

local blood = {
    tile{'world_blood_red_c', 'Blood', layer='upper', solid=false}
}

--
-- GENERATOR
--

local generator_on =  tile{'world_generator_on', 'Generator', layer='upper', solid=false}
local generator_off = tile{'world_generator_off', 'Generator', layer='upper', solid=false}

generator_off.light = {format='float', r=0.3}
generator_on.light  = {format='float', g=0.5}

--
-- Lights
--

local dirs = {'N', 'S', 'W', 'E'}
local wall_lights = {}
for _, dir in ipairs(dirs) do
    local light = tile{
        'world_wall_light_blue_' .. dir,
        'Wall Light',
        layer='upper',
        solid=false
    }
    local bright_light = tile{
        'world_wall_light_blue_bright_' .. dir,
        'Wall Light',
        layer='upper',
        solid=false,
        sprite='world_wall_light_blue_' .. dir,
    }
    --light.light = {format='float', b=0.4, r=0.3, g=0.3}
    --bright_light.light = {format='float', b=0.8, r=0.7, g=0.7}
    table.insert(wall_lights, light)
end

return {tiles=tiles, items=items}