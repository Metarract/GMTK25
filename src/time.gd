extends Node

# Simple time controller

const DAYS:Array = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
const SECONDS_PER_DAY:float = 60.0

var days_passed:int = 0 # The number of days that have passed
var seconds:float = 0.0 # The number of seconds we have been in the current day
var day_index:int = 4:  # The index of DAYS which contains the current day
  set(i):
    day_index = i
    if day_index > 6: day_index = 0
    
var current_day:String: # The current day string
  get:
    return DAYS[day_index]
  set(s):
    print("ERR: Should we be setting Time.current_day directly?")
    current_day = s

func _process(delta: float) -> void:
  seconds += delta
  
  if seconds >= SECONDS_PER_DAY:
    seconds -= SECONDS_PER_DAY
    day_index += 1
    days_passed += 1
