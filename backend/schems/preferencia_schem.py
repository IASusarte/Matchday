from pydantic import BaseModel

class CrearPreferencia(BaseModel):

    id_usuario: int
    id_deporte: int