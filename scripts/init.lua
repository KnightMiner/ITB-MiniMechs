local mod = {
  id = "mini_mechs",
  name = "Mini Mechs",
  version = "1.0.0",
  requirements = {},
  modApiVersion = "2.5.3",
  icon = "img/units/mission/mini_judobot_ns.png"
}

--- List of deployables found in vanilla
local VANILLA_DEPLOYS = {
  "DeploySkill_Tank", "DeploySkill_ShieldTank", "DeploySkill_AcidTank", "DeploySkill_IceTank", "DeploySkill_PullTank",
}

--[[--
  Helper function to load mod scripts

  @param  name   Script path relative to mod directory
]]
function mod:loadScript(path)
  return require(self.scriptPath..path)
end

--[[--
  Fixes skill names in pawns

  @param name  Weapon name to fix
]]
function fixWeaponTexts(name)
  -- get name and description
  local base = _G[name]
  base.Name = Weapon_Texts[name .. "_Name"]
  base.Description = Weapon_Texts[name .. "_Description"]
  -- upgrade A description
  for _, key in ipairs({"_A", "_B"}) do
    local fullName = name .. key
    local upgrade = _G[fullName]
    if upgrade ~= nil then
      upgrade.UpgradeDescription =  Weapon_Texts[fullName .. "_UpgradeDescription"]
    end
  end
end

function mod:metadata()
end

function mod:init()
  self:loadScript("libs/multiFire"):init("MiniMechsMultiFire")
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
      Default  = { PosX = -19, PosY = -4,  },
      Animated = { PosX = -19, PosY = -4, NumFrames = 4 },
      Death    = { PosX = -20, PosY = -7, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = -4 },
      Icon     = {}
    },
    {
      Name = "mini_laserbot",
      Default  = { PosX = -15, PosY = -5 },
      Animated = { PosX = -15, PosY = -5, NumFrames = 4 },
      Death    = { PosX = -19, PosY = -9, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -15, PosY = -5 },
      Icon     = {}
    },
    {
      Name = "mini_judobot",
      Default  = { PosX = -15, PosY = -1 },
      Animated = { PosX = -15, PosY = -1, NumFrames = 4 },
      Death    = { PosX = -19, PosY = -5, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -15, PosY = -1 },
      Icon     = {}
    },
    {
      Name = "mini_leapbot",
      Default  = { PosX = -14, PosY =  -5 },
      Animated = { PosX = -15, PosY =  -5, NumFrames = 4 },
      Death    = { PosX = -20, PosY = -10, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -14, PosY =  -5 },
      Icon     = {}
    },
    -- copters
    {
      Name    = "mini_smoke_copter",
      Default  = { PosX = -15, PosY = 0 },
      Animated = { PosX = -15, PosY = 0, NumFrames = 4 },
      Death    = { PosX = -19, PosY = 1, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = 1 },
      Icon     = {}
    },
    {
      Name    = "mini_napalm_copter",
      Default  = { PosX = -15, PosY = 0 },
      Animated = { PosX = -15, PosY = 0, NumFrames = 4 },
      Death    = { PosX = -19, PosY = 1, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = 1 },
      Icon     = {}
    },
    {
      Name    = "mini_repair_copter",
      Default  = { PosX = -15, PosY = 0 },
      Animated = { PosX = -15, PosY = 0, NumFrames = 4 },
      Death    = { PosX = -19, PosY = 1, NumFrames = 11, Time = 0.14, Loop = false },
      Broken   = { PosX = -19, PosY = 1 },
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
  sprites.addMechs(
    {
      Name = "mini_tower",
      Default  = { PosX = -17, PosY = -10 },
      Animated = { PosX = -17, PosY = -12, NumFrames = 4 },
      Broken   = { PosX = -17, PosY = -10 },
      Death    = { PosX = -21, PosY = -13, NumFrames = 11, Time = 0.14, Loop = false },
      Icon     = {},
      NoHanger = true
    }
  )
  -- tanks
  sprites.addSprite("effects", "shotup_mini_mirrortank")
  sprites.addSprite("weapons", "deploy_mini_mirrortank")
  sprites.addSprite("effects", "shotup_mini_shrapneltank")
  sprites.addSprite("weapons", "deploy_mini_shrapneltank")
  -- bots
  sprites.addSprite("effects", "shotup_mini_knightbot")
  sprites.addSprite("weapons", "deploy_mini_knightbot")
  sprites.addSprite("effects", "shotup_mini_laserbot")
  sprites.addSprite("weapons", "deploy_mini_laserbot")
  sprites.addSprite("effects", "shotup_mini_judobot")
  sprites.addSprite("weapons", "deploy_mini_judobot")
  sprites.addSprite("effects", "shotup_mini_leapbot")
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
  sprites.addIcon("combat/icons", "icon_deploy_mine", Point(-13,14))
  sprites.addSprite("effects", "shotup_mini_rock_artillery")
  sprites.addSprite("effects", "shotup_mini_volcano_rock")
  sprites.addSprite("weapons", "deploy_mini_rock_artillery")
  -- towers
  sprites.addSprite("effects", "shotup_mini_wind_tower")
  sprites.addSprite("weapons", "deploy_mini_wind_tower")
  sprites.addSprite("effects", "shotup_mini_geoformer")
  sprites.addSprite("weapons", "deploy_mini_geoformer")
  sprites.addSprite("weapons", "mini_geoform")
  sprites.addSprite("effects", "shotup_mini_storm_tower")
  sprites.addSprite("weapons", "deploy_mini_storm_tower")
  sprites.addSprite("weapons", "mini_lightning_strike")
  sprites.addSprite("effects", "shotup_mini_overdriver")
  sprites.addSprite("weapons", "deploy_mini_overdriver")
  sprites.addSprite("weapons", "mini_overdrive")
  sprites.addIcon("combat/icons", "mini_fill_icon", Point(-10,12))
  sprites.addIcon("combat/icons", "mini_lava_icon", Point(-10,12))
  sprites.addIcon("combat/icons", "mini_overdrive_icon", Point(-10,12))
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
  self:loadScript("deploys/towers")

  -- texts
  local texts = self:loadScript("weapon_texts")
  modApi:addWeapon_Texts(texts)

  -- add weapons to the shop
  for _, id in ipairs({
    "Mini_DeployKnightBot", "Mini_DeployLaserBot", "Mini_DeployJudoBot", "Mini_DeployLeapBot",
    "Mini_DeploySmokeCopter", "Mini_DeployNapalmCopter", "Mini_DeployRepairCopter",
    "Mini_DeployMirrorTank", "Mini_DeployShrapnelTank",
    "Mini_DeployUnstableArtillery", "Mini_DeployFreezeArtillery", "Mini_DeployRockArtillery",
    "Mini_DeployWindTower", "Mini_DeployGeoformer", "Mini_DeployStormTower", "Mini_DeployOverdriver"
  }) do
    modApi:addWeaponDrop(id, true)
    fixWeaponTexts(id)
  end
  -- fix deploy weapon texts
  for _, id in ipairs({
    "Mini_KnightCharge", "Mini_Laserbeam", "Mini_JudoThrow", "Mini_Boosters",
    "Mini_SmokeBombs", "Mini_NapalmBombs", "Mini_RepairDrop",
    "Mini_Mirrorshot",
    "Mini_UnstableArtShot", "Mini_DeployFreezeMine", "Mini_RockThrow",
    "Mini_WindTorrent", "Mini_Geoform", "Mini_LightningStrike", "Mini_Overdrive"
  }) do
    fixWeaponTexts(id)
  end
end

function mod:load(options,version)
end

return mod
