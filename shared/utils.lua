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

repeat Wait(1) until Config

Config.order = {}

for name in pairs(Config.list) do
    table.insert(Config.order, name)
end

table.sort(Config.order)

local count = 0
for _, name in pairs(Config.order) do
    count = count + 1
    Config.list[name].index = count
    Config.order[count] = name
end