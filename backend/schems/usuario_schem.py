from pydantic import BaseModel
from datetime import date

class CrearUsuario(BaseModel):

    rut: str
    nombres: str
    apellidos: str
    email: str
    nickname: str
    password: str
    fecha_nacimiento: date
    sexo: str

class Login(BaseModel):
    email: str
    password: str
    