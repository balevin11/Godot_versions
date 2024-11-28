extends Node

var tcp_server = TCPServer.new()
var port = 8080
var coordenadas = []  # Lista para almacenar múltiples coordenadas
var max_coordenadas = 10  # Límite máximo de coordenadas

func _ready():
	# Iniciar el servidor en el puerto especificado
	tcp_server.listen(port)
	print("Servidor HTTP escuchando en el puerto %d" % port)

func _process(delta):
	# Revisar si hay conexiones entrantes
	if tcp_server.is_connection_available():
		var client = tcp_server.take_connection()
		if client:
			# Leer la solicitud HTTP del cliente
			var request = client.get_utf8_string()
			print("Solicitud recibida:\n%s" % request)

			# Procesar la solicitud
			var response = _handle_http_request(request)
			
			# Enviar la respuesta
			client.put_utf8_string(response)
			client.close()

func _handle_http_request(request):
	# Dividir la solicitud en líneas para analizarla
	var request_lines = request.split("\r\n")
	var request_line = request_lines[0] if request_lines.size() > 0 else ""
	
	# Obtener el método y la ruta
	var parts = request_line.split(" ")
	if parts.size() < 2:
		return _http_response(400, "Solicitud inválida")

	var method = parts[0]
	var path = parts[1]
	
	# Manejar las rutas
	if method == "GET" and path == "/coordenadas":
		if coordenadas.size() > 0:
			return _http_response(200, "Coordenadas almacenadas: %s" % str(coordenadas))
		else:
			return _http_response(404, "No hay coordenadas almacenadas")
	elif method == "POST" and path == "/coordenadas":
		# Buscar el cuerpo de la solicitud
		var body = request.split("\r\n\r\n")[1] if request.find("\r\n\r\n") != -1 else ""
		if body.strip() != "":
			var json = JSON.new()  # Crear una instancia de JSON
			var parse_result = json.parse(body)  # Parsear el cuerpo JSON
			if parse_result.error == OK:
				var nueva_coordenada = parse_result.result  # Coordenada recibida
				# Verificar si el número máximo de coordenadas ha sido alcanzado
				if coordenadas.size() >= max_coordenadas:
					coordenadas.pop_front()  # Eliminar la coordenada más antigua si el límite es alcanzado
				coordenadas.append(nueva_coordenada)  # Agregar la nueva coordenada
				return _http_response(200, "Coordenada almacenada: %s" % str(nueva_coordenada))
			else:
				return _http_response(400, "Cuerpo de solicitud inválido")
		else:
			return _http_response(400, "Cuerpo vacío en la solicitud POST")
	else:
		return _http_response(404, "Ruta no encontrada")

func _http_response(status_code, body):
	# Crear una respuesta HTTP
	return "HTTP/1.1 %d %s\r\nContent-Type: text/plain\r\nContent-Length: %d\r\n\r\n%s" % [
		status_code,
		_get_http_status_message(status_code),
		body.length(),
		body
	]

func _get_http_status_message(status_code):
	# Mensajes de estado HTTP
	match status_code:
		200: return "OK"
		400: return "Bad Request"
		404: return "Not Found"
		_: return "Internal Server Error"
