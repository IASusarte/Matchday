from bd import crear_motor

try:
    conn = crear_motor.connect()

    print("Conexion exitosa")

    conn.close()

except Exception as e:
    print("Error:", e)

