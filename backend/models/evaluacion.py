from sqlalchemy import Column
from sqlalchemy import Integer


from sqlalchemy.orm import declarative_base


Base = declarative_base()

class Evaluacion(Base):
    __tablename__ = "evaluaciones"

    id_evaluacion = Column(
        Integer,
        primary_key=True)
    id_partida = Column(Integer)
    id_evaluador = Column(Integer)
    id_evaluado = Column(Integer)
    compromiso = Column(Integer)
    puntualidad = Column(Integer)
    fairplay = Column(Integer)
    nivel_juego = Column(Integer)
