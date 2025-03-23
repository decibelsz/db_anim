class = function(base)
    local cls = {}
    cls.__index = cls
    cls.__base = base
    setmetatable(
        cls,
        {
            __call = function(_, ...)
                local instance = setmetatable({}, cls)
                if cls.__init then
                    cls.__init(instance, ...)
                end
                return instance
            end,
            __index = base
        }
    )
    return cls
end

hashToUint8 = function(str)
    local hash = 0
    for i = 1, #str do
        hash = (hash + string.byte(str, i)) % 256
    end
    return hash
end
