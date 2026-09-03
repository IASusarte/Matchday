from fastapi import FastAPI
from fastapi.middleware.cors import CORSMiddleware

from routes.usuarios import router as usuarios_router
from routes.deportes import router as deportes_router
from routes.partidas import router as partidas_router
from routes.solicitudes import router as solicitudes_router
from routes.participantes import router as participantes_router
from routes.evaluaciones import router as evaluaciones_router
from routes.ubicaciones import router as ubicaciones_router
from routes.preferencias import router as preferencias_router

app = FastAPI()

app.add_middleware(
    CORSMiddleware,
    allow_origins=["*"],
    allow_credentials=True,
    allow_methods=["*"],
    allow_headers=["*"]
)

app.include_router(usuarios_router)
app.include_router(deportes_router)
app.include_router(partidas_router)
app.include_router(solicitudes_router)
app.include_router(participantes_router)
app.include_router(evaluaciones_router)
app.include_router(ubicaciones_router)
app.include_router(preferencias_router)

# PRUEBA

@app.get("/")
def inicio():
    return {
        "mensaje": "API Matchday funcionando"
    }

@app.get("/prueba")
def prueba():
    return{
        "mensaje": "Primer endpoint"
    }