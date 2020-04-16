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
		freeze.sSound = "/impact/generic/ice"
		ret:AddDamage(freeze)
	end
	-- fire freeze mine
	local damage = SpaceDamage(p2, 0)
	-- if ground, place mine, water or holes will "detonate the mine" and freeze it
	if not Board:IsBlocked(p2, PATH_GROUND) then
		damage.sItem = self.Item
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
