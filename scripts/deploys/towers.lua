local mod = mod_loader.mods[modApi.currentMod]
local multiFire = mod:loadScript("libs/multiFire")

-- Skill that targets anything in a square around the unit
local SquareTargetSkill = Skill:new{
  Range      = 2,
  TargetSelf = false
}

-- return true for a point if it can be targeted by this weapon
function SquareTargetSkill:IsValidTarget(point)
  return true
end

function SquareTargetSkill:GetTargetArea(p1)
  local ret = PointList()

  for i = -self.Range, self.Range do
    for j = -self.Range, self.Range do
      local point = Point(p1.x + i, p1.y + j)
      if Board:IsValid(point)
          and (self.TargetSelf or i ~= 0 or j ~= 0)
          and self:IsValidTarget(point) then
        ret:push_back(point)
      end
    end
  end

  return ret
end


-----------------------
-- Deploy Wind Tower --
-----------------------

--- Unit
Mini_WindTower = Pawn:new {
  Name           = "Wind Tower",
  Health         = 2,
  MoveSpeed      = 0,
  DefaultTeam    = TEAM_PLAYER,
  ImpactMaterial = IMPACT_METAL,
  SkillList      = { "Mini_WindTorrent" },
  Pushable       = false,
  Corpse         = false,
  -- display
  Image          = "mini_tower",
  ImageOffset     = modApi:getPaletteImageOffset("Steel Judoka"),
  SoundLocation  = "/support/earthmover/"
}
Mini_WindTowerA  = Mini_WindTower:new { SkillList = { "Mini_WindTorrent_A" } }
Mini_WindTowerB  = Mini_WindTower:new { SkillList = { "Mini_WindTorrent_B" } }
Mini_WindTowerAB = Mini_WindTower:new { SkillList = { "Mini_WindTorrent_AB" } }

-- Weapon
Mini_WindTorrent = Support_Wind:new{
  Range    = 2,
  Limited  = 0,
  PushAway = false,
  Upgrades = 2,
  UpgradeCost = { 1, 2 },
}

Mini_WindTorrent_A  = Mini_WindTorrent:new{
  PushAway = true,
  TipImage = {
    Unit = Point(2,2),
    Enemy = Point(2,1),
    Enemy2 = Point(3,2),
    Enemy3 = Point(0,2),
    Mountain = Point(3,1),
    Friendly = Point(1,2),
    Target = Point(3,3),
  }
}
Mini_WindTorrent_B  = Mini_WindTorrent:new{ Range = 3 }
Mini_WindTorrent_AB = Mini_WindTorrent_A:new{ Range = 3 }

local originalTargetArea = Support_Wind.GetTargetArea
function Support_Wind:GetTargetArea(point)
  local ret = originalTargetArea(self, point)

  if self.PushAway then
    ret:push_back(Point(3,3))
    ret:push_back(Point(3,4))
    ret:push_back(Point(4,3))
    ret:push_back(Point(4,4))
  end

  return ret
end

-- mostly a clone of wind torrent, targets different units
function Mini_WindTorrent:GetSkillEffect(p1, p2)
  local ret = SkillEffect()
  local dir = DIR_NONE

  if p2.x == 1 or p2.x == 2 then dir = DIR_LEFT
  elseif p2.x == 5 or p2.x == 6 then dir = DIR_RIGHT
  elseif p2.y == 1 or p2.y == 2 then dir = DIR_UP
  elseif p2.y == 5 or p2.y == 6 then dir = DIR_DOWN end

  -- new feature: push away
  if dir == DIR_NONE then
    for i = self.Range, 1, -1 do
      for dir = DIR_START, DIR_END do
        local point = DIR_VECTORS[dir] * i + p1
        if Board:IsValid(point) and Board:IsPawnSpace(point) then
          ret:AddDamage(SpaceDamage(point, 0, dir))
        end
      end
      ret:AddDelay(0.2)
    end
  else
    ret:AddEmitter(Point(3,3),"Emitter_Wind_"..dir)
    ret:AddEmitter(Point(4,4),"Emitter_Wind_"..dir)

    local iRange, iOffset
    if dir == DIR_RIGHT or dir == DIR_DOWN then
      iRange = -self.Range
      iOffset = -1
    else
      iRange = self.Range
      iOffset = 1
    end

    for i = -iRange, iRange, iOffset do
      for j = -self.Range, self.Range do
        local point
        if dir == DIR_UP or dir == DIR_DOWN then
          point = Point(p1.x + j, p1.y + i)
        else
          point = Point(p1.x + i, p1.y + j)
        end
        if Board:IsValid(point) and Board:IsPawnSpace(point) then
          ret:AddDamage(SpaceDamage(point, 0, dir))
          ret:AddDelay(0.2)
        end
      end
    end
  end

  return ret
