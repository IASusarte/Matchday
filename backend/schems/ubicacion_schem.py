from pydantic import BaseModel

class CrearUbicacion(BaseModel):

    nombres: str
    direccion: str
    ciudad: str
    latitud: float
    longitud: float