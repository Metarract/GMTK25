class_name LineDrawer
extends Node2D

# constants (real)
# see: src/shaders/linedraw_bitmap_processor.gdshader
var S_PARAM_LINE_COLOR := "line_color"
var S_PARAM_SEGMENT_RADIUS := "segment_radius"
var S_PARAM_SEGMENT_COUNT := "segment_count"
var S_PARAM_SEGMENTS := "segments"
# "constants"
@export var MAX_SEGMENT_SIZE: float = 3.0 # set this to influence the size of the line as well
@export var MIN_SEGMENT_SIZE: float = 1.0
@export var MAX_SEGMENT_COUNT: int = 1000 # absolutely CANNOT go above 1000 without editing the shader
@export var SEGMENT_TIMEOUT_MS: int = 3000

# state
enum DrawState {
  IDLE,
  DRAWING,
  ERASING
}

var draw_state := DrawState.IDLE

# segment management
var segment_array: Array = []
var removal_queue: Array = []
var last_mouse_pos: Vector2 = Vector2()

@export var segment_color: Color = Color.DARK_GRAY:
  set = set_segment_color

# nodes
var line_sprite: Sprite2D
var coll_body: StaticBody2D
var shader_mat: ShaderMaterial

#region lifecycle
func _ready() -> void:
  line_sprite = $%LineSprite
  coll_body = $%Collider
  shader_mat = line_sprite.material as ShaderMaterial
  set_segment_color(segment_color)
  setup_blank_image()

func setup_blank_image() -> void:
  # probably better to use a ColorRect rather than do this nonsense here, but it only happens once so who cares right now
  var bmp = BitMap.new()
  bmp.create(get_viewport_rect().size)

  line_sprite.centered = false
  line_sprite.texture = ImageTexture.new()
  line_sprite.texture.set_image(bmp.convert_to_image());

func _unhandled_input(_event: InputEvent) -> void:
  match draw_state:
    DrawState.IDLE:
      handle_idle_input()
    DrawState.DRAWING:
      handle_drawing_input()
      if _event is InputEventMouseMotion:
        get_viewport().set_input_as_handled()
    DrawState.ERASING:
      handle_erasing_input()

func _process(_delta: float) -> void:
  handle_removal_queue()

func _physics_process(_delta: float) -> void:
  queue_timeouts()
  queue_segment_cap_removals()
  var mouse_pos = get_global_mouse_position()
  match draw_state:
    DrawState.IDLE:
      return
    DrawState.DRAWING:
      var result = try_add_segments(last_mouse_pos, mouse_pos)
      if result:
        last_mouse_pos = mouse_pos
        update_visuals()
    DrawState.ERASING:
      var result = try_erase_segments(mouse_pos, 5)
      if result: update_visuals()
#endregion

#region state handlers
func handle_idle_input():
  if Input.is_action_just_pressed("draw_line"):
    last_mouse_pos = get_global_mouse_position()
    draw_state = DrawState.DRAWING
  elif Input.is_action_just_pressed("erase_line"):
    draw_state = DrawState.ERASING

func handle_drawing_input():
  if Input.is_action_just_released("draw_line"):
    draw_state = DrawState.IDLE
  elif Input.is_action_just_pressed("erase_line"):
    draw_state = DrawState.ERASING

func handle_erasing_input():
  if Input.is_action_just_released("erase_line"):
    draw_state = DrawState.IDLE
  elif Input.is_action_just_pressed("draw_line"):
    last_mouse_pos = get_global_mouse_position()
    draw_state = DrawState.DRAWING
#endregion

