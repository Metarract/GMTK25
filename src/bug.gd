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

@onready var stun_particles: CPUParticles2D = $%StunParticles
@onready var stun_circle: Node2D = $%StunCircle
#region rays
@onready var ray_s: RayCast2D = $%RayS
@onready var ray_sw: RayCast2D = $%RaySW
@onready var ray_w: RayCast2D = $%RayW
@onready var ray_nw: RayCast2D = $%RayNW
@onready var ray_n: RayCast2D = $%RayN
@onready var ray_ne: RayCast2D = $%RayNE
@onready var ray_e: RayCast2D = $%RayE
@onready var ray_se: RayCast2D = $%RaySE
#endregion

var shader_mat: ShaderMaterial;
var last_pos: Vector2 = Vector2()

func _ready() -> void:
  if not bug_stats:
    bug_stats = BugBuilder.get_confused_bug_stats()
  
  # Assign node references
  sprite = $Sprite2D
  collision_shape = $CollisionShape2D
  state_machine = $%StateMachine

  sprite.material = shader_mat

  # setup from bug_stats data
  sprite.texture = load(bug_stats.texture_path)
  sprite.modulate = bug_stats.color

  # awaken! my state machine!!
  state_machine.awake(self, MovingBug.new())

func _physics_process(_delta: float) -> void:
  # check the number of rays that are colliding
  if check_ray_coll_count() > 6:
    stun()

func update_rotation_from_move():
  # only rotate if we have moved some distance
  # thus we don't jitter when we stop and rotate to 0
  if is_zero_approx(last_pos.distance_to(global_position)): return
  # currently sprites lookin up
  # rotate a bit since right is 0 rot in godot
  rotation = last_pos.angle_to_point(global_position) + (PI / 2)

func stun():
  if state_machine.current_state is StunBug: return
  state_machine.change_state(StunBug.new())

func capture():
  # all that our bug is should be in our stats - so just pass that data to whoever wanted it
  on_bug_captured.emit(bug_stats)
  # remove ourselves, our job here is done
  queue_free()

func check_ray_coll_count() -> int:
  var count := 0
  if ray_s.is_colliding(): count += 1
  if ray_sw.is_colliding(): count += 1
  if ray_w.is_colliding(): count += 1
  if ray_nw.is_colliding(): count += 1
  if ray_n.is_colliding(): count += 1
  if ray_ne.is_colliding(): count += 1
  if ray_e.is_colliding(): count += 1
  if ray_se.is_colliding(): count += 1
  
  return count