from fastapi import APIRouter

router = APIRouter()

from bd import sesion_local
from models.evaluacion import Evaluacion
from schems.evaluacion_schem import CrearEvaluacion

# EVALUACIONES

# POST
@router.post("/evaluaciones")
def crear_evaluacion(datos: CrearEvaluacion):
    db = sesion_local()
    evaluacion = Evaluacion(
        id_partida=datos.id_partida,
        id_evaluador=datos.id_evaluador,
        id_evaluado=datos.id_evaluado,
        compromiso=datos.compromiso,
        puntualidad=datos.puntualidad,
        fairplay=datos.fairplay,
        nivel_juego=datos.nivel_juego
    )
    db.add(evaluacion)
    db.commit()
    db.refresh(evaluacion)
    db.close()
    return {
        "ok": True,
        "id": evaluacion.id_evaluacion
    }

# GET
@router.get("/evaluaciones")
def obtener_evaluaciones():
    db = sesion_local()
    evaluaciones = db.query(
        Evaluacion
    ).all()
    res = []
    for evaluacion in evaluaciones:
        res.append(
            {
                "id": evaluacion.id_evaluacion,
                "id_partida": evaluacion.id_partida,
                "id_evaluador": evaluacion.id_evaluador,
                "id_evaluado": evaluacion.id_evaluado,
                "compromiso": evaluacion.compromiso,
                "puntualidad": evaluacion.puntualidad,
                "fairplay": evaluacion.fairplay,
                "nivel_juego": evaluacion.nivel_juego
            }
        )
    db.close()
    return res

# GET/id
@router.get("/evaluaciones/{id}")
def obtener_evaluacion(id: int):
    db = sesion_local()
    evaluacion = db.query(
        Evaluacion
    ).filter(
        Evaluacion.id_evaluacion == id
    ).first()
    db.close()
    if evaluacion is None:
        return {
            "ok": False,
            "mensaje": "Evaluación no encontrada"
        }
    return {
        "id": evaluacion.id_evaluacion,
        "id_partida": evaluacion.id_partida,
        "id_evaluador": evaluacion.id_evaluador,
        "id_evaluado": evaluacion.id_evaluado,
        "compromiso": evaluacion.compromiso,
        "puntualidad": evaluacion.puntualidad,
        "fairplay": evaluacion.fairplay,
        "nivel_juego": evaluacion.nivel_juego
    }

# PUT/id
@router.put("/evaluaciones/{id}")
def actualizar_evaluacion(
    id: int,
    datos: CrearEvaluacion
):
    db = sesion_local()
    evaluacion = db.query(
        Evaluacion
    ).filter(
        Evaluacion.id_evaluacion == id
    ).first()
    if evaluacion is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Evaluación no encontrada"
        }
    evaluacion.compromiso = datos.compromiso
    evaluacion.puntualidad = datos.puntualidad
    evaluacion.fairplay = datos.fairplay
    evaluacion.nivel_juego = datos.nivel_juego

    db.commit()
    db.refresh(evaluacion)
    db.close()
    return {
        "ok": True,
        "mensaje": "Evaluación actualizada"
    }

# DELETE/id
@router.delete("/evaluaciones/{id}")
def eliminar_evaluacion(id: int):
    db = sesion_local()
    evaluacion = db.query(
        Evaluacion
    ).filter(
        Evaluacion.id_evaluacion == id
    ).first()
    if evaluacion is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Evaluación no encontrada"
        }
    db.delete(evaluacion)
    db.commit()
    db.close()
    return {
        "ok": True,
        "mensaje": "Evaluación eliminada"
    }
