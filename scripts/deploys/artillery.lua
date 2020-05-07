------------------------
-- Unstable Artillery --
------------------------

--- Unit
Mini_UnstableArtillery = Pawn:new {
	Name           = "Unstable Artillery",
	Health         = 1,
	MoveSpeed      = 2,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_UnstableArtShot" },
	-- display
	Image          = "mini_unstable_artillery",
	SoundLocation  = "/mech/distance/artillery/",
	Corpse         = false
}
Mini_UnstableArtilleryA  = Mini_UnstableArtillery:new { Armor = true }
Mini_UnstableArtilleryB  = Mini_UnstableArtillery:new { SkillList = { "Mini_UnstableArtShot_A" } }
Mini_UnstableArtilleryAB = Mini_UnstableArtillery:new { Armor = true, SkillList = { "Mini_UnstableArtShot_A" } }

--- Unit weapon
Mini_UnstableArtShot = LineArtillery:new{
	Class = "Unique",
	Range = RANGE_ARTILLERY,
	Damage = 1,
	Rarity = 0,
	-- upgrades
	DoubleShot = false,
	Upgrades    = 1,
	UpgradeCost = {2},
	-- Display
	Explosion = "",
	Icon = "weapons/ranged_artillery.png",
	UpShot = "effects/shotup_tribomb_missile.png",
	LaunchSound = "/support/civilian_artillery/fire",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Mini_UnstableArtillery",
	}
}
Mini_UnstableArtShot_A = Mini_UnstableArtShot:new{
	Double = true
}

function Mini_UnstableArtShot:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2-p1)

	-- artillery shot
	ret:AddArtillery(SpaceDamage(p2, self.Damage, dir), self.UpShot, 0.5)

	-- push self back
	ret:AddDamage(SpaceDamage(p1, 0, (dir + 2) % 4))

	-- second artillery shot
	if self.Double then
		local double = p2 + DIR_VECTORS[dir]
		if Board:IsValid(double) then
			local secondShot = SpaceDamage(double, self.Damage, dir)
			secondShot.bHidePath = true
			ret:AddArtillery(secondShot, self.UpShot, FULL_DELAY)
			if not Board:IsBlocked(double, PATH_FLYER) then
				-- fake move so the tooltip looks right
				-- both missiles will hit the target basically
				local move = PointList()
				move:push_back(p2)
				move:push_back(double)
				ret:AddMove(move, FULL_DELAY)
			end
		end
	end

	return ret
end

-- Equipable weapon
Mini_DeployUnstableArtillery = Deployable:new{
	Deployed = "Mini_UnstableArtillery",
	Rarity      = 2,
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_unstable_artillery.png",
  Projectile  = "effects/shotup_mini_unstable_artillery.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1)
	},
}
Mini_DeployUnstableArtillery_A = Mini_DeployUnstableArtillery:new{
	Deployed = "Mini_UnstableArtilleryA"
}
Mini_DeployUnstableArtillery_B = Mini_DeployUnstableArtillery:new{
	Deployed = "Mini_UnstableArtilleryB"
}
Mini_DeployUnstableArtillery_AB = Mini_DeployUnstableArtillery:new{
	Deployed = "Mini_UnstableArtilleryAB"
}

----------------------
-- Freeze Artillery --
----------------------

--- Unit
Mini_FreezeArtillery = Pawn:new {
	Name           = "Freeze Artillery",
	Health         = 1,
	MoveSpeed      = 2,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_DeployFreezeMine" },
	-- display
	Image          = "mini_freeze_artillery",
	SoundLocation  = "/mech/distance/artillery/",
	Corpse         = false
}
Mini_FreezeArtilleryA  = Mini_FreezeArtillery:new { Armor = true }
Mini_FreezeArtilleryB  = Mini_FreezeArtillery:new { SkillList = { "Mini_DeployFreezeMine_A" } }
Mini_FreezeArtilleryAB = Mini_FreezeArtillery:new { Armor = true, SkillList = { "Mini_DeployFreezeMine_A" } }

--- Unit weapon
Mini_DeployFreezeMine = LineArtillery:new{
	Class = "Unique",
	Item = "Freeze_Mine",
	PowerCost = 0,
	Rarity = 0,
	-- upgrades
	BackFreeze = false,
	Upgrades    = 1,
	UpgradeCost = {2},
	-- Display
	BounceAmount = 2,
	Explosion = "",
	Icon = "weapons/deploy_mini_freeze_mine.png",
	Projectile = "effects/shotup_mini_freeze_mine.png",
	LaunchSound = "/weapons/ice_throw",
	ImpactSound = "/props/freezing_mine",
	TipImage = {
		Unit = Point(2,3),
		Target = Point(2,1),
		CustomPawn = "Mini_FreezeArtillery",
	}
}
Mini_DeployFreezeMine_A = Mini_DeployFreezeMine:new{
	BackFreeze = true,
	TipImage = {
		Unit = Point(2,3),
		Enemy = Point(2,4),
		Target = Point(2,1),
		CustomPawn = "Mini_FreezeArtillery",
	}
}

function Mini_DeployFreezeMine:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		for i = 2, self.ArtillerySize do
			local curr = Point(point + DIR_VECTORS[dir] * i)
			if not Board:IsValid(curr) then break end
			if not Board:IsBlocked(curr, PATH_GROUND) and not Board:IsItem(curr) then
				ret:push_back(curr)
			end
		end
	end
	return ret
