import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../data/session.dart';
import '../api/api_match.dart';
import '../api/api_user.dart';
import '../api/api_location.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class CreateMatchView extends StatefulWidget {
  const CreateMatchView({super.key});

  @override
  State<CreateMatchView> createState() => _CreateMatchViewState();
}

class _CreateMatchViewState extends State<CreateMatchView> {

  final TextEditingController fechaController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  final TextEditingController cantJugadoresController = TextEditingController();
  final TextEditingController lugarController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();

  List<dynamic> deportes = [];
  List<dynamic> ubicaciones = [];

  @override
  void initState() {
    super.initState();
    cargarDeportes();
    cargarUbicaciones();
  }

  Future<void> cargarDeportes() async {
    final data = await UserApi.obtenerPreferencias(
      Session.usuarioId!,
    );
    setState(() {
      deportes = data.where(
        (d) => d["activo"] == true,
      ).toList();
    });
  }

  Future<void> cargarUbicaciones() async {
    final data = await LocationApi.obtenerUbicaciones();
    setState(() {
      ubicaciones = data;
    });
  }


  @override
  void dispose() {
    fechaController.dispose();
    horaController.dispose();
    cantJugadoresController.dispose();
    lugarController.dispose();
    descripcionController.dispose();
    super.dispose();
  }

  int obtenerMaximoJugadores (int idDeporte){
    switch (idDeporte) {
      case 1:
      return 22; 
      case 2:
      return 4;
      case 3:
      return 10;
      case 4:
      return 12;
      default:
      return 30;
    }
  }

