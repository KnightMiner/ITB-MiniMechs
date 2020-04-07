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
	ImageOffset    = 0,
	SoundLocation  = "/enemy/snowlaser_1/",
	Corpse         = false
}
Mini_KnightBotA  = Mini_KnightBot:new { MoveSpeed = 4 }
Mini_KnightBotB  = Mini_KnightBot:new { ImageOffset = 1, SkillList = { "Mini_KnightCharge_A" } }
Mini_KnightBotAB = Mini_KnightBotB:new { MoveSpeed = 4 }

--- Unit weapon
Mini_KnightCharge = Prime_Punchmech:new {
	Class       = "Unique",
	Damage      = 1,
	Push        = 0,
	PowerCost   = 0,
	Upgrades    = 1,
	UpgradeCost = {3},
	-- display
	Icon = "weapons/prime_sword.png",
	TipImage = {
		Unit = Point(2,2),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Mini_KnightBot"
	}
}
Mini_KnightCharge_A = Mini_KnightCharge:new{
	PathSize = INT_MAX,
	Dash = true,
	Damage = 2,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Mini_KnightBotB"
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
  Projectile  = "effects/shotup_mini_knightbot1.png",
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
  Projectile = "effects/shotup_mini_knightbot2.png",
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
	ImageOffset    = 0,
	SoundLocation  = "/enemy/snowlaser_1/",
	Corpse         = false
}
Mini_LaserBotA  = Mini_LaserBot:new { MoveSpeed = 4 }
Mini_LaserBotB  = Mini_LaserBot:new { ImageOffset = 1, SkillList = { "Mini_Laserbeam_A" } }
Mini_LaserBotAB = Mini_LaserBotB:new { MoveSpeed = 4 }

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
		Mountain = Point(2,0),
		CustomPawn = "Mini_LaserBot"
	}
}
Mini_Laserbeam_A = Mini_Laserbeam:new{
	Damage = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Friendly = Point(2,1),
		Target = Point(2,2),
		Mountain = Point(2,0),
		CustomPawn = "Mini_LaserBotB"
	}
}

-- Equipable weapon
Mini_DeployLaserBot = Deployable:new{
	Deployed = "Mini_LaserBot",
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,3},
	-- visuals
  Icon        = "weapons/deploy_mini_laserbot.png",
  Projectile  = "effects/shotup_mini_laserbot1.png",
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
	Deployed = "Mini_LaserBotB",
	Projectile = "effects/shotup_mini_laserbot2.png"
}
Mini_DeployLaserBot_AB = Mini_DeployLaserBot_B:new{
	Deployed = "Mini_LaserBotAB"
}

-----------------------
-- Deploy Judo-Bot --
-----------------------

--- Unit
Mini_JudoBot = Pawn:new {
	Name           = "Judo-Bot",
	Health         = 1,
	MoveSpeed      = 3,
	Armor          = true,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_JudoThrow" },
	-- display
	Image          = "mini_judobot",
	ImageOffset    = 0,
	SoundLocation  = "/enemy/snowlaser_1/",
	Corpse         = false
}
Mini_JudoBotA  = Mini_JudoBot:new { MoveSpeed = 4 }
Mini_JudoBotB  = Mini_JudoBot:new { ImageOffset = 1, SkillList = { "Mini_JudoThrow_A" } }
Mini_JudoBotAB = Mini_JudoBotB:new { MoveSpeed = 4 }

--- Unit weapon
Mini_JudoThrow = Skill:new {
	Class       = "Unique",
	Damage      = 0,
	Range       = 1,
	PowerCost   = 0,
	Upgrades    = 1,
	UpgradeCost = {2},
	-- display
	Icon = "weapons/prime_shift.png",
	LaunchSound = "/weapons/shift",
	TipImage = {
		Unit   = Point(2,2),
		Enemy  = Point(2,1),
		Target = Point(2,3),
		CustomPawn = "Mini_JudoBot"
	}
}
Mini_JudoThrow_A = Mini_JudoThrow:new{
	Range = 2,
	TipImage = {
		Unit   = Point(2,2),
		Enemy  = Point(2,1),
		Target = Point(2,4),
		CustomPawn = "Mini_JudoBotB"
	}
}

-- targets landing instead of units
function Mini_JudoThrow:GetTargetArea(point)
	local ret = PointList()
	for dir = DIR_START, DIR_END do
		local side = DIR_VECTORS[dir]
		local target = point + side
		-- can target non-guarding pawns
		if Board:IsPawnSpace(target) and not Board:GetPawn(target):IsGuarding() then
			-- can land on spaces behind the mech that are open
			local canTarget = false
			for i = 1, self.Range do
				local landing = point - side * i
				if not Board:IsBlocked(landing, PATH_FLYER) then
					ret:push_back(landing)
					canTarget = true
				end
			end
			-- add the pawn as targetable too, adds compat with old behavior
			if canTarget then
				ret:push_back(target)
			end
		end
	end

	return ret
end

