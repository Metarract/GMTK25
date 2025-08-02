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

# State machine variables
var current_state:states = states.IDLE
var previous_state:states
var time_in_state:float = 0.0

# "IDLE" state variables
var min_idle_time:float = 0.5
var max_idle_time:float = 2.5

# "MOVING" state variables
var movement_target_pos:Vector2 = Vector2.ZERO

var last_pos: Vector2 = Vector2()

func _ready() -> void:
  
  # bug_stats = BugStats.new("Pillbug", "Small but evasive.", "", 1.0, 50.0, 2)
  
  if not bug_stats:
    bug_stats = BugBuilder.get_confused_bug_stats()
  
  # Assign node references
  sprite = $Sprite2D
  collision_shape = $CollisionShape2D

  # setup from bug_stats data
  sprite.texture = load(bug_stats.texture_path)
  # update color if assigned
  sprite.modulate = bug_stats.color

func change_state(state:states) -> void:
  if DEBUG: print('Changing from ', str(current_state), ' to ', str(state))
  
  previous_state = current_state
  current_state = state
  time_in_state = 0.0

func _process(delta: float) -> void:
  time_in_state += delta # keep track of how long we have been in the current state
  
  match current_state:
    states.IDLE:
      if time_in_state >= max_idle_time:
        change_state(states.TARGETING)
      else:
        if time_in_state >= min_idle_time:
          # 20% to change
          if randf() >= 0.2: change_state(states.TARGETING)
        
      # else maybe chance to spin around or smth?
  
    states.TARGETING:
      # get sad about rays
      # if no rays pick a random spot on the screen
      movement_target_pos = Vector2( randi_range(1, 640), randi_range(1, 360) )
      change_state(states.MOVING)
      
    states.MOVING:
      #if DEBUG: print(str(global_position), " > ", str(movement_target_pos))
      last_pos = global_position
      if movement_target_pos == Vector2.ZERO:
        change_state(states.TARGETING)
        
      # if global_position within +/- 1 of movement_target_pos
      elif (global_position.x >= movement_target_pos.x -1 and global_position.x <= movement_target_pos.x +1) and \
        (global_position.y >= movement_target_pos.y -1 and global_position.y <= movement_target_pos.y +1):
        change_state(states.IDLE)
        
      else:
        var movement_direction = global_position.direction_to(movement_target_pos)
        if not move_and_collide(movement_direction * bug_stats.movement_speed * delta, true):
          move_and_collide(movement_direction * bug_stats.movement_speed * delta)
          update_rotation_from_move()
        else:
          # probably go to targeting
          if DEBUG: print('bonk')
    _:
      print("ERR: Dafuq state are we in? ", current_state)

func update_rotation_from_move():
  # only rotate if we have moved some distance
  # thus we don't jitter when we stop and rotate to 0
  if is_zero_approx(last_pos.distance_to(global_position)): return
  # currently sprites lookin up
  # rotate a bit since right is 0 rot in godot
  sprite.rotation = last_pos.angle_to_point(global_position) + (PI / 2)

func capture():
  # all that our bug is should be in our stats - so just pass that data to whoever wanted it
  on_bug_captured.emit(bug_stats)
  # remove ourselves, our job here is done
  queue_free()
