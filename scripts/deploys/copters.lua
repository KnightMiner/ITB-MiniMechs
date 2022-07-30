------------
-- Common --
------------

-- Deployable is limited to ground, but copters are flying, so allow deploying over water and holes
local FlyingDeployable = Deployable:new{}
function FlyingDeployable:GetTargetArea(point)
	local ret = PointList()

	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = Point(point + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then
				break
			end

			if not self.OnlyEmpty or not Board:IsBlocked(curr, PATH_FLYER) then
				ret:push_back(curr)
			end

		end
	end

	return ret
end

--- Shared logic for the two leap attacks
Mini_Leap_Attack = Support_Smoke:new {
	Class = "Unique",
	Rarity = 0,
	Smoke = 0,
	PowerCost = 0,
	TargetEmpty = true
}
function Mini_Leap_Attack:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)

	-- make move
	local move = PointList()
	move:push_back(p1)
	move:push_back(p2)

	ret:AddBounce(p1, 2)
	if p1:Manhattan(p2) == 1 then
		ret:AddLeap(move, 0.5)--small delay between move and the damage, attempting to make the damage appear when jet is overhead
	else
		ret:AddLeap(move, 0.25)
	end

	-- add smoke
	for k = 1, (self.Range-1) do
		local point = p1 + DIR_VECTORS[dir]*k
		if point == p2 then
			break
		end

		if k > 1 then
			ret:AddDelay(self.AnimDelay)
		end

		if self.TargetEmpty or Board:IsPawnSpace(point) then
			local damage = SpaceDamage(p1 + DIR_VECTORS[dir]*k, self.Damage)
			damage.iSmoke = self.Smoke
			damage.iFire = self.Fire
			damage.iAcid = self.Acid
			damage.sAnimation = self.AttackAnimation
			damage.sSound = self.BombSound

			ret:AddDamage(damage)
			ret:AddBounce(p1 + DIR_VECTORS[dir]*k,3)
		end
	end

	return ret
end

-------------------------
-- Deploy Smoke Copter --
-------------------------

--- Unit
Mini_SmokeCopter = Pawn:new {
	Name           = "Smoke Copter",
	Health         = 1,
	MoveSpeed      = 3,
	Flying         = true,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_SmokeBombs" },
	-- display
	Image          = "mini_smoke_copter",
	SoundLocation  = "/support/support_drone",
	Corpse         = false
}
Mini_SmokeCopterA  = Mini_SmokeCopter:new { IgnoreSmoke = true }
Mini_SmokeCopterB  = Mini_SmokeCopter:new { SkillList = { "Mini_SmokeBombs_A" } }
Mini_SmokeCopterAB = Mini_SmokeCopter:new { IgnoreSmoke = true, SkillList = { "Mini_SmokeBombs_A" } }

Mini_SmokeBombs = Mini_Leap_Attack:new {
	Smoke           = 1,
	Upgrades        = 1,
	UpgradeCost     = {2},
	Icon            = "weapons/support_smoke.png",
	AttackAnimation = "mini_raining_smoke",
	TipImage        = {
		Unit       = Point(2,3),
		Enemy      = Point(2,2),
		Target     = Point(2,1),
		CustomPawn = "Mini_SmokeCopter"
	}
}
Mini_SmokeBombs_A = Mini_SmokeBombs:new {
	Range = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,0),
		CustomPawn = "Mini_SmokeCopterB"
	}
}

-- Equipable weapon
Mini_DeploySmokeCopter = FlyingDeployable:new{
	Deployed = "Mini_SmokeCopter",
	Rarity      = 3,
	PowerCost   = 1,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_smoke_copter.png",
  Projectile  = "effects/shotup_mini_smoke_copter.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(2,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1)
	}
}
Mini_DeploySmokeCopter_A = Mini_DeploySmokeCopter:new{
	Deployed = "Mini_SmokeCopterA",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Smoke         = Point(1,1),
		Enemy         = Point(2,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1)
	}
}
Mini_DeploySmokeCopter_B = Mini_DeploySmokeCopter:new{
	Deployed = "Mini_SmokeCopterB",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(2,1),
		Enemy2        = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(4,1)
	}
}
Mini_DeploySmokeCopter_AB = Mini_DeploySmokeCopter:new{
	Deployed = "Mini_SmokeCopterAB",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Smoke         = Point(1,1),
		Enemy         = Point(2,1),
		Enemy2        = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(4,1)
	}
}

--------------------------
-- Deploy Napalm Copter --
--------------------------

--- Unit
Mini_NapalmCopter = Pawn:new {
	Name           = "Napalm Copter",
	Health         = 1,
	MoveSpeed      = 3,
	Flying         = true,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_NapalmBombs" },
	-- display
	Image          = "mini_napalm_copter",
	SoundLocation  = "/support/support_drone",
	Corpse         = false
}
Mini_NapalmCopterA  = Mini_NapalmCopter:new { IgnoreFire = true }
Mini_NapalmCopterB  = Mini_NapalmCopter:new { SkillList = { "Mini_NapalmBombs_A" } }
Mini_NapalmCopterAB = Mini_NapalmCopter:new { IgnoreFire = true, SkillList = { "Mini_NapalmBombs_A" } }

