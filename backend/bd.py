from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker

DATABASE_URL = ("mysql+pymysql://root:admin123@localhost/matchday_db")

crear_motor = create_engine(DATABASE_URL)

sesion_local = sessionmaker(
    autocommit = False,
    autoflush = False,
    bind = crear_motor
)
