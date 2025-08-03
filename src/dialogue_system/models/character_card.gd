class_name CharacterCard
extends AnimatedSprite2D

const VENDOR_POSITION = Vector2(480, 251)

enum Emotions {
  NORMAL,
  EEPY,
  YAPPY,
  ANGY
}

var emotion_map = {
  Emotions.NORMAL: "default",
  Emotions.EEPY: "eepy",
  Emotions.YAPPY: "yappy",
  Emotions.ANGY: "angy"
}

func _ready() -> void:
  # centered := false
  # if centered:
  #   # put somewhere else
  #   pass
  # else:
  position = VENDOR_POSITION
  set_emotion(Emotions.NORMAL)

func set_emotion(emotion: Emotions): play(emotion_map[emotion])
