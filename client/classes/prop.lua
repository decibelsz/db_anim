---@class Prop
---@field ped number
---@field server_id number
---@field model string
---@field hash number
---@field bone string
---@field boneIndex number
---@field pos vector3
---@field rot vector3
---@field object? number

Prop = class()
---@type table<number, Prop>
createdEntities = {}

---@param data table
---@param entity? number
---@return Prop
function Prop:__init(data, entity)
    self.ped       = entity or PlayerPedId()
    self.server_id = GetPlayerServerId(NetworkGetPlayerIndexFromPed(self.ped))
    self.model     = data.model
    self.hash      = GetHashKey(data.model)
    self.bone      = data.bone
    self.boneIndex = GetPedBoneIndex(self.ped, self.bone)
    self.pos       = data.pos
    self.rot       = data.rot
end

--- loads the prop model
---@param timeout? number
---@return boolean
function Prop:load(timeout)
    local timeoutDuration = timeout or 2000
    local requestEndTime = GetGameTimer() + timeoutDuration

    RequestModel(self.model)

    while not HasModelLoaded(self.model) and GetGameTimer() <= requestEndTime do
        Wait(1)
    end

    assert(HasModelLoaded(self.model), ('Prop:load() - failed to load model: %s'):format(self.model))

    if (Config.debug) then
        print(('Prop:load() - loaded model: %s'):format(self.model))
    end

    SetModelAsNoLongerNeeded(self.model)
    return HasModelLoaded(self.model)
end

--- creates the prop and attaches it to the entity
---@return number
function Prop:create()
    if (createdEntities[self.server_id]) then
        return
    end

    self.object = CreateObject(self.hash, 0, 0, 0, false, false, false)

    if (Config.debug) then
        print(('Prop:create() - creating prop with model name: %s'):format(self.model))
        print('Prop:create() attaching to ped:', self.ped)
    end

    AttachEntityToEntity(
        self.object,
        self.ped,
        self.boneIndex,
        self.pos.x,
        self.pos.y,
        self.pos.z,
        self.rot.x,
        self.rot.y,
        self.rot.z,
        true,
        true,
        false,
        true,
        1,
        true
    )

    createdEntities[self.server_id] = self

    return self.object
end

--- destroys the prop
function Prop:destroy()
    if (Config.debug) then
        print(('Prop:destroy() - destroying prop with model name: %s and net %s'):format(self.model, self.object))
    end

    createdEntities[self.server_id] = nil

    DeleteEntity(self.object)
end
