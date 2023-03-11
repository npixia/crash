local ship_power = requirep 'crash:ship_power'

game.tiles.addInteraction('world_switch_off', 'Turn On', function(actor, x, y)
    game.tiles.toggleTile(
        game.world.currentMap(),
        x, y, actor,
        game.tiles.fromID('world_switch_off'),
        game.tiles.fromID('world_switch_on')
    )
    ship_power.activatePower()
end)