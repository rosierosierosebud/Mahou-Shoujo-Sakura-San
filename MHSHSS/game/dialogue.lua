-- VERY IMPORTANT NOTE!! the second option's 'next' value must ALWAYS be after the first options's, otherwise it won't properly display crap in the right order.
-- por = character portrait to be displayed
-- bg = background image to be displayed
dialogue_Intro = {
  {
    name = "?",
    text = "To be honest, I hate you all.",
    choices = {
      --{ text = "[X] All of us?", next = 2 }, example
      --{ text = "[B] . . .", next = 3}
    },
    por = "none",
    bg = "none",
    cmd = function() 
      playnoise = false
      play_human()
    end,
    frame = love.graphics.newImage("graphics/overlays/overlay/frame.png"),
    overlay = love.graphics.newImage("graphics/overlays/overlay/overlay.png")
  },
  {
    name = "?",
    text = "Yes. All of you.",
    choices = {}
  },
  {
    name = "?",
    text = "All of you, all of you-- All. Of. You.",
    choices = {}
  },
  {
    name = "?",
    text = "It's nothing personal, really.",
    choices = {}
  },
  {
    name = "?",
    text = "I promise it's not.",
    choices = {}
  },
  {
    name = "?",
    text = "I just can't stand doing this anymore.",
    choices = {}
  },
  {
    name = "?",
    text = "I am so sick of it.",
    choices = {}
  },
  {
    name = "?",
    text = ". . .",
    choices = {}
  },
  {
    name = "?",
    text = "No, I...",
    choices = {}
  },
  {
    name = "?",
    text = "I'll get it right this time.",
    choices = {}
  },
  {
    name = "?",
    text = "I promise.",
    choices = {},
    cmd = function()
      playnoise = true
      TEsound.stop("interruptable", false) --When you want to pass in arguments, please make an anonymous function like so.
      songs2play.human.hasrun = false --Remember to reset a song's run value after you no longer need it! Otherwise, it will not be able to play again in the future. This value exists in the first place so that the song doesn't run over itself-- is there a better way to do this? Probably, but this is what I could think of right now.
     
    end
    
  },
  {
    name = "???",
    text = "SAKURA!",
    choices = {},
    bg = love.graphics.newImage("graphics/bgs/classroom.png")
  },
  {
    name = "You",
    text = "(You hear the familiar, cheery ",
    choices = {}
  },
  {
    name = "You",
    text = "voice of your friend Haruko behind you.)",
    choices = {}
  },
  {
    name = "You",
    text = "(Before you can even turn around, you feel her",
    choices = {}
  },
  {
    name = "You",
    text = "arms wrap tightly around you.)",
    choices = {}
  },
  {
    name = "Haruko",
    text = "Slow as ever, eh? Jeez, you need to sleep more.",
    choices = {
      { text = "Rude.", next = 18},
      { text = "Mondays, y'know.", next = 19}
    },
    por = love.graphics.newImage("graphics/portraits/haruko_happy.png")
    
  },
  {
    name = "Haruko",
    text = "Hey! I didn't mean it like- Ugh, oh well.",
    choices = {},
    por = love.graphics.newImage("graphics/portraits/haruko_annoy.png")
  },
  {
    name = "Haruko",
    text = "Heh, ain't that right.",
    choices = {},
    por = love.graphics.newImage("graphics/portraits/haruko_sigh.png")
  }
  
  }