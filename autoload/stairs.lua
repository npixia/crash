local ship_power = requirep 'crash:ship_power'

local function addStairInteraction(id)

    game.tiles.addInteraction(id .. '_up', 'ascend', function(actor, x, y)
        if actor:getX() == x and actor:getY() == y then
            local map_x, map_y, map_z, region = game.world.currentMapLocation()
            if map_z >= 0 then
                print("Can't go up!")
            else
                game.world.teleport(x, y, map_x, map_y, map_z+1, region)
                print('Checking ship power status...')
                if ship_power.isPowerOn() then
                    print('power status is on, turning on the lights..')
                    ship_power.activateFloor(game.world.map())
                end
            end
        else
            print('Must be standing on stairs');
        end
    end)

    game.tiles.addInteraction(id .. '_down', 'descend', function(actor, x, y)
        local map_x, map_y, map_z, region = game.world.currentMapLocation()
        local next_floor = -1 * map_z + 1
        if actor:count(game.items.makeItem('keycard_' .. next_floor)) > 0 then
            if actor:getX() == x and actor:getY() == y then
                game.world.teleport(x, y, map_x, map_y, map_z-1, region)
                return true
            else
                print('Must be standing on stairs');
                return false
            end
        else
            print("[color=red]ACCESS DENIED[/color] Please insert keycard for this floor")
        end

    end)
end

addStairInteraction('world_wall_rust_stair')