RegisterNetEvent('animation:start', function(id)
    assert(source, 'animation:start(): missing args')
    assert(id, 'animation:start(): missing args')

    local name = Config.order[id]
    local data = Config.list[name]

    assert(data, 'animation:start(): tried to play invalid animation')

    data.id = id

    local animation       = Animation(data)
    local animationLoaded = animation:load(5000)

    if (not animationLoaded) then
        return
    end

    animation:play()
end)