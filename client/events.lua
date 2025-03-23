RegisterNetEvent('animation:start', function(uInt8)
    assert(source, 'animation:start(): missing args')
    assert(uInt8, 'animation:start(): missing args')

    local name = Config.hashToUint8Reference[uInt8]
    local data = Config.list[name]

    assert(data, 'animation:start(): tried to play invalid animation')

    data.uInt8 = uInt8

    local animation       = Animation(data)
    local animationLoaded = animation:load(5000)

    if (not animationLoaded) then
        return
    end

    animation:play()
end)