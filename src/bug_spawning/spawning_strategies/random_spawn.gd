class_name RandomSpawn
extends SpawningStrategy

const SPAWN_TIMEOUT_MS_MIN := 500
const SPAWN_TIMEOUT_MS_BASE := 2000 # 10000
const SPAWN_TIMEOUT_MS_DEFAULT_MOD := 2000

# TODO timer
# timer modifies itself or summin idunno

var _spawn_timeout_cd := SPAWN_TIMEOUT_MS_BASE
var _spawn_timer := 0

func on_enter() -> void:
  print("starting random spawner")
  # reset_timer()

func on_process(_delta: float) -> void:
  if can_spawn:
    handle_can_spawn()
  else:
    handle_idle()

func handle_idle():
  if Time.get_ticks_msec() > _spawn_timer:
    can_spawn = true
func handle_can_spawn():
  print("attempting to spawn bug")
  var bug = get_random_bug()
  try_spawn_bug.emit(bug, get_random_gpos())
  # 
  can_spawn = false
  reset_timer()

func get_random_gpos() -> Vector2:
  print("getting random spawn position")
  var index = randi() % _global_spawn_positions.size()
  return _global_spawn_positions[index]

func get_random_bug() -> Bug:
  print("getting random bug")
  # for now just spawn a ant, but we should have a way of figuring out what to spawn
  var builder = BugBuilder.new()
  var count = builder.BugType.size()
  var rindex = randi() % count
  ########### debug
  # var bug = BugBuilder.new().ladybug().normalize_stats().build()
  ########### debug
  var bug = BugBuilder.new().BugType.values()[rindex].call().normalize_stats().build()
  return bug

func reset_timer():
  _spawn_timer = Time.get_ticks_msec() + _spawn_timeout_cd
  # TODO modify it?
  # do we adjust it, then clamp?
  # if we do adjust it maybe we emit a signal that tells the
  # play area that things have ramped up
  pass