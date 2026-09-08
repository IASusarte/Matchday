from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String


from sqlalchemy.orm import declarative_base


Base = declarative_base()

class EstadoSolicitud(Base):
    __tablename__ = "estados_solicitud"

    id_estado = Column(Integer, primary_key=True)
    nombre = Column(String(50))