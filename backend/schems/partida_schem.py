from pydantic import BaseModel
from datetime import date, time

class CrearPartida(BaseModel):

    id_creador: int
    id_deporte: int
    fecha: date
    hora: time
    cant_jugadores: int
    lugar: str
    descripcion: str
    estado: str