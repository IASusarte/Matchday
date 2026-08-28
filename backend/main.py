from fastapi import FastAPI
from schems.usuario_schem import CrearUsuario, Login
from schems.partida_schem import CrearPartida
from schems.solicitud_schem import CrearSolicitud
from schems.participante_schem import CrearParticipante
from schems.evaluacion_schem import CrearEvaluacion

from bd import sesion_local
from models.usuario import Usuario
from models.deporte import Deporte
from models.partida import Partida
from models.solicitud import Solicitud
from models.participante import Participante
from models.evaluacion import Evaluacion

app = FastAPI()

# PRUEBA

@app.get("/")
def inicio():
    return {
        "mensaje": "API Matchday funcionando"
    }

@app.get("/prueba")
def prueba():
    return{
        "mensaje": "Primer endpoint"
    }

# HOME

# GET
@app.get("/home/{id}")
def obtener_home(id: int):
    db = sesion_local()
    solicitudes = db.query(
        Solicitud
    ).filter(
        Solicitud.id_usuario == id
    ).all()
    participaciones = db.query(
        Participante
    ).filter(
        Participante.id_usuario == id
    ).all()
    partidas_activas = db.query(
        Partida
    ).filter(
        Partida.estado == "Activa"
    ).count()
    db.close()
    return {
        "mis_solicitudes": len(solicitudes),
        "mis_partidas": len(participaciones),
        "partidas_activas": partidas_activas
    }

# USUARIOS

# POST
@app.post("/usuarios")
def crear_usuario(usuario: CrearUsuario):
    db = sesion_local()
    nuevo_usuario = Usuario(
        rut=usuario.rut,
        nombres=usuario.nombres,
        apellidos=usuario.apellidos,
        email=usuario.email,
        nickname=usuario.nickname,
        password=usuario.password,
        fecha_nacimiento= str(usuario.fecha_nacimiento),
        sexo=usuario.sexo
    )
    db.add(nuevo_usuario)
    db.commit()
    db.refresh(nuevo_usuario)
    db.close()
    return{
        "mensaje": "Usuario creado exitosamente",
        "id": nuevo_usuario.id_usuario
    }

# POST/login
@app.post("/login")
def login(datos: Login):
    db = sesion_local()
    usuario = db.query(
        Usuario
    ).filter(
        Usuario.email == datos.email
    ).first()
    if usuario is None:
        db.close()
        return{
            "ok": False,
            "mensaje": "Usuario no encontrado"
        }
    if usuario.password != datos.password:
        db.close()
        return{
            "ok": False,
            "mensaje": "Contraseña incorrecta"
        }
    db.close()
    return{
        "ok": True,
        "id": usuario.id_usuario,
        "nickname": usuario.nickname,
        "email": usuario.email
    }

# GET
@app.get("/usuarios")
def obtener_usuarios():
    db = sesion_local()
    usuarios = db.query(
        Usuario
    ).all()
    res = []
    for usuario in usuarios:
        res.append(
            {
                "id": usuario.id_usuario,
                "nickname": usuario.nickname,
                "email": usuario.email
            }
        )
    db.close()
    return res

# GET/id
@app.get("/usuarios/{id}")
def obtener_usuarios(id: int):
    db = sesion_local()
    usuario = db.query(
        Usuario
    ).filter(
        Usuario.id_usuario == id
    ).first()
    db.close()
    if usuario is None:
        return{
            "ok": False,
            "mensaje": "Usuario no encontrado"
            }
    return{
        "id": usuario.id_usuario,
        "rut": usuario.rut,
        "nombres": usuario.nombres,
        "apellidos": usuario.apellidos,
        "email": usuario.email,
        "nickname": usuario.nickname,
        "fecha_nacimiento": usuario.fecha_nacimiento,
        "sexo": usuario.sexo
    }

# GET/id/partidas
@app.get("/usuarios/{id}/partidas")
def obtener_partidas_usuario(id: int):
    db = sesion_local()
    participantes = db.query(
        Participante
    ).filter(
        Participante.id_usuario == id
    ).all()
    res = []
    for participante in participantes:
        res.append(
            {
                "id_partida": participante.id_partida
            }
        )
    db.close()
    return res

# GET/id/solicitudes
@app.get("/usuarios/{id}/solicitudes")
def obtener_solicitudes_usuario(id: int):
    db = sesion_local()
    solicitudes = db.query(
        Solicitud
    ).filter(
        Solicitud.id_usuario == id
    ).all()
    res = []
    for solicitud in solicitudes:
        res.append(
            {
                "id": solicitud.id_solicitud,
                "id_partida": solicitud.id_partida,
                "estado": solicitud.estado
            }
        )
    db.close()
    return res

