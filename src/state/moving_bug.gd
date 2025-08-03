class_name MovingBug
extends BugState

const TARGET_DIST_THRESHHOLD := 3.0

var _target_gpos: Vector2

func on_enter() -> void:
  retarget()

func on_physics(delta: float) -> void:
  if _target_gpos == Vector2.ZERO:
    retarget()
    return
  _bug.last_pos = _bug.global_position

  var move_dir = _bug.global_position.direction_to(_target_gpos)
  var move_str = move_dir * _bug.bug_stats.movement_speed * delta
  if !_bug.move_and_collide(move_str, true):
    _bug.move_and_collide(move_str)
    _bug.update_rotation_from_move()
  else:
    retarget()

  if _bug.global_position.distance_to(_target_gpos) <= TARGET_DIST_THRESHHOLD:
    on_change_state.emit(IdleBug.new())


func retarget() -> void:
  _target_gpos = Vector2(randi_range(1, 640), randi_range(1, 360))
  # var v = _bug.get_viewport().get_visible_rect().size
  # _target_gpos = Vector2(randi_range(1, v.x), randi_range(1, v.y))
  pass
