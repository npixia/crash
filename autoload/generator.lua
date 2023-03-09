local ship_power = requirep 'crash:ship_power'

game.tiles.addInteraction('world_generator_off', 'Turn On', function(actor, x, y)
    game.tiles.toggleTile(
        game.world.currentMap(),
        x, y, actor,
        game.tiles.fromID('world_generator_off'),
        game.tiles.fromID('world_generator_on')
    )
    ship_power.activatePower()
end)