from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker
import os

DATABASE_URL = os.getenv(
    "DATABASE_URL"
)

crear_motor = create_engine(DATABASE_URL)

sesion_local = sessionmaker(
    autocommit = False,
    autoflush = False,
    bind = crear_motor
)
