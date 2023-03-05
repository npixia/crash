requirep 'crash:spaceship_world_generator'

game.config.setZoom(true)

-- Called when the world is loaded
game.signal.subscribe('/world/load/complete', function()
    game.worldgen.use('SpaceShip')
end)

-- Called after the first render tick has completed after the world has loaded
game.signal.subscribe('/world/load/render_complete', function()

    if not game.world.data().has_seen_welcome_message then
        local welcome_message = requirep 'welcome_message'
        local keep_reading = 0
        -- User must select "Play" in order to exit the loop
        while keep_reading == 0 or keep_reading == 1 do
            game.gui.messageBox('Welcome!', welcome_message)
            keep_reading = game.gui.menuSelect('Ready to play?', {'Show Welcome Message', 'Play'})
        end
        game.world.data().has_seen_welcome_message = true
    end
end)


game.signal.subscribe('/world/clock/interval/100', function()

end)


-- Called when the player dies
game.signal.subscribe('/player/death', function()
    local loop = true
    while loop do
        game.gui.messageBox('You Died!', 'You Died!')
        local selected = game.gui.menuSelect('Respawn?', {'close', 'respawn', 'exit'})
        loop = false
        if selected == 0 or selected == 1 then
            -- player selected close
            loop = true
        elseif selected == 2 then
            heal()
        elseif selected == 3 then
            game.exit()
        end
    end
end)