# GET/id/evaluaciones
@app.get("/usuarios/{id}/evaluaciones")
def obtener_evaluaciones_usuario(id: int):
    db = sesion_local()
    evaluaciones = db.query(
        Evaluacion
    ).filter(
        Evaluacion.id_evaluado == id
    ).all()
    res = []
    for e in evaluaciones:
        res.append(
            {
                "id": e.id_evaluacion,
                "compromiso": e.compromiso,
                "puntualidad": e.puntualidad,
                "fairplay": e.fairplay,
                "nivel_juego": e.nivel_juego
            }
        )
    db.close()
    return res

# GET/id/reputacion
@app.get("/usuarios/{id}/reputacion")
def obtener_reputacion(id: int):
    db = sesion_local()
    evaluaciones = db.query(
        Evaluacion
    ).filter(
        Evaluacion.id_evaluado == id
    ).all()
    db.close()
    if len(evaluaciones) == 0:
        return {
            "compromiso": 0,
            "puntualidad": 0,
            "fairplay": 0,
            "nivel_juego": 0
        }
    compromiso = sum(
        e.compromiso
        for e in evaluaciones
    ) / len(evaluaciones)
    puntualidad = sum(
        e.puntualidad
        for e in evaluaciones
    ) / len(evaluaciones)
    fairplay = sum(
        e.fairplay
        for e in evaluaciones
    ) / len(evaluaciones)
    nivel_juego = sum(
        e.nivel_juego
        for e in evaluaciones
    ) / len(evaluaciones)
    return {
        "compromiso": round(compromiso, 2),
        "puntualidad": round(puntualidad, 2),
        "fairplay": round(fairplay, 2),
        "nivel_juego": round(nivel_juego, 2)
    }

# GET/id/historial
@app.get("/usuarios/{id}/historial")
def obtener_historial(id: int):
    db = sesion_local()
    participantes = db.query(
        Participante
    ).filter(
        Participante.id_usuario == id
    ).all()
    res = []
    for participante in participantes:
        partida = db.query(
            Partida
        ).filter(
            Partida.id_partida ==
            participante.id_partida
        ).first()
        if partida:
            res.append(
                {
                    "id": partida.id_partida,
                    "fecha": str(partida.fecha),
                    "estado": partida.estado
                }
            )
    db.close()
    return res

# GET/id/perfil
@app.get("/usuarios/{id}/perfil")
def obtener_perfil(id: int):
    db = sesion_local()
    usuario = db.query(
        Usuario
    ).filter(
        Usuario.id_usuario == id
    ).first()
    if usuario is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Usuario no encontrado"
        }
    evaluaciones = db.query(
        Evaluacion
    ).filter(
        Evaluacion.id_evaluado == id
    ).all()
    compromiso = 0
    puntualidad = 0
    fairplay = 0
    nivel_juego = 0
    if len(evaluaciones) > 0:
        compromiso = round(
            sum(e.compromiso for e in evaluaciones)
            / len(evaluaciones), 2
        )
        puntualidad = round(
            sum(e.puntualidad for e in evaluaciones)
            / len(evaluaciones), 2
        )
        fairplay = round(
            sum(e.fairplay for e in evaluaciones)
            / len(evaluaciones), 2
        )
        nivel_juego = round(
            sum(e.nivel_juego for e in evaluaciones)
            / len(evaluaciones), 2
        )
    db.close()
    return {
        "usuario": {
            "id": usuario.id_usuario,
            "nickname": usuario.nickname,
            "email": usuario.email,
            "nombres": usuario.nombres,
            "apellidos": usuario.apellidos
        },
        "reputacion": {
            "compromiso": compromiso,
            "puntualidad": puntualidad,
            "fairplay": fairplay,
            "nivel_juego": nivel_juego
        }
    }

# GET/id/dashboard
@app.get("/usuarios/{id}/dashboard")
def obtener_dashboard(id: int):
    db = sesion_local()
    partidas_creadas = db.query(
        Partida
    ).filter(
        Partida.id_creador == id
    ).count()
    participaciones = db.query(
        Participante
    ).filter(
        Participante.id_usuario == id
    ).count()
    evaluaciones = db.query(
        Evaluacion
    ).filter(
        Evaluacion.id_evaluado == id
    ).all()
    compromiso = 0
    puntualidad = 0
    fairplay = 0
    nivel_juego = 0
    if len(evaluaciones) > 0:
        compromiso = round(
            sum(e.compromiso for e in evaluaciones)
            / len(evaluaciones), 2
        )
        puntualidad = round(
            sum(e.puntualidad for e in evaluaciones)
            / len(evaluaciones), 2
        )
        fairplay = round(
            sum(e.fairplay for e in evaluaciones)
            / len(evaluaciones), 2
        )
        nivel_juego = round(
            sum(e.nivel_juego for e in evaluaciones)
            / len(evaluaciones), 2
        )
    db.close()
    return {
        "partidas_creadas": partidas_creadas,
        "partidas_jugadas": participaciones,
        "promedio_compromiso": compromiso,
        "promedio_puntualidad": puntualidad,
        "promedio_fairplay": fairplay,
        "promedio_nivel_juego": nivel_juego
    }

