class_name LineDrawer
extends Node2D

var line_sprite: Sprite2D
var coll_body: StaticBody2D
var env_bitmap: BitMap
var image_tex: ImageTexture
var play_area: ReferenceRect

var is_drawing: bool = false

func _ready() -> void:
  line_sprite = $%LineSprite
  coll_body = $%Collider
  play_area = $%PlayArea

  bitmap_setup()

func _unhandled_input(event: InputEvent) -> void:
  if Input.is_action_just_pressed("draw_line"):
    is_drawing = true
  elif Input.is_action_just_released("draw_line"):
    is_drawing = false
  # TODO: keep track of last position, and draw a line from there to here
  ##############
  # if event.is_pressed() && event is InputEventMouseButton && (event as InputEventMouseButton).button_mask == MOUSE_BUTTON_RIGHT:
  #   print("trying to reset")
  #   env_bitmap.create(play_area.size)
  #   update_visuals()
  ##############
  # early return if not drawing
  if is_drawing == false:
    return
  # register on mouse movements
  if event is InputEventMouseMotion:
    var mouse_pos = line_sprite.to_local(get_global_mouse_position())
    draw_circle_to_bitmap(10, mouse_pos)
    # update_colliders()
    update_visuals()


func update_visuals() -> void:
  image_tex.update(env_bitmap.convert_to_image())

func update_colliders():
  var polygons = env_bitmap.opaque_to_polygons(Rect2i(Vector2i(), env_bitmap.get_size()), 2.5)

  var collider_shapes = coll_body.get_children()
  for coll in collider_shapes:
    coll.queue_free()

  for polygon in polygons:
    var c = CollisionPolygon2D.new()
    c.polygon = polygon
    coll_body.add_child(c)

# TODO pass in bool for whether we are drawing or erasing
# TODO adapt shader to do everything below
# receive the bitmap information and our items below
# convert bitmap to texture -> which becomes sampler2d, which can be passed in as a uniform, then use texture(sample, UV)
# do yo thang
# TODO apply some noise
func draw_circle_to_bitmap(strength: float, mouse_pos: Vector2) -> void:
  var radius = floori(strength / 2)
  for x in range(-radius, radius):
    for y in range(-radius, radius):
      var e = pow(x, 2) + pow(y, 2) - pow(radius, 2)
      var adj_pos = Vector2(x,y) + mouse_pos

      # check if we're in bounds
      if is_outside_bounds(adj_pos):
        continue
      # check if we already have a pixel here
      if env_bitmap.get_bitv(adj_pos):
        continue
      env_bitmap.set_bitv(adj_pos, e < 0)
    pass
  pass

func is_outside_bounds(pos: Vector2i) -> bool:
  return pos.x < 0 or pos.y < 0 or pos.x >= env_bitmap.get_size().x or pos.y >= env_bitmap.get_size().y

func bitmap_setup() -> void:
  env_bitmap = BitMap.new()

  var grect: Rect2 = play_area.get_global_rect()
  prints(grect.size, grect.position)
  prints(play_area.size, play_area.position, play_area.global_position)
  # env_bitmap.create(play_area.size)
  env_bitmap.create(grect.size)

  # env_bitmap.set_bitv(grect.get_center(), true)

  image_tex = ImageTexture.new()
  image_tex.set_image(env_bitmap.convert_to_image())
  line_sprite.centered = false
  line_sprite.texture = image_tex
  # line_sprite.global_position = play_area.position
  line_sprite.global_position = grect.position
  update_visuals()
