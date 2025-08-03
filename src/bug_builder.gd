class_name BugBuilder
extends RefCounted
## fluent builder for bugs
## USAGE:
## BugBuilder.new().ant().shiny().normalize_stats().build()
## copy down whole of "_NULL() -> BugBuilder:" and replace what values make sense

const MIN_STAT := 0.0
const MAX_STAT := 10.0
const NORMAL_DIST_DEVIATION := 2.0

var _bug_pck:PackedScene = preload("res://src/bug.tscn")
var _bug_shader = load("res://src/shaders/bug.gdshader")

# temp vals for building
var _bug_stats: BugStats

func build() -> Bug:
  var new_bug: Bug = _bug_pck.instantiate()
  new_bug.bug_stats = _bug_stats
  _bug_stats = null # remove this ref to ensure recounted can do its thing (i think?)

  var smat = ShaderMaterial.new()
  smat.shader = _bug_shader
  new_bug.shader_mat = smat

  return new_bug

#region get bug functions

## dict of callables that can be substituted for a .bug(). call if handled properly
## use BugType.values() to get an array to index into
## USAGE: BugBuilder.new().BugType.values()[#].call().build()
## USAGE: BugBuilder.new().BugType["key_name"].call().build()
var BugType := {
  "Ant": ant,
  "Cicada": cicada,
  "Hornst": hornst,
  "Ladybug": ladybug,
  "17apeed": pillar,
  "Pillbug": pillbug,
  "Slug": slug,
  "Schtick": stick,
  "Stinkbug": stinkbug,
  "Da'Weevil": weevil
}

## DO NOT USE THIS SPECIFIC ONE
## ONLY to be copied out to fill out info for other bugs in a human-readable way
func _NULL() -> BugBuilder:
  var name = "NULL"
  var description = "NULL"
  var tex_path = "res://assets/Sprites/bugs/doodle_ant.png"
  var weight = 1.0
  var speed = 1.0
  var base_trade_value = 1.0
  var capture_res = 0.5
  var color = Color.WHITE
  var affability = 1.0
  var cronch = 1.0
  var honor = 1.0
  var juice = 1.0
  var leg = 6
  var stink = 1.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

## get random from dictionary
func random() -> BugBuilder:
  var index = randi() % BugType.size()
  return BugType.values()[index].call()

# the real shit now
func ant() -> BugBuilder:
  var name = "Ant"
  var description = "Small, but oh so mighty"
  var tex_path = "res://assets/Sprites/bugs/ant.png"
  var weight = 1.0
  var speed = 60.0
  var base_trade_value = 2.0
  var capture_res = 0.3
  var color = Color.RED
  var affability = 3.0
  var cronch = 4.0
  var honor = 9.0
  var juice = 2.0
  var leg = 6
  var stink = 8.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

func cicada() -> BugBuilder:
  var name = "Cicada"
  var description = "They say these things only come out every 21 years."
  var tex_path = "res://assets/Sprites/bugs/cicada.png"
  var weight = 3.0
  var speed = 15.0
  var base_trade_value = 10.0
  var capture_res = 0.5
  var color = Color.DARK_OLIVE_GREEN
  var affability = 4.0
  var cronch = 7.0
  var honor = 2.0
  var juice = 2.0
  var leg = 6
  var stink = 8.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

func hornst() -> BugBuilder:
  var name = "Hornst"
  var description = "A very real bug indeed."
  var tex_path = "res://assets/Sprites/bugs/horns.png"
  var weight = 5.0
  var speed = 20.0
  var base_trade_value = 15.0
  var capture_res = 0.5
  var color = Color.SADDLE_BROWN
  var affability = 1.0
  var cronch = 8.0
  var honor = 6.0
  var juice = 4.0
  var leg = 7
  var stink = 4.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

func ladybug() -> BugBuilder:
  var name = "Ladybug"
  var description = "Don't be fooled by her appearance, this lady is a killer"
  var tex_path = "res://assets/Sprites/bugs/ladybug.png"
  var weight = 15.0
  var speed = 30.0
  var base_trade_value = 1.0
  var capture_res = 0.6
  var color = Color.RED
  var affability = 9.0
  var cronch = 5.0
  var honor = 4.0
  var juice = 6.0
  var leg = 6
  var stink = 7.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self
  
func pillar() -> BugBuilder:
  var name = "17apeed"
  var description = "Try counting the legs. I dare ya."
  var tex_path = "res://assets/Sprites/bugs/pillar.png"
  var weight = 3.0
  var speed = 170.0
  var base_trade_value = 17.0
  var capture_res = 0.5
  var color = Color.DEEP_SKY_BLUE
  var affability = 1.0
  var cronch = 1.0
  var honor = 1.0
  var juice = 8.0
  var leg = 17
  var stink = 10.0
  
  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

