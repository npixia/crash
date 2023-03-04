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

return {tiles=tiles, items=items}