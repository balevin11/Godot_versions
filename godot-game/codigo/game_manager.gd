extends Node

var coins = 0

signal coin_actualizate(coins_now:int)

func new_coin():
	coins += 1
	coin_actualizate.emit(coins)
	
