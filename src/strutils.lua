local strutils = {}

function strutils.title(str)
    return string.gsub(" "..str, "%W%l", string.upper):sub(2)
end

return strutils