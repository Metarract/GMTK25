class_name Bug
extends RigidBody2D

enum states {IDLE, TARGETING, MOVING}

# for use by inventory and spawn controller
signal on_bug_captured(bug_stats: BugStats)

# debug flag
var DEBUG:bool = false

# bug_stats
var bug_stats:BugStats

# scene vars
var sprite:Sprite2D = null
var collision_shape:CollisionShape2D = null
var state_machine: StateMachine = null

var last_pos: Vector2 = Vector2()

func _ready() -> void:
  if not bug_stats:
    bug_stats = BugBuilder.get_confused_bug_stats()
  
  # Assign node references
  sprite = $Sprite2D
  collision_shape = $CollisionShape2D
  state_machine = $%StateMachine

  # setup from bug_stats data
  sprite.texture = load(bug_stats.texture_path)
  sprite.modulate = bug_stats.color

  # awaken! my state machine!!
  state_machine.awake(self, MovingBug.new())

func update_rotation_from_move():
  # only rotate if we have moved some distance
  # thus we don't jitter when we stop and rotate to 0
  if is_zero_approx(last_pos.distance_to(global_position)): return
  # currently sprites lookin up
  # rotate a bit since right is 0 rot in godot
  rotation = last_pos.angle_to_point(global_position) + (PI / 2)

func capture():
  # all that our bug is should be in our stats - so just pass that data to whoever wanted it
  on_bug_captured.emit(bug_stats)
  # remove ourselves, our job here is done
  queue_free()