end

-- Deploy
Mini_DeployWindTower = Deployable:new{
  Deployed = "Mini_WindTower",
  Rarity      = 4,
  PowerCost   = 2,
  Upgrades    = 2,
  UpgradeCost = {1, 2},
  -- visuals
  Icon        = "weapons/deploy_mini_wind_tower.png",
  Projectile  = "effects/shotup_mini_wind_tower.png",
  LaunchSound = "/weapons/deploy_tank",
  ImpactSound = "/impact/generic/mech",
  TipImage = {
    Unit          = Point(0,3),
    Enemy         = Point(2,1),
    Enemy2        = Point(3,2),
    Enemy3        = Point(0,2),
    Mountain      = Point(3,1),
    Friendly      = Point(1,2),
    Target        = Point(2,3),
    Second_Origin = Point(2,3),
    Second_Target = Point(3,2)
  }
}
Mini_DeployWindTower_A  = Mini_DeployWindTower:new{
  Deployed = "Mini_WindTowerA",
  TipImage = {
    Unit          = Point(0,2),
    Enemy         = Point(2,1),
    Enemy2        = Point(3,2),
    Enemy3        = Point(0,3),
    Mountain      = Point(3,1),
    Friendly      = Point(1,2),
    Target        = Point(2,2),
    Second_Origin = Point(2,2),
    Second_Target = Point(3,3)
  }
}
Mini_DeployWindTower_B  = Mini_DeployWindTower:new{ Deployed = "Mini_WindTowerB" }
Mini_DeployWindTower_AB = Mini_DeployWindTower:new{ Deployed = "Mini_WindTowerAB" }


----------------------
-- Deploy Geoformer --
----------------------

--- Unit
Mini_Geoformer = Pawn:new {
  Name           = "Geoformer",
  Health         = 2,
  MoveSpeed      = 0,
  DefaultTeam    = TEAM_PLAYER,
  ImpactMaterial = IMPACT_METAL,
  SkillList      = { "Mini_Geoform" },
  Pushable       = false,
  Corpse         = false,
  -- display
  Image          = "mini_tower",
  ImageOffset     = modApi:getPaletteImageOffset("Flame Behemoths"),
  SoundLocation  = "/support/earthmover/"
}
Mini_GeoformerA  = Mini_Geoformer:new { SkillList = { "Mini_Geoform_A" } }
Mini_GeoformerB  = Mini_Geoformer:new { SkillList = { "Mini_Geoform_B" } }
Mini_GeoformerAB = Mini_Geoformer:new { SkillList = { "Mini_Geoform_AB" } }

-- Weapon
Mini_Geoform = SquareTargetSkill:new{
  Class       = "Unique",
  Rarity      = 0,
  Damage      = 0,
  Range       = 2,
  UsesPerTurn = 2,
  PowerCost   = 0,
  Upgrades    = 2,
  UpgradeCost = {1, 3},
  -- display
  Icon = "weapons/mini_geoform.png",
  LaunchSound = "/props/lava_tile",
  TipImage = {
    Unit          = Point(2,3),
    Hole          = Point(3,1),
    Target        = Point(3,1),
    Second_Origin = Point(2,3),
    Second_Target = Point(2,1)
  }
}

Mini_Geoform_A = Mini_Geoform:new{ UsesPerTurn = 3 }
Mini_Geoform_B = Mini_Geoform:new{ Range = 3 }
Mini_Geoform_AB = Mini_Geoform_A:new{ Range = 3 }

function Mini_Geoform:IsValidTarget(point)
  return not Board:IsPawnSpace(point)
end

function Mini_Geoform:GetSkillEffect(p1, p2)
  local ret = SkillEffect()

  -- mountains and buildings - break
  if Board:IsTerrain(p2, TERRAIN_MOUNTAIN) or Board:IsBuilding(p2) then
    ret:AddDamage(SpaceDamage(p2, DAMAGE_DEATH))
  elseif Board:IsSpawning(p2) then
    -- spawns: rock
    local damage = SpaceDamage(p2, 0)
    damage.sPawn = "Wall" -- better spawn animation than thrown rock
    ret:AddDamage(damage)
  elseif Board:IsTerrain(p2, TERRAIN_WATER) or Board:IsTerrain(p2, TERRAIN_HOLE) or Board:IsTerrain(p2, TERRAIN_LAVA) then
  -- holes: fill
    local damage = SpaceDamage(p2, 0)
    damage.iTerrain = TERRAIN_ROAD
    damage.sImageMark = "combat/icons/mini_fill_icon.png"
    ret:AddDamage(damage)
    ret:AddBounce(p2, -6)
  else
  -- anything else: lava
    local damage = SpaceDamage(p2, 0)
    damage.iTerrain = TERRAIN_LAVA
    damage.sImageMark = "combat/icons/mini_lava_icon.png"
    ret:AddDamage(damage)
  end

  -- add additional uses
  multiFire:UpdateUseCount(ret, Pawn, self.UsesPerTurn)

  return ret
