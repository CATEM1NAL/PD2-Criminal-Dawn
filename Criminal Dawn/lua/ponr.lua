local FileIdent = "ponr"

-- Setup PONR timer
function CrimDawn_CreatePONR()
  local loc = managers.localization

  local ponrElement = {
    id = "crimdawn_ponr",
    class = "ElementPointOfNoReturn",
    values = { elements = {} }
  }

  managers.mission._scripts["default"]._elements["crimdawn_ponr"] = ElementPointOfNoReturn:new(managers.mission, ponrElement)

  if math.random() > 0.1 then
    loc:add_localized_strings({ -- Default PONR text
      ["hud_crimdawn_no_return"] = loc:text("crimdawn_ponr_default")
    })

  else assert(not Global.CrimDawn.DLC, "nil returned true")
    loc:add_localized_strings({ -- Rare PONR text
      ["hud_crimdawn_no_return"] = loc:text("crimdawn_ponr_rare" .. math.random(1,77))
    })
  end

  tweak_data.point_of_no_returns.crimdawn_ponr_tweak = deep_clone(tweak_data.point_of_no_returns.noreturn)
  tweak_data.point_of_no_returns.crimdawn_ponr_tweak.text_id = "hud_crimdawn_no_return"
end

-- Mask up hook
Hooks:PostHook(IngameStandardState, "at_enter", "CrimDawn_ForcePONR", function(self)
  local TotalTimeItems = ((Global.CrimDawn.data.game.run_length * 15) / Global.CrimDawn.data.game.timer_strength) - 1

  if NetworkHelper:IsHost() then -- Disable timer when all time upgrades + 1 are collected
    if Global.CrimDawn.data.x.time_upgrades > TotalTimeItems then CrimDawn.state.ponr = true end
  end

  if CrimDawn.state.ponr then return end

  CrimDawn_CreatePONR()
  NetworkHelper:SendToPeers("CrimDawn_StartPONR", true)

  CrimDawn.Log(FileIdent, "Time remaining: " .. Global.CrimDawn.data.game.ponr)

  managers.groupai:state():set_point_of_no_return_timer(
    Global.CrimDawn.data.game.ponr,
    "crimdawn_ponr",
    "crimdawn_ponr_tweak"
  )

  CrimDawn.state.maskup_time = TimerManager:game():time()
  CrimDawn.state.ponr = true
end)