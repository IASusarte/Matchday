from pydantic import BaseModel

class CrearParticipante(BaseModel):

    id_usuario: int
    id_partida: int