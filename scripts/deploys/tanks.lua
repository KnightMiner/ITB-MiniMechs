------------------------
-- Deploy Mirror Tank --
------------------------

--- Unit
Mini_MirrorTank = Pawn:new {
	Name           = "Mirror Tank",
	Health         = 1,
	MoveSpeed      = 3,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_Mirrorshot" },
	-- display
	Image          = "mini_mirrortank",
	SoundLocation  = "/mech/brute/tank",
	Corpse         = false
}
Mini_MirrorTankA  = Mini_MirrorTank:new { Health = 3 }
Mini_MirrorTankB  = Mini_MirrorTank:new { SkillList = { "Mini_Mirrorshot_A" } }
Mini_MirrorTankAB = Mini_MirrorTank:new { Health = 3, SkillList = { "Mini_Mirrorshot_A" } }

--- Unit weapon
Mini_Mirrorshot = TankDefault:new {
	Class = "Unique",
	Damage      = 1,
	BackShot    = 1,
	Push        = 0,
	PowerCost   = 0,
	Upgrades    = 1,
	UpgradeCost = {2},
	-- display
	Icon        = "weapons/brute_mirror.png",
	Sound       = "/general/combat/explode_small",
	LaunchSound = "/weapons/mirror_shot",
	ImpactSound = "/impact/generic/explosion",
	TipImage = {
		Unit   = Point(2,2),
		Enemy  = Point(1,2),
		Enemy2 = Point(4,2),
		Target = Point(1,2)
	}
}
Mini_Mirrorshot_A = Mini_Mirrorshot:new{ Push = 1 }

-- Reimplemented as vanilla ignores hte push flag on the backshot
function Mini_Mirrorshot:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)
	local target = GetProjectileEnd(p1, p2)

	-- front attack
	local damage = SpaceDamage(target, self.Damage)
	damage.sAnimation = self.Explo .. direction
	if self.Push == 1 then
		damage.iPush = direction
	end
	ret:AddProjectile(damage, self.ProjectileArt, NO_DELAY)

	-- back attack
	local backdir = GetDirection(p1 - p2)
	local target2 = GetProjectileEnd(p1, p1 + DIR_VECTORS[backdir])
	if target2 ~= p1 then
		damage = SpaceDamage(target2, self.Damage)
		damage.sAnimation = self.Explo..backdir
		if self.Push == 1 then
			damage.iPush = backdir
		end
		ret:AddProjectile(damage, self.ProjectileArt)
	end

	return ret
end

-- Equipable weapon
Mini_DeployMirrorTank = Deployable:new{
	Deployed = "Mini_MirrorTank",
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_mirrortank.png",
  Projectile  = "effects/shotup_mini_mirrortank.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(2,3),
		Target        = Point(2,1),
		Enemy         = Point(3,1),
		Enemy2        = Point(1,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(3,1)
	},
}
Mini_DeployMirrorTank_A = Mini_DeployMirrorTank:new{
	Deployed = "Mini_MirrorTankA"
}
Mini_DeployMirrorTank_B = Mini_DeployMirrorTank:new{
	Deployed = "Mini_MirrorTankB"
}
Mini_DeployMirrorTank_AB = Mini_DeployMirrorTank:new{
	Deployed = "Mini_MirrorTankAB"
}