end

-- Deploy
Mini_DeployGeoformer = Deployable:new{
  Deployed = "Mini_Geoformer",
  Rarity      = 4,
  PowerCost   = 2,
  Upgrades    = 2,
  UpgradeCost = {1,2},
  -- visuals
  Icon        = "weapons/deploy_mini_geoformer.png",
  Projectile  = "effects/shotup_mini_geoformer.png",
  LaunchSound = "/weapons/deploy_tank",
  ImpactSound = "/impact/generic/mech",
  TipImage = {
    Unit          = Point(2,3),
    Target        = Point(2,1),
    Second_Origin = Point(2,1),
    Second_Target = Point(3,2)
  }
}

Mini_DeployGeoformer_A  = Mini_DeployGeoformer:new{ Deployed = "Mini_GeoformerA" }
Mini_DeployGeoformer_B  = Mini_DeployGeoformer:new{ Deployed = "Mini_GeoformerB" }
Mini_DeployGeoformer_AB = Mini_DeployGeoformer:new{ Deployed = "Mini_GeoformerAB" }


------------------------
-- Deploy Storm Tower --
------------------------

--- Unit
Mini_StormTower = Pawn:new {
  Name           = "Storm Tower",
  Health         = 2,
  MoveSpeed      = 0,
  DefaultTeam    = TEAM_PLAYER,
  ImpactMaterial = IMPACT_METAL,
  SkillList      = { "Mini_LightningStrike" },
  Pushable       = false,
  Corpse         = false,
  -- display
  Image          = "mini_tower",
  ImageOffset     = modApi:getPaletteImageOffset("Blitzkrieg"),
  SoundLocation  = "/support/earthmover/"
}
Mini_StormTowerA  = Mini_StormTower:new { SkillList = { "Mini_LightningStrike_A" } }
Mini_StormTowerB  = Mini_StormTower:new { SkillList = { "Mini_LightningStrike_B" } }
Mini_StormTowerAB = Mini_StormTower:new { SkillList = { "Mini_LightningStrike_AB" } }

-- Weapon
Mini_LightningStrike = SquareTargetSkill:new{
  Class       = "Unique",
  Rarity      = 0,
  Damage      = 2,
  Range       = 2,
  PowerCost   = 0,
  Upgrades    = 2,
  UpgradeCost = {2,2},
  -- display
  Icon = "weapons/mini_lightning_strike.png",
  TipImage = {
    Unit          = Point(2,3),
    Enemy         = Point(2,1),
    Target        = Point(2,1)
  }
}
Mini_LightningStrike_A  = Mini_LightningStrike:new{ Damage = 3 }
Mini_LightningStrike_B  = Mini_LightningStrike:new{ Range = 3 }
Mini_LightningStrike_AB = Mini_LightningStrike_A:new{ Range = 3 }

function Mini_LightningStrike:GetSkillEffect(p1, p2)
  local ret = SkillEffect()

  -- TODO: custom skill tooltip?
  ret:AddSound("/props/lightning_strike")
  ret:AddDelay(1)
  local damage = SpaceDamage(p2, self.Damage, DIR_FLIP)
  damage.sAnimation = "LightningBolt0"
  ret:AddDamage(damage)

  return ret
end


-- Deploy
Mini_DeployStormTower = Deployable:new{
  Deployed = "Mini_StormTower",
  Rarity      = 4,
  PowerCost   = 2,
  Upgrades    = 2,
  UpgradeCost = {2,2},
  -- visuals
  Icon        = "weapons/deploy_mini_storm_tower.png",
  Projectile  = "effects/shotup_mini_storm_tower.png",
  LaunchSound = "/weapons/deploy_tank",
  ImpactSound = "/impact/generic/mech",
  TipImage = {
    Unit          = Point(2,3),
    Enemy         = Point(3,2),
    Target        = Point(2,1),
    Second_Origin = Point(2,1),
    Second_Target = Point(3,2)
  }
}
Mini_DeployStormTower_A  = Mini_DeployStormTower:new{ Deployed = "Mini_StormTowerA" }
Mini_DeployStormTower_B  = Mini_DeployStormTower:new{ Deployed = "Mini_StormTowerB" }
Mini_DeployStormTower_AB = Mini_DeployStormTower:new{ Deployed = "Mini_StormTowerAB" }


