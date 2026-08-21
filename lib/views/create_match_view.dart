import 'package:flutter/material.dart';
import '../models/partida.dart';
import '../data/test_data.dart';
import 'active_matches_view.dart';

class CreateMatchView extends StatefulWidget {
  const CreateMatchView({super.key});

  @override
  State<CreateMatchView> createState() => _CreateMatchViewState();
}

class _CreateMatchViewState extends State<CreateMatchView> {

  final TextEditingController deporteController = TextEditingController();
  final TextEditingController fechaController = TextEditingController();
  final TextEditingController horaController = TextEditingController();
  final TextEditingController cantJugadoresController = TextEditingController();
  final TextEditingController lugarController = TextEditingController();
  final TextEditingController descripcionController = TextEditingController();
  @override
  void dispose() {
    deporteController.dispose();
    fechaController.dispose();
    horaController.dispose();
    cantJugadoresController.dispose();
    lugarController.dispose();
    descripcionController.dispose();
    super.dispose();
  }
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

            TextField(
              controller: deporteController,
              decoration: const InputDecoration(
                labelText: 'Deporte',
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: fechaController,
              decoration: const InputDecoration(
                labelText: 'Fecha',
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 15),

            TextField(
              controller: horaController,
              decoration: const InputDecoration(
                labelText: 'Hora',
                filled: true,
                fillColor: Colors.white,
              ),
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

                final nuevaPartida = Partida(
                  id: testPartidas.length + 1,
                  idDeporte: int.tryParse(deporteController.text) ?? 0,
                  fecha: DateTime.parse(fechaController.text),
                  hora: horaController.text,
                  cantJugadores: 
                      int.tryParse(cantJugadoresController.text) ?? 0,
                    lugar: lugarController.text,
                    descripcion: descripcionController.text,
                    estado: "Activa",
                  );
              

                  testPartidas.add(nuevaPartida);
              

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