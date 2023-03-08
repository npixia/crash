local function isDownStair(tile)
    return tile == game.tiles.fromID('world_wall_rust_stair_down_locked')
end

game.items.defineAction('keycard', 'use', {fn_type='MAP', map_range=5},
    function(item, owner, map, x, y)
        local _, _, floor_level = game.world.currentMapLocation()
        floor_level = floor_level * -1
        local next_floor = floor_level + 1

        if isDownStair(map:getLower(x, y)) then
            if next_floor == item.attr.floor then
                map:setLower(x, y, game.tiles.fromID('world_wall_rust_stair_down'))
                print('[color=green]ACCESS GRANTED[/color]')
                return {remove_item=true, time=100}
            else
                print('[color=red]ACCESS DENIED[/color] This keycard is for another floor')
            end
        else
            print('The key card does nothing')
            return {time=100}
        end
    end
)