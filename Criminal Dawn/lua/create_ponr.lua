Hooks:PostHook(GameSetup, "init_finalize", "CrimDawn_CreatePONR", function()
  local loc = managers.localization

  local ponrElement = {
    id = "crimdawn_ponr",
    class = "ElementPointOfNoReturn",
    values = { elements = {} }
  }

  managers.mission._scripts.default._elements.crimdawn_ponr = ElementPointOfNoReturn:new(managers.mission, ponrElement)

  math.randomseed(os.time() .. os.clock())
  if math.random() > 0.1 then
    loc:add_localized_strings({
      ["hud_crimdawn_no_return"] = loc:text("crimdawn_ponr_default")
    })

  else assert(not Global.CrimDawn.DLC, "nil returned true")
    loc:add_localized_strings({
      ["hud_crimdawn_no_return"] = loc:text("crimdawn_ponr_rare" .. math.random(1,100))
    })
  end

  tweak_data.point_of_no_returns.crimdawn_ponr_tweak = deep_clone(tweak_data.point_of_no_returns.noreturn)
  tweak_data.point_of_no_returns.crimdawn_ponr_tweak.text_id = "hud_crimdawn_no_return"
end)