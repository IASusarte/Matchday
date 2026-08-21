import 'package:flutter/material.dart';
import 'rate_players_view.dart';

class MatchDetailView extends StatelessWidget {
  const MatchDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF43AAE8),

      appBar: AppBar(
        backgroundColor: const Color(0xFF43AAE8),
        title: const Text('Detalle de la partida'),
      ),

      body: Padding(
  padding: const EdgeInsets.all(20),
  child: Card(
    child: Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          const Text(
            'Fútbol',
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 20),

          const Text('Fecha: 20/07/2026'),
          const Text('Hora: 18:00'),
          const Text('Lugar: Estadio Municipal'),
          const Text('Jugadores requeridos: 10'),

          const SizedBox(height: 20),

          const Text(
            'Descripción:',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),

          const Text(
            'Partido amistoso recreativo.',
          ),

          const Spacer(),

          Center(
            child: SizedBox(
              width: 250,
              height: 60,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF5850EC),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RatePlayersView(),
                    ),
                  );
                },
                child: const Text(
                  'Finalizar y puntuar',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    ),
  ),
),
    );
  }
}