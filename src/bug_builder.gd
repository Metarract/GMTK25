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
  "ant": ant,
  "slug": slug,
  "pillbug": pillbug,
  "ladybug": ladybug
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
  var color = Color.WHITE
  var affability = 1.0
  var cronch = 1.0
  var honor = 1.0
  var juice = 1.0
  var leg = 6
  var stink = 1.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  return self

# the real shit now
func ant() -> BugBuilder:
  var name = "Ant"
  var description = "Small, but oh so mighty"
  var tex_path = "res://assets/Sprites/bugs/ant.png"
  var base_trade_value = 2.0
  var color = Color.RED
  var weight = 1.0
  var speed = 60.0
  var affability = 3.0
  var cronch = 4.0
  var honor = 9.0
  var juice = 2.0
  var leg = 6
  var stink = 8.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  return self

func slug() -> BugBuilder:
  var name = "Slug"
  var description = "The biggest pos this side of the garden"
  var tex_path = "res://assets/Sprites/bugs/sloog.png"
  var base_trade_value = 1.0
  var color = Color.BISQUE
  var weight = 3.0
  var speed = 3.0
  var affability = 0.0
  var cronch = 0.0
  var honor = 0.0
  var juice = 10.0
  var leg = 0
  var stink = 7.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  return self

func pillbug() -> BugBuilder:
  var name = "Pillbug"
  var description = "Small but evasive"
  var tex_path = "res://assets/Sprites/bugs/pillbug.png"
  var weight = 1.0
  var speed = 15.0
  var base_trade_value = 1.0
  var color = Color.WHITE
  var affability = 1.0
  var cronch = 1.0
  var honor = 1.0
  var juice = 1.0
  var leg = 6
  var stink = 1.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  return self

func ladybug() -> BugBuilder:
  var name = "Ladybug"
  var description = "Don't be fooled by her appearance, this lady is a killer"
  var tex_path = "res://assets/Sprites/bugs/ladybug.png"
  var weight = 15.0
  var speed = 30.0
  var base_trade_value = 1.0
  var color = Color.RED
  var affability = 9.0
  var cronch = 5.0
  var honor = 4.0
  var juice = 6.0
  var leg = 6
  var stink = 7.0

  _bug_stats = BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  return self

#endregion

#region helper functions to do some thangs
## randomize the color so we get some cool lookin guy B)
func shiny() -> BugBuilder:
  # bug.color =
  return self

## randomize all applicable stats across a normal distribution, then clamp
func normalize_stats() -> BugBuilder:
  _bug_stats.weight = normal_dist_stat(_bug_stats.weight)
  _bug_stats.movement_speed = normal_dist_stat(_bug_stats.movement_speed)
  _bug_stats.affability = normal_dist_stat(_bug_stats.affability)
  _bug_stats.cronch = normal_dist_stat(_bug_stats.cronch)
  _bug_stats.honor = normal_dist_stat(_bug_stats.honor)
  _bug_stats.juice = normal_dist_stat(_bug_stats.juice)
  _bug_stats.stink = normal_dist_stat(_bug_stats.stink)
  return self

static func normal_dist_stat(value: float) -> float:
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
  var color = Color.WHITE
  var affability = 1.0
  var cronch = 1.0
  var honor = 1.0
  var juice = 1.0
  var leg = 6
  var stink = 1.0

  return BugStats.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