  int? deporteSeleccionado;
  int? ubicacionSeleccionada;

  



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Crear partida'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              'Crear partida',
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),

            const SizedBox(height: 20),

            

        
            DropdownButtonFormField<int>(
              initialValue: deporteSeleccionado,
              decoration: const InputDecoration(
                labelText: 'Deporte',
                filled: true,
                fillColor: Colors.white,
              ),
              items: deportes.map<DropdownMenuItem<int>>(
                (deporte) {

                  return DropdownMenuItem<int>(
                    value: deporte["id"],
                    child: Text(
                      deporte["nombre"],
                    ),
                  );

                },
              ).toList(),
              onChanged: (value) async {
                if (value == null) return;
                final ubicacionesFiltradas = await LocationApi
                        .obtenerUbicacionesPorDeporte(value);
                setState(() {
                  deporteSeleccionado = value;
                  ubicaciones = ubicacionesFiltradas;
                  ubicacionSeleccionada = null;
                  lugarController.clear();
                });
              },
            ),




            const SizedBox(height: 15),

            TextField(
              controller: fechaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.calendar_today)
              ),

              onTap: () async {
                final fechaSeleccionada = 
                  await showDatePicker(
                    context: context, 
                    initialDate: DateTime.now(),
                    firstDate: DateTime.now(), 
                    lastDate: DateTime(2030)
                    );
                if(fechaSeleccionada != null){
                  fechaController.text = 
                    DateFormat('dd/MM/yyyy')
                    .format(fechaSeleccionada);
                  //.toIso8601String()
                  //.split('T')[0];
                }
              }
            ),

            const SizedBox(height: 15),

            TextField(
              controller: horaController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Hora',
                filled: true,
                fillColor: Colors.white,
                suffixIcon: Icon(Icons.access_time)
              ),
              onTap: () async {
                final horaSeleccionada = 
                  await showTimePicker(
                    context: context, 
                    initialTime: TimeOfDay.now()
                    );
                if(horaSeleccionada != null){
                  final hora = horaSeleccionada.hour
                  .toString()
                  .padLeft(2, '0');
                  final minuto = horaSeleccionada.minute
                  .toString()
                  .padLeft(2, '0');
                  horaController.text = '$hora:$minuto';
                }
              }
            ),

            const SizedBox(height: 15),

            TextField(
              controller: cantJugadoresController,
              decoration: const InputDecoration(
                labelText: 'Cantidad de jugadores',
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: lugarController,
              readOnly: true,
              decoration: const InputDecoration(
                labelText: 'Lugar seleccionado',
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: descripcionController,
              maxLines: 3,
              decoration: const InputDecoration(
                labelText: 'Descripción',
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 30),

            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: LatLng(
                    -34.982,
                    -71.239,
                  ),
                  initialZoom: 15,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  ),
                  MarkerLayer(
                    markers: ubicaciones.map(
                      (u) {
                        return Marker(
                          point: LatLng(
                            u["latitud"],
                            u["longitud"],
                          ),
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                ubicacionSeleccionada =
                                    u["id"];
                                lugarController.text =
                                    u["nombre"];
                              });
                            },
                            child: Icon(
                              Icons.location_pin,
                              color:
                                  ubicacionSeleccionada ==
                                          u["id"]
                                      ? Colors.green
                                      : Colors.red,
                              size: 40,
                            ),
                          ),
                        );

                      },
                    ).toList(),
                  )
                ],
              )
            ),

            if (ubicacionSeleccionada != null)
              Builder(
                builder: (context) {
                  final ubicacion =
                      ubicaciones.firstWhere(
                    (u) =>
                        u["id"] ==
                        ubicacionSeleccionada,
                  );
                  return Padding(
                    padding: const EdgeInsets.only(
                      top: 10,
                    ),
                    child: Column(
                      children: [
                        Text(
                          ubicacion["nombre"],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          "Dirección: ${ubicacion["direccion"]}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () async {

                if(
                  deporteSeleccionado == null ||
                  fechaController.text.isEmpty ||
                  horaController.text.isEmpty ||
                  cantJugadoresController.text.isEmpty ||
                  lugarController.text.isEmpty ||
                  ubicacionSeleccionada == null
                ) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Por favor, complete todos los campos'),
                    ),
                  );
                  return;
                }

                final cant = int.tryParse(cantJugadoresController.text);
                if(cant == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cantidad de jugadores debe ser numerica'),
                    ),
                  );
                  return;
                }
                if (cant <= 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cantidad de jugadores debe ser mayor a 0'),
                    ),
                  );
                  return;
                }
                if (cant % 2 != 0) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Cantidad de jugadores debe ser par'),
                    ),
                  );
                  return;
                }

                final deporte = deporteSeleccionado;
                if (deporte == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Debe ingresar un deporte valido',
                      ),
                    ),
                  );
                  return;
                }


                /*DateTime? fecha;
                try {
                  fecha = DateTime.parse(fechaController.text);
                } catch (_) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Fecha inválida. Use formato YYYY-MM-DD'),
                    ),
                  );
                  return;
                }*/
                final maxJugadores = obtenerMaximoJugadores(deporte);
                if (cant > maxJugadores) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Cantidad de jugadores no puede ser mayor a $maxJugadores'),
                    ),
                  );
                  return;
                }

                final fechaSeleccionada = 
                  DateFormat('dd/MM/yyyy').parse(fechaController.text);
                
                final horaCompleta = 
                  horaController.text.split(':');

                final horaSeleccionada = 
                  int.parse(horaCompleta[0]);
                if(
                  horaSeleccionada < 6 ||
                  horaSeleccionada > 23) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La hora debe estar entre las 06:00 y 23:00'
                      ),
                    ),
                    );
                    return;
                  }
                
                final fechaHora = DateTime(
                  fechaSeleccionada.year,
                  fechaSeleccionada.month,
                  fechaSeleccionada.day,
                  int.parse(horaCompleta[0]),
                  int.parse(horaCompleta[1])
                );

                if (fechaHora.isBefore(DateTime.now())){
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'La fecha y hora no pueden ser del pasado'
                      ),
                    ),
                  );
                  return;
                }

                if (ubicacionSeleccionada == null) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Debe seleccionar una ubicación',
                      ),
                    ),
                  );
                  return;
                }

                final res = await MatchApi.crearPartida(
                  idCreador: Session.usuarioId!,
                  idDeporte: deporte,
                  fecha: DateFormat('yyyy-MM-dd')
                      .format(fechaSeleccionada),
                  hora: "${horaCompleta[0]}:${horaCompleta[1]}:00",
                  cantJugadores: cant,
                  lugar: lugarController.text,
                  descripcion: descripcionController.text,
                  idUbicacion: ubicacionSeleccionada!,
                );

                if (!context.mounted) return;

                if (res?["ok"] == false) {
                  ScaffoldMessenger.of(context)
                      .showSnackBar(
                    SnackBar(
                      content: Text(
                        res?["mensaje"],
                      ),
                    ),
                  );
                  return;
                }

                if (res == null) {

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Error al crear la partida'
                      ),
                    ),
                  );
                  return;
                } 
 
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Partida creada correctamente',
                    ),
                    duration: Duration(seconds: 1),
                  ),
                );

                fechaController.clear();
                horaController.clear();
                cantJugadoresController.clear();
                //lugarController.clear();
                descripcionController.clear();

                setState(() {
                  deporteSeleccionado = null;
                });
                
                await Future.delayed(
                  const Duration(seconds: 1),
                );

                if (!context.mounted) return;

                Navigator.pop(context);
                
              },
              child: const Text('Crear'),
            ),
            
          ],
        ),
      ),
    );
  }
}