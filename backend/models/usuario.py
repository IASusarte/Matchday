from sqlalchemy import Column
from sqlalchemy import Integer
from sqlalchemy import String
from sqlalchemy import Date


from sqlalchemy.orm import declarative_base


Base = declarative_base()

class Usuario(Base):
    __tablename__ = "usuarios"

    id_usuario = Column(
        Integer,
        primary_key=True)
    rut = Column(String(12))
    nombres = Column(String(100))
    apellidos = Column(String(100))
    email = Column(String(100))
    nickname = Column(String(50))
    password = Column(String(255))
    fecha_nacimiento = Column(Date)
    sexo = Column(String(20))