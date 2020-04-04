local mod = {
  id = "mini_mechs",
  name = "Mini Mechs",
  version = "0.0.1",
  requirements = {}
}

--[[--
  Helper function to load mod scripts

  @param  name   Script path relative to mod directory
]]
function mod:loadScript(path)
  return require(self.scriptPath..path)
end

function mod:metadata()
end

function mod:init()
  -- sprites
  local sprites = self:loadScript("libs/sprites")
end

function mod:load(options,version)
end

return mod
