local rngutils = {}

function rngutils.randchoice(rng, list)
    return list[rng:random(1,#list)]
end

return rngutils