func stick() -> BugBuilder:
  var name = "Schtick"
  var description = "This one's always got a joke to tell."
  var tex_path = "res://assets/Sprites/bugs/stick.png"
  var weight = 3.0
  var speed = 10.0
  var base_trade_value = 10.0
  var capture_res = 0.5
  var color = Color.SADDLE_BROWN
  var affability = 8.0
  var cronch = 9.0
  var honor = 7.0
  var juice = 1.0
  var leg = 6
  var stink = 2.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

func slug() -> BugBuilder:
  var name = "Slug"
  var description = "The biggest pos this side of the garden"
  var tex_path = "res://assets/Sprites/bugs/sloog.png"
  var weight = 3.0
  var speed = 3.0
  var base_trade_value = 1.0
  var capture_res = 0.9
  var color = Color.BISQUE
  var affability = 0.0
  var cronch = 0.0
  var honor = 0.0
  var juice = 10.0
  var leg = 0
  var stink = 7.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

func stinkbug() -> BugBuilder:
  var name = "Stinkbug"
  var description = "You get it."
  var tex_path = "res://assets/Sprites/bugs/stinkbug.png"
  var weight = 5.0
  var speed = 50.0
  var base_trade_value = 10.0
  var capture_res = 0.5
  var color = Color.YELLOW_GREEN
  var affability = 1.0
  var cronch = 6.0
  var honor = 1.0
  var juice = 2.0
  var leg = 6
  var stink = 10.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

func pillbug() -> BugBuilder:
  var name = "Pillbug"
  var description = "Small but evasive"
  var tex_path = "res://assets/Sprites/bugs/pillbug.png"
  var weight = 1.0
  var speed = 15.0
  var base_trade_value = 1.0
  var capture_res = 0.3
  var color = Color.WHITE
  var affability = 1.0
  var cronch = 1.0
  var honor = 1.0
  var juice = 1.0
  var leg = 6
  var stink = 1.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

func weevil() -> BugBuilder:
  var name = "Da'Weevil"
  var description = "Did you know some weevils have neck knuckles? GROSS."
  var tex_path = "res://assets/Sprites/bugs/weevil.png"
  var weight = 8.0
  var speed = 10.0
  var base_trade_value = 10.0
  var capture_res = 0.5
  var color = Color.WHITE
  var affability = 5.0
  var cronch = 7.0
  var honor = 9.0
  var juice = 6.0
  var leg = 6
  var stink = 5.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  _bug_stats.capture_resistance = capture_res
  return self

#endregion

#region helper functions to do some thangs
## randomize the color so we get some cool lookin guy B)
func shiny() -> BugBuilder:
  _bug_stats.color = Color(randf_range(0.0, 1.0), randf_range(0.0, 1.0), randf_range(0.0, 1.0), 1.0)
  return self

## randomize all applicable stats across a normal distribution, then clamp
func normalize_stats() -> BugBuilder:
  _bug_stats.weight = _normal_dist_stat(_bug_stats.weight)
  _bug_stats.movement_speed = _normal_dist_stat(_bug_stats.movement_speed)
  _bug_stats.affability = _normal_dist_stat(_bug_stats.affability)
  _bug_stats.cronch = _normal_dist_stat(_bug_stats.cronch)
  _bug_stats.honor = _normal_dist_stat(_bug_stats.honor)
  _bug_stats.juice = _normal_dist_stat(_bug_stats.juice)
  _bug_stats.stink = _normal_dist_stat(_bug_stats.stink)
  return self

static func _normal_dist_stat(value: float) -> float:
  var dist = randfn(value, NORMAL_DIST_DEVIATION)
  return clampf(dist, MIN_STAT, INF)
#endregion

####################
## Finally, this is a fallback confused bug in case things go wrooooong during BugStats scene setup
## This does NOT work with the Fluent Builder
static func get_confused_bug_stats() -> BugStats:
  var name = "Confused BugStats"
  var description = "This bug is confused!"
  var tex_path = "res://assets/Sprites/bugs/doodle_pillbug.png"
  var weight = 1.0
  var speed = 1.0
  var base_trade_value = 99999.0
  var capture_res = 0.5
  var color = Color.WHITE
  var affability = 1.0
  var cronch = 1.0
  var honor = 1.0
  var juice = 1.0
  var leg = 6
  var stink = 1.0

  var b_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  b_stats.capture_resistance = capture_res
  return b_stats
