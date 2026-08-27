from pydantic import BaseModel

class CrearEvaluacion(BaseModel):

    id_partida: int
    id_evaluador: int
    id_evaluado: int
    compromiso: int
    puntualidad: int
    fairplay: int
    nivel_juego: int