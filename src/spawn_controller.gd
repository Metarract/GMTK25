class_name SpawnController
extends Node

const SPAWN_TIMEOUT_MS_MIN := 500
const SPAWN_TIMEOUT_MS_BASE := 10000
const SPAWN_TIMEOUT_MS_DEFAULT_MOD := 2000
const SPAWN_CAP_DEFAULT := 5
const SPAWN_CAP_MOD := 1

signal bug_spawned(bug)
signal bug_captured(bug)

var active_bugs: int = 0

@export var stage: Node2D

enum SpawnState {
  IDLE,
  CAN_SPAWN,
  SPAWNING
}

var is_awake := false
var state: SpawnState = SpawnState.IDLE

var awaiting_spawn_confirmation := false

var spawn_timeout_add := SPAWN_TIMEOUT_MS_BASE
var spawn_timeout

func _ready() -> void:
  state = SpawnState.CAN_SPAWN
  if stage == null: printerr("no stage set! IDIOT")

func _process(_delta: float) -> void:
  if !is_awake: return
  match state:
    SpawnState.IDLE:
      pass
    SpawnState.CAN_SPAWN:
      pass
    SpawnState.SPAWNING:
      pass
    _:
      pass

  if state != SpawnState.CAN_SPAWN: return
  state = SpawnState.SPAWNING
  var bug = BugBuilder.new().ant().normalize_stats().build()
  bug.position = Vector2(200,200) # for test
  stage.add_child(bug)
  bug_spawned.emit(bug)

## start me up, start me up, start me up i'll never stop~
func awake():
  is_awake = true
  state = SpawnState.CAN_SPAWN

## jk i will stop
func sleep():
  is_awake = false
  state = SpawnState.IDLE

##############

#region state handlers
func handle_idle():
  # wait wait wait wait
  # shift to can spawn when things are choochin
  pass
func handle_can_spawn():
  # spawn a guy
  # increment a thing
  pass
func handle_spawning():
  # basically just waiting out a signal that our current bug is done
  # or that we don't have too many bugs up
  # 
  pass
#endregion

func on_spawn_confirmed(bug: Node2D):
  awaiting_spawn_confirmation = false
  bug.disconnect("", on_spawn_confirmed)
  active_bugs += 1
  ## increment active bug count

func on_bug_captured(bug: Node2D):
  # decrement active bug count
  if (active_bugs == 0):
    printerr("somehow a bug got captured even though we should have none")
    printerr(bug)
  active_bugs -= 1
  pass

func reset_timer():
  spawn_timeout = Time.get_ticks_msec() + spawn_timeout_add
  # TODO modify it?
  # do we adjust it, then clamp?
  # if we do adjust it maybe we emit a signal that tells the
  # play area that things have ramped up
  pass