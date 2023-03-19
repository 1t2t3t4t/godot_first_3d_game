extends Node

@export var mob_scene: PackedScene

@onready var player = $Player
@onready var spawnLocator = $SpawnPath/SpawnLocator as PathFollow3D
@onready var score_label = $UI/ScoreLabel as ScoreLabel
@onready var rety_screen = $UI/Retry as Retry

@onready var mob_timer = $MobTimer as Timer

func _ready() -> void:
	randomize()
	var mp = get_node("/root/MusicPlayer")
	print(mp)

func _on_mob_timer_timeout() -> void:
	var mob := mob_scene.instantiate() as Mob
	spawnLocator.progress_ratio = randf()
	
	mob.initialize(spawnLocator.position, player.position)
	mob.squashed.connect(func (): score_label.on_mob_squashed(mob))
	add_child(mob)


func _on_player_hit() -> void:
	mob_timer.stop()
	rety_screen.show()
	rety_screen.play_show_anim()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") and rety_screen.visible:
		get_tree().reload_current_scene()
		
