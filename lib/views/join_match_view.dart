import 'package:flutter/material.dart';

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

            partidaCard(
              context,
              deporte: 'Fútbol',
              lugar: 'Estadio Municipal',
              fecha: '20/07/2026',
              hora: '18:00',
            ),

            const SizedBox(height: 15),

            partidaCard(
              context,
              deporte: 'Tenis',
              lugar: 'Club de Tenis Curicó',
              fecha: '20/07/2026',
              hora: '19:00',
            ),
          ],
        ),
      ),
    );
  }

  Widget partidaCard(
    BuildContext context, {
    required String deporte,
    required String lugar,
    required String fecha,
    required String hora,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              deporte,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            Text('Lugar: $lugar'),
            Text('Fecha: $fecha'),
            Text('Hora: $hora'),

            const SizedBox(height: 10),

            ElevatedButton(
              onPressed: () {
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