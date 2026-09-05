from fastapi import APIRouter

router = APIRouter()

from bd import sesion_local
from models.partida import Partida
from models.usuario import Usuario
from models.solicitud import Solicitud
from models.participante import Participante
from schems.partida_schem import CrearPartida

# PARTIDAS

# POST
@router.post("/partidas")
def crear_partida(partida: CrearPartida):
    db = sesion_local()
    nueva_partida = Partida(
        id_creador=partida.id_creador,
        id_deporte=partida.id_deporte,
        fecha=partida.fecha,
        hora=partida.hora,
        cant_jugadores=partida.cant_jugadores,
        lugar=partida.lugar,
        id_ubicacion=partida.id_ubicacion,
        descripcion=partida.descripcion,
        estado=partida.estado,
    )
    db.add(nueva_partida)
    db.commit()
    db.refresh(nueva_partida)
    id_partida = nueva_partida.id_partida
    participante = Participante(
        id_usuario=nueva_partida.id_creador,
        id_partida=id_partida
    )
    db.add(participante)
    db.commit()
    db.close()
    return{
        "mensaje": "Partida creada exitosamente",
        "id": id_partida
    }

# POST/id/finalizar
@router.post("/partidas/{id}/finalizar")
def finalizar_partida(id: int):
    db = sesion_local()
    partida = db.query(
        Partida
    ).filter(
        Partida.id_partida == id
    ).first()
    if partida is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Partida no encontrada"
        }
    partida.estado = "Finalizada"
    db.commit()
    db.close()
    return {
        "ok": True,
        "mensaje": "Partida finalizada"
    }

# GET
@router.get("/partidas")
def obtener_partidas():
    db = sesion_local()
    partidas = db.query(
        Partida
    ).all()
    res = []
    for partida in partidas:
        res.append(
            {
                "id": partida.id_partida,
                "id_creador": partida.id_creador,
                "id_deporte": partida.id_deporte,
                "fecha": str(partida.fecha),
                "hora": str(partida.hora),
                "cant_jugadores": partida.cant_jugadores,
                "lugar": partida.lugar,
                "id_ubicacion": partida.id_ubicacion,
                "descripcion": partida.descripcion,
                "estado": partida.estado
            }
        )
    db.close()
    return res

# GET/activas
@router.get("/partidas/activas")
def obtener_partidas_activas():
    db = sesion_local()
    partidas = db.query(
        Partida
    ).filter(
        Partida.estado == "Activa"
    ).all()
    res = []
    for partida in partidas:
        res.append(
            {
                "id": partida.id_partida,
                "id_creador": partida.id_creador,
                "fecha": str(partida.fecha),
                "hora": str(partida.hora),
                "lugar": partida.lugar
            }
        )
    db.close()
    return res

# GET/id
@router.get("/partidas/{id}")
def obtener_partida(id: int):
    db = sesion_local()
    partida = db.query(
        Partida
    ).filter(
        Partida.id_partida == id
    ).first()
    usuario = db.query(
    Usuario
    ).filter(
        Usuario.id_usuario == partida.id_creador
    ).first()
    db.close()
    if partida is None:
        return {
            "ok": False,
            "mensaje": "Partida no encontrada"
        }
    return {
        "id": partida.id_partida,
        "id_creador": partida.id_creador,
        "organizador": usuario.nickname if usuario else "",
        "id_deporte": partida.id_deporte,
        "fecha": str(partida.fecha),
        "hora": str(partida.hora),
        "cant_jugadores": partida.cant_jugadores,
        "lugar": partida.lugar,
        "descripcion": partida.descripcion,
        "estado": partida.estado
    }

