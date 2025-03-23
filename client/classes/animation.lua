PlayerPedId = PlayerPedId
RequestAnimDict = RequestAnimDict
HasAnimDictLoaded = HasAnimDictLoaded
GetGameTimer = GetGameTimer
IsPedRagdoll = IsPedRagdoll
IsPedSwimming = IsPedSwimming
IsPedSwimmingUnderWater = IsPedSwimmingUnderWater
IsPedFalling = IsPedFalling
IsPedInParachuteFreeFall = IsPedInParachuteFreeFall
DecorRegister = DecorRegister
DecorSetInt = DecorSetInt
TaskPlayAnim = TaskPlayAnim
StopAnimTask = StopAnimTask
DecorRemove = DecorRemove
---@class Animation
---@field ped number
---@field uInt8 number
---@field animDictionary string
---@field animationName string
---@field blendInSpeed number
---@field blendOutSpeed number
---@field duration number
---@field flag number
---@field playbackRate number
---@field lockX number
---@field lockY number
---@field lockZ number
---@field prop? Prop
---@field object? number

Animation        = class()
---@type table<number, Animation>
currentAnimation = {}

DecorRegister('CURRENT_ANIM', 3)

---@param data table
---@return Animation
function Animation:__init(data)
    self.ped            = data.entity or PlayerPedId()
    self.uInt8          = data.uInt8
    self.animDictionary = data.animDictionary
    self.animationName  = data.animationName
    self.blendInSpeed   = data.blendInSpeed or 1.0
    self.blendOutSpeed  = data.blendOutSpeed or 1.0
    self.duration       = data.duration or -1
    self.flag           = data.flag or FLAGS.UPPER_BODY
    self.playbackRate   = data.playbackRate or 0
    self.lockX          = data.lockX or 0
    self.lockY          = data.lockY or 0
    self.lockZ          = data.lockZ or 0
    self.prop           = data.prop and nil or Prop(data.prop)
    return self
end

--- loads the animation dictionary
---@param timeout? number
---@return boolean
function Animation:load(timeout)
    local timeoutDuration = timeout or 2000
    local requestEndTime  = GetGameTimer() + timeoutDuration

    RequestAnimDict(self.animDictionary)
    while not HasAnimDictLoaded(self.animDictionary) and GetGameTimer() <= requestEndTime do Wait(1) end

    assert(HasAnimDictLoaded(self.animDictionary), ('Animation:load() - failed to load dictionary: %s'):format(self.animDictionary))

    if Config.debug then
        print(('Animation:load() - loaded dictionary: %s'):format(self.animDictionary))
    end

    return HasAnimDictLoaded(self.animDictionary)
end

--- plays the animation
function Animation:play()
    if ( currentAnimation[self.ped] or IsPedRagdoll(self.ped) or IsPedSwimming(self.ped) or IsPedSwimmingUnderWater(self.ped) or IsPedFalling(self.ped) or IsPedInParachuteFreeFall(self.ped) ) then
        return
    end

    TaskPlayAnim(
        self.ped,
        self.animDictionary,
        self.animationName,
        self.blendInSpeed,
        self.blendOutSpeed,
        self.duration,
        self.flag,
        self.playbackRate,
        self.lockX,
        self.lockY,
        self.lockZ
    )

    DecorSetInt(self.ped, 'CURRENT_ANIM', self.uInt8)

    if self.prop then
        self.object = self.prop:create()
    end

    currentAnimation[self.ped] = self

    if Config.debug then
        print(('Animation:play() - playing animation %s from dictionary %s'):format(self.animationName, self.animDictionary))
    end
end

--- stops the animation
function Animation:stop()
    currentAnimation[self.ped] = nil

    StopAnimTask(self.ped, self.animDictionary, self.animationName, 1.0)

    DecorRemove(self.ped, 'CURRENT_ANIM')

    if Config.debug then
        print(('Animation:stop() - stopped animation %s from dictionary %s'):format(self.animationName, self.animDictionary))
    end
end

local cancelAnimation = function()
    local animation = currentAnimation[PlayerPedId()]
    if (not animation) then
        return
    end
    animation:stop()
end

RegisterCommand('animation:cancel', cancelAnimation)
RegisterKeyMapping('animation:cancel', 'cancelar animação', 'KEYBOARD', 'F6')

--- removes the animation on script start in case we restart
CreateThread(
    function()
        DecorRemove(PlayerPedId(), 'CURRENT_ANIM')
    end
)
