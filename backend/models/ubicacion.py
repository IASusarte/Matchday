from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import Float


from sqlalchemy.orm import declarative_base


Base = declarative_base()

class Ubicacion(Base):
    __tablename__ = "ubicaciones"

    id_ubicacion = Column(
        Integer,
        primary_key=True)
    nombre = Column(String(200))
    direccion = Column(String(300))
    ciudad = Column(String(100))
    latitud = Column(Float)
    longitud = Column(Float)