-- Add ability to open/close all working door types
local toggleTile = game.tiles.toggleTile
local getTile = game.tiles.fromID
local map = game.world.currentMap

local function doorInteraction(closed_id, open_id)
    game.tiles.addInteraction(closed_id, 'open', function(actor, x, y)
        toggleTile(map(), x, y, actor, getTile(closed_id), getTile(open_id))
        wait(100)
    end)
    game.tiles.addInteraction(open_id, 'close', function(actor, x, y)
        toggleTile(map(), x, y, actor, getTile(open_id), getTile(closed_id))
        wait(100)
    end)

end

doorInteraction('world_door_hatch_h_closed', 'world_door_hatch_h_open')