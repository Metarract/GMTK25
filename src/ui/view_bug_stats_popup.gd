extends PanelContainer

@onready var rtl_bug_name:RichTextLabel = $VBoxContainer/Header/rtlBugName
@onready var rtl_bug_description:RichTextLabel = $VBoxContainer/Body/VBoxContainer/rtlBugDescription
@onready var rtl_weight:RichTextLabel = $VBoxContainer/Body/VBoxContainer/hbBio/hbWeight/rtlWeight
@onready var rtl_speed = $VBoxContainer/Body/VBoxContainer/hbBio/hbSpeed/rtlSpeed
@onready var rtl_value = $VBoxContainer/Body/VBoxContainer/hbBio/hbValue/rtlValue
@onready var rtl_aff:RichTextLabel = $VBoxContainer/Body/VBoxContainer/vbStats/HBoxContainer/hbCol1/vbStats1/rtlAff
@onready var rtl_honor:RichTextLabel = $VBoxContainer/Body/VBoxContainer/vbStats/HBoxContainer/hbCol1/vbStats1/rtlHonor
@onready var rtl_leg:RichTextLabel = $VBoxContainer/Body/VBoxContainer/vbStats/HBoxContainer/hbCol1/vbStats1/rtlLeg
@onready var rtl_crunch:RichTextLabel = $VBoxContainer/Body/VBoxContainer/vbStats/HBoxContainer/hbCol2/vbStats2/rtlCrunch
@onready var rtl_juice:RichTextLabel = $VBoxContainer/Body/VBoxContainer/vbStats/HBoxContainer/hbCol2/vbStats2/rtlJuice
@onready var rtl_stink:RichTextLabel = $VBoxContainer/Body/VBoxContainer/vbStats/HBoxContainer/hbCol2/vbStats2/rtlStink

func _ready() -> void:
  pass
  #var new_bugg = BugStats.new("Icky Gross BugStats", "A very gross and also icky bug.", null, 69.420, 10.0, 5.0)
  #loadBug(new_bugg)

func loadBug(b:BugStats) -> bool:
  if !b: return false
  
  rtl_bug_name.text = b.bug_name
  rtl_bug_description.text = b.description
  rtl_weight.text = "%3.1f" % [b.weight]
  rtl_speed.text = "%3.1f" % [b.movement_speed]
  rtl_value.text = "%3.1f" % [b.trade_value]
  rtl_aff.text = "%3.1f" % [b.affability]
  rtl_honor.text = "%3.1f" % [b.honor]
  rtl_leg.text = "%3.1f" % [b.leg]
  rtl_crunch.text = "%3.1f" % [b.cronch]
  rtl_juice.text = "%3.1f" % [b.juice]
  rtl_stink.text = "%3.1f" % [b.stink]
  
  return true
