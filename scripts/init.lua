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
    -- tanks
    {
      Name = "mini_mirrortank",
      Default  = { PosX = -15, PosY = 12 },
      Animated = { PosX = -15, PosY = 12, NumFrames = 2 },
      Death    = { PosX = -21, PosY =  3, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -21, PosY =  3 },
      Icon     = {}
    },
    -- bots
    {
      Name = "mini_knightbot",
      Default  = { Height = 2, PosX = -19, PosY = -4,  },
      Animated = { Height = 2, PosX = -19, PosY = -4, NumFrames = 4 },
      Death    = { Height = 2, PosX = -20, PosY = -7, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { Height = 2, PosX = -19, PosY = -4 },
      Icon     = { Height = 2 }
    },
    {
      Name = "mini_laserbot",
      Default  = { Height = 2, PosX = -15, PosY = -5 },
      Animated = { Height = 2, PosX = -15, PosY = -5, NumFrames = 4 },
      Death    = { Height = 2, PosX = -19, PosY = -9, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { Height = 2, PosX = -15, PosY = -5 },
      Icon     = { Height = 2 }
    },
    {
      Name = "mini_judobot",
      Default  = { Height = 2, PosX = -15, PosY = -1 },
      Animated = { Height = 2, PosX = -15, PosY = -1, NumFrames = 4 },
      Death    = { Height = 2, PosX = -19, PosY = -5, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { Height = 2, PosX = -15, PosY = -1 },
      Icon     = { Height = 2 }
    },
    {
      Name = "mini_leapbot",
      Default  = { Height = 2, PosX = -14, PosY =  -5 },
      Animated = { Height = 2, PosX = -15, PosY =  -5, NumFrames = 4 },
      Death    = { Height = 2, PosX = -20, PosY = -10, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { Height = 2, PosX = -14, PosY =  -5 },
      Icon     = { Height = 2 }
    },
    -- copters
    {
      Name    = "mini_smoke_copter",
      Default  = { PosX = -15, PosY = 8 },
      Animated = { PosX = -15, PosY = 8, NumFrames = 4 },
      Death    = { PosX = -19, PosY = 9, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = 9 },
      Icon     = {}
    },
    {
      Name    = "mini_napalm_copter",
      Default  = { PosX = -15, PosY = 8 },
      Animated = { PosX = -15, PosY = 8, NumFrames = 4 },
      Death    = { PosX = -19, PosY = 9, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = 9 },
      Icon     = {}
    },
    {
      Name    = "mini_repair_copter",
      Default  = { PosX = -15, PosY = 8 },
      Animated = { PosX = -15, PosY = 8, NumFrames = 4 },
      Death    = { PosX = -19, PosY = 9, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = 9 },
      Icon     = {}
    }
  )
  -- tanks
  sprites.addSprite("effects", "shotup_mini_mirrortank")
  sprites.addSprite("weapons", "deploy_mini_mirrortank")
  -- bots
  sprites.addSprite("effects", "shotup_mini_knightbot1")
  sprites.addSprite("effects", "shotup_mini_knightbot2")
  sprites.addSprite("weapons", "deploy_mini_knightbot")
  sprites.addSprite("effects", "shotup_mini_laserbot1")
  sprites.addSprite("effects", "shotup_mini_laserbot2")
  sprites.addSprite("weapons", "deploy_mini_laserbot")
  sprites.addSprite("effects", "shotup_mini_judobot1")
  sprites.addSprite("effects", "shotup_mini_judobot2")
  sprites.addSprite("weapons", "deploy_mini_judobot")
  sprites.addSprite("effects", "shotup_mini_leapbot1")
  sprites.addSprite("effects", "shotup_mini_leapbot2")
  sprites.addSprite("weapons", "deploy_mini_leapbot")
  -- copters
  sprites.addSprite("effects", "shotup_mini_smoke_copter")
  sprites.addSprite("weapons", "deploy_mini_smoke_copter")
  sprites.addSprite("effects", "shotup_mini_napalm_copter")
  sprites.addSprite("weapons", "deploy_mini_napalm_copter")
  sprites.addSprite("weapons", "mini_napalm_bombs")
  sprites.addSprite("effects", "shotup_mini_repair_copter")
  sprites.addSprite("weapons", "deploy_mini_repair_copter")
  sprites.addSprite("weapons", "mini_repair_drop")

  -- deploys
  self:loadScript("deploys/tanks")
  self:loadScript("deploys/bots")
  self:loadScript("deploys/copters")

  -- texts
  modApi:addWeapon_Texts(self:loadScript("weapon_texts"))
end

function mod:load(options,version)
end

return mod
