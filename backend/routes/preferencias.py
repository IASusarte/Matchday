from fastapi import APIRouter

router = APIRouter()

from bd import sesion_local
from models.preferencia_deporte import PreferenciaDeporte
from models.deporte import Deporte
from schems.preferencia_schem import CrearPreferencia

# PREFERENCIAS

# GET/usuarios/id
@router.get("/usuarios/{id}/preferencias")
def obtener_preferencias(id: int):
    db = sesion_local()
    preferencias = db.query(
        PreferenciaDeporte
    ).filter(
        PreferenciaDeporte.id_usuario == id
    ).all()
    res = []
    for preferencia in preferencias:
        deporte = db.query(
            Deporte
        ).filter(
            Deporte.id_deporte ==
            preferencia.id_deporte
        ).first()
        if deporte:
            res.append(
                {
                    "id": deporte.id_deporte,
                    "nombre": deporte.nombre
                }
            )
    db.close()
    return res

# POST/usuarios/id
@router.post("/usuarios/{id}/preferencias")
def agregar_preferencia(
    id: int,
    datos: CrearPreferencia
):
    db = sesion_local()
    existe = db.query(
        PreferenciaDeporte
    ).filter(
        PreferenciaDeporte.id_usuario == id,
        PreferenciaDeporte.id_deporte == datos.id_deporte
    ).first()
    if existe:
        db.close()
        return {
            "ok": False,
            "mensaje": "La preferencia ya existe"
        }
    preferencia = PreferenciaDeporte(
        id_usuario=id,
        id_deporte=datos.id_deporte
    )
    db.add(preferencia)
    db.commit()
    db.refresh(preferencia)
    db.close()
    return {
        "ok": True,
        "id": preferencia.id_preferencia
    }

# DELETE/usuarios/id
@router.delete("/usuarios/{id}/preferencias/{id_deporte}")
def eliminar_preferencia(
    id: int,
    id_deporte: int
):
    db = sesion_local()
    preferencia = db.query(
        PreferenciaDeporte
    ).filter(
        PreferenciaDeporte.id_usuario == id,
        PreferenciaDeporte.id_deporte == id_deporte
    ).first()
    if preferencia is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Preferencia no encontrada"
        }
    db.delete(preferencia)
    db.commit()
    db.close()
    return {
        "ok": True,
        "mensaje": "Preferencia eliminada"
    }

