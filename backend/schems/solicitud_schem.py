from pydantic import BaseModel

class CrearSolicitud(BaseModel):

    id_usuario: int
    id_partida: int
    estado: str