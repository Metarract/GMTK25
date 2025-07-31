class_name LineDrawer
extends Node2D

var line_sprite: Sprite2D
var coll_body: StaticBody2D
var env_bitmap: BitMap
var image_tex: ImageTexture

enum DrawingState {
  IDLE,
  DRAWING,
  ERASING
}

var draw_state := DrawingState.IDLE

func _ready() -> void:
  line_sprite = $%LineSprite
  coll_body = $%Collider
  bitmap_setup()

func _unhandled_input(_event: InputEvent) -> void:
  match draw_state:
    DrawingState.IDLE:
      handle_idle_input()
      return
    DrawingState.DRAWING:
      handle_drawing_input()
      return
    DrawingState.ERASING:
      handle_erasing_input()
      return
    _:
      return

  # TODO: keep track of last position, and draw a line from there to here
  ##############
  # if event.is_pressed() && event is InputEventMouseButton && (event as InputEventMouseButton).button_mask == MOUSE_BUTTON_RIGHT:
  #   print("trying to reset")
  #   env_bitmap.create(get_viewport_rect().size)
  #   update_visuals()
  ##############

func _physics_process(_delta: float) -> void:
  if draw_state == DrawingState.IDLE:
    return

  var is_erasing := false
  if draw_state == DrawingState.ERASING:
    is_erasing = true
  var mouse_pos = line_sprite.to_local(get_global_mouse_position())
  draw_circle_to_bitmap(10, mouse_pos, is_erasing)
  update_colliders()
  update_visuals()

#region state handlers
func handle_idle_input():
  if Input.is_action_just_pressed("draw_line"):
    draw_state = DrawingState.DRAWING
  elif Input.is_action_just_pressed("erase_line"):
    draw_state = DrawingState.ERASING
  pass

func handle_drawing_input():
  if Input.is_action_just_released("draw_line"):
    draw_state = DrawingState.IDLE
  elif Input.is_action_just_pressed("erase_line"):
    draw_state = DrawingState.ERASING

func handle_erasing_input():
  if Input.is_action_just_released("erase_line"):
    draw_state = DrawingState.IDLE
  elif Input.is_action_just_pressed("draw_line"):
    draw_state = DrawingState.DRAWING
#endregion

func update_visuals() -> void:
  image_tex.update(env_bitmap.convert_to_image())

func update_colliders():
  var polygons = env_bitmap.opaque_to_polygons(Rect2i(Vector2i(), env_bitmap.get_size()), 3)

  var collider_shapes = coll_body.get_children()
  for coll in collider_shapes:
    coll.queue_free()

  for polygon in polygons:
    var c = CollisionPolygon2D.new()
    c.polygon = polygon
    coll_body.add_child(c)

# TODO adapt shader to do everything below
# receive the bitmap information and our items below
# convert bitmap to texture -> which becomes sampler2d, which can be passed in as a uniform, then use texture(sample, UV)
# do yo thang
# TODO apply some noise
func draw_circle_to_bitmap(strength: float, mouse_pos: Vector2, is_erasing := false) -> void:
  var radius = floori(strength / 2)
  for x in range(-radius, radius):
    for y in range(-radius, radius):
      # e corresponds to a value that determines whether a point lies either within, on, or outside the circle
      # values > 0 lie outside the circle
      #        < 0 lie within the circle
      #        = 0 lies on the circle
      var e = pow(x, 2) + pow(y, 2) - pow(radius, 2)
      var adj_pos = Vector2(x, y) + mouse_pos

      # check if we're in bounds
      if is_outside_bounds(adj_pos) or e > 0:
        continue
      # check if we already have a pixel here and we're DRAWING or the inverse
      # if env_bitmap.get_bitv(adj_pos):
      if env_bitmap.get_bitv(adj_pos) != is_erasing:
        continue
      # assume we are drawing, otherwise, erase
      env_bitmap.set_bitv(adj_pos, !is_erasing)
    pass
  pass

func is_outside_bounds(pos: Vector2i) -> bool:
  return pos.x < 0 or pos.y < 0 or pos.x >= env_bitmap.get_size().x or pos.y >= env_bitmap.get_size().y

func bitmap_setup() -> void:
  env_bitmap = BitMap.new()

  var vrect: Rect2 = get_viewport_rect()
  env_bitmap.create(vrect.size)

  image_tex = ImageTexture.new()
  image_tex.set_image(env_bitmap.convert_to_image())
  line_sprite.centered = false
  line_sprite.texture = image_tex
  update_visuals()
