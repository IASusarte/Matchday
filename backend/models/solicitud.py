from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String


from sqlalchemy.orm import declarative_base

Base = declarative_base()

class Solicitud(Base):
    __tablename__ = "solicitudes"

    id_solicitud = Column(
        Integer,
        primary_key=True)
    id_usuario = Column(Integer)
    id_partida = Column(Integer)
    estado = Column(String(20))