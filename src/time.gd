class_name TimeController
extends Node

# Simple time controller

signal day_ended(current_day: String)

const DAYS: Array = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"]
const SECONDS_PER_DAY: float = 15.0 #60.0

var _active := false

var days_passed: int = 0 # The number of days that have passed
var seconds: float = 0.0 # The number of seconds we have been in the current day
var day_index: int = 5: # The index of DAYS which contains the current day
  set(i):
    day_index = i
    if day_index > 6: day_index = 0
    
var current_day: String: # The current day string
  get:
    return DAYS[day_index]
  set(s):
    print("ERR: Should we be setting Time.current_day directly?")
    current_day = s

func _process(delta: float) -> void:
  if !_active: return
  if seconds < SECONDS_PER_DAY:
    seconds += delta
  elif seconds >= SECONDS_PER_DAY:
    reset_day_seconds()
    _active = false
    day_ended.emit(current_day)

func tick_day():
  day_index += 1
  days_passed += 1
  _active = true

func reset_day_seconds():
  seconds = 0.0
