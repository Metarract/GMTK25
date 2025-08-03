class_name Bug
extends RigidBody2D

const CAP_TIME_MAX_S = 5
const CAP_RES_MAX := 1.0
const CAP_RES_MIN := 0.0

# for use by inventory and spawn controller
signal on_bug_captured(bug: Bug)

# debug flag
var DEBUG:bool = false

# bug_stats
var bug_stats:BugStats

var is_being_captured := false
var base_cap_resistance := CAP_RES_MAX # modified by stun
var current_cap_resistance := CAP_RES_MAX

# scene vars
var sprite:Sprite2D = null
var collision_shape:CollisionShape2D = null
var state_machine: StateMachine = null

@onready var stun_particles: CPUParticles2D = $%StunParticles
@onready var stun_circle: Node2D = $%StunCircle
@onready var cap_progress_bar = $%CaptureProgress
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

  # Assign node references
  sprite = $Sprite2D
  collision_shape = $CollisionShape2D
  state_machine = $%StateMachine

  ############
  ## fallbackS if not assigned at build time
  if not bug_stats:
    bug_stats = BugBuilder.get_confused_bug_stats()
  if shader_mat != null: sprite.material = shader_mat
  else: shader_mat = sprite.material as ShaderMaterial
  ############

  # setup from bug_stats data
  sprite.texture = load(bug_stats.texture_path)
  sprite.modulate = bug_stats.color
  reset_capture_resistance()

  # awaken! my state machine!!
  state_machine.awake(self, MovingBug.new())

func _process(delta: float) -> void:
  # always face up lol
  # TODO make not goofy like this?
  $CenterContainer.rotation = -rotation

  if is_being_captured:
    if current_cap_resistance <= 0:
      # TODO probably tween in and out the opacity on the progress bar (delay on out)
      # particle effect for capture
      capture()
      cap_progress_bar.visible = false

    current_cap_resistance -= delta / CAP_TIME_MAX_S
  elif state_machine.current_state is not StunBug:
    current_cap_resistance += delta / CAP_TIME_MAX_S

  if current_cap_resistance < base_cap_resistance:
    cap_progress_bar.visible = true
    cap_progress_bar.set_value_no_signal(current_cap_resistance / base_cap_resistance)
  elif current_cap_resistance >= base_cap_resistance:
    cap_progress_bar.visible = false
    is_being_captured = false

  current_cap_resistance = clampf(current_cap_resistance, CAP_RES_MIN, base_cap_resistance)

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
  base_cap_resistance /= 2
  current_cap_resistance /= 2

func capture():
  is_being_captured = false
  on_bug_captured.emit(self)
  Input.set_custom_mouse_cursor(Globals.mouse_pen_shadow, Input.CURSOR_CAN_DROP, Globals.MOUSE_SHADOW_HOTSPOT)

func reset_capture_resistance():
  base_cap_resistance = bug_stats.capture_resistance
  current_cap_resistance = bug_stats.capture_resistance

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

func on_mouse_over():
  Input.set_custom_mouse_cursor(Globals.mouse_grab_hand, Input.CURSOR_CAN_DROP, Globals.MOUSE_GRAB_HOTSPOT)
func on_mouse_out():
  Input.set_custom_mouse_cursor(Globals.mouse_pen_shadow, Input.CURSOR_CAN_DROP, Globals.MOUSE_SHADOW_HOTSPOT)
