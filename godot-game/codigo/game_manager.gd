extends Node

var coins = 0
@onready var cont_coins: Label = $cont_coins

func new_coin():
	coins += 1
	cont_coins.text = "Monedas: " + str(coins)
	
