extends Node

var bgm_title = "res://assets/Sounds/Music/Chiptune Vol2 Work Work Work Main.wav"
var bgm_play = "res://assets/Sounds/Music/Chiptune Vol2 Evil Grudge Main.wav"

@onready var bgm_player:AudioStreamPlayer = $BGMPlayer
@onready var bgm_fader:AnimationPlayer = $BGMFader

func play_bgm(path:String) -> void:
  if not path: return
  
  bgm_fader.play("fade")
  await  bgm_fader.animation_finished
  bgm_player.stream = load(path)
  bgm_player.play()
  bgm_fader.play_backwards("fade")
