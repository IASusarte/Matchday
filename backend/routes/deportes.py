from fastapi import APIRouter

router = APIRouter()

from bd import sesion_local
from models.deporte import Deporte

# DEPORTES

# GET
@router.get("/deportes")
def obtener_deportes():
    db = sesion_local()
    deportes = db.query(
        Deporte
    ).all()
    res = []
    for deporte in deportes:
        res.append(
            {
                "id": deporte.id_deporte,
                "nombre": deporte.nombre
            }
        )
    db.close()
    return res