# PUT/id
@app.put("/usuarios/{id}")
def actualizar_usuario(
    id: int,
    datos: CrearUsuario
):
    db = sesion_local()
    usuario = db.query(
        Usuario
    ).filter(
        Usuario.id_usuario == id
    ).first()
    if usuario is None:
        db.close()
        return{
            "ok": False,
            "mensaje": "Usuario no encontrado"
        }
    usuario.rut = datos.rut
    usuario.nombres = datos.nombres
    usuario.apellidos = datos.apellidos
    usuario.email = datos.email
    usuario.nickname = datos.nickname
    usuario.password = datos.password
    usuario.fecha_nacimiento = datos.fecha_nacimiento
    usuario.sexo = datos.sexo

    db.commit()
    db.refresh(usuario)
    db.close()
    return{
        "ok": True,
        "mensaje": "Usuario actualizado correctamente"
    }

# DEPORTES

# GET
@app.get("/deportes")
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

# PARTIDAS

# POST
@app.post("/partidas")
def crear_partida(partida: CrearPartida):
    db = sesion_local()
    nueva_partida = Partida(
        id_creador=partida.id_creador,
        id_deporte=partida.id_deporte,
        fecha=partida.fecha,
        hora=partida.hora,
        cant_jugadores=partida.cant_jugadores,
        lugar=partida.lugar,
        descripcion=partida.descripcion,
        estado=partida.estado,
    )
    db.add(nueva_partida)
    db.commit()
    db.refresh(nueva_partida)
    db.close()
    return{
        "mensaje": "Partida creada exitosamente",
        "id": nueva_partida.id_partida
    }

# POST/id/aceptar/id
@app.post("/partidas/{id}/aceptar/{id_solicitud}")
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

# POST/id/rechazar/id
@app.post("/partidas/{id}/rechazar/{id_solicitud}")
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

# POST/id/finalizar
@app.post("/partidas/{id}/finalizar")
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
@app.get("/partidas")
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
                "descripcion": partida.descripcion,
                "estado": partida.estado
            }
        )
    db.close()
    return res

# GET/id
@app.get("/partidas/{id}")
def obtener_partida(id: int):
    db = sesion_local()
    partida = db.query(
        Partida
    ).filter(
        Partida.id_partida == id
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
        "id_deporte": partida.id_deporte,
        "fecha": str(partida.fecha),
        "hora": str(partida.hora),
        "cant_jugadores": partida.cant_jugadores,
        "lugar": partida.lugar,
        "descripcion": partida.descripcion,
        "estado": partida.estado
    }

# GET/id/solicitudes
@app.get("/partidas/{id}/solicitudes")
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
@app.get("/partidas/{id}/solicitudes/detalle")
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

# GET/id/detalle
@app.get("/partidas/{id}/detalle")
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
@app.get("/partidas/{id}/jugadores")
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

@app.get("/partidas/{id}/evaluables")
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

# GET/activas
@app.get("/partidas/activas")
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
                "fecha": str(partida.fecha),
                "hora": str(partida.hora),
                "lugar": partida.lugar
            }
        )
    db.close()
    return res

# PUT/id
@app.put("/partidas/{id}")
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
@app.delete("/partidas/{id}")
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

# SOLICITUDES

# POST
@app.post("/solicitudes")
def crear_solicitud(datos: CrearSolicitud):
    db = sesion_local()
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
@app.get("/solicitudes")
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

# GET/id
@app.get("/solicitudes/{id}")
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
@app.put("/solicitudes/{id}")
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

# DELETE
@app.delete("/solicitudes/{id}")
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

# PARTICIPANTES

# POST
@app.post("/participantes")
def crear_participante(datos: CrearParticipante):
    db = sesion_local()
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
@app.get("/participantes")
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

# GET/id
@app.get("/partidas/{id}/participantes")
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

# EVALUACIONES

# POST
@app.post("/evaluaciones")
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
@app.get("/evaluaciones")
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
@app.get("/evaluaciones/{id}")
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
@app.put("/evaluaciones/{id}")
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
@app.delete("/evaluaciones/{id}")
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