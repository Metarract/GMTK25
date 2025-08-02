class_name StunBug
extends BugState

const STUN_TIMEOUT := 4.0
const FLASH_STR_MAX := 0.7
const STUN_CIRC_ROT_AMNT := PI / 30

var stun_timer := 0.0
var flash_strength := FLASH_STR_MAX
var stun_circ_dir := -1

func on_enter() -> void:
  flash_strength = FLASH_STR_MAX
  if randf() > 0.5: stun_circ_dir = 1
  else: stun_circ_dir = -1

  # flip accordingly
  _bug.stun_circle.scale = Vector2(stun_circ_dir, 1)

  _bug.stun_particles.emitting = true
  _bug.stun_circle.visible = true
  update_stun_flash(flash_strength)

func on_process(delta: float) -> void:
  flash_strength -= delta * 2
  flash_strength = clampf(flash_strength, 0, FLASH_STR_MAX)
  update_stun_flash(flash_strength)

  _bug.stun_circle.rotate(STUN_CIRC_ROT_AMNT * stun_circ_dir)

  stun_timer += delta
  if stun_timer >= STUN_TIMEOUT:
    on_change_state.emit(MovingBug.new())

func on_exit() -> void:
  update_stun_flash()
  _bug.stun_circle.visible = false

func update_stun_flash(val: float = 0): _bug.shader_mat.set_shader_parameter("strength", val)