# GET/id/detalle
@router.get("/partidas/{id}/detalle")
def obtener_detalle_partida(id: int):
    db = sesion_local()
    partida = db.query(
        Partida
    ).filter(
        Partida.id_partida == id
    ).first()
    if partida is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Partida no encontrada"
        }
    participantes = db.query(
        Participante
    ).filter(
        Participante.id_partida == id
    ).all()
    solicitudes = db.query(
        Solicitud
    ).filter(
        Solicitud.id_partida == id
    ).all()
    res = {
        "id": partida.id_partida,
        "id_creador": partida.id_creador,
        "id_deporte": partida.id_deporte,
        "fecha": str(partida.fecha),
        "hora": str(partida.hora),
        "lugar": partida.lugar,
        "estado": partida.estado,
        "participantes": len(participantes),
        "solicitudes": len(solicitudes)
    }
    db.close()
    return res

# GET/id/jugadores
@router.get("/partidas/{id}/jugadores")
def obtener_jugadores_partida(id: int):
    db = sesion_local()
    participantes = db.query(
        Participante
    ).filter(
        Participante.id_partida == id
    ).all()
    res = []
    for participante in participantes:
        usuario = db.query(
            Usuario
        ).filter(
            Usuario.id_usuario ==
            participante.id_usuario
        ).first()
        if usuario:
            res.append(
                {
                    "id": usuario.id_usuario,
                    "nickname": usuario.nickname,
                    "email": usuario.email
                }
            )
    db.close()
    return res

# GET/id/evaluables
@router.get("/partidas/{id}/evaluables")
def obtener_jugadores_evaluables(id: int):
    db = sesion_local()
    participantes = db.query(
        Participante
    ).filter(
        Participante.id_partida == id
    ).all()
    res = []
    for participante in participantes:
        usuario = db.query(
            Usuario
        ).filter(
            Usuario.id_usuario ==
            participante.id_usuario
        ).first()
        if usuario:
            res.append(
                {
                    "id": usuario.id_usuario,
                    "nickname": usuario.nickname
                }
            )
    db.close()
    return res

# GET/id/participantes
@router.get("/partidas/{id}/participantes")
def obtener_participantes_partida(id: int):
    db = sesion_local()
    participantes = db.query(
        Participante
    ).filter(
        Participante.id_partida == id
    ).all()
    res = []
    for participante in participantes:
        res.append(
            {
                "id": participante.id_participante,
                "id_usuario": participante.id_usuario
            }
        )
    db.close()
    return res

# GET/id/disponibilidad
@router.get("/partidas/{id}/disponibilidad")
def obtener_disponibilidad(id: int):
    db = sesion_local()
    partida = db.query(
        Partida
    ).filter(
        Partida.id_partida == id
    ).first()
    if partida is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Partida no encontrada"
        }
    ocupados = db.query(
        Participante
    ).filter(
        Participante.id_partida == id
    ).count()
    db.close()
    return {
        "capacidad": partida.cant_jugadores,
        "ocupados": ocupados,
        "disponibles": partida.cant_jugadores - ocupados
    }

# PUT/id
@router.put("/partidas/{id}")
def actualizar_partida(
    id: int,
    datos: CrearPartida
):
    db = sesion_local()
    partida = db.query(
        Partida
    ).filter(
        Partida.id_partida == id
    ).first()
    if partida is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Partida no encontrada"
        }
    partida.id_deporte = datos.id_deporte
    partida.fecha = datos.fecha
    partida.hora = datos.hora
    partida.cant_jugadores = datos.cant_jugadores
    partida.lugar = datos.lugar
    partida.descripcion = datos.descripcion
    partida.estado = datos.estado

    db.commit()
    db.refresh(partida)
    db.close()
    return {
        "ok": True,
        "mensaje": "Partida actualizada correctamente"
    }

# DELETE/id
@router.delete("/partidas/{id}")
def eliminar_partida(id: int):

    db = sesion_local()
    partida = db.query(
        Partida
    ).filter(
        Partida.id_partida == id
    ).first()
    if partida is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Partida no encontrada"
        }
    db.delete(partida)
    db.commit()
    db.close()
    return {
        "ok": True,
        "mensaje": "Partida eliminada correctamente"
    }

