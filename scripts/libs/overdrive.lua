local overdrive = {}

--[[--
  Checks if the given unit can be overdriven
]]
function overdrive:canTarget(point)
	local pawn = Board:GetPawn(point)
	return pawn and not pawn:IsDead() and not pawn:IsActive() and pawn:GetTeam() == TEAM_PLAYER
end

--[[--
  Skill effect helper to overdrive a unit

  Returns space damage to add other effects, needed for the icon
]]
function overdrive:apply(effect, target)
  -- power on unit again
  effect:AddSound("/enemy/shared/robot_power_on")
  effect:AddScript(string.format([[
    local p = %s
    local unit = Board:GetPawn(p)
    if unit then
      unit:SetActive(true)
      Board:Ping(p, GL_Color(128, 0, 255))
    end]],
    target:GetString()
  ))

  local icon = SpaceDamage(target, 0)
  icon.sImageMark = "combat/icons/mini_overdrive_icon.png"
  return icon
end

return overdrive
