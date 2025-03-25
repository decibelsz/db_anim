local runCommand = function(source, args)
    local name = args[1]

    if (not name) then
        return TriggerClientEvent('Notify',source,'negado',('Modo de uso: /%s [nome_animacao].'):format(Config.command))
    end

    if (not Config.list[name]) then
        return TriggerClientEvent('Notify',source,'negado',('%s não é uma animação previamente registrada.'):format(name))
    end

    local ped = GetPlayerPed(source)
    local hp  = GetEntityHealth(ped)

    if (hp <= Config.minHealth) then
        return TriggerClientEvent('Notify', source, 'negado', 'Você não pode fazer isso morto.')
    end

    TriggerClientEvent('animation:start', source, Config.list[name].index)
end

RegisterCommand(Config.command, runCommand)
