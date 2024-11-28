extends Node2D

var deads = 0
var dead_icons = []
const dead_icon_scene = preload("res://escenas/dead_icon.tscn")


func new_dead(x: float, y: float):
	var url = "http://127.0.0.1:8000/coordenadas"
		
		# Crear una instancia de HTTPRequest
	var http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.connect("request_completed", _on_server_has_responded)
	var body = JSON.stringify({"x": x, "y": y})
	var headers = ["Content-Type: application/json", "Client-Secret: abc"]
	http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	

# Esta función maneja la respuesta una vez que se recibe
func _on_server_has_responded(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print("Server response:")
	print(response)
	
func _on_server_has_responded_print(result, response_code, headers, body):
	var response = JSON.parse_string(body.get_string_from_utf8())
	print("Server response:")
	print(response)
	for coord in response:
		deads += 1
		var child = dead_icon_scene.instantiate()
		child.position.x = coord["x"]
		child.position.y = coord["y"]
		add_child(child)
		dead_icons.append(child)
	
func _ready() -> void:
	var url = "http://127.0.0.1:8000/coordenadas"
	var request = HTTPRequest.new()
	add_child(request)
	request.connect("request_completed", _on_server_has_responded_print)
	var response = request.request(url)
	
	
