function play_menu() 
    if songs2play.menu.hasrun == false then
      TEsound.playLooping("audio/mus_HELLYEAHBABYTHISPARTYISBUMPIN.mp3", "stream", {"mus", "interruptable"})
      songs2play.menu.hasrun = true
    end
  end
  function play_human()
    if songs2play.human.hasrun == false then
      TEsound.playLooping("audio/mus_ForWeAreOnlyMortal.mp3", "stream", {"mus", "interruptable"})
      TEsound.volume("interruptable", 1)
      songs2play.human.hasrun = true
    end
  end
function play_jump()
  TEsound.play("audio/sf_jump.ogg", "static", {"sfx"})
end
function play_land()
  TEsound.play("audio/sf_land.ogg", "static", {"sfx"})
end
function play_confirm()
  TEsound.play("audio/sf_confirm.ogg", "static", {"sfx"})
end
function play_back()
  TEsound.play("audio/sf_nah.ogg", "static", {"sfx"})
end
function play_next()
  TEsound.play("audio/sf_next.ogg", "static", {"sfx"})
end
function play_ow()
  TEsound.play("audio/sf_ow.ogg", "static", {"sfx"})
end
function play_collect()
  TEsound.play("audio/sf_collect.ogg", "static", {"sfx"})
end

