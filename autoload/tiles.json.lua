local tiles = {}
local items = {}

local all_tiles = game.sys.read 'pkg/crash/sprites/crash/tg_world/all_tiles.txt'
all_tiles = string.lines(all_tiles)
all_tiles = list.map(all_tiles, function(fname) return fname:sub(0, #fname-4):sub(4, #fname) end)

local function tile(args)
    local id = args[1]
    local name = args[2]
    local layer = args.layer or 'lower'

    local pixel_color = '#333'
    if layer == 'lower' then
        pixel_color = '#ccc'
    end

    local sprite = f'crash/tg_world/tg_{id}'
    tiles[id]= {
        display_name=name,
        sprite=sprite,
        layer=layer,
        pixel_color=pixel_color,
    }
    items[id]={
        name=name,
        desc=name,
        visual={
            sprite=sprite,
        }
    }
    if layer == 'upper' then
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
    a=tile{'world_terminal_a', 'Terminal (Activated)', layer='upper'},
    b=tile{'world_terminal_b', 'Terminal', layer='upper'},
    c=tile{'world_terminal_c', 'Terminal (No Power)', layer='upper'},
}
for _,terminal in pairs(terminals) do
    terminal.solid = false
    terminal.casts_shadow = false
    terminal.opacity = 0.0
    terminal.pixel_color = '#00ff00'
end
terminals['b'].light = {
    format='float',
    r=0.0,
    g=0.5,
    b=0.0,
}

return {tiles=tiles, items=items}