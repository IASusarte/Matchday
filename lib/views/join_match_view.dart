import 'package:flutter/material.dart';
import '../data/test_data.dart';
import '../models/solicitud.dart';
import '../models/partida.dart';

class JoinMatchView extends StatelessWidget {
  const JoinMatchView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Partidas disponibles'),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [

            const Text(
              'Partidas disponibles',
              style: TextStyle(
                color: Colors.white,
                fontSize: 38,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 20),

            Container(
              height: 300,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white),
              ),
              child: Image.asset(
                'assets/images/map.png',
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: testPartidas.length,
              itemBuilder: (context, index) {
                final partida = testPartidas[index];
                return partidaCard(
                  context,
                  partida: partida,
                );
              },
            ),

            const SizedBox(height: 15),

            partidaCard(
              context,
              partida: Partida(
                id: 0,
                idDeporte: 2,
                lugar: 'Club de Tenis Curicó',
                fecha: DateTime.parse('2026-07-20'),
                descripcion: 'Partido amistoso de tenis.',
                cantJugadores: 2,
                estado: 'pendiente',
                hora: '19:00',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget partidaCard(
    BuildContext context, {
    required Partida partida,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              partida.idDeporte.toString(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text('Lugar: ${partida.lugar}'),
            Text('Fecha: ${partida.fecha}'),
            Text('Hora: ${partida.hora}'),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
                testSolicitudes.add(
                  Solicitud(
                    id: testSolicitudes.length + 1,
                    idPartida: partida.id,
                    idUsuario: 1,
                    estado: 'pendiente',
                  )
                );
                showDialog(
                  context: context,
                  builder: (_) => AlertDialog(
                    title: const Text('Solicitud enviada'),
                    content: const Text(
                      'La solicitud para unirse a la partida ha sido enviada.',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Aceptar'),
                      ),
                    ],
                  ),
                );
              },
              child: const Text('Solicitar unirse'),
            ),
          ],
        ),
      ),
    );
  }
}