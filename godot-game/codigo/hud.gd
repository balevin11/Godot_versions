extends CanvasLayer

@onready var contador_monedas: Label = $contador_monedas

func _ready() -> void:
	visible = true
	var game_manager = get_node("%GameManager")
	game_manager.coin_actualizate.connect(_on_new_coin)
	
func _on_new_coin(coin_count : int) -> void:
	contador_monedas.text = str(coin_count)
