game.actors.addInteraction('engineer', 'inspect',
    function(storage, other)
        game.control.trade(other, storage)
    end
)