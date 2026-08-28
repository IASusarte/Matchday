from pydantic import BaseModel

class CrearUbicacionDeporte(BaseModel):

    id_ubicacion: int
    id_deporte: int
