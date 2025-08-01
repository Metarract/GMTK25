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

# temp vals for building
var _bug: Bug

func build():
  var new_bug = _bug_pck.instantiate()
  new_bug.bug = _bug
  _bug = null # remove this ref to ensure recounted can do its thing (i think?)
  return new_bug

#region get bug functions

## DO NOT USE THIS SPECIFIC ONE
## ONLY to be copied out to fill out info for other bugs in a human-readable way
func _NULL() -> BugBuilder:
  var name = "NULL"
  var description = "NULL"
  var tex_path = "res://assets/Sprites/ant.png"
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

  _bug = Bug.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  return self

# the real shit now
func ant() -> BugBuilder:
  var name = "ant"
  var description = "small, but oh so mighty"
  var tex_path = "res://assets/Sprites/ant.png"
  var base_trade_value = 2.0
  var color = Color.RED
  var weight = 1.0
  var speed = 6.0
  var affability = 3.0
  var cronch = 4.0
  var honor = 9.0
  var juice = 2.0
  var leg = 6
  var stink = 8.0

  _bug = Bug.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  return self

func slug() -> BugBuilder:
  var name = "slug"
  var description = "the biggest pos this side of the garden"
  var tex_path = "res://assets/Sprites/sloog.png"
  var base_trade_value = 1.0
  var color = Color.BISQUE
  var weight = 3.0
  var speed = 1.0
  var affability = 0.0
  var cronch = 0.0
  var honor = 0.0
  var juice = 10.0
  var leg = 0
  var stink = 7.0

  _bug = Bug.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)
  return self
#endregion

#region helper functions to do some thangs
## randomize the color so we get some cool lookin guy B)
func shiny() -> BugBuilder:
  # bug.color =
  return self

## randomize all applicable stats across a normal distribution, then clamp
func normalize_stats() -> BugBuilder:
  _bug.weight = normal_dist_stat(_bug.weight)
  _bug.movement_speed = normal_dist_stat(_bug.movement_speed)
  _bug.affability = normal_dist_stat(_bug.affability)
  _bug.cronch = normal_dist_stat(_bug.cronch)
  _bug.honor = normal_dist_stat(_bug.honor)
  _bug.juice = normal_dist_stat(_bug.juice)
  _bug.stink = normal_dist_stat(_bug.stink)
  return self

static func normal_dist_stat(value: float) -> float:
  var dist = randfn(value, NORMAL_DIST_DEVIATION)
  return clampf(dist, MIN_STAT, MAX_STAT)
#endregion


####################
## Finally, this is a fallback confused bug in case things go wrooooong during Bug scene setup
## This does NOT work with the Fluent Builder
static func get_confused_bug() -> Bug:
  var name = "Confused Bug"
  var description = "This bug is confused!"
  var tex_path = "res://assets/Sprites/pillbug.png"
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

  return Bug.new(name, description, tex_path, weight, speed, base_trade_value, color, affability, cronch, honor, juice, leg, stink)