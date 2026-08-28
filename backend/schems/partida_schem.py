from pydantic import BaseModel
from datetime import date, time
from typing import Optional

class CrearPartida(BaseModel):

    id_creador: int
    id_deporte: int
    fecha: date
    hora: time
    cant_jugadores: int
    lugar: str
    id_ubicacion: Optional[int] = None
    descripcion: str
    estado: str