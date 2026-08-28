from sqlalchemy import Column
from sqlalchemy import Integer


from sqlalchemy.orm import declarative_base


Base = declarative_base()

class PreferenciaDeporte(Base):
    __tablename__ = "preferencias_deporte"

    id_preferencia = Column(
        Integer,
        primary_key=True)
    id_usuario = Column(Integer)
    id_deporte = Column(Integer)