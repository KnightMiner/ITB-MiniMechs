-----------------------
-- Deploy Knight-Bot --
-----------------------

--- Unit
Mini_KnightBot = Pawn:new {
	Name           = "Knight-Bot",
	Health         = 1,
	MoveSpeed      = 3,
  Armor          = true,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_KnightCharge" },
	-- display
	Image          = "mini_knightbot",
	SoundLocation  = "/enemy/snowlaser_1/",
	Corpse         = false
}
Mini_KnightBotA  = Mini_KnightBot:new { MoveSpeed = 4 }
Mini_KnightBotB  = Mini_KnightBot:new { SkillList = { "Mini_KnightCharge_A" } }
Mini_KnightBotAB = Mini_KnightBot:new { MoveSpeed = 4, SkillList = { "Mini_KnightCharge_A" } }

--- Unit weapon
Mini_KnightCharge = Prime_Punchmech:new {
	Class       = "Unique",
	Damage      = 1,
	Push        = 0,
	PowerCost   = 0,
	Upgrades    = 1,
	UpgradeCost = {3},
	-- display
	Icon        = "weapons/prime_sword.png",
}
Mini_KnightCharge_A = Mini_KnightCharge:new{
	PathSize = INT_MAX,
	Dash = true,
	Damage = 2,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1)
	}
}

-- Equipable weapon
Mini_DeployKnightBot = Deployable:new{
	Deployed = "Mini_KnightBot",
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,3},
	-- visuals
  Icon        = "weapons/deploy_mini_knightbot.png",
  Projectile  = "effects/shotup_mini_knightbot.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(2,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(2,1)
	}
}
Mini_DeployKnightBot_A = Mini_DeployKnightBot:new{
	Deployed = "Mini_KnightBotA"
}
Mini_DeployKnightBot_B = Mini_DeployKnightBot:new{
	Deployed = "Mini_KnightBotB",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(3,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(2,1)
	}
}
Mini_DeployKnightBot_AB = Mini_DeployKnightBot_B:new{
	Deployed = "Mini_KnightBotAB"
}

-----------------------
-- Deploy Laser-Bot --
-----------------------

--- Unit
Mini_LaserBot = Pawn:new {
	Name           = "Laser-Bot",
	Health         = 1,
	MoveSpeed      = 3,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_Laserbeam" },
	-- display
	Image          = "mini_laserbot",
	SoundLocation  = "/enemy/snowlaser_1/",
	Corpse         = false
}
Mini_LaserBotA  = Mini_LaserBot:new { MoveSpeed = 4 }
Mini_LaserBotB  = Mini_LaserBot:new { SkillList = { "Mini_Laserbeam_A" } }
Mini_LaserBotAB = Mini_LaserBot:new { MoveSpeed = 4, SkillList = { "Mini_Laserbeam_A" } }

--- Unit weapon
Mini_Laserbeam = LaserDefault:new {
	Class       = "Unique",
	Damage      = 2,
	PowerCost   = 0,
	Upgrades    = 1,
	UpgradeCost = {3},
	-- display
	Icon = "weapons/prime_lasermech.png",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0)
	}
}
Mini_Laserbeam_A = Mini_Laserbeam:new{
	Damage = 3
}

-- Equipable weapon
Mini_DeployLaserBot = Deployable:new{
	Deployed = "Mini_LaserBot",
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,3},
	-- visuals
  Icon        = "weapons/deploy_mini_laserbot.png",
  Projectile  = "effects/shotup_mini_laserbot.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(2,1),
		Friendly      = Point(3,1),
		Mountain      = Point(4,1),
		Second_Origin = Point(1,1),
		Second_Target = Point(2,1)
	}
}
Mini_DeployLaserBot_A = Mini_DeployLaserBot:new{
	Deployed = "Mini_LaserBotA"
}
Mini_DeployLaserBot_B = Mini_DeployLaserBot:new{
	Deployed = "Mini_LaserBotB"
}
Mini_DeployLaserBot_AB = Mini_DeployLaserBot:new{
	Deployed = "Mini_LaserBotAB"
}
