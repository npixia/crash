local ship_power = {}

function ship_power.isPowerOn()
    if game.world.data().ship_power_on == true then return true end
end

local function turnOnLights(map)
    local light_locations = map:attr().light_locations
    if light_locations then
        for i = 1,#light_locations do
            local p = light_locations[i]
            local l = map:getUpper(p.x, p.y)
            local on_id = l.id .. '_bright'
            local on_tile = game.tiles.fromIDOrNil(on_id)
            if on_tile ~= game.tiles.NIL then
                map:setUpper(p.x, p.y, on_tile)
            end
        end
    end
end

function ship_power.activatePower()
    game.world.data().ship_power_on = true
    ship_power.activateFloor(game.world.map())
    print('Ship backup power status: [color=green]ACTIVE[/color]')
end

function ship_power.activateFloor(map)
    --if not map:attr().power_activated then
        turnOnLights(map)
    --end
    map:attr().power_activated = true
end

return ship_power