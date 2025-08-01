class_name BugStatsDistributionGraph
extends Control
## stickynote is currently pinned to top left corner, so position within other controls based on that
## or change it lol
## USAGE: just put it into the scene and call set_bug_stats(<bug stats here>), and bada bing

const MIN_PERCENT := 0.3
const MAX_PERCENT := 1.0
const TWEEN_DURATION_S := 2

@onready var origin: Marker2D = $%Origin
@onready var stat_poly: Polygon2D = $%StatPoly

var bug_stats: Bug

# order matters here! must move in a clockwise or anticlockwise fashion
# all others, could be in any order but let's be consistent lol
var stats = {
  "juice": StatVec.new(),
  "honor": StatVec.new(),
  "stink": StatVec.new(),
  "affability": StatVec.new(),
  "leg": StatVec.new(),
  "cronch": StatVec.new(),
}

var tick_tweener: Tween
var tick_tween_percent: float = MIN_PERCENT

func _ready() -> void:
  # get the position of all our marker2ds (which is relative to our origin)
  stats["juice"].ext_pos = $%JuiceExtent.position
  stats["honor"].ext_pos = $%HonorExtent.position
  stats["stink"].ext_pos = $%StinkExtent.position
  stats["affability"].ext_pos = $%AffabilityExtent.position
  stats["leg"].ext_pos = $%LegExtent.position
  stats["cronch"].ext_pos = $%CronchExtent.position
  # set other default max values
  # TODO probably have these as constants on the bug builder or the bug stats
  stats["leg"].max_val = 20.0
  ############# debug
  # set_bug_stats(BugBuilder.new().ant()._bug)
  ############# debug

#################################
## initiates the redraw
func set_bug_stats(bug: Bug) -> void:
  stats["juice"].value = bug.juice
  stats["honor"].value = bug.honor
  stats["stink"].value = bug.stink
  stats["affability"].value = bug.affability
  stats["leg"].value = bug.leg
  stats["cronch"].value = bug.cronch

  for stat in stats.values():
    (stat as StatVec).reset()

  reset_tick_tween()

func reset_tick_tween():
  if tick_tweener != null:
    tick_tweener.kill()

  var bound_polygon_call = do_polygon_tick.bind(MIN_PERCENT)
  tick_tweener = create_tween()
  tick_tweener.set_ease(Tween.EASE_OUT)
  tick_tweener.set_trans(Tween.TRANS_EXPO)
  tick_tweener.tween_callback(bound_polygon_call)
  tick_tweener.tween_interval(0.5)
  tick_tweener.tween_method(do_polygon_tick, MIN_PERCENT, MAX_PERCENT, TWEEN_DURATION_S)

func do_polygon_tick(percent: float):
  var vec_arr: PackedVector2Array = []
  for s in stats.values():
    # vec_arr.append(s.current) # the real shit, for now don't use

    # gets the full length of the vector, multiples it by our percentage
    # then multiplies -that- by the same normalized vector
    var vec = (s.ext_pos.length() * s.base * percent) * s.ext_pos.normalized()
    vec_arr.append(vec)
  stat_poly.polygon = vec_arr

## helper class
class StatVec:
  var ext_pos: Vector2

  var value: Variant
  var base: float
  var current: float = MIN_PERCENT

  var min_val: float = 0.0
  var max_val: float = 10.0

  func reset():
    current = MIN_PERCENT
    var r = remap(value, min_val, max_val, 0.0, MAX_PERCENT)
    base = clampf(r, MIN_PERCENT, MAX_PERCENT)
