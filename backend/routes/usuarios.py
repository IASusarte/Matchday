from fastapi import APIRouter

router = APIRouter()

from bd import sesion_local
from models.usuario import Usuario
from models.partida import Partida
from models.solicitud import Solicitud
from models.participante import Participante
from models.evaluacion import Evaluacion
from schems.usuario_schem import CrearUsuario, Login

# USUARIOS

# GET
@router.get("/usuarios")
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
@router.get("/usuarios/{id}")
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

# POST
@router.post("/usuarios")
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

# PUT/id
@router.put("/usuarios/{id}")
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

# POST/login
@router.post("/login")
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

# GET/id/partidas
@router.get("/usuarios/{id}/partidas")
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
@router.get("/usuarios/{id}/solicitudes")
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
@router.get("/usuarios/{id}/evaluaciones")
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
@router.get("/usuarios/{id}/reputacion")
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
@router.get("/usuarios/{id}/historial")
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
@router.get("/usuarios/{id}/perfil")
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
@router.get("/usuarios/{id}/dashboard")
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

# HOME

@router.get("/home/{id}")
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