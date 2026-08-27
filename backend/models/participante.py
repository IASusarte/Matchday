from sqlalchemy import Column
from sqlalchemy import Integer

from sqlalchemy.orm import declarative_base

Base = declarative_base()

class Participante(Base):
    __tablename__ = "participantes_partida"

    id_participante = Column(
        Integer,
        primary_key=True)
    id_usuario = Column(Integer)
    id_partida = Column(Integer)