-- toss units to to landing
function Mini_JudoThrow:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local dir = GetDirection(p2 - p1)

	-- determine target and landing
	local target
	local landing = p2

	-- if targeting the pawn, throw to first available space
	if Board:IsPawnSpace(p2) then
		target = p2
		local offset = DIR_VECTORS[dir]
		for i = 1, self.Range do
			local point = p1 - offset * i
			if not Board:IsBlocked(point, PATH_FLYER) then
				landing = point
				break
			end
		end
	else
		-- if targeting an empty space, that is where the unit lands, so determine target pawn
		target = p1 - DIR_VECTORS[dir]
	end

	-- area to toss unit
	local move = PointList()
	move:push_back(target)
	move:push_back(landing)

	-- fake punch and toss
	ret:AddMelee(p1, SpaceDamage(target, 0))
	ret:AddLeap(move, FULL_DELAY)

	-- damage the target after landing
	if self.FriendlyDamage or not Board:IsPawnTeam(target, TEAM_PLAYER) then
		ret:AddDamage(SpaceDamage(landing, self.Damage))
	end
	ret:AddBounce(landing, 3)

	return ret
end

-- Equipable weapon
Mini_DeployJudoBot = Deployable:new{
	Deployed = "Mini_JudoBot",
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_judobot.png",
  Projectile  = "effects/shotup_mini_judobot1.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(2,3),
		Target        = Point(2,1),
		Enemy         = Point(1,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(1,1)
	}
}
Mini_DeployJudoBot_A = Mini_DeployJudoBot:new{
	Deployed = "Mini_JudoBotA"
}
Mini_DeployJudoBot_B = Mini_DeployJudoBot:new{
	Deployed    = "Mini_JudoBotB",
  Projectile  = "effects/shotup_mini_judobot2.png",
	TipImage = {
		Unit          = Point(2,3),
		Target        = Point(2,1),
		Enemy         = Point(1,1),
		Second_Origin = Point(2,1),
		Second_Target = Point(4,1)
	}
}
Mini_DeployJudoBot_AB = Mini_DeployJudoBot_B:new{
	Deployed = "Mini_JudoBotAB"
}

-----------------------
-- Deploy Leap-Bot --
-----------------------

--- Unit
Mini_LeapBot = Pawn:new {
	Name           = "Laser-Bot",
	Health         = 1,
	MoveSpeed      = 3,
	DefaultTeam    = TEAM_PLAYER,
	ImpactMaterial = IMPACT_METAL,
	SkillList      = { "Mini_Boosters" },
	-- display
	Image          = "mini_leapbot",
	ImageOffset    = 0,
	SoundLocation  = "/enemy/snowart_1/",
	Corpse         = false
}
Mini_LeapBotA  = Mini_LeapBot:new { MoveSpeed = 4 }
Mini_LeapBotB  = Mini_LeapBot:new { ImageOffset = 1, SkillList = { "Mini_Boosters_A" } }
Mini_LeapBotAB = Mini_LeapBotB:new { MoveSpeed = 4 }

--- Unit weapon
Mini_Boosters = Leap_Attack:new {
	Class       = "Unique",
	Damage      = 0,
	SelfDamage  = 0,
	Push        = 1,
	Range       = 2,
	PowerCost   = 0,
	Upgrades    = 1,
	UpgradeCost = {2},
	-- display
	Icon = "weapons/brute_boosters.png",
	LaunchSound = "/weapons/boosters",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Enemy2 = Point(3,2),
		Target = Point(2,2),
		CustomPawn = "Mini_LeapBot"
	}
}
Mini_Boosters_A = Mini_Boosters:new{
	Range = 3,
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,2),
		Enemy2 = Point(3,1),
		Target = Point(2,1),
		CustomPawn = "Mini_LeapBotB"
	}
}

-- Equipable weapon
Mini_DeployLeapBot = Deployable:new{
	Deployed = "Mini_LeapBot",
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_leapbot.png",
  Projectile  = "effects/shotup_mini_leapbot1.png",
	LaunchSound = "/weapons/deploy_tank",
	ImpactSound = "/impact/generic/mech",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(2,1),
		Enemy2        = Point(3,2),
		Second_Origin = Point(1,1),
		Second_Target = Point(3,1)
	}
}
Mini_DeployLeapBot_A = Mini_DeployLeapBot:new{
	Deployed = "Mini_LeapBotA"
}
Mini_DeployLeapBot_B = Mini_DeployLeapBot:new{
	Deployed = "Mini_LeapBotB",
	Projectile = "effects/shotup_mini_leapbot2.png",
	TipImage = {
		Unit          = Point(1,3),
		Target        = Point(1,1),
		Enemy         = Point(3,1),
		Enemy2        = Point(4,2),
		Second_Origin = Point(1,1),
		Second_Target = Point(4,1)
	}
}
Mini_DeployLeapBot_AB = Mini_DeployLeapBot_B:new{
	Deployed = "Mini_LeapBotAB"
}
