//import 'dart:js_interop';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/partida.dart';
import '../data/test_data.dart';
import 'active_matches_view.dart';
import '../data/session.dart';
import '../repos/partida_repo.dart';

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

  final PartidaRepo partidaRepo = PartidaRepo();


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
              items: const [
                DropdownMenuItem( 
                  value: 1,
                  child: Text('⚽ Fútbol'),
                ),
                DropdownMenuItem( 
                  value: 2,
                  child: Text('🎾 Tenis'),
                ),
                DropdownMenuItem( 
                  value: 3,
                  child: Text('🏀 Básquetbol'),
                ),
                DropdownMenuItem( 
                  value: 4,
                  child: Text('🏐 Vóleibol'),
                ),
              ],
              onChanged: (value) {
              setState(() {
                deporteSeleccionado = value;
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
              decoration: const InputDecoration(
                labelText: 'Lugar',
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
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 30),

            ElevatedButton(
              onPressed: () {
                /*print('Deporte: ${deporteController.text}');
                print('Fecha: ${fechaController.text}');
                print('Hora: ${horaController.text}');
                print('Cantidad de jugadores: ${cantJugadoresController.text}');
                print('Lugar: ${lugarController.text}');
                print('Descripción: ${descripcionController.text}');*/

                if(
                  deporteSeleccionado == null ||
                  fechaController.text.isEmpty ||
                  horaController.text.isEmpty ||
                  cantJugadoresController.text.isEmpty ||
                  lugarController.text.isEmpty 
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
                        'La fecha y hora no pueden se del pasado'
                      ),
                    ),
                  );
                  return;
                }


                final nuevaPartida = Partida(
                  idCreador: usuarioLogueado!.id,
                  id: testPartidas.length + 1,
                  idDeporte: deporte,
                  fecha: DateTime.parse(
                    fechaController.text
                  ),
                  hora: horaController.text,
                  cantJugadores: 
                      int.tryParse(cantJugadoresController.text) ?? 0,
                    lugar: lugarController.text,
                    descripcion: descripcionController.text,
                    estado: "Activa",
                  );
              

                  partidaRepo.crearPartida(nuevaPartida);
              

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ActiveMatchesView(),
                    ),
                  );

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Partida creada'),
                  ),
                );
              },
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }
}