extends Node

@onready var player: CharacterBody2D = $".."
@onready var timer: Timer = $Timer

const DURATION = 5
const PITCH_DEFAULT : float = 1

@export var pitch_efecto_velocity : float
@export var MATERIAL : Material

func _ready() -> void:
	player.effect_run.connect(_on_player_run_effect)
	timer.timeout.connect(_on_timer_timeout)
	
func _on_player_run_effect() -> void:
	player.run = true
	player.activate_material(MATERIAL)
	Music.pitch_scale = pitch_efecto_velocity
	timer.start(DURATION)

func _on_timer_timeout() -> void:
	player.run = false
	player.activate_material(null)
	Music.pitch_scale = PITCH_DEFAULT
