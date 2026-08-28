from sqlalchemy import Column
from sqlalchemy import Integer

from sqlalchemy.orm import declarative_base


Base = declarative_base()

class UbicacionDeporte(Base):
    __tablename__ = "ubicaciones_deporte"

    id = Column(
        Integer,
        primary_key=True)
    id_ubicacion = Column(Integer)
    id_deporte = Column(Integer)