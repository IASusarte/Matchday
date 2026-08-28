from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import Date
from sqlalchemy import Time


from sqlalchemy.orm import declarative_base


Base = declarative_base()

class Partida(Base):
    __tablename__ = "partidas"

    id_partida = Column(
        Integer,
        primary_key=True)
    id_creador = Column(Integer)
    id_deporte = Column(Integer)
    fecha = Column(Date)
    hora = Column(Time)
    cant_jugadores = Column(Integer)
    lugar = Column(String(200))
    id_ubicacion = Column(Integer)
    descripcion = Column(String(500))
    estado = Column(String(20))