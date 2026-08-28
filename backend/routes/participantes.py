from fastapi import APIRouter

router = APIRouter()

from bd import sesion_local
from models.participante import Participante
from schems.participante_schem import CrearParticipante

# PARTICIPANTES

# POST
@router.post("/participantes")
def crear_participante(datos: CrearParticipante):
    db = sesion_local()
    participante_existente = db.query(
        Participante
    ).filter(
        Participante.id_usuario == datos.id_usuario,
        Participante.id_partida == datos.id_partida
    ).first()
    if participante_existente:
        db.close()
        return {
            "ok": False,
            "mensaje": "El usuario ya participa en esta partida"
        }
    participante = Participante(
        id_usuario=datos.id_usuario,
        id_partida=datos.id_partida
    )
    db.add(participante)
    db.commit()
    db.refresh(participante)
    db.close()
    return {
        "ok": True,
        "id": participante.id_participante
    }

# GET
@router.get("/participantes")
def obtener_participantes():
    db = sesion_local()
    participantes = db.query(
        Participante
    ).all()
    res = []
    for participante in participantes:
        res.append(
            {
                "id": participante.id_participante,
                "id_usuario": participante.id_usuario,
                "id_partida": participante.id_partida
            }
        )
    db.close()
    return res
