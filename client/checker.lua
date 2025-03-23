PlayerPedId = PlayerPedId
GetEntityCoords = GetEntityCoords
GetGamePool = GetGamePool
GetPlayerServerId = GetPlayerServerId
NetworkGetPlayerIndexFromPed = NetworkGetPlayerIndexFromPed
DecorExistOn = DecorExistOn
DecorGetInt = DecorGetInt
local animationChecker = function()
    ClearPedTasksImmediately(PlayerPedId())

    while true do
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)
        local peds = GetGamePool('CPed')

        for _, nped in ipairs(peds) do
            local source = GetPlayerServerId(NetworkGetPlayerIndexFromPed(nped))
            if DecorExistOn(nped, 'CURRENT_ANIM') then
                local currentAnim = DecorGetInt(nped, 'CURRENT_ANIM')
                local animName = Config.hashToUint8Reference[currentAnim]
                local distance = #(playerCoords - GetEntityCoords(nped))

                if Config.list[animName] and distance <= Config.loadDistance then
                    if not createdEntities[source] then
                        local instance = Prop(Config.list[animName].prop, nped)
                        instance:load()
                        instance:create()
                        createdEntities[source] = instance
                    end
                else
                    if createdEntities[source] then
                        createdEntities[source]:destroy()
                        createdEntities[source] = nil
                    end
                end
            else
                if createdEntities[source] then
                    createdEntities[source]:destroy()
                    createdEntities[source] = nil
                end
            end
        end

        Wait(500)
    end
end

CreateThread(animationChecker)
