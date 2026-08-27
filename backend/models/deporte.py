from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String


from sqlalchemy.orm import declarative_base

Base = declarative_base()

class Deporte(Base):
    __tablename__ = "deportes"

    id_deporte = Column(
        Integer,
        primary_key=True)
    nombre = Column(String(50))