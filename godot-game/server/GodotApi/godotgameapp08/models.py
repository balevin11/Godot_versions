from django.db import models


class Coordenadas(models.Model):
    x = models.FloatField()  # O usa IntegerField si son enteros
    y = models.FloatField()  # O usa IntegerField si son enteros

    def __str__(self):
        return f"({self.x}, {self.y})"