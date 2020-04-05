local mod = {
  id = "mini_mechs",
  name = "Mini Mechs",
  version = "0.0.1",
  requirements = {}
}

--[[--
  Helper function to load mod scripts

  @param  name   Script path relative to mod directory
]]
function mod:loadScript(path)
  return require(self.scriptPath..path)
end

function mod:metadata()
end

function mod:init()
  -- sprites
  local sprites = self:loadScript("libs/sprites")
  sprites.addMissionUnits(
    {
      Name = "mini_mirrortank",
      Default  = { PosX = -15, PosY = 12 },
      Animated = { PosX = -15, PosY = 12, NumFrames = 2 },
      Death    = { PosX = -21, PosY =  3, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -21, PosY =  3 },
      Icon     = {}
    }
  )
  sprites.addSprite("effects", "shotup_mini_mirrortank")
  sprites.addSprite("weapons", "deploy_mini_mirrortank")

  -- deploys
  self:loadScript("deploys/tanks")

  -- texts
  modApi:addWeapon_Texts(self:loadScript("weapon_texts"))
end

function mod:load(options,version)
end

return mod
