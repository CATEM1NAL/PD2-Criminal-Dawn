Hooks:PostHook(SideJobEventManager, "load", "CrimDawn_SideJobEventItems", function(self)
  for _, data in pairs(tweak_data.event_jobs.challenges) do
    managers.event_jobs:completed_challenge(data.id)
    for i = 1, #data.rewards do managers.event_jobs:claim_reward(data.id, i) end
  end
end)

Hooks:PostHook(SideJobEventManager, "reset", "CrimDawn_SideJobEventItems", function(self)
  for _, data in pairs(tweak_data.event_jobs.challenges) do
    managers.event_jobs:completed_challenge(data.id)
    for i = 1, #data.rewards do managers.event_jobs:claim_reward(data.id, i) end
  end
end)