game.actors.addInteraction('chest', 'open',
    function(storage, other)
        game.control.trade(other, storage)
    end
)