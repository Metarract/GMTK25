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

var segment_array: Array = []
var last_mouse_pos: Vector2 = Vector2()
const MAX_SEGMENT_SIZE := 10.0

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
  var is_erasing := draw_state == DrawingState.ERASING

  var mouse_pos = get_global_mouse_position()
  if draw_state == DrawingState.DRAWING:
    add_segments(last_mouse_pos, mouse_pos)
    last_mouse_pos = mouse_pos
  else:
    check_erase_colls(mouse_pos, 5)
  # draw_circle_to_bitmap(10, mouse_pos, is_erasing)
  # update_visuals()

#region state handlers
func handle_idle_input():
  if Input.is_action_just_pressed("draw_line"):
    last_mouse_pos = get_global_mouse_position()
    draw_state = DrawingState.DRAWING
  elif Input.is_action_just_pressed("erase_line"):
    draw_state = DrawingState.ERASING

func handle_drawing_input():
  if Input.is_action_just_released("draw_line"):
    draw_state = DrawingState.IDLE
  elif Input.is_action_just_pressed("erase_line"):
    draw_state = DrawingState.ERASING

func handle_erasing_input():
  if Input.is_action_just_released("erase_line"):
    draw_state = DrawingState.IDLE
  elif Input.is_action_just_pressed("draw_line"):
    last_mouse_pos = get_global_mouse_position()
    draw_state = DrawingState.DRAWING
#endregion

func update_visuals() -> void:
  image_tex.update(env_bitmap.convert_to_image())

func add_segments(a: Vector2, b: Vector2) -> void:
  var distance: float = a.distance_to(b)
  var new_segment_arr := []
  if distance > MAX_SEGMENT_SIZE:
    # distance is too great, split into multiple segments
    var rem = fmod(distance, MAX_SEGMENT_SIZE)
    var flat_dist = distance - rem
    var segment_count = floori(flat_dist / MAX_SEGMENT_SIZE)
    # for each, create a vector from a->b (store b as next a)
    for i in range(segment_count):
      # create a new vector denoting the point MAX_DIST from current a
      var nb: Vector2 = (a.direction_to(b) * MAX_SEGMENT_SIZE) + a
      new_segment_arr.append(get_segment_coll(a, nb))
      # move up the line
      a = nb
      pass
  new_segment_arr.append(get_segment_coll(a, b))

  for s in new_segment_arr:
    segment_array.append(s)
    coll_body.add_child(s)

func get_segment_coll(a: Vector2, b: Vector2) -> CollisionShape2D:
  var line = SegmentShape2D.new()
  line.a = a
  line.b = b
  var coll = CollisionShape2D.new()
  coll.shape = line
  return coll

func check_erase_colls(origin: Vector2, radius: float):
  var erasable_segments = []
  for s in segment_array:
    var seg = (s.shape as SegmentShape2D)
    if seg.a.distance_to(origin) < radius or seg.b.distance_to(origin) < radius:
      erasable_segments.append(s)

  for s in erasable_segments:
    segment_array.erase(s)
    s.queue_free()

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

class Segment extends RefCounted:
  const TIMEOUT_MS: int = 5000
  var timestamp: int
  var coll: CollisionShape2D
  var seg: SegmentShape2D

  var start: Vector2:
    set(value):
      printerr("don't")
    get():
      return seg.a
  var end: Vector2:
    set(value):
      printerr("don't")
    get():
      return seg.b

  func _init(start: Vector2, end: Vector2, body: CollisionObject2D) -> void:
    timestamp = Time.get_ticks_msec() + TIMEOUT_MS
    seg = SegmentShape2D.new()
    seg.a = start
    seg.b = end

    coll = CollisionShape2D.new()
    coll.shape = seg
    body.add_child(coll)

  func queue_free():
    coll.queue_free()
