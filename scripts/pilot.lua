CreatePilot{
  Id = "Pilot_MiniToyman",
  Name = "Tomek Morah",
  Personality = "Repairman", -- TODO: custom personality
  Skill = "MiniDeploy",
  Sex = SEX_MALE,
  PowerCost = 2,
  Voice = "/voice/harold"
}

-- list of all valid deployables, format is {PawnId,ProjectileImage}
local DEPLOYABLES = {
  -- Bots
  {"Mini_KnightBot", "effects/shotup_mini_knightbot.png"},
  {"Mini_LaserBot", "effects/shotup_mini_laserbot.png"},
  {"Mini_JudoBot", "effects/shotup_mini_judobot.png"},
  {"Mini_LeapBot", "effects/shotup_mini_leapbot.png"},
  -- Tanks
  {"Deploy_Tank", "effects/shotup_tank.png"},
  {"Deploy_ShieldTank", "effects/shotup_shieldtank.png"},
  {"Deploy_AcidTank", "effects/shotup_acidtank.png"},
  {"Deploy_PullTank", "effects/shotup_pulltank.png"},
  -- copters
  {"Mini_SmokeCopter", "effects/shotup_mini_smoke_copter.png"},
  {"Mini_NapalmCopter", "effects/shotup_mini_napalm_copter.png"},
  {"Mini_RepairCopter", "effects/shotup_mini_repair_copter.png"},
  {"Mini_OverdriveCopter", "effects/shotup_mini_overdrive_copter.png"},
  -- artillery
  {"Mini_UnstableArtillery", "effects/shotup_mini_unstable_artillery.png"},
  {"Mini_FreezeArtillery", "effects/shotup_mini_freeze_artillery.png"},
  {"Mini_RockArtillery", "effects/shotup_mini_rock_artillery.png"},
  {"Mini_ShrapnelTank", "effects/shotup_mini_shrapneltank.png"},
}

-- iterate directions prioritizing towards the enemy, so you don't deploy in a back corner
local DIR_ORDER = {DIR_RIGHT, DIR_DOWN, DIR_UP, DIR_LEFT}

--[[
  Spawns the deployable for a mech
]]--
local function spawnDeploy(pawn)
  local space = pawn:GetSpace()
  -- try increasing distances from the pawn
  for dist = 1, 7 do
    for _, dir in ipairs(DIR_ORDER) do
      -- prioritize spawning in front (towards the battle)
      local target = space + (DIR_VECTORS[dir] * dist)
      -- on the board
      if Board:IsValid(target)
        -- no holes, mountains, water, lava, existing pawn
        and not Board:IsBlocked(target, PATH_GROUND)
        -- no easy time pod, sorry
        and not Board:IsPod(target)
        -- lets not force the mini to die in one turn
        and not Board:IsFire(target)
        -- don't deploy on mines
        and not Board:IsItem(target)
      then -- acceptable: ACID, smoke, environment effects`
        -- found a spot! do the actual spawn
        local deploy = random_element(DEPLOYABLES)
        -- use a skill effect so the owner is set
        local effect = SkillEffect()
        effect.iOwner = pawn:GetId()
        effect:AddSound("/weapons/deploy_tank")
        -- build an artillery so it looks cool
        local damage = SpaceDamage(target,0)
        damage.sPawn = deploy[1]
        effect:AddArtillery(pawn:GetSpace(), damage, deploy[2])
        -- since its currently the enemy's turn, set the pawn to inactive so it does not attack
        -- attack is not queued, so could be bad for the grid
        effect:AddScript([[
          local pawn = Board:GetPawn(]]..target:GetString()..[[)
          pawn:ResetUses()
          pawn:SetActive(false)
        ]])
        Board:AddEffect(effect)

        -- don't need to further search for a space
        return
      end
    end
  end
end

modApi.events.onNextTurn:subscribe(function(mission)
  if Game:GetTurnCount() == 0 then
    local mechs = extract_table(Board:GetPawns(TEAM_PLAYER))
    for i,id in pairs(mechs) do
      local pawn = Board:GetPawn(id)
      if pawn:IsAbility("MiniDeploy") and not pawn:IsDead() then
        spawnDeploy(pawn)
      end
    end
  end
end)