#region segment management
## returns false if segment was too small, true if segment(s) were added
func try_add_segments(a: Vector2, b: Vector2) -> bool:
  var distance: float = a.distance_to(b)
  if distance < MIN_SEGMENT_SIZE: return false
  var timeout_cd = Time.get_ticks_msec() + SEGMENT_TIMEOUT_MS
  if distance > MAX_SEGMENT_SIZE:
    # distance is too great, split into multiple segments
    # keeps our segments small so that erasing isn't too wonky
    var rem = fmod(distance, MAX_SEGMENT_SIZE)
    var flat_dist = distance - rem
    var segment_count = floori(flat_dist / MAX_SEGMENT_SIZE)
    # for each, create a vector from a->b (store b as next a)
    for i in range(segment_count):
      # create a new vector denoting the point MAX_SEGMENT_SIZE from current a
      var nb: Vector2 = (a.direction_to(b) * MAX_SEGMENT_SIZE) + a
      segment_array.append(Segment.new(a, nb, coll_body, timeout_cd))
      # move up the line
      a = nb
      pass
  segment_array.append(Segment.new(a, b, coll_body, timeout_cd))
  return true

## returns false if no segments were removed, otherwise true
func try_erase_segments(origin: Vector2, radius: float) -> bool:
  var erasable_segments = []
  var retval := false
  for s in segment_array:
    if s.a.distance_to(origin) < radius or s.b.distance_to(origin) < radius:
      erasable_segments.append(s)
      retval = true
  # don't modify an array while you're iterating over it
  for s in erasable_segments:
    segment_array.erase(s)
    s.queue_free()
  return retval

func queue_timeouts():
  var to_queue = []
  for s in segment_array:
    if Time.get_ticks_msec() > s.timeout:
      to_queue.append(s)
  # don't modify an array while you're iterating over it
  for s in to_queue:
    segment_array.erase(s)
    removal_queue.append(s)

func queue_segment_cap_removals():
  var excess = segment_array.size() - MAX_SEGMENT_COUNT
  if excess < 0:
    return
  for s in range(excess):
    removal_queue.append(segment_array[s])
    segment_array.erase(segment_array[s])

func handle_removal_queue():
  var update_vis := false
  while removal_queue.size() > 0:
    update_vis = true
    var s = removal_queue.front()
    removal_queue.erase(s)
    s.queue_free()
  if update_vis: update_visuals()
#endregion

func update_visuals() -> void:
  var segment_vec2_array: PackedVector2Array = []
  for s in segment_array:
    segment_vec2_array.append(s.origin)
  shader_mat.set_shader_parameter(S_PARAM_SEGMENT_RADIUS, MAX_SEGMENT_SIZE)
  shader_mat.set_shader_parameter(S_PARAM_SEGMENT_COUNT, segment_vec2_array.size())
  shader_mat.set_shader_parameter(S_PARAM_SEGMENTS, segment_vec2_array)

func set_segment_color(c: Color) -> void:
  segment_color = c
  if shader_mat == null: return
  shader_mat.set_shader_parameter(S_PARAM_LINE_COLOR, segment_color)

## helper class to keep track of some data
class Segment extends RefCounted:
  var timeout: int
  var coll: CollisionShape2D
  var segment: SegmentShape2D
  var origin: Vector2i
  # TODO color, noise usage, etc. other values to account for when drawing with different implements

  var a: Vector2:
    set(value):
      printerr("don't")
    get():
      return segment.a
  var b: Vector2:
    set(value):
      printerr("don't")
    get():
      return segment.b

  func _init(start: Vector2, end: Vector2, body: CollisionObject2D, timeout_cd: int) -> void:
    timeout = timeout_cd
    segment = SegmentShape2D.new()
    coll = CollisionShape2D.new()

    segment.a = start
    segment.b = end

    coll.shape = segment

    var c_x = (segment.a.x + segment.b.x) / 2
    var c_y = (segment.a.y + segment.b.y) / 2
    origin = Vector2i(c_x, c_y)

    body.add_child(coll) # this is a little goofy but this should only ever be used here

  func queue_free():
    # thin queue_free wrapper since we had side effects in init that created references
    if coll == null or coll.is_queued_for_deletion(): return
    coll.queue_free()