# POST/aceptar/
@router.post("/partidas/{id}/aceptar/{id_solicitud}")
def aceptar_solicitud(
    id: int,
    id_solicitud: int
):
    db = sesion_local()
    solicitud = db.query(
        Solicitud
    ).filter(
        Solicitud.id_solicitud == id_solicitud
    ).first()
    if solicitud is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Solicitud no encontrada"
        }
    if solicitud.id_partida != id:
        db.close()
        return {
            "ok": False,
            "mensaje": "La solicitud no pertenece a esta partida"
        }
    solicitud.estado = "Aceptada"
    partida = db.query(
        Partida
    ).filter(
        Partida.id_partida == id
    ).first()
    if partida is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Partida no encontrada"
        }
    participantes_actuales = db.query(
        Participante
    ).filter(
        Participante.id_partida == id
    ).count()
    if participantes_actuales >= partida.cant_jugadores:
        db.close()
        return {
            "ok": False,
            "mensaje": "La partida ya está completa"
        }
    participante_existente = db.query(
        Participante
    ).filter(
        Participante.id_usuario == solicitud.id_usuario,
        Participante.id_partida == id
    ).first()
    if participante_existente:
        db.close()
        return {
            "ok": False,
            "mensaje": "El usuario ya participa en esta partida"
        }
    participante = Participante(
        id_usuario=solicitud.id_usuario,
        id_partida=id
    )
    db.add(participante)
    db.commit()
    db.close()
    return {
        "ok": True,
        "mensaje": "Solicitud aceptada"
    }

# POST/rechazar/
@router.post("/partidas/{id}/rechazar/{id_solicitud}")
def rechazar_solicitud(
    id: int,
    id_solicitud: int
):
    db = sesion_local()
    solicitud = db.query(
        Solicitud
    ).filter(
        Solicitud.id_solicitud ==
        id_solicitud
    ).first()
    if solicitud is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Solicitud no encontrada"
        }
    if solicitud.id_partida != id:
        db.close()
        return {
            "ok": False,
            "mensaje": "La solicitud no pertenece a esta partida"
        }
    solicitud.estado = "Rechazada"
    db.commit()
    db.refresh(solicitud)
    db.close()
    return {
        "ok": True,
        "mensaje": "Solicitud rechazada"
    }

# GET/id/solicitudes
@router.get("/partidas/{id}/solicitudes")
def obtener_solicitudes_partida(id: int):
    db = sesion_local()
    solicitudes = db.query(
        Solicitud
    ).filter(
        Solicitud.id_partida == id
    ).all()
    res = []
    for solicitud in solicitudes:
        res.append(
            {
                "id": solicitud.id_solicitud,
                "id_usuario": solicitud.id_usuario,
                "estado": solicitud.estado
            }
        )
    db.close()
    return res

# GET/id/solicitudes/detalle
@router.get("/partidas/{id}/solicitudes/detalle")
def obtener_detalle_solicitudes(id: int):
    db = sesion_local()
    solicitudes = db.query(
        Solicitud
    ).filter(
        Solicitud.id_partida == id
    ).all()
    res = []
    for solicitud in solicitudes:
        usuario = db.query(
            Usuario
        ).filter(
            Usuario.id_usuario ==
            solicitud.id_usuario
        ).first()
        if usuario:
            res.append(
                {
                    "id_solicitud": solicitud.id_solicitud,
                    "id_usuario": usuario.id_usuario,
                    "nickname": usuario.nickname,
                    "email": usuario.email,
                    "estado": solicitud.estado
                }
            )
    db.close()
    return res

# GET/id/participantes/detalle
@router.get("/partidas/{id}/participantes/detalle")
def obtener_participantes_detalle(id: int):
    db = sesion_local()
    participantes = db.query(
        Participante
    ).filter(
        Participante.id_partida == id
    ).all()
    res = []
    for participante in participantes:
        usuario = db.query(
            Usuario
        ).filter(
            Usuario.id_usuario ==
            participante.id_usuario
        ).first()
        if usuario:
            res.append(
                {
                    "id_usuario": usuario.id_usuario,
                    "nickname": usuario.nickname,
                    "email": usuario.email
                }
            )
    db.close()
    return res

