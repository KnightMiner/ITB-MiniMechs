local multiFire = {
  key = nil
}

-- initializes the multifire logic with the given key
function multiFire:init(key)
  self.key = key

  -- global function to be called in scripts to run the actual double shot logic
  local function internalScript(id, maxUses)
    -- pull uses from mission data
    local mission = GetCurrentMission()
    if mission then
      if not mission[key] then
        mission[key] = {}
      end
      -- if we have not yet reached max uses, set the pawn to active again
      mission[key][id] = (mission[key][id] or 0) + 1
      if mission[key][id] < maxUses then
      	local pawn = Board:GetPawn(id)
        modApi:runLater(function()
          pawn:SetActive(true)
        end)
      end
    end
  end
  -- name the function uniquely by the key to prevent things from breaking if another mod copies this logic
  _G["_MultiFire_UpdateUseCount_" .. key] = internalScript

  -- clear out geoformer uses each turn
  modApi.events.onNextTurn:subscribe(function(mission)
    mission[key] = nil
  end)
end

-- allows the pawn to take another action after the current skill effect finishes
function multiFire:UpdateUseCount(skillEffect, pawn, maxUses)
  if maxUses > 1 and not IsTestMechScenario() then
    assert(self.key ~= nil)
    skillEffect:AddScript(string.format("_MultiFire_UpdateUseCount_%s(%d, %d)", self.key, pawn:GetId(), maxUses))
  end
end

return multiFire
