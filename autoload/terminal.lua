local T = game.tiles.fromID
local ship_power = requirep 'crash:ship_power'

game.tiles.addInteraction('world_terminal_c', 'activate', function(actor, x, y)
    if ship_power.isPowerOn() then
        game.tiles.toggleTile(game.world.currentMap(), x, y, actor, T'world_terminal_c', T'world_terminal_b')
        game.gui.messageBox("You Escaped!", "You hear your ship's thrusters come to life. Your ship rises off the hostile planet and into orbit. [color=yellow]You have escaped![/color]")
        print('Thank you for playing! Feel free to explore the ship!')
    else
        print('[color=red]NAVIGATION ERROR[/color]: insufficient power')
    end
end)
