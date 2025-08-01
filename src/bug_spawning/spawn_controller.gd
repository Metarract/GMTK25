class_name SpawnController
extends Node

const SPAWN_CAP_DEFAULT := 20 # 5
const SPAWN_CAP_MOD := 1

## for use by the play zone to do some fanfare or sum shit
signal bug_spawned(bug_stats: BugStats, count: int)
## pass me up from listening on the bug to the play zone
signal bug_captured(bug_stats: BugStats, remaining: int)

var _is_awake := false

var active_bugs: int = 0
var spawn_cap: int = SPAWN_CAP_DEFAULT

var spawner: SpawningStrategy

@onready var stage: Node2D = $%Stage
@onready var spawn_positions_container: Node2D = $%SpawnPositions

func _ready() -> void:
  ######### debug
  var gspawns = []
  for node in spawn_positions_container.get_children():
    gspawns.append(node.global_position)
  set_spawn_strategy(RandomSpawn.new(gspawns))
  awake()
  ######### debug

func _process(delta: float) -> void:
  if !_is_awake:
    if active_bugs >= spawn_cap: return
    awake()
  spawner.on_process(delta)

func awake():
  _is_awake = true

func sleep():
  _is_awake = false

func set_spawn_strategy(s: SpawningStrategy) -> void:
  if (spawner != null):
    spawner.on_exit()
    spawner.try_spawn_bug.disconnect(on_spawn_request)
  spawner = s
  spawner.on_enter()
  spawner.try_spawn_bug.connect(on_spawn_request)

func on_spawn_request(bug: Bug, gpos: Vector2):
  print("got bug spawn request")
  active_bugs += 1
  stage.add_child(bug)
  bug.global_position = gpos
  bug_spawned.emit(bug, active_bugs)
  bug.on_bug_captured.connect(on_bug_captured)
  if active_bugs >= spawn_cap:
    sleep()

func on_bug_captured(bug: Bug):
  bug.on_bug_captured.disconnect(on_bug_captured)
  # decrement active_bug count
  if (active_bugs == 0):
    printerr("somehow a bug got captured even though we should have none")
    printerr(bug)
    return
  active_bugs -= 1
  bug_captured.emit(bug, active_bugs)
