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
    {
      Name = "mini_shrapneltank",
      Default  = { PosX = -15, PosY = 7 },
      Animated = { PosX = -15, PosY = 7, NumFrames = 2 },
      Death    = { PosX = -21, PosY = 3, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -21, PosY = 3 },
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
    },
    -- artillery
    {
      Name    = "mini_unstable_artillery",
      Default  = { PosX = -15, PosY =  7 },
      Animated = { PosX = -15, PosY =  6, NumFrames = 4 },
      Death    = { PosX = -19, PosY = -2, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = -2 },
      Icon     = {}
    },
    {
      Name    = "mini_freeze_artillery",
      Default  = { PosX = -15, PosY =  7 },
      Animated = { PosX = -15, PosY =  6, NumFrames = 4 },
      Death    = { PosX = -19, PosY = -2, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = -2 },
      Icon     = {}
    },
    {
      Name    = "mini_rock_artillery",
      Default  = { PosX = -15, PosY =  7 },
      Animated = { PosX = -15, PosY =  6, NumFrames = 4 },
      Death    = { PosX = -19, PosY = -2, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = -2 },
      Icon     = {}
    },
    {
      Name    = "mini_volcano_rock",
      Default = { PosX = -18, PosY = -1 },
      Death   = { PosX = -34, PosY = -9, NumFrames = 13, Time = 0.09, Loop = false }
    }
  )
  -- tanks
  sprites.addSprite("effects", "shotup_mini_mirrortank")
  sprites.addSprite("weapons", "deploy_mini_mirrortank")
  sprites.addSprite("effects", "shotup_mini_shrapneltank")
  sprites.addSprite("weapons", "deploy_mini_shrapneltank")
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
  -- artillery
  sprites.addSprite("effects", "shotup_mini_unstable_artillery")
  sprites.addSprite("weapons", "deploy_mini_unstable_artillery")
  sprites.addSprite("effects", "shotup_mini_freeze_artillery")
  sprites.addSprite("effects", "shotup_mini_freeze_mine")
  sprites.addSprite("weapons", "deploy_mini_freeze_artillery")
  sprites.addSprite("weapons", "deploy_mini_freeze_mine")
  sprites.addSprite("effects", "shotup_mini_rock_artillery")
  sprites.addSprite("effects", "shotup_mini_volcano_rock")
  sprites.addSprite("weapons", "deploy_mini_rock_artillery")
  -- animations
  sprites.addAnimation("effects", "mini_raining_smoke", {
    NumFrames = 6,
    Time = 0.045,
    PosX = -20,
    PosY = -38
  })
  sprites.addAnimation("effects", "mini_raining_health", {
    NumFrames = 3,
    Time = 0.0225,
    PosX = -20,
    PosY = -38
  })

  -- deploys
  self:loadScript("deploys/tanks")
  self:loadScript("deploys/bots")
  self:loadScript("deploys/copters")
  self:loadScript("deploys/artillery")

  -- texts
  local texts = self:loadScript("weapon_texts")
  modApi:addWeapon_Texts(texts)

  -- add weapons to the shop
  local shop = self:loadScript("libs/shop")
  for _, id in ipairs({
    "Mini_DeployKnightBot", "Mini_DeployLaserBot", "Mini_DeployJudoBot", "Mini_DeployLeapBot",
    "Mini_DeploySmokeCopter", "Mini_DeployNapalmCopter", "Mini_DeployRepairCopter",
    "Mini_DeployMirrorTank", "Mini_DeployShrapnelTank",
    "Mini_DeployUnstableArtillery", "Mini_DeployFreezeArtillery"
  }) do
    local name = texts[id .. "_Name"]
    shop:addWeapon({
      id = id,
      name = "Add Deploy " .. name .. " to runs",
      desc = "Add Deploy " .. name .. " to the store, timepods, and perfect island rewards."
    })
  end
end

function mod:load(options,version)
  self:loadScript("libs/shop"):load(options)
end

return mod