Mini_NapalmBombs = Mini_Leap_Attack:new {
	Fire            = 1,
	Damage          = 1,
	Upgrades        = 1,
	UpgradeCost     = {2},
	Icon            = "weapons/mini_napalm_bombs.png",
	AttackAnimation = "ExploRaining1",
	TipImage = {
		Unit       = Point(2,3),
		Enemy      = Point(2,2),
		Target     = Point(2,1),
		CustomPawn = "Mini_NapalmCopter"
	}
}
Mini_NapalmBombs_A = Mini_NapalmBombs:new {
	Range = 3,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,2),
		Enemy2 = Point(2,1),
		Target = Point(2,0),
		CustomPawn = "Mini_NapalmCopterB"
	}
}

-- Equipable weapon
Mini_DeployNapalmCopter = FlyingDeployable:new{
	Deployed = "Mini_NapalmCopter",
	Rarity      = 2,
	PowerCost   = 1,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_napalm_copter.png",
  Projectile  = "effects/shotup_mini_napalm_copter.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(2,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1)
	}
}
Mini_DeployNapalmCopter_A = Mini_DeployNapalmCopter:new{
	Deployed = "Mini_NapalmCopterA",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Fire          = Point(1,1),
		Enemy         = Point(2,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1)
	}
}
Mini_DeployNapalmCopter_B = Mini_DeployNapalmCopter:new{
	Deployed = "Mini_NapalmCopterB",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(2,1),
		Enemy2        = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(4,1)
	}
}
Mini_DeployNapalmCopter_AB = Mini_DeployNapalmCopter:new{
	Deployed = "Mini_NapalmCopterAB",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Fire          = Point(1,1),
		Enemy         = Point(2,1),
		Enemy2        = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(4,1)
	}
}

--------------------------
-- Deploy Repair Copter --
--------------------------

--- Unit
Mini_RepairCopter = Pawn:new {
	Name           = "Napalm Copter",
	Health         = 1,
	MoveSpeed      = 3,
	Flying         = true,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_RepairDrop" },
	-- display
	Image          = "mini_repair_copter",
	SoundLocation  = "/support/support_drone",
	Corpse         = false
}
Mini_RepairCopterB  = Mini_RepairCopter:new { SkillList = { "Mini_RepairDrop_A" } }

Mini_RepairDrop = Mini_Leap_Attack:new {
	Damage          = -1,
	Fire            = EFFECT_REMOVE,
	Acid            = EFFECT_REMOVE,
	TargetEmpty     = false,
	Upgrades        = 1,
	UpgradeCost     = {2},
	Icon            = "weapons/mini_repair_drop.png",
	AttackAnimation = "mini_raining_health",
	TipImage        = {
		Unit             = Point(2,3),
		Friendly_Damaged = Point(2,2),
		Target           = Point(2,1),
		CustomPawn       = "Mini_RepairCopter"
	}
}
Mini_RepairDrop_A = Mini_RepairDrop:new {
	Range = 3,
	TipImage = {
		Unit              = Point(2,3),
		Friendly_Damaged  = Point(2,2),
		Friendly2_Damaged = Point(2,1),
		Target            = Point(2,0),
		CustomPawn        = "Mini_RepairCopterB"
	}
}

-- Equipable weapon
Mini_DeployRepairCopter = FlyingDeployable:new{
	Deployed = "Mini_RepairCopter",
	Rarity       = 4,
	PowerCost    = 1,
	Upgrades     = 2,
	UpgradeCost  = {1,2},
	ShieldDeploy = false,
	-- visuals
  Icon        = "weapons/deploy_mini_repair_copter.png",
  Projectile  = "effects/shotup_mini_repair_copter.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit             = Point(1,3),
		Target           = Point(1,1),
		Friendly_Damaged = Point(2,1),
		Second_Origin    = Point(1,1),
		Second_Target    = Point(3,1)
	}
}
Mini_DeployRepairCopter_A = Mini_DeployRepairCopter:new{
	ShieldDeploy = true
}
Mini_DeployRepairCopter_B = Mini_DeployRepairCopter:new{
	Deployed = "Mini_RepairCopterB",
	TipImage = {
		Unit              = Point(1,3),
		Target            = Point(1,1),
		Friendly_Damaged  = Point(3,1),
		Friendly2_Damaged = Point(2,1),
		Second_Origin     = Point(1,1),
		Second_Target     = Point(4,1)
	}
}
Mini_DeployRepairCopter_AB = Mini_DeployRepairCopter_B:new{
	ShieldDeploy = true,
	Deployed = "Mini_RepairCopterB"
}
-- shield upgrade
function Mini_DeployRepairCopter:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	-- add copter
	local damage = SpaceDamage(p2,0)
	damage.sPawn = self.Deployed
	ret:AddArtillery(damage,self.Projectile)
	-- add shield if requested
	if self.ShieldDeploy then
		damage = SpaceDamage(p2, 0)
		damage.iShield = EFFECT_CREATE
		ret:AddDamage(damage)
	end

	return ret
end
