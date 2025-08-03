extends Node
class_name AudioController

var sfx_pitch_variation:float = 0.2

var bgm_title = "res://assets/Sounds/Music/Chiptune Vol2 Work Work Work Main.wav"
var bgm_play = "res://assets/Sounds/Music/Chiptune Vol2 Evil Grudge Main.wav"

@onready var bgm_player:AudioStreamPlayer = $BGMPlayer
@onready var bgm_fader:AnimationPlayer = $BGMFader
@onready var draw_player:AudioStreamPlayer = $DrawPlayer
@onready var sfx_player:AudioStreamPlayer = $SFXPlayer
@onready var ui_player:AudioStreamPlayer = $UIPlayer

func play_bgm(path:String) -> void:
  if not path: return
  
  bgm_fader.play("fade")
  await  bgm_fader.animation_finished
  bgm_player.stream = load(path)
  bgm_player.play()
  bgm_fader.play_backwards("fade")
  
func play_drawing() -> void: play_sfx("res://assets/Sounds/Library Scribbling B.wav", draw_player)
func play_stun_bug() -> void: play_sfx("res://assets/Sounds/Grab Sounds/Jump 009.wav")
func play_capture_bug() -> void: play_sfx("res://assets/Sounds/Strike Sounds/Melee Attack Punch 00%d.wav" %[randi_range(2,4)]) 
func play_journal_open() -> void: play_sfx("res://assets/Sounds/Library Foliant G Clipped.wav", ui_player)
func play_journal_closed() -> void: play_sfx("res://assets/Sounds/Library Foliant A.wav", ui_player)
func play_scribble() -> void: play_sfx("res://assets/Sounds/Library Scribbling B.wav")
func play_coins() -> void: play_sfx("res://assets/Sounds/Coins In Sack Dropped on Wood.wav")


func play_sfx(path:String, player:AudioStreamPlayer = sfx_player) -> void:
  if not path: return

  var clip = load(path)
  if not clip: return
  
  # vary the pitch of SFX to prevent audio fatigue 
  var pitch_variation = randf_range(-sfx_pitch_variation, sfx_pitch_variation)
  player.pitch_scale = 1.0 + pitch_variation

  # load and play
  if player.stream != clip: player.stream = clip
  player.play()
