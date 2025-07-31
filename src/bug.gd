extends Node2D
class_name Bug

# bio
var bug_name:String = ""
var description:String = ""
var texture_path:String = "" 
var color:Color = Color(1.0, 1.0, 1.0, 1.0)
var weight:float = 0.0
var movement_speed:float = 0.0 # likely to move to MovementController ?

var base_trade_value:float = 10.0
var trade_value:float:
	set(v):
		print('eh? should we be setting Bug.trade_value directly?')
		trade_value = v
	get():
		return base_trade_value + ((10 * affability) + (10 * cronch) + (10 * honor) + (10 * juice) + (10 * leg) + (10 * stink))

# stats
var affability:float = 0.0
var cronch:float = 0.0
var honor:float = 0.0
var juice:float = 0.0
var leg:int = 0 # literally the number of legs the bug has
var stink:float = 0.0

# scene vars
var sprite:Sprite2D = null
var collision_shape:CollisionObject2D = null
var movement_controller:Node = null

func _init(bn:String, d:String, tp:String, wgt:float, ms:float, btv:float, col:Color=Color.TRANSPARENT, a:float=-1.0, c:float=-1.0, h:float=-1.0, j:float=-1.0, l:int=-1.0, s:float=-1.0) -> void:
	bug_name = bn
	description = d
	texture_path = tp
	weight = wgt
	movement_speed = ms
	base_trade_value = btv
	
	# Assign values if passed, or define random ranges here
	if col != Color.TRANSPARENT: color = col
	else: color = Color(randf_range(0.0, 1.0), randf_range(0.0, 1.0), randf_range(0.0, 1.0), 1.0)
	
	if a != -1.0: affability = a
	else: affability = randf_range(0.0, 10.0)
	
	if c != -1.0: cronch = c
	else: cronch = randf_range(0.0, 10.0)
	
	if h != -1.0: honor = h
	else: honor = randf_range(0.0, 10.0)
	
	if j != -1.0: juice = j
	else: juice = randf_range(0.0, 10.0)
	
	if l != -1.0: leg = l
	else: leg = randi_range(1, 10)
	
	if s != -1.0: stink = s
	else: stink = randf_range(0.0, 10.0)

func _ready() -> void:
	# Assign scene references on read
	sprite = $Sprite2D
	collision_shape = $CollisionShape2D
	movement_controller = $MovementController
	
	# update color if assigned
	if color: sprite.modulate = color
