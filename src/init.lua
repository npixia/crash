requirep 'crash:spaceship_world_generator'

local welcome_message = [[
You wake up and remember that space ship had a power failure and has crash-landed on an unknown planet.
You must descend into your ship's hull and manually override the [color=yellow]backup power[/color]. Then return here to the [color=yellow]navigation console[/color] to escape.
Beware, the crash landing has attracted attention of the [color=green]locals[/color].

=== IMPORTANT KEYBINDS ===

Press [color=green]?[/color] for help and keybind list

[color=orange]View[/color]:
Press [color=green]alt +[/color] or [color=green]alt -[/color] to scale the text & tiles
[color=green]Z[/color]: Zoom in/out, Center View

[color=orange]Gameplay[/color]:
Move using [color=green]WASD[/color]
[color=green]SPACE OR LMB[/color]: Use Item
[color=green]I[/color]: Inventory
[color=green]L[/color]: Look
[color=green]E OR RMB[/color]: Interact
[color=green]G[/color]: Pick Up (Some items are auto-pickup)
[color=green]P[/color]: Equipment
[color=green]/[/color]: Open message log ([color=green]ESC[/color]) to close

[color=orange]Menus/Other[/color]:
[color=green]ESC[/color] or [color=green]Q[/color] to exit menus, dialogs, and screens
Press [color=green]ENTER[/color] or [color=green]SPACE[/color] to select things
]]


-- Config
game.config.setZoom(true)
game.config.setAutomoveWaitTime(120)

-- Called when the world is loaded
game.signal.subscribe('/world/load/complete', function()
    game.worldgen.use('SpaceShip')

    -- Start on floor -1
    if not game.world.data().first_load_complete then
        game.world.teleport(128, 128, 0, 0, -1, '')
    end
    game.world.data().first_load_complete = true

    game.config.setKeybinding('z', 'Zoom', function()
        game.render.setCamera(game.actors.getPlayer():getXY())
        game.config.setZoom(not game.config.getZoom())
    end)

end)

local died_message  = 'You [color=red]Died[/color]! Close the game and create a new world to try again.'

-- Called after the first render tick has completed after the world has loaded
game.signal.subscribe('/world/load/render_complete', function()

    if not game.world.data().has_seen_welcome_message then
        local keep_reading = 0
        -- User must select "Play" in order to exit the loop
        while keep_reading == 0 or keep_reading == 1 do
            game.gui.messageBox('Welcome!', welcome_message)
            keep_reading = game.gui.menuSelect('Ready to play?', {'Show Welcome Message', 'Play'})
        end
        game.world.data().has_seen_welcome_message = true
    end

    if game.world.data().player_dead then
        game.gui.messageBox(died_message)
    end
    print(died_message)
end)


game.signal.subscribe('/world/clock/interval/100', function()

end)


-- Called when the player dies
game.signal.subscribe('/player/death', function()
    game.world.data().player_dead = true
    game.save()

    game.gui.messageBox('You Died!', 'You Died!')
    local selected = game.gui.menuSelect('Respawn?', {'close', 'exit'})
    if selected == 0 or selected == 1 then
        -- player selected close
    elseif selected == 2 then
        game.exit()
    end
    print(died_message)
end)