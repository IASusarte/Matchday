from fastapi import APIRouter

router = APIRouter()

from bd import sesion_local
from models.ubicacion import Ubicacion
from models.ubicacion_deporte import UbicacionDeporte
from models.deporte import Deporte
from schems.ubicacion_schem import CrearUbicacion
from schems.ubicacion_deporte_schem import CrearUbicacionDeporte

# UBICACIONES

# GET
@router.get("/ubicaciones")
def obtener_ubicaciones():
    db = sesion_local()
    ubicaciones = db.query(
        Ubicacion
    ).all()
    res = []
    for ubicacion in ubicaciones:
        res.append(
            {
                "id": ubicacion.id_ubicacion,
                "nombre": ubicacion.nombre,
                "ciudad": ubicacion.ciudad,
                "direccion": ubicacion.direccion,
                "latitud": ubicacion.latitud,
                "longitud": ubicacion.longitud
            }
        )
    db.close()
    return res

# GET/id
@router.get("/ubicaciones/{id}")
def obtener_ubicacion(id: int):
    db = sesion_local()
    ubicacion = db.query(
        Ubicacion
    ).filter(
        Ubicacion.id_ubicacion == id
    ).first()
    db.close()
    if ubicacion is None:
        return {
            "ok": False,
            "mensaje": "Ubicación no encontrada"
        }
    return {
        "id": ubicacion.id_ubicacion,
        "nombre": ubicacion.nombre,
        "ciudad": ubicacion.ciudad,
        "direccion": ubicacion.direccion,
        "latitud": ubicacion.latitud,
        "longitud": ubicacion.longitud
    }

# GET/id/detalle
@router.get("/ubicaciones/{id}/detalle")
def obtener_detalle_ubicacion(id: int):
    db = sesion_local()
    ubicacion = db.query(
        Ubicacion
    ).filter(
        Ubicacion.id_ubicacion == id
    ).first()
    if ubicacion is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Ubicación no encontrada"
        }
    relaciones = db.query(
        UbicacionDeporte
    ).filter(
        UbicacionDeporte.id_ubicacion == id
    ).all()
    deportes = []
    for relacion in relaciones:
        deporte = db.query(
            Deporte
        ).filter(
            Deporte.id_deporte ==
            relacion.id_deporte
        ).first()
        if deporte:
            deportes.append(
                {
                    "id": deporte.id_deporte,
                    "nombre": deporte.nombre
                }
            )
    db.close()
    return {
        "id": ubicacion.id_ubicacion,
        "nombre": ubicacion.nombre,
        "ciudad": ubicacion.ciudad,
        "direccion": ubicacion.direccion,
        "latitud": ubicacion.latitud,
        "longitud": ubicacion.longitud,
        "deportes": deportes
    }

# GET/ciudad
@router.get("/ubicaciones/ciudad/{ciudad}")
def obtener_ubicaciones_ciudad(ciudad: str):
    db = sesion_local()
    ubicaciones = db.query(
        Ubicacion
    ).filter(
        Ubicacion.ciudad == ciudad
    ).all()
    res = []
    for ubicacion in ubicaciones:
        res.append(
            {
                "id": ubicacion.id_ubicacion,
                "nombre": ubicacion.nombre,
                "direccion": ubicacion.direccion,
                "latitud": ubicacion.latitud,
                "longitud": ubicacion.longitud
            }
        )
    db.close()
    return res

# POST
@router.post("/ubicaciones")
def crear_ubicacion(datos: CrearUbicacion):
    db = sesion_local()
    ubicacion = Ubicacion(
        nombre=datos.nombre,
        ciudad=datos.ciudad,
        direccion=datos.direccion,
        latitud=datos.latitud,
        longitud=datos.longitud
    )
    db.add(ubicacion)
    db.commit()
    db.refresh(ubicacion)
    db.close()
    return {
        "ok": True,
        "id": ubicacion.id_ubicacion
    }

# PUT/id
@router.put("/ubicaciones/{id}")
def actualizar_ubicacion(
    id: int,
    datos: CrearUbicacion
):
    db = sesion_local()
    ubicacion = db.query(
        Ubicacion
    ).filter(
        Ubicacion.id_ubicacion == id
    ).first()
    if ubicacion is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Ubicación no encontrada"
        }
    ubicacion.nombre = datos.nombre
    ubicacion.ciudad = datos.ciudad
    ubicacion.direccion = datos.direccion
    ubicacion.latitud = datos.latitud
    ubicacion.longitud = datos.longitud

    db.commit()
    db.refresh(ubicacion)
    db.close()
    return {
        "ok": True,
        "mensaje": "Ubicación actualizada"
    }

# DELETE/id
@router.delete("/ubicaciones/{id}")
def eliminar_ubicacion(id: int):
    db = sesion_local()
    ubicacion = db.query(
        Ubicacion
    ).filter(
        Ubicacion.id_ubicacion == id
    ).first()
    if ubicacion is None:
        db.close()
        return {
            "ok": False,
            "mensaje": "Ubicación no encontrada"
        }
    db.delete(ubicacion)
    db.commit()
    db.close()
    return {
        "ok": True,
        "mensaje": "Ubicación eliminada"
    }

# UBICACIONES DEPORTE

# POST
@router.post("/ubicaciones-deporte")
def crear_ubicacion_deporte(datos: CrearUbicacionDeporte):
    db = sesion_local()
    relacion = UbicacionDeporte(
        id_ubicacion=datos.id_ubicacion,
        id_deporte=datos.id_deporte
    )
    db.add(relacion)
    db.commit()
    db.refresh(relacion)
    db.close()
    return {
        "ok": True,
        "id": relacion.id
    }

# GET
@router.get("/ubicaciones-deporte")
def obtener_ubicaciones_deporte():
    db = sesion_local()
    relaciones = db.query(
        UbicacionDeporte
    ).all()
    res = []
    for relacion in relaciones:
        res.append(
            {
                "id": relacion.id,
                "id_ubicacion": relacion.id_ubicacion,
                "id_deporte": relacion.id_deporte
            }
        )
    db.close()
    return res

# GET/deportes/id
@router.get("/deportes/{id}/ubicaciones")
def obtener_ubicaciones_deporte(id: int):
    db = sesion_local()
    relaciones = db.query(
        UbicacionDeporte
    ).filter(
        UbicacionDeporte.id_deporte == id
    ).all()
    res = []
    for relacion in relaciones:
        ubicacion = db.query(
            Ubicacion
        ).filter(
            Ubicacion.id_ubicacion ==
            relacion.id_ubicacion
        ).first()
        if ubicacion:
            res.append(
                {
                    "id": ubicacion.id_ubicacion,
                    "nombre": ubicacion.nombre,
                    "ciudad": ubicacion.ciudad,
                    "direccion": ubicacion.direccion,
                    "latitud": ubicacion.latitud,
                    "longitud": ubicacion.longitud
                }
            )
    db.close()
    return res

# GET/id/deportes
@router.get("/ubicaciones/{id}/deportes")
def obtener_deportes_ubicacion(
    id: int
):
    db = sesion_local()
    relaciones = db.query(
        UbicacionDeporte
    ).filter(
        UbicacionDeporte.id_ubicacion == id
    ).all()
    res = []
    for relacion in relaciones:
        deporte = db.query(
            Deporte
        ).filter(
            Deporte.id_deporte ==
            relacion.id_deporte
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
