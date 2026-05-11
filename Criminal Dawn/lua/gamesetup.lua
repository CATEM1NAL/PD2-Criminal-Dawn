local FileIdent = "GameSetup"

Hooks:PostHook(GameSetup, "init_finalize", "CrimDawn_GameSetupInit", function()
  local loc, script = managers.localization, managers.mission._scripts.default._elements
  local level = managers.job:current_level_id()
  CrimDawn.Log(FileIdent, "Level ID: " .. level)

  local ponrElement = {
    id = "crimdawn_ponr",
    class = "ElementPointOfNoReturn",
    values = { elements = {} }
  }

  script.crimdawn_ponr = ElementPointOfNoReturn:new(managers.mission, ponrElement)

  -- Heist specific timer elements we want to modify
  local TimerTweaks = { big = {},

    -- Mandatory meth cooking
    alex_1 = { reChance = "on_executed" },
    rat = { reChance = "on_executed" },
    mex_cooking = { meth_taken = "on_executed", counter_below3 = "on_executed" },

    -- Assorted timers
    -- TimerOperator = "time", Timer = "timer"
    red2 = { logic_link_018 = "on_executed", logic_link_020 = "on_executed" }, -- FWB thermite
    wwh = { ["120_seconds"] = "timer" }, -- Alaskan Deal fuel
    brb = { ["30"] = "timer" }, -- Brooklyn Bank circle cutter
    roberts = { logic_timer_operator_001 = "time", logic_timer_operator_002 = "time", logic_timer_operator_003 = "time" },
    pbr = { refuel_timer = "timer", bomb_timer = "timer" },
    mia_1 = { hatch_timer_2min = "timer", hatch_timer_3min = "timer",
              ["90s"] = "time", ["120"] = "time", ["180"] = "time" },
    born = { start = "time" },
    pal = { valve_timer = "timer" },
    rvd2 = { start_wait_for_LN = "on_executed", seq_start_friendly_heli_fly_in = "on_executed" },
    peta2 = { ["2min"] = "on_executed", ["1min"] = "on_executed", ["30s"] = "on_executed" },
    shoutout_raid = { tick = "on_executed" },
    jewelry_store = { policeAreHereRemoveNoAlarmEscape = "on_executed" },
    run = { func_sequence_034 = "on_executed", func_sequence_033 = "on_executed",
            func_sequence_032 = "on_executed", func_sequence_031 = "on_executed", },
    mallcrasher = { delay = "on_executed" },
  }

  local TimerMult = math.min(Global.CrimDawn.data.game.progression_items * 2, 99)
  TimerMult = 1 - (TimerMult / 100)

  -- Modify element timers
  if TimerTweaks[level] then
    for ElementName, ElementValue in pairs(TimerTweaks[level]) do
      for BaseElementName, BaseElement in pairs(script) do
        if BaseElement._editor_name == ElementName and BaseElement._values[ElementValue] then
          CrimDawn.Log(FileIdent, "Found mission element " .. ElementName)
          --Utils.PrintTable(BaseElement, 2)

          if ElementValue ~= "on_executed" then
            BaseElement._values[ElementValue] = BaseElement._values[ElementValue] * TimerMult
            --Utils.PrintTable(BaseElement._values, 1)

          else for _, ExecutedElement in ipairs(BaseElement._values.on_executed) do
            ExecutedElement.delay = ExecutedElement.delay * TimerMult
          end break end

        end
      end
    end
  end

  math.randomseed(os.time() + (os.clock() * 1000))
  if math.random() > 0.1 then
    loc:add_localized_strings({
      ["hud_crimdawn_no_return"] = loc:text("crimdawn_ponr_default")
    })

  else --assert(not Global.CrimDawn.DLC, "nil returned true")
    loc:add_localized_strings({
      ["hud_crimdawn_no_return"] = loc:text("crimdawn_ponr_rare" .. math.random(1,100))
    })
  end

  tweak_data.point_of_no_returns.crimdawn_ponr_tweak = deep_clone(tweak_data.point_of_no_returns.noreturn)
  tweak_data.point_of_no_returns.crimdawn_ponr_tweak.text_id = "hud_crimdawn_no_return"

  dofile(CrimDawn.ModPath .. "lua/score_handler.lua")
  dofile(CrimDawn.ModPath .. "lua/managers/criminals.lua")
end)