end
function Mini_DeployFreezeMine:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	-- freeze behind artillery
	ret:AddBounce(p1, 1)
	if self.BackFreeze then
		local freeze = SpaceDamage(p1 + DIR_VECTORS[GetDirection(p1 - p2)], 0)
		freeze.iFrozen = EFFECT_CREATE
		freeze.sAnimation = "ExplIce1"
		freeze.sSound = "/props/freezing_mine"
		ret:AddDamage(freeze)
	end
	-- fire freeze mine
	local damage = SpaceDamage(p2, 0)
	-- if ground, place mine, water or holes will "detonate the mine" and freeze it
	if not Board:IsBlocked(p2, PATH_GROUND) then
		damage.sItem = self.Item
		damage.sImageMark = "combat/icons/icon_deploy_mine.png"
	elseif Board:IsTerrain(p2, TERRAIN_WATER) then
		damage.iFrozen = EFFECT_CREATE
		damage.sAnimation = "ExplIce1"
	end
	ret:AddArtillery(damage, self.Projectile) -- TODO: shotup mine
	ret:AddBounce(p2, self.BounceAmount)

	return ret
end

-- Equipable weapon
Mini_DeployFreezeArtillery = Deployable:new{
	Deployed = "Mini_FreezeArtillery",
	Rarity      = 4,
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_freeze_artillery.png",
  Projectile  = "effects/shotup_mini_freeze_artillery.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(2,3),
		Target        = Point(2,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(4,1)
	}
}
Mini_DeployFreezeArtillery_A = Mini_DeployFreezeArtillery:new{
	Deployed = "Mini_FreezeArtilleryA"
}
Mini_DeployFreezeArtillery_B = Mini_DeployFreezeArtillery:new{
	Deployed = "Mini_FreezeArtilleryB",
	TipImage = {
		Unit          = Point(2,3),
		Target        = Point(2,1),
		Enemy         = Point(1,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(4,1)
	}
}
Mini_DeployFreezeArtillery_AB = Mini_DeployFreezeArtillery_B:new{
	Deployed = "Mini_FreezeArtilleryAB"
}

--------------------
-- Rock Artillery --
--------------------

--- Unit
Mini_RockArtillery = Pawn:new {
	Name           = "Rock Artillery",
	Health         = 1,
	MoveSpeed      = 2,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_RockThrow" },
	-- display
	Image          = "mini_rock_artillery",
	SoundLocation  = "/mech/distance/artillery/",
	Corpse         = false
}
Mini_RockArtilleryA  = Mini_RockArtillery:new { Armor = true }
Mini_RockArtilleryB  = Mini_RockArtillery:new { SkillList = { "Mini_RockThrow_A" } }
Mini_RockArtilleryAB = Mini_RockArtilleryB:new { Armor = true }

-- like normal rock, but fire immune
Mini_VolcanoRock = RockThrown:new {
	Name = "Volcano Boulder",
	Image = "mini_volcano_rock",
	IgnoreFire = true
}

--- Unit weapon
Mini_RockThrow = ArtilleryDefault:new{
	Class = "Unique",
	Damage = 2,
	PowerCost = 0,
	ArtilleryStart = 2,
	ArtillerySize = 8,
	Rarity = 0,
	-- upgrades
	Fire = false,
	Rock = "RockThrown",
	RockAnimation = "rock1d",
	Upgrades = 1,
	UpgradeCost = {2},
	-- Display
	Explosion = "",
	BounceAmount = 1,
	Sound = "",
	Icon = "weapons/ranged_rockthrow.png",
	Projectile = "effects/shotdown_rock.png",
	LaunchSound = "/weapons/boulder_throw",
	ImpactSound = "/impact/dynamic/rock",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Mini_RockArtillery",
	}
}
Mini_RockThrow_A = Mini_RockThrow:new{
	Fire = true,
	BounceAmount = 2,
	Rock = "Mini_VolcanoRock",
	RockAnimation = "mini_volcano_rockd",
	Projectile = "effects/shotup_mini_volcano_rock.png",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Mini_RockArtilleryB",
	}
}
function Mini_RockThrow:GetSkillEffect(p1,p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)
	local damage = SpaceDamage(p2, self.Damage)
	if self.Fire then
		damage.iFire = EFFECT_CREATE
	end
	if not Board:IsBlocked(p2, PATH_PROJECTILE) then
		damage.sPawn = self.Rock
		damage.sAnimation = ""
		damage.iDamage = 0
	else
		damage.sAnimation = self.RockAnimation
	end

	ret:AddBounce(p1, 1)
	ret:AddArtillery(damage, self.Projectile)
	ret:AddBounce(p2, self.BounceAmount)
	ret:AddBoardShake(0.15)

	return ret
end

-- Equipable weapon
Mini_DeployRockArtillery = Deployable:new{
	Deployed = "Mini_RockArtillery",
	Rarity      = 3,
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_rock_artillery.png",
  Projectile  = "effects/shotup_mini_rock_artillery.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1)
	}
}
Mini_DeployRockArtillery_A = Mini_DeployRockArtillery:new{
	Deployed = "Mini_RockArtilleryA"
}
Mini_DeployRockArtillery_B = Mini_DeployRockArtillery:new{
	Deployed = "Mini_RockArtilleryB",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(3,1),
		Enemy2        = Point(3,2),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1)
	}
}
Mini_DeployRockArtillery_AB = Mini_DeployRockArtillery_B:new{
	Deployed = "Mini_RockArtilleryAB"
}
