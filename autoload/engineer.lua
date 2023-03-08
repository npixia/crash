game.actors.addInteraction('engineer', 'trade',
    function(storage, other)
        game.control.trade(other, storage)
    end
)