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


------------------------
-- Deploy Terraformer --
------------------------

--- Unit
Mini_Terraformer = Pawn:new {
	Name           = "Terraformer",
	Health         = 2,
	MoveSpeed      = 0,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_Terraform" },
	Pushable       = false,
	Corpse         = false,
	-- display
	Image          = "mini_tower",
  ImageOffset     = modApi:getPaletteImageOffset("Flame Behemoths"),
	SoundLocation  = "/support/earthmover/"
}
Mini_TerraformerA  = Mini_Terraformer:new { SkillList = { "Mini_Terraform_A" } }
Mini_TerraformerB  = Mini_Terraformer:new { SkillList = { "Mini_Terraform_B" } }
Mini_TerraformerAB = Mini_Terraformer:new { SkillList = { "Mini_Terraform_AB" } }

-- Weapon
Mini_Terraform = SquareTargetSkill:new{
	Class       = "Unique",
	Rarity      = 0,
	Damage      = 0,
	Range       = 2,
  UsesPerTurn = 2,
	PowerCost   = 0,
	Upgrades    = 2,
	UpgradeCost = {1, 3},
	-- display
	Icon = "weapons/mini_terraform.png",
	LaunchSound = "/props/lava_tile",
  TipImage = {
		Unit          = Point(2,3),
		Hole          = Point(3,1),
    Target        = Point(3,1),
    Second_Origin = Point(2,3),
    Second_Target = Point(2,1)
	}
}

Mini_Terraform_A = Mini_Terraform:new{ UsesPerTurn = 3 }
Mini_Terraform_B = Mini_Terraform:new{ Range = 3 }
Mini_Terraform_AB = Mini_Terraform_A:new{ Range = 3 }

function Mini_Terraform:IsValidTarget(point)
  return not Board:IsPawnSpace(point) and not Board:IsSpawning(point)
end

-- clear out terraformer uses each turn
modApi.events.onNextTurn:subscribe(function(mission)
  mission.MiniTerraformUses = nil
end)

-- lets the terraformer be used multiple times per turn
function Mini_Terraform.UpdateUseCount(id, maxUses)
  local mission = GetCurrentMission()
  if mission then
    if not mission.MiniTerraformUses then
      mission.MiniTerraformUses = {}
    end
    -- if we have not yet reached max uses, set the pawn to active again
    mission.MiniTerraformUses[id] = (mission.MiniTerraformUses[id] or 0) + 1
    if mission.MiniTerraformUses[id] < maxUses then
    	local pawn = Board:GetPawn(id)
      modApi:runLater(function()
        pawn:SetActive(true)
      end)
    end
  end
end

function Mini_Terraform:GetSkillEffect(p1, p2)
  local ret = SkillEffect()

  -- mountains and buildings - break
  if Board:IsTerrain(p2, TERRAIN_MOUNTAIN) or Board:IsBuilding(p2) then
    ret:AddDamage(SpaceDamage(p2, DAMAGE_DEATH))
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

  -- add another use if we have more than 1
  if self.UsesPerTurn > 1 and not IsTestMechScenario() then
		ret:AddScript(string.format("Mini_Terraform.UpdateUseCount(%d, %d)", Pawn:GetId(), self.UsesPerTurn))
  end

  return ret
end

-- Deploy
Mini_DeployTerraformer = Deployable:new{
	Deployed = "Mini_Terraformer",
	Rarity      = 4,
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_terraformer.png",
  Projectile  = "effects/shotup_mini_terraformer.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
  TipImage = {
		Unit          = Point(2,3),
		Target        = Point(2,1),
    Second_Origin = Point(2,1),
    Second_Target = Point(3,2)
	}
}

Mini_DeployTerraformer_A  = Mini_DeployTerraformer:new{ Deployed = "Mini_TerraformerA" }
Mini_DeployTerraformer_B  = Mini_DeployTerraformer:new{ Deployed = "Mini_TerraformerB" }
Mini_DeployTerraformer_AB = Mini_DeployTerraformer:new{ Deployed = "Mini_TerraformerAB" }
}
