import json
from django.http import JsonResponse
from django.views.decorators.csrf import csrf_exempt

from godotgameapp08.models import Coordenadas

@csrf_exempt
def coords(request):
    if request.method == "GET":
        try:
            # Recuperar todas las coordenadas de la base de datos
            all_coords = list(Coordenadas.objects.all().values('x', 'y'))
            return JsonResponse(all_coords, safe=False)
        except Exception as e:
            return JsonResponse({'error': str(e)}, status=500)

    elif request.method == "POST":
        try:
            # Intentar leer el cuerpo de la solicitud
            body_json = json.loads(request.body)
            json_x = body_json['x']
            json_y = body_json['y']
        except KeyError as e:
            # Si falta alguno de los parámetros en el cuerpo de la solicitud
            return JsonResponse({"error": f"Missing parameter: {str(e)}"}, status=400)

        # Verificar que x y y no estén vacíos
        if not json_x or not json_y:
            return JsonResponse({"error": "Missing parameter value"}, status=400)

        try:
            # Intentar convertir x y y a tipos numéricos
            json_x = float(json_x)
            json_y = float(json_y)
        except ValueError:
            # Si la conversión falla (por ejemplo, si no es un número válido)
            return JsonResponse({"error": "Invalid data type for x or y"}, status=400)

        # Crear y guardar una nueva coordenada
        coord = Coordenadas(x=json_x, y=json_y)
        coord.save()

        # Respuesta exitosa con el ID de la coordenada recién guardada
        return JsonResponse({"message": "Coordinates created successfully", "id": coord.id}, status=201)

    else:
        # Si el método HTTP no es GET ni POST, devolver un error 405
        return JsonResponse({'error': 'Not supported HTTP method'}, status=405)

@csrf_exempt  # Si no tienes CSRF habilitado en tu juego
def limpiar_coordenadas(request):
    if request.method == "POST":
        try:
            # Elimina todas las coordenadas
            deleted_count, _ = Coordenadas.objects.all().delete()
            return JsonResponse({"message": f"{deleted_count} coordenadas eliminadas."}, status=200)
        except Exception as e:
            return JsonResponse({"error": f"Hubo un error al eliminar las coordenadas: {str(e)}"}, status=500)
    else:
        return JsonResponse({"error": "Método no soportado"}, status=405)

