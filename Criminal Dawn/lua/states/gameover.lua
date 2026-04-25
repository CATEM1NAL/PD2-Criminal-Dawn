local FileIdent = "gameover"

Hooks:PostHook(GameOverState, "at_enter", "CrimDawn_HeistFailed", function(self)
  CrimDawn:RunReset(FileIdent)
end)