-----------------------
-- Deploy Overdriver --
-----------------------

--- Unit
Mini_Overdriver = Pawn:new {
  Name           = "Overdriver",
  Health         = 2,
  MoveSpeed      = 0,
  DefaultTeam    = TEAM_PLAYER,
  ImpactMaterial = IMPACT_METAL,
  SkillList      = { "Mini_Overdrive" },
  Pushable       = false,
  Corpse         = false,
  -- display
  Image          = "mini_tower",
  ImageOffset     = modApi:getPaletteImageOffset("Secret Squad"),
  SoundLocation  = "/support/earthmover/"
}
Mini_OverdriverA  = Mini_Overdriver:new { SkillList = { "Mini_Overdrive_A" } }
Mini_OverdriverB  = Mini_Overdriver:new { SkillList = { "Mini_Overdrive_B" } }
Mini_OverdriverAB = Mini_Overdriver:new { SkillList = { "Mini_Overdrive_AB" } }

-- Weapon
Mini_Overdrive = SquareTargetSkill:new{
  Class       = "Unique",
  Rarity      = 0,
  Damage      = 0,
  Range       = 2,
  PowerCost   = 0,
  Limited     = 2,
  Upgrades    = 2,
  UpgradeCost = {2,2},
  -- display
  Icon = "weapons/mini_overdrive.png",
  TipImage = {
    Unit          = Point(2,3),
    Friendly      = Point(2,1),
    Target        = Point(2,1)
  }
}
Mini_Overdrive_A = Mini_Overdrive:new{ Limited = 3 }
Mini_Overdrive_B = Mini_Overdrive:new{ Range = 3 }
Mini_Overdrive_AB = Mini_Overdrive_A:new{ Range = 3 }

function Mini_Overdrive:IsValidTarget(point)
  local target = Board:GetPawn(point)
  if target and not target:IsDead() and not target:IsActive()
      and not isEnemy(Pawn:GetTeam(), target:GetTeam()) then
    return true
  end
  return false
end

function Mini_Overdrive:GetSkillEffect(p1, p2)
  local ret = SkillEffect()

  -- power on unit again
  ret:AddSound("/enemy/shared/robot_power_on")
  ret:AddScript(string.format([[
    local p = %s
    local unit = Board:GetPawn(p)
    if unit then
      unit:SetActive(true)
      Board:Ping(p, GL_Color(128, 0, 255))
    end]],
    p2:GetString()
  ))

  local icon = SpaceDamage(p2, 0)
  icon.sImageMark = "combat/icons/mini_overdrive_icon.png"
  ret:AddDamage(icon)

  -- self damgae when activating mechs
  local target = Board:GetPawn(p2)
  if target and target:IsMech() and self.Damage > 0 then
    ret:AddDamage(SpaceDamage(target, self.Damage))
  end

  return ret
end

-- Deploy
Mini_DeployOverdriver = Deployable:new{
  Deployed = "Mini_Overdriver",
  Rarity      = 4,
  PowerCost   = 2,
  Upgrades    = 2,
  UpgradeCost = {2,2},
  -- visuals
  Icon        = "weapons/deploy_mini_overdriver.png",
  Projectile  = "effects/shotup_mini_overdriver.png",
  LaunchSound = "/weapons/deploy_tank",
  ImpactSound = "/impact/generic/mech",
  TipImage = {
    Unit          = Point(2,3),
    Friendly      = Point(1,2),
    Target        = Point(2,1),
    Second_Origin = Point(2,1),
    Second_Target = Point(1,2)
  }
}
Mini_DeployOverdriver_A = Mini_DeployOverdriver:new{ Deployed = "Mini_OverdriverA" }
Mini_DeployOverdriver_B = Mini_DeployOverdriver:new{ Deployed = "Mini_OverdriverB" }
Mini_DeployOverdriver_AB = Mini_DeployOverdriver:new{ Deployed = "Mini_OverdriverAB" }

function Mini_DeployOverdriver:GetSkillEffect(p1, p2)
  local ret = SkillEffect()
  local damage = SpaceDamage(p2,0)
  damage.sPawn = self.Deployed
  ret:AddArtillery(damage,self.Projectile)
  -- for some reason the overdriver spawns with only 1 use remaining despite having 2, so just reset it to the full amount
  ret:AddScript("Board:GetPawn("..p2:GetString().."):ResetUses()")
  return ret
end
