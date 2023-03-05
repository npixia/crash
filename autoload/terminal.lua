local T = game.tiles.fromID

game.tiles.addInteraction('world_terminal_b', 'activate', function(actor, x, y)
    game.tiles.toggleTile(game.world.currentMap(), x, y, actor, T'world_terminal_b', T'world_terminal_a')
end)
