extends RigidBody2D

enum states {IDLE, TARGETING, MOVING}

# debug flag
var DEBUG:bool = false

# bug
var bug:Bug

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

func _ready() -> void:
  
  bug = Bug.new("Pillbug", "Small but evasive.", "", 1.0, 50.0, 2)
  
  if not bug:
    bug = Bug.new("Confused Bug", "This bug is a Bug!", "", 0.0, 0.0, 99999, Color.RED)
  
  # Assign node references
  sprite = $Sprite2D
  collision_shape = $CollisionShape2D
  
  # update color if assigned
  sprite.modulate = bug.color

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
      
      if movement_target_pos == Vector2.ZERO:
        change_state(states.TARGETING)
        
      # if global_position within +/- 1 of movement_target_pos
      elif (global_position.x >= movement_target_pos.x -1 and global_position.x <= movement_target_pos.x +1) and \
        (global_position.y >= movement_target_pos.y -1 and global_position.y <= movement_target_pos.y +1):
        change_state(states.IDLE)
        
      else:
        var movement_direction = global_position.direction_to(movement_target_pos)
        if not move_and_collide(movement_direction * bug.movement_speed * delta, true):
          move_and_collide(movement_direction * bug.movement_speed * delta)
        else:
          # probably go to targeting
          if DEBUG: print('bonk')
    _:
      print("ERR: Dafuq state are we in? ", current_state)
