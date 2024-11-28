extends Node

var coins = 0

@onready var cont_coins: Label = $cont_coins

signal coin_actualizate(coins_now:int)

func new_coin():
	coins += 1
	coin_actualizate.emit(coins)
	cont_coins.text = "Monedas: " + str(coins)
