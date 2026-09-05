from fastapi import APIRouter

router = APIRouter()

from bd import sesion_local
from models.solicitud import Solicitud
from models.usuario import Usuario
from models.partida import Partida
from schems.solicitud_schem import CrearSolicitud

# SOLICITUDES

# POST
@router.post("/solicitudes")
def crear_solicitud(datos: CrearSolicitud):
    db = sesion_local()
    solicitud_existente = db.query(
        Solicitud
    ).filter(
        Solicitud.id_usuario == datos.id_usuario,
        Solicitud.id_partida == datos.id_partida
    ).first()
    if solicitud_existente:
        db.close()
        return {
            "ok": False,
            "mensaje": "Ya existe una solicitud para esta partida"
        }
    nueva_solicitud = Solicitud(
        id_usuario=datos.id_usuario,
        id_partida=datos.id_partida,
        estado=datos.estado
    )
    db.add(nueva_solicitud)
    db.commit()
    db.refresh(nueva_solicitud)
    db.close()
    return {
        "ok": True,
        "id": nueva_solicitud.id_solicitud
    }

# GET
@router.get("/solicitudes")
def obtener_solicitudes():
    db = sesion_local()
    solicitudes = db.query(
        Solicitud
    ).all()
    res = []
    for solicitud in solicitudes:
        res.append(
            {
                "id": solicitud.id_solicitud,
                "id_usuario": solicitud.id_usuario,
                "id_partida": solicitud.id_partida,
                "estado": solicitud.estado
            }
        )
    db.close()
    return res

# GET/detalles
@router.get("/solicitudes/detalle")
def obtener_solicitudes_detalle():
    db = sesion_local()
    solicitudes = db.query(
        Solicitud
    ).all()
    res = []
    for solicitud in solicitudes:
        usuario = db.query(
            Usuario
        ).filter(
            Usuario.id_usuario ==
            solicitud.id_usuario
        ).first()

        partida = db.query(
            Partida
        ).filter(
            Partida.id_partida ==
            solicitud.id_partida
        ).first()
        res.append(
            {
                "id_solicitud": solicitud.id_solicitud,
                "id_usuario": solicitud.id_usuario,
                "nickname": usuario.nickname
                    if usuario
                    else "",
                "id_partida": solicitud.id_partida,
                "lugar": partida.lugar
                    if partida
                    else "",
                "estado": solicitud.estado
            }
        )
    db.close()
    return res

# GET/id
@router.get("/solicitudes/{id}")
def obtener_solicitud(id: int):
    db = sesion_local()
    solicitud = db.query(
        Solicitud
    ).filter(
        Solicitud.id_solicitud == id
    ).first()
    db.close()
    if solicitud is None:
        return {
            "ok": False,
            "mensaje": "Solicitud no encontrada"
        }
    return {
        "id": solicitud.id_solicitud,
        "id_usuario": solicitud.id_usuario,
        "id_partida": solicitud.id_partida,
        "estado": solicitud.estado
    }

# PUT/id
@router.put("/solicitudes/{id}")
def actualizar_solicitud(
    id: int,
    datos: CrearSolicitud
):
    db = sesion_local()
    solicitud = db.query(
        Solicitud
    ).filter(
        Solicitud.id_solicitud == id
    ).first()
    if solicitud is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Solicitud no encontrada"
        }
    solicitud.estado = datos.estado
    db.commit()
    db.refresh(solicitud)
    db.close()
    return {
        "ok": True,
        "mensaje": "Solicitud actualizada"
    }

# DELETE/id
@router.delete("/solicitudes/{id}")
def eliminar_solicitud(id: int):
    db = sesion_local()
    solicitud = db.query(
        Solicitud
    ).filter(
        Solicitud.id_solicitud == id
    ).first()
    if solicitud is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Solicitud no encontrada"
        }
    db.delete(solicitud)
    db.commit()
    db.close()
    return {
        "ok": True,
        "mensaje": "Solicitud eliminada"
    }
