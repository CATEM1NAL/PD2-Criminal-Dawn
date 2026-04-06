Hooks:OverrideFunction(InfamyManager, "available", function() return true end)

Hooks:PostHook(InfamyManager, "init", "CrimDawn_InfamyLoad", function(self)
  for _, item in ipairs(tweak_data.infamy.tree) do self:unlock_item(item) end
end)