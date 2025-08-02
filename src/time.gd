extends Node

# Simple time controller

const DAYS:Array = ["Mon", "Tue", "Wed", "Thu", "Fri"] #, "Sat", "Sun"]
const SECONDS_PER_DAY:float = 60.0

var time_counter:float = 0.0  # The number of seconds we have been in the current day
var day_counter:int = 0       # The index of DAYS which contains the current day
var current_day:String:
  get:
    return DAYS[day_counter]
  set(s):
    print("ERR: Should we be setting Time.current_day directly?")
    current_day = s

func _process(delta: float) -> void:
  time_counter += delta
  
  if time_counter >= SECONDS_PER_DAY:
    time_counter -= SECONDS_PER_DAY
    day_counter += 1
    if day_counter > 4: day_counter = 0
