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
Mini_KnightBotAB = Mini_KnightBotB:new { MoveSpeed = 4 }

--- Unit weapon
Mini_KnightCharge = Prime_Punchmech:new {
	Class       = "Unique",
	Rarity      = 0,
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
	TipImage = {
		Unit = Point(2,4),
		Enemy = Point(2,1),
		Target = Point(2,1),
		CustomPawn = "Mini_KnightBotB"
	}
}

function Mini_KnightCharge_A:GetSkillEffect(p1, p2)
	local ret = SkillEffect()
	local direction = GetDirection(p2 - p1)

	local doDamage = true
	local target = p2

  if self.Dash then
		target = GetProjectileEnd(p1,p2,PATH_PROJECTILE)
    if not Board:IsBlocked(target,PATH_PROJECTILE) then -- dont attack an empty edge square, just run to the edge
    	doDamage = false
	    target = target + DIR_VECTORS[direction]
  	end
		local dashEnd = target - DIR_VECTORS[direction]
		if dashEnd ~= p1 then
	  	ret:AddCharge(Board:GetSimplePath(p1, dashEnd), FULL_DELAY)
		end
	end

	if doDamage then
		-- boost damage by 1 if we dashed
		local damageAmount = self.Damage
		if target:Manhattan(p1) > 1 then
			damageAmount = damageAmount + 1
		end
		local damage = SpaceDamage(target, damageAmount, direction)
		damage.sAnimation = "explopunch1_"..direction
		damage.loc = target
		ret:AddMelee(p2 - DIR_VECTORS[direction], damage)
	end

	return ret
end

-- Equipable weapon
Mini_DeployKnightBot = Deployable:new{
	Deployed = "Mini_KnightBot",
	Rarity      = 2,
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
Mini_LaserBotAB = Mini_LaserBotB:new { MoveSpeed = 4 }

--- Unit weapon
Mini_Laserbeam = LaserDefault:new {
	Class       = "Unique",
	Rarity      = 0,
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
	Rarity      = 3,
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
	Deployed = "Mini_LaserBotB",
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
	SoundLocation  = "/enemy/snowlaser_1/",
	Corpse         = false
}
Mini_JudoBotA  = Mini_JudoBot:new { MoveSpeed = 4 }
Mini_JudoBotB  = Mini_JudoBot:new { SkillList = { "Mini_JudoThrow_A" } }
Mini_JudoBotAB = Mini_JudoBotB:new { MoveSpeed = 4 }

--- Unit weapon
Mini_JudoThrow = Skill:new {
	Class       = "Unique",
	Rarity      = 0,
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
	Rarity      = 2,
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_judobot.png",
  Projectile  = "effects/shotup_mini_judobot.png",
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
	SoundLocation  = "/enemy/snowart_1/",
	Corpse         = false
}
Mini_LeapBotA  = Mini_LeapBot:new { MoveSpeed = 4 }
Mini_LeapBotB  = Mini_LeapBot:new { SkillList = { "Mini_Boosters_A" } }
Mini_LeapBotAB = Mini_LeapBotB:new { MoveSpeed = 4 }

--- Unit weapon
Mini_Boosters = Leap_Attack:new {
	Class       = "Unique",
	Rarity      = 0,
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
	Rarity      = 3,
	PowerCost   = 2,
	Upgrades    = 2,
	UpgradeCost = {1,2},
	-- visuals
  Icon        = "weapons/deploy_mini_leapbot.png",
  Projectile  = "effects/shotup_mini_leapbot